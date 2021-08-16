   <div class="table-responsive">
     <table class="table table-striped table-bordered">
      <tr>
       <th width="5%">Per_ID</th>
       <th width="38%">system name</th>
       <th width="38%">menu name</th>
       <th width="38%">sub menu</th>
       <th width="57%">Action</th>
      </tr>
      @foreach($data as $row)
      <tr>
       <td>{{ $row->id }}</td>
       <td>{{ $row->systemname }}</td>
       <td>{{ $row->menu_name }}</td>
       <td>{{ $row->subm_name }}</td>
       <td>
         
        <div class="row mb-12">
          <div class="col-sm-3">
            
          </div>

           <div class="col-sm-6">

           <div class="row mb-2">
                <button type="button" name='delete' id='{{ $row->id }}'  class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button> 
            </div>
            </div>

          </div>
       </td>
       
      </tr>
      @endforeach
     </table>

     {!! $data->render() !!}

    </div>

   </div>