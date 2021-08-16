   <div class="table-responsive">
       <table class="table table-striped table-bordered">
           <tr>
               <th width="5%">Sys_ID</th>
               <th width="38%">Sys name</th>
               <th width="38%">short name</th>

               <th width="38%">Effective</th>
               <th>Remark</th>
               <th width="57%">Status</th>
               <th width="57%">Action</th>
           </tr>
           @foreach ($data as $row)
               <tr>
                   <td>{{ $row->sys_con_id }}</td>
                   <td>{{ $row->sys_con_name }}</td>
                   <td>{{ $row->sys_con_short_name }}</td>
                   <td>{{ $row->sys_con_effective }}</td>
                   <td>{{ $row->sys_con_remark }}</td>
                   <td>{{ $row->status }}</td>
                   <td>

                       <div class="row mb-12">
                           <div class="col-sm-6">
                               <div class="row mb-2">
                                   <button type="button" name='edit' id='{{ $row->sys_con_id }}'
                                       class="edit btn btn-xs btn-success btn-sm my-0"><i
                                           class="fas fa-edit"></i></button>
                               </div>

                           </div>

                           <div class="col-sm-6">

                               <div class="row mb-2">
                                   <button type="button" name='delete' id='{{ $row->sys_con_id }}'
                                       class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button>
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
