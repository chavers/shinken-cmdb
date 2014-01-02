%rebase layout globals(), title='Options DBase', menu_part='/system/option'
<div class="span12">
%if action=='debug':
{{cmd}}
%end
%if action == 'list':
	<h3>Add option:</h3>
	<form id="add" name="add" action="/manage_hosts/option" method="post">
		<label for="host_name">Host name:</label>
		<input list="allhost" id="host_name" name="host_name">
			<datalist id="allhost">
%for h in host:
			<option value="{{h['host_name']}}">{{h['host_name']}}</option>
%end
			</datalist>
		<input type="submit" name="action"  value="find" class="btn btn-primary">
	</form>
	<hr>
	<h3>Options list:</h3>
	<table class="table table-hover">
		<thead>
			<tr>
				<th>Host name</th>
				<th>Option name</th>
				<th>Value</th>
			</tr>
		</thead>
		<tbody>
%for o in option:
			<tr>
				<td><a href="option?global_search={{o['host_name']}}&action=edit">{{o['host_name']}}</a></td>
				<td>{{o['option_name']}}</td>
				<td>{{o['option_value']}}</td>
			</tr>
%end
		</tbody>
	</table>
%end

%if action == 'edit':
	<h3>Add option:</h3>
	<table>
	<form id="add" name="add" action="/manage_hosts/option" method="post">
		<tr><td>
		<label for="host_name">Host name:</label>
		<input type="text" id="host_name" name="host_name" value="{{host_name}}" readonly >
	</td><td>
		<label for="option_name">option name:</label>
			<select id="option_name" name="option_name">
%for on in all_option:
				<option value="{{on['option_name']}}">{{on['option_name']}}</option>
%end
			</select>
		</td><td>
		<label for="option_value">option value:</label>
			<input list="allopt" name="option_value" id="option_value">
			<datalist id="allopt">
%for ov in all_option_value:
			<option value="{{ov['option_value']}}">{{ov['option_value']}}</option>
%end
			</datalist>
		<input type="submit" name="action"  value="add" class="btn btn-primary">
	</td></tr>
	</form>
	</table>
<hr>
<h3>Edit {{host_name}} option:</h3>
%for o in option:
%if o['option_name'] != "":
<hr>
  <form id="add{{o['option_name']}}" name="add{{o['option_name']}}" action="/manage_hosts/option" method="post">
  <label for="option_value">option <b>"{{o['option_name']}}"</b> value:</label>
    <input id="option_value" name="option_value" type="text" value="{{o['option_value']}}" >
  <input type="hidden" name="host_name" value="{{o['host_name']}}" >
  <input type="hidden" name="option_name" value="{{o['option_name']}}" >
  <p>
  <input type="submit" name="action"  value="update" class="btn btn-primary">
  <input type="submit" name="action"  value="delete" class="btn btn-danger">
  </p>
</form>
%end
%end
</div>

