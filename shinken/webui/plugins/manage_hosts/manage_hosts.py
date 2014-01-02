#!/usr/bin/python
# -*- coding: utf-8 -*-


from shinken.webui.bottle import redirect
import MySQLdb as mdb
import os, sys
from symbol import except_clause

### Will be populated by the UI with it's own value
app = None
dbh = '127.0.0.1'
dbn = 'supervision'
dbu = 'dbuser'
dbp = 'dbpasswd'

def set_hosts():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	host_name = app.request.forms.get('host_name', '')
	old_host_name = app.request.forms.get('old_host_name', '')
	action    = app.request.forms.get('action', '')
	address   = app.request.forms.get('address', '')
	alias     = app.request.forms.get('alias', '')
	realm     = app.request.forms.get('realm', '')
	try:
		con = mdb.connect(dbh, dbu, dbp,dbn)
		cur = con.cursor()
		if action == 'delete':
			try:
				cmd = 'DELETE FROM hosts WHERE host_name="%s" ;' % host_name  
				cur.execute(cmd)
				con.commit()
			except:
				pass
		if action == 'update':
			try:
				cmd = 'UPDATE hosts set host_name="%s", address="%s", alias="%s", realm="%s" WHERE host_name="%s";' %(host_name, address, alias, realm, old_host_name)
				cur.execute(cmd)
				con.commit()
			except:
				pass
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
	except:
		pass
	finally:
		if con:
			con.close()
	if action == 'delete':
		redirect("/manage_hosts/host" )
		return
	else:
		redirect("/manage_hosts/host?global_search=%s" % host_name)
		return

def add_hosts():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	host_name = app.request.forms.get('host_name', '')
	address = app.request.forms.get('address', '')
	alias = app.request.forms.get('alias', '')
	realm = app.request.forms.get('realm', '')
	hostgroups = app.request.forms.get('hostgroups', '')
	cmd = []
	try:
		con = mdb.connect(dbh, dbu, dbp, dbn)
		cur = con.cursor(mdb.cursors.DictCursor)
		cur.execute('INSERT INTO hosts (host_name, address, alias, realm) VALUES ("%s","%s","%s","%s");' %(host_name,address,alias,realm))
		if hostgroups != '':
			cur.execute('INSERT INTO host_groups (host_name, hostgroups) VALUES ("%s","%s");' %(host_name, hostgroups))
		cur.execute('INSERT INTO host_template (host_name, template) VALUES ("%s","generic-host");' %host_name)
		con.commit()
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
	except:
		pass
	finally:
		if con:
			con.close()
	redirect("/manage_hosts/template?global_search=%s" % host_name)
	return

def add_hosts_form():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	hostgroups = []
	try:
		con = mdb.connect(dbh, dbu, dbp, dbn)
		cur = con.cursor(mdb.cursors.DictCursor)
		cur.execute('SELECT distinct(hostgroups) from host_groups ORDER BY hostgroups ASC;')
		hostgroups = cur.fetchall()
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
	except:
		pass
	finally:
		if con:
			con.close()
	return {'app':app, 'user': user, 'hostgroups':hostgroups }

def get_hosts():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	action = 'list'
	try:
		host_name = app.request.GET.get('global_search', '')
		opt1 = ''
		if host_name != '':
			opt1 = ' AND host_name="%s" ' % host_name
			action = 'edit'
		con = mdb.connect(dbh, dbu, dbp, dbn)
		cur = con.cursor(mdb.cursors.DictCursor)
		cur.execute('select * from hosts WHERE 1 %s order by host_name asc;' % opt1 )
		my_hosts = cur.fetchall()
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
	except:
		pass
	finally:
		if con:
			con.close()
	return {'app': app, 'user': user, 'hosts': my_hosts, 'action': action}

def set_options():
	user = app.get_user_auth()
	if not user:
			redirect("/user/login")
			return
	action = app.request.forms.get('action', '')
	host_name = app.request.forms.get('host_name', '')
	option_name = app.request.forms.get('option_name', '')
	option_value = app.request.forms.get('option_value', '')
	try:
		con = mdb.connect(dbh, dbu, dbp, dbn)
		cur = con.cursor()
		if action == 'add':
			cur.execute('INSERT INTO host_option (host_name_key,option_name,option_value) VALUES ("%s","%s","%s") ;' % (host_name,option_name,option_value))
			con.commit()
		if action == 'update':
			cur.execute('UPDATE host_option set option_value="%s" WHERE host_name_key="%s" AND option_name="%s" ;' % (option_value,host_name,option_name))
		if action == 'delete':
			cur.execute('DELETE FROM host_option WHERE host_name_key="%s" AND option_name="%s" ;' % (host_name,option_name))
		con.commit()
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
	except:
		pass
	finally:
		if con:
			con.close()
	redirect("/manage_hosts/option?global_search=%s&action=edit" % host_name) 
	return

