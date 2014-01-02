
%rebase layout globals(), title='Template DBase', menu_part='/system/template'
<div class="span3">
%if action == 'list':
  <h3>Templates list: {{len(all_template)}}</h3>
  <table class="table table-hover">
    <thead>
      <tr>
        <th>Host name</th>
        <th>Template</th>
      </tr>
    </thead>
    <tbody>

%for t in template:
      <tr>
        <td><a href="template?global_search={{t['host_name']}}">{{t['host_name']}}</a></td>
        <td><a href="template?template={{t['template']}}">{{t['template']}}</a></td>
      </tr>
%end
    </tbody>
  </table>

%end
%if action == 'edit':
%if len(template) == 0:
  <h3>Host not found</h3>
%else:
  <h3>Edit host template for {{template[0]['host_name']}}</h3>

  <form id="add" name="add" action="/manage_hosts/template" method="post">
  <label for="addtemplate"><i class="icon-wrench"></i> Add template to {{template[0]['host_name']}}:</label>
  <input list="alltmp" name="template" id="addtemplate">
  <datalist id="alltmp">
%for at in all_template:
    <option value="{{at['template']}}">{{at['template']}}</option>
%end
  </datalist>
  <input type="hidden" name="host_name" value="{{template[0]['host_name']}}">
  <input type="submit" name="action"  value="add" >
  </form>
%for t in template:
  <form name="edit" action="/manage_hosts/template" method="post">
  <label for="edit{{t['host_name']}}"><i class="icon-wrench"></i> Edit {{t['host_name']}} template <i>{{t['template']}}</i> *:</label>
  <input id="edit{{t['host_name']}}" name="template" type="text" value="{{t['template']}}" />
  <input type="hidden" name="host_name" value="{{t['host_name']}}">
  <input type="hidden" name="old_template" value="{{t['template']}}" >
  <input type="submit" name="action" value="save">
  </form>

%end
%end
%end
* Blank to delete.
</div>

