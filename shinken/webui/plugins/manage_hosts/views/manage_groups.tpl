%rebase layout globals(), title='Group DBase', menu_part='/system/group'
<div class="span3">
%if action == 'list':
  <h3>Host group list: {{len(hostgroups)}}</h3>
  <table class="table table-hover">
    <thead>
      <tr>
        <th>Host name</th>
        <th>Group</th>
      </tr>
    </thead>
    <tbody>

%for g in group:
      <tr>
        <td><a href="group?global_search={{g['host_name']}}">{{g['host_name']}}</a></td>
        <td><a href="group?group={{g['hostgroups']}}">{{g['hostgroups']}}</a></td>
      </tr>
%end
    </tbody>
  </table>
%end
%if action == 'edit':
%if len(group) == 0:
  <h3>Host not found</h3>
%else:
  <h3>Edit host group for {{group[0]['host_name']}}</h3>

  <form id="add" name="add" action="/manage_hosts/group" method="post">
  <label for="addgroup"><i class="icon-wrench"></i> Add group to {{group[0]['host_name']}}:</label>
  <input list="allgrp" name="group" id="addgroup">
  <datalist id="allgrp">
%for hg in hostgroups:
    <option value="{{hg['hostgroups']}}">{{hg['hostgroups']}}</option>
%end
  </datalist>
  <input type="hidden" name="host_name" value="{{group[0]['host_name']}}">
  <input type="submit" name="action"  value="add" >
  </form>
%for g in group:
  <form name="edit" action="/manage_hosts/group" method="post">
  <label for="edit{{g['host_name']}}"><i class="icon-wrench"></i> Edit {{g['host_name']}} group <i>{{g['hostgroups']}}</i> *:</label>
  <input id="edit{{g['host_name']}}" name="group" type="text" value="{{g['hostgroups']}}" />
  <input type="hidden" name="host_name" value="{{g['host_name']}}">
  <input type="hidden" name="old_group" value="{{g['hostgroups']}}" >
  <input type="submit" name="action" value="save">
  </form>
%end
<hr>
%end
%end
* Blank to delete.
</div>

