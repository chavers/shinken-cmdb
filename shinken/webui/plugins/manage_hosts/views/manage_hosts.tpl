
%rebase layout globals(), title='Hosts DBase', menu_part='/system/host'
<div class="span3">
%if action == 'list':
  <h3>Hosts list: ({{len(hosts)}})</h3>
  <a href="/manage_hosts/host/add" class="btn btn-success"><i class="icon-pencil"></i> Add Host</a>
  <table class="table table-hover">
    <thead>
      <tr>
        <th>Host name</th>
        <th>Alias</th>
        <th>Address</th>
        <th>Site</th>
      </tr>
    </thead>
    <tbody>

%for h in hosts:
      <tr>
        <td><a href="host?global_search={{h['host_name']}}">{{h['host_name']}}</a></td>
        <td>{{h['alias']}}</td>
        <td>{{h['address']}}</td>
        <td>{{h['realm']}}</td>
      </tr>
%end
    </tbody>  
  </table>
%end
%if action == 'edit':
%if len(hosts) == 0:
  <h3>Host not found</h3>
%else:
%h = hosts[0]
  <h3>Edit host {{h['host_name']}}</h3>
  <form id="add" name="add" action="/manage_hosts/host" method="post">
  <label for="host_name">Host name:</label>
    <input id="host_name" name="host_name" type="text" value="{{h['host_name']}}" />
  <label for="address">Address:</label>
    <input id="address" name="address" type="text" value="{{h['address']}}" />
  <label for="alias">Alias:</label>
    <input id="alias" name="alias" type="text" value="{{h['alias']}}" />
  <label for="realm">Realm:</label>
    <input id="realm" name="realm" type="text" value="{{h['realm']}}" />
  <input type="hidden" name="old_host_name" value="{{h['host_name']}}" />
  <p>
  <input type="submit" name="action"  value="update" class="btn btn-primary">
  <input type="submit" name="action"  value="delete" class="btn btn-danger">
  </p>
</form>
%end
%end
</div>

