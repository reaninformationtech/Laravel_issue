<div class="table-responsive">
    <table class="table table-striped table-bordered">
        <tr>
            <th width="5%">Code</th>
            <th width="38%">Branch name</th>
            <th width="38%">Full name</th>
            <th width="38%">Short name</th>
            <th width="38%">Phone</th>
            <th width="38%">Email</th>
            <th width="57%">Website</th>
            <th width="38%">Inactive</th>
            <th width="57%">Action</th>
        </tr>
        @foreach($data as $row)
        <tr>
            <td>{{ $row->branchcode }}</td>
            <td>{{ $row->setname }}</td>
            <td>{{ $row->branchname }}</td>
            <td>{{ $row->branchshort }}</td>
            <td>{{ $row->phone }}</td>
            <td>{{ $row->email }}</td>
            <td>{{ $row->website }}</td>
            <td>{{ $row->status }}</td>
            <td>

                <div class="row mb-12">
                    <div class="col-sm-2">
                    </div>

                    <div class="col-sm-6">
                        <div class="row mb-2">

                            <button type="button" name='edit' id='{{ $row->branchcode }}'    class="edit btn btn-xs btn-success btn-sm my-0"><i class="fas fa-edit"></i></button>
                        </div>
                    </div>

                </div>
            </td>

        </tr>
        @endforeach
    </table>

    {{ $data->links('vendor.pagination.custom') }}

</div>
