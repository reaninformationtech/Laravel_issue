   <div class="table-responsive">
     <table class="table table-striped table-bordered">
      <tr class="table-primary" >
       <th width="5%">Menu_ID</th>
       <th width="38%">Menu name</th>
       <th width="38%">Effective menu</th>
       <th >icon1</th>
       <th >class1</th>
       <th width="57%">Status</th>
       <th width="57%">Action</th>
      </tr>
      @foreach($data as $row)

      <tr>
       <td>{{ $row->menu_id }}</td>
       <td>{{ $row->menu_name }}</td>
       <td>{{ $row->menu_effective }}</td>
       <td>{{ $row->menu_glyphicon1 }}</td>
       <td>{{ $row->menu_class1 }}</td>
       <td>{{ $row->status }}</td>
       <td>

        <div class="row mb-12">
          <div class="col-sm-6">
            <div class="row mb-2">
              <button type="button" name='edit' id='{{ $row->menu_id }}'    class="edit btn btn-xs btn-success btn-sm my-0"><i class="fas fa-edit"></i></button>
            </div>

          </div>

           <div class="col-sm-6">

           <div class="row mb-2">
                <button type="button" name='delete' id='{{ $row->menu_id }}'  class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button>
            </div>
            </div>

          </div>
       </td>

      </tr>
      @endforeach
     </table>
     {{ $data->links('vendor.pagination.custom') }}

    </div>
