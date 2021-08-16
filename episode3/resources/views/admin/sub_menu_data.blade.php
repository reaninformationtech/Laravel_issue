   <div class="table-responsive">
       <table class="table table-striped table-bordered">
           <tr >
               <th width="5%">Sub_ID</th>
               <th width="38%">Sub name</th>
               <th width="38%">main menu</th>
               <th width="57%">Controller</th>
               <th width="57%">Function</th>
               <th width="57%">Status</th>
               <th width="57%">Action</th>
           </tr>
           @php
               $my_variable = '';
           @endphp

           @foreach ($data as $row)

               @if ($my_variable != $row->menu_id && $my_variable != '')

                   <tr>
                       <th width="5%">{{ $row->menu_id }}</th>
                       <th width="38%">{{ $row->menu_name }}</th>
                       <th width="38%"></th>
                       <th width="57%"></th>
                       <th width="57%"></th>
                       <th width="57%"></th>
                       <th width="57%"></th>
                   </tr>
               @endif



               <tr >
                   <td>{{ $row->subm_id }}</td>
                   <td>{{ $row->subm_name }}</td>
                   <td>{{ $row->menu_name }}</td>
                   <td>{{ $row->subm_controller }}</td>
                   <td>{{ $row->subm_function }}</td>
                   <td>{{ $row->status }}</td>
                   <td>

                       <div class="row mb-12">
                           <div class="col-sm-6">
                               <div class="row mb-2">
                                   <button type="button" name='edit' id='{{ $row->subm_id }}'
                                       class="edit btn btn-xs btn-success btn-sm my-0"><i
                                           class="fas fa-edit"></i></button>
                               </div>

                           </div>

                           <div class="col-sm-6">

                               <div class="row mb-2">
                                   <button type="button" name='delete' id='{{ $row->subm_id }}'
                                       class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button>
                               </div>
                           </div>

                       </div>
                   </td>

               </tr>


               @php
                   $my_variable = $row->menu_id;
               @endphp
           @endforeach
       </table>

       {{ $data->links('vendor.pagination.custom') }}
   </div>
