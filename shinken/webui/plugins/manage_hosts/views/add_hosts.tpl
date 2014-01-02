
%rebase layout globals(), title='Add hosts', menu_part='/system/host/add'
<div class="span8">
	<h3>Add hosts</h3>
	<form id="add" name="add" action="/manage_hosts/host/add" method="post">
	<label for="host_name">Host name:</label>
		<input id="host_name" name="host_name" type="text" placeholder="short hostname" required >
	<label for="address">Address:</label>
		<input id="address" name="address" type="text" placeholder="10." required pattern="((^|\.)((25[0-5])|(2[0-4]\d)|(1\d\d)|([1-9]?\d))){4}$">
	<label for="alias">Alias:</label>
		<input id="alias" name="alias" type="text" placeholder="fqdn or alias" required>
	<label for="realm">Realm:</label>
		<select id="realm" name="realm">
			<option value="std">std</option>
			<option value="trz">trz</option>
		</select>
	<label for="hostgroups">group:</label>
		<select id="hostgroups" name="hostgroups">
			<option value="">No group</option>
%for g in hostgroups:
			<option value="{{g['hostgroups']}}">{{g['hostgroups']}}</option>
%end
		</select>
	<p>
		<input type="submit" name="action"  value="add" class="btn btn-primary">
	</p>
</form>
</div>
