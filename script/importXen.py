#!/usr/bin/python
# -*- coding: utf-8 -*-
import MySQLdb as mdb
import sys
import iptools
import XenAPI
from symbol import except_clause
from string import split
import dns.resolver

debug = False 

def addlog(msg):
  if debug:
    print msg

addlog("debug on")

def _apply_rules(name):
  name = name.strip()
  name = name.split(' ', 1)[0]
  name = name.split('.', 1)[0]
  name = name.lower()
  return name


def get_site(ipaddr):
  ret = 'realmA'
  ip1 = ipaddr.split('.')[1]
  ip2 = ipaddr.split('.')[2]
  # vlan ID in datacenter fake value...
  DC1 = ["1", "2"]
  DC2 = ["3", "4"]
  DC3 = ["5"]
  if ip1 == "1":
    ret = "realmA"
    if ip2 in DC2:
      ret = "realmB"
  if ip1 in DC1:
    ret = "realmA"
  if ip1 in DC3:
    ret = "realmB"
  return ret

def add_host(hostname, host_ip, is_vm):
  if host_ip is None:
    try:
      ipv4 = dns.resolver.query(hostname, 'A')
      host_ip = ipv4[0].address
    except:
      print "error add_host  h:%s ip:%s" % (hostname, host_ip)
      return 0
  site = get_site(host_ip)
  conLocal = mdb.connect('127.0.0.1', 'dbuser', 'dbpasswd','supervision')
  curLocal = conLocal.cursor()
  hostname = _apply_rules(hostname)
  try:
    addlog( "import %s --> %s %s" % (hostname, host_ip, site))
    curLocal.execute("select count(*) from hosts where host_name = \"%s\";" % hostname)
    found = curLocal.fetchone()
    if found:
      if is_vm:
        curLocal.execute("update hosts set vm = 1 where host_name = \"%s\";" % hostname)
      else:
        curLocal.execute("update hosts set vm = 0 where host_name = \"%s\";" % hostname)
      conLocal.commit()
    else:
      if is_vm:
        curLocal.execute("insert into hosts(host_name,address,alias,realm,vm) VALUES (\"%s\",\"%s\",\"%s\",\"%s\",1);" 
          %(hostname, host_ip, hostname, site))
      else:
        curLocal.execute("insert into host_template(host_name, template,vm) VALUES (\"%s\",\"generic-host\",0);" 
          % hostname)
      conLocal.commit()
  except mdb.Error, e:
    print "Error %d: %s" % (e.args[0], e.args[1])
    pass
  finally:
    if conLocal:
      conLocal.close()
  return 0


def main(session, url):
    addlog("Main for %s" % url)
    hosts = session.xenapi.host.get_all()
    for host in hosts:
      host_name = session.xenapi.host.get_hostname(host)
      host_ip = session.xenapi.host.get_address(host)
      add_host(host_name, host_ip, False)
    vms = session.xenapi.VM.get_all()
    for vm in vms:
      record = session.xenapi.VM.get_record(vm)
      if not(record["is_a_template"]) and not(record["is_control_domain"]) and record["power_state"] == "Running":
        if session.xenapi.VM.get_power_state(vm) == 'Running':
          vm_name = session.xenapi.VM.get_name_label(vm)
          if len(vm_name.split(' ')) == 1:
            add_host(vm_name, None, True)
    
def get_pool_name(s,host):
    pool_name = 'NA'
    try:
        pools = s.xenapi.pool.get_all()
        for p in pools:
            m = s.xenapi.pool.get_master(p)
            if s.xenapi.host.get_address(m) == host:
                pool_name = s.xenapi.pool.get_name_label(p)
                break
    except:
        pass
    finally:
        return pool_name
    
if __name__ == "__main__":
    # xen pool master list
    hosts = ['10.0.0.1','10.0.0.2','10.0.0.3']
    username = "xenuser"
    password = "xenpasswd"
    for host in hosts:
        try: 
            s = XenAPI.Session("http://"+host)
            s.xenapi.login_with_password(username, password)
            addlog( "pool:%s ip:%s" % (get_pool_name(s, host), host))
            main(s, host)
            s.xenapi.session.logout()
        except XenAPI.Failure, msg: 
            if  msg.details[0] == "HOST_IS_SLAVE":
                host = msg.details[1]
                s = XenAPI.Session("http://"+host)   
                s.xenapi.login_with_password(username, password)
                addlog( "pool:%s ip:%s" % (get_pool_name(s, host), host))
                main(s, host)
                s.xenapi.session.logout()      
        except:
          pass
