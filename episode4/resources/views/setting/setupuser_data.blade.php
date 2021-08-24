   <div class="table-responsive">
     <table class="table table-striped table-bordered">
      <tr>
       <th width="5%">ID</th>
       <th width="38%">Login Name</th>
       <th width="38%">User name</th>
        <th width="38%">Contact</th>
        <th width="38%">Profile</th>
        <th width="38%">Inactive</th>
        <th width="38%">Inputter</th>
       <th width="57%">Action</th>
      </tr>
      @foreach($data as $row)
      <tr>
       <td>{{ $row->id }}</td>
       <td>{{ $row->username }}</td>
       <td>{{ $row->name }}</td>
       <td>{{ $row->contact }}</td>
       <td>{{ $row->profilename }}</td>
       <td>{{ $row->status }}</td>
       <td>{{ $row->inputter }}</td>
       <td>

        <div class="row mb-12">

            <div class="col-sm-6">
                <div class="row mb-2">
                    <button type="button" name='edit' id='{{ $row->id }}'    class="edit btn btn-xs btn-success btn-sm my-0"><i class="fas fa-edit"></i></button>
                </div>
            </div>
            <div class="col-sm-6">
                <div class="row mb-2">
                    <button type="button" name='resetpwd' id='{{ $row->id }}'    class="resetpwd btn btn-xs btn-warning btn-sm my-0"><i class="fas fa-key fa-fw"></i></button>
                </div>
            </div>

          </div>
       </td>

      </tr>
      @endforeach
     </table>

     {{ $data->links('vendor.pagination.custom') }}

    </div>
