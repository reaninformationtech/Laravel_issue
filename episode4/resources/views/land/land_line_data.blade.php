<div class="table-responsive">
    <table class="table table-striped table-bordered">
        <tr>
            <th width="5%">Item_ID</th>
            <th width="38%">Item name</th>
            <th width="5%">Inactive</th>
            <th >Item Line</th>
            <th >Remark</th>
            <th width="5%">Action</th>
        </tr>
        @foreach($data as $row)
        <tr>
            <td>{{ $row->item_id }}</td>
            <td>{{ $row->item_name }}</td>
            <td>{{ $row->status }}</td>
            <td>{{ $row->type }}</td>
            <td>{{ $row->item_remark }}</td>
            <td>

                <div class="row mb-12">
                    <div class="col-sm-6">
                        <div class="row mb-2">
                            <button type="button" name='edit' id='{{ $row->item_id }}'    class="edit btn btn-xs btn-success btn-sm my-0"><i class="fas fa-edit"></i></button>
                        </div>

                    </div>

                    <div class="col-sm-6">

                        <div class="row mb-2">
                            <button type="button" name='delete' id='{{ $row->item_id }}'  class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button>
                        </div>
                    </div>

                </div>
            </td>

        </tr>
        @endforeach
    </table>
    {{ $data->links('vendor.pagination.custom') }}
</div>