def get_options():
	user = app.get_user_auth() 
	if not user:
		redirect("/user/login")
		return
	my_options = []
	all_hosts = []
	all_option = []
	all_option_value = []
	try:
		action = app.request.GET.get('action', 'list')
		host_name = app.request.GET.get('global_search', '')
		con = mdb.connect(dbh, dbu, dbp,dbn)
		cur = con.cursor(mdb.cursors.DictCursor)
		cur.execute('select distinct(option_name) from host_option order by option_name asc;')
		all_option = cur.fetchall()
		cur.execute('select distinct(option_value) from host_option order by option_value asc;')
		all_option_value = cur.fetchall()
		if host_name != '':
			cur.execute('select host_name_key as host_name, option_name, option_value from host_option where host_name_key="%s" order by host_name_key asc;' % host_name )
			my_options = cur.fetchall()
			action = 'edit'
			if len(my_options)==0:
				my_options[0]['host_name']=host_name
				my_options[0]['option_name']=""
				my_options[0]['option_value']=""
		else:
			cur.execute('select host_name from hosts order by host_name asc;')
			all_hosts = cur.fetchall()
			cur.execute('select host_name_key as host_name, option_name, option_value from host_option order by host_name_key asc;' )
			my_options = cur.fetchall()
	except:
		pass
	finally:
		if con:
			con.close()
	return {'app':app, 'user': user, 'host_name':host_name, 'option': my_options, 'action':action, 'host':all_hosts, 'all_option':all_option, 'all_option_value':all_option_value}

def set_templates():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	host_name = app.request.forms.get('host_name', '')
	action  = app.request.forms.get('action', '')
	template  = app.request.forms.get('template', '')
	old_template = app.request.forms.get('old_template', '')
	try:
		con = mdb.connect(dbh, dbu, dbp,dbn)
		cur = con.cursor()
		if action == 'add':
			cmd = 'SELECT COUNT(*) FROM host_template WHERE host_name="%s" AND template="%s";' % (host_name, template)  
			cur.execute(cmd)
			found = cur.fetchone()
			if found[0] == 0:
				cmd = 'INSERT INTO host_template (host_name, template) VALUES ("%s", "%s");' % (host_name, template)
				cur.execute(cmd)
				con.commit()
		if action == 'save':
			if template == '':
				cmd = 'DELETE FROM host_template WHERE host_name="%s" AND template="%s";' % (host_name, old_template)
				cur.execute(cmd)
				con.commit()
			else:
				cmd = 'UPDATE host_template set template="%s" WHERE host_name="%s" AND template="%s";' % (template, host_name, old_template)
				cur.execute(cmd)
				con.commit()
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
	except:
		pass
	finally:
		if con:
			con.close()
	redirect("/manage_hosts/template?global_search=%s" % host_name)
	return

def get_templates():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	all_template = []
	action = 'list'
	try:
		con = mdb.connect(dbh, dbu, dbp,dbn)
		cur = con.cursor(mdb.cursors.DictCursor)
		host_name = app.request.GET.get('global_search', '')
		template = app.request.GET.get('template', '')
		opt1 = ''
		opt2 = ''
		if host_name != '':
			opt1 = ' AND h.host_name="%s" ' % host_name
			action = 'edit'
		if template != '':
			opt2 = ' AND ht.template="%s" ' % template
		cmd = 'select h.host_name, ht.template from hosts AS h LEFT JOIN host_template AS ht ON h.host_name=ht.host_name WHERE 1 %s %s ORDER BY h.host_name ASC;' % (opt1, opt2)
		cur.execute(cmd)
		my_templates = cur.fetchall()
		cur.execute('SELECT distinct(template) FROM host_template ORDER BY template ASC;')
		all_template = cur.fetchall() 
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
#	except:
#		pass
	finally:
		if con:
			con.close()
	return {'app':app, 'user': user,'template': my_templates,'all_template': all_template,'action':action}

