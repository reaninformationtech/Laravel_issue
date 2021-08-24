<div class="table-responsive">
    <table class="table table-striped table-bordered">
        <tr>
            <th width="5%">Pro_ID</th>
            <th width="38%">Profile name</th>
            <th width="38%">Branch name</th>
            <th width="57%">Status</th>
            <th width="57%">Action</th>
        </tr>
        @foreach($data as $row)
        <tr>
            <td>{{ $row->profileid }}</td>
            <td>{{ $row->profilename }}</td>
            <td>{{ $row->branchname }}</td>
            <td>{{ $row->status }}</td>
            <td>

                <div class="row mb-12">
                    <div class="col-sm-6">
                        <div class="row mb-2">
                            <button type="button" name='edit' id='{{ $row->profileid }}'    class="edit btn btn-xs btn-success btn-sm my-0"><i class="fas fa-edit"></i></button>
                        </div>

                    </div>

                    <div class="col-sm-6">

                        <div class="row mb-2">
                            <button type="button" name='delete' id='{{ $row->profileid }}'  class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button>
                        </div>
                    </div>

                </div>
            </td>

        </tr>
        @endforeach
    </table>
    {{ $data->links('vendor.pagination.custom') }}
</div>
