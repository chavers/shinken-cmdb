#!/usr/bin/env python
# -*- coding: utf-8 -*-


import os
import sys
import shlex
import shutil
import optparse
from subprocess import Popen, PIPE
import dns.resolver
import MySQLdb as mdb
# Try to load json (2.5 and higer) or simplejson if failed (python2.4)
try:
    import json
except ImportError:
    # For old Python version, load
    # simple json (it can be hard json?! It's 2 functions guy!)
    try:
        import simplejson as json
    except ImportError:
        sys.exit("Error: you need the json or simplejson module for this script")

VERSION = '0.1'


# Split and clean the rules from a string to a list
def _split_rules(rules):
    return [r.strip() for r in rules.split('|')]


# Apply all rules on the objects names
def _apply_rules(name, rules):
    name = name.strip()
    if len(name.split(' ')) == 1: 
      if 'nofqdn' in rules:
        name = name.split(' ', 1)[0]
        name = name.split('.', 1)[0]
      if 'lower' in rules:
        name = name.lower()
    else:
      name = '10'
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

# Get all vmware hosts from a VCenter and return the list
def get_vmware_hosts(check_esx_path, vcenter, user, password):
    list_host_cmd = [check_esx_path, '-D', vcenter, '-u', user, '-p', password,
                     '-l', 'runtime', '-s', 'listhost']

    output = Popen(list_host_cmd, stdout=PIPE).communicate()

    parts = output[0].split(':')
    hsts_raw = parts[1].split('|')[0]
    hsts_raw_lst = hsts_raw.split(',')

    hosts = []
    for hst_raw in hsts_raw_lst:
        hst_raw = hst_raw.strip()
        # look as server4.mydomain(UP)
        if "(UP)" in hst_raw:
          elts = hst_raw.split('(')
          hst = elts[0]
          hosts.append(hst)

    return hosts


# For a specific host, ask all VM on it to the VCenter
def get_vm_of_host(check_esx_path, vcenter, host, user, password):
    #print "Listing host", host
    list_vm_cmd = [check_esx_path, '-D', vcenter, '-H', host,
                   '-u', user, '-p', password,
                   '-l', 'runtime', '-s', 'list']
    output = Popen(list_vm_cmd, stdout=PIPE).communicate()
    parts = output[0].split(':')
    # Maybe we got a 'CRITICAL - There are no VMs.' message,
    # if so, we bypass this host
    if len(parts) < 2:
        return None

    vms_raw = parts[1].split('|')[0]
    vms_raw_lst = vms_raw.split(',')

    lst = []
    for vm_raw in vms_raw_lst:
        vm_raw = vm_raw.strip()
        # look as MYVM(UP)
        if "(OK)" in vm_raw:
          elts = vm_raw.split('(')
          vm = elts[0]
          lst.append(vm)
    return lst



def main(check_esx_path, vcenter, user, password, rules):
    rules = _split_rules(rules)
    res = {}
    conLocal = mdb.connect('127.0.0.1', 'dbuser', 'dbpasswd','supervision')
    curLocal = conLocal.cursor()
    hosts = get_vmware_hosts(check_esx_path, vcenter, user, password)
    for host in hosts:
      host_name = _apply_rules(host, rules)
      if host_name != "10":
        answers_IPv4 = dns.resolver.query(host, 'A')
        host_ip = answers_IPv4[0].address
        #print "h:%s ip:%s" %(host_name, host_ip)
        try:
          curLocal.execute("select count(*) from hosts where host_name = \"%s\";" % host_name)
          found = curLocal.fetchone()
          if found:
            curLocal.execute("update hosts set vm = 0 where host_name = \"%s\";" % host_name)
          else:
            curLocal.execute("insert into hosts(host_name,address,alias,realm,vm) VALUES (\"%s\",\"%s\",\"%s\",\"%s\",0);" %(host_name, host_ip, host_name, getsite(host_ip)))
            curLocal.execute("insert into host_template(host_name, template) VALUES (\"%s\",\"generic-host\");" % host_name)
          conLocal.commit()
        except mdb.Error, e:
          print "Error %d: %s" % (e.args[0], e.args[1])
          pass
        lst = get_vm_of_host(check_esx_path, vcenter, host, user, password)
        if lst:
          for vm in lst:
            vm_name = _apply_rules(vm, rules)
            if vm_name != '10':
              try:
                vm_IPv4 = dns.resolver.query(vm, 'A')
                vm_ip = vm_IPv4[0].address
                try:
                  curLocal.execute("select count(*) from hosts where host_name = \"%s\";" % vm_name)
                  found = curLocal.fetchone()
                  if found:
                    curLocal.execute("update hosts set vm = 1 where host_name = \"%s\";" % vm_name)
                  else:
                    curLocal.execute("insert into hosts(host_name,address,alias,realm,vm) VALUES (\"%s\",\"%s\",\"%s\",\"%s\",1);" %(vm_name, vm_ip, vm_name, getsite(vm_ip)))
                    curLocal.execute("insert into host_template(host_name, template) VALUES (\"%s\",\"generic-host\");" % vm_name)
                  conLocal.commit()
                except mdb.Error, e:
                  print "Error %d: %s" % (e.args[0], e.args[1])
                  pass
              #print "vm:%s  ip:%s" %( vm, vm_ip)
              except:
                print "vm:%s  ip:NA" % vm
                pass

# Here we go!
if __name__ == "__main__":
    # Manage the options
    parser = optparse.OptionParser(
        version="Shinken VMware links dumping script version %s" % VERSION)
    parser.add_option("-x", "--esx3-path", dest='check_esx_path',
                      default='/usr/local/shinken/libexec/check_esx3.pl',
                      help="Full path of the check_esx3.pl script (default: %default)")
    parser.add_option("-V", "--vcenter", '--Vcenter',
                      default='vcenter.local.lan',
                      help="tThe IP/DNS address of your Vcenter host.")
    parser.add_option("-u", "--user",
                      default='svc_shinken',
                      help="User name to connect to this Vcenter")
    parser.add_option("-p", "--password",
                      default='*************',
                      help="The password of this user")
    parser.add_option('-r', '--rules', default='lower|nofqdn',
                      help="Rules of name transformation. Valid names are: "
                      "`lower`: to lower names, "
                      "`nofqdn`: keep only the first name (server.mydomain.com -> server)."
                      "You can use several rules like `lower|nofqdn`")

    opts, args = parser.parse_args()
    if args:
        parser.error("does not take any positional arguments")

    if opts.vcenter is None:
        parser.error("missing -V or --Vcenter option for the vcenter IP/DNS address")
    if opts.user is None:
        parser.error("missing -u or --user option for the vcenter username")
    if opts.password is None:
        error = True
        parser.error("missing -p or --password option for the vcenter password")
    if not os.path.exists(opts.check_esx_path):
        parser.error("the path %s for the check_esx3.pl script is wrong, missing file" % opts.check_esx_path)

    main(**opts.__dict__)