def get_groups():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	my_groups = []
	my_hostgroups = []
	action = 'list'
	try:
		con = mdb.connect(dbh, dbu, dbp,dbn)
		cur = con.cursor(mdb.cursors.DictCursor)
		curg = con.cursor(mdb.cursors.DictCursor)
		opt1 = ''
		opt2 = ''
		host_name = app.request.GET.get('global_search', '')
		if host_name != '':
			opt1 = ' AND h.host_name="%s" ' % host_name
			action = 'edit'
		group = app.request.GET.get('group', '')
		if group != '':
			opt2 = ' AND hg.hostgroups="%s" ' % group
		if group == 'None':
			opt2 = " AND hg.hostgroups IS NULL "
		cmd = 'SELECT h.host_name, hg.hostgroups FROM hosts AS h LEFT JOIN host_groups AS hg ON h.host_name=hg.host_name WHERE 1 %s %s ORDER BY h.host_name ASC ;' % (opt1, opt2)
		cur.execute(cmd )
		my_groups = cur.fetchall()
		curg.execute('select distinct(hostgroups) from host_groups order by hostgroups asc;')
		my_hostgroups = curg.fetchall()
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
#	except:
#		pass
	finally:
		if con:
			con.close()
	return {'app':app, 'user': user, 'group': my_groups, 'action':action, 'hostgroups':my_hostgroups}

def set_groups():
	user = app.get_user_auth()
	if not user:
		redirect("/user/login")
		return
	host_name = app.request.forms.get('host_name', '')
	action  = app.request.forms.get('action', '')
	group  = app.request.forms.get('group', '')
	old_group = app.request.forms.get('old_group', '')
	try:
		con = mdb.connect(dbh, dbu, dbp,dbn)
		cur = con.cursor()
		if action == 'add':
			cmd = 'SELECT COUNT(*) FROM host_groups WHERE host_name="%s" AND hostgroups="%s";' % (host_name, group)  
			cur.execute(cmd)
			found = cur.fetchone()
			if found[0] == 0:
				cmd = 'INSERT INTO host_groups (host_name, hostgroups) VALUES ("%s", "%s");' % (host_name, group)
				cur.execute(cmd)
				con.commit()
		if action == 'save':
			if group == '':
				cmd = 'DELETE FROM host_groups WHERE host_name="%s" AND hostgroups="%s";' % (host_name, old_group)
				cur.execute(cmd)
				con.commit()
			else:
				cmd = 'UPDATE host_groups set hostgroups="%s" WHERE host_name="%s" AND hostgroups="%s";' % (group, host_name, old_group)
				cur.execute(cmd)
				con.commit()
	except mdb.Error, e:
		print "Error %d: %s" % (e.args[0],e.args[1])
	except:
		pass
	finally:
		if con:
			con.close()
	redirect("/manage_hosts/group?global_search=%s" % host_name)
	return

pages = {
	add_hosts_form: {'routes': ['/manage_hosts/host/add'], 'view': 'add_hosts',        'method': 'GET',  'static': True},
	add_hosts:      {'routes': ['/manage_hosts/host/add'], 'view': 'add_hosts',        'method': 'POST', 'static': True},
	get_hosts:      {'routes': ['/manage_hosts/host'],     'view': 'manage_hosts',     'method': 'GET',  'static': True},
	set_hosts:      {'routes': ['/manage_hosts/host'],     'view': 'manage_hosts',     'method': 'POST', 'static': True},
	get_options:    {'routes': ['/manage_hosts/option'],   'view': 'manage_options',   'method': 'GET',  'static': True},
	set_options:    {'routes': ['/manage_hosts/option'],   'view': 'manage_options',   'method': 'POST', 'static': True},
	get_templates:  {'routes': ['/manage_hosts/template'], 'view': 'manage_templates', 'method': 'GET',  'static': True},
	set_templates:  {'routes': ['/manage_hosts/template'], 'view': 'manage_templates', 'method': 'POST', 'static': True},
	get_groups:     {'routes': ['/manage_hosts/group'],    'view': 'manage_groups',    'mothod': 'GET',  'static': True},
	set_groups:     {'routes': ['/manage_hosts/group'],    'view': 'manage_groups',    'method': 'POST', 'static': True},
}


