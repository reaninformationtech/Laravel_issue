<div class="table-responsive">
    <table class="table table-striped table-bordered">
        <tr class="table-primary">
            <th width="5%">ID</th>
            <th width="38%">Item name</th>
            <th width="57%">Remark</th>
            <th width="38%">Status</th>
            <th width="57%">Action</th>
        </tr>
        @php
            $my_variable = '';
        @endphp

        @foreach ($data as $row)


            @if ($my_variable != $row->line_type && $my_variable != '')

                <tr class="table-primary">
                    <th width="5%">{{ $row->line_type }}</th>
                    <th width="38%">{{ $row->line }}</th>
                    <th width="38%"></th>
                    <th width="57%"></th>
                    <th width="57%"></th>
                </tr>
            @endif


            <tr class="table-secondary">
                <td>{{ $row->line_id }}</td>
                <td>{{ $row->line_name }}</td>
                <td>{{ $row->line_remark }}</td>
                <td>{{ $row->status }}</td>
                <td>

                    <div class="row mb-12">
                        <div class="col-sm-6">
                            <div class="row mb-2">
                                <button type="button" name='edit' id='{{ $row->line_id }}'
                                    class="edit btn btn-xs btn-success btn-sm my-0"><i class="fas fa-edit"></i></button>
                            </div>

                        </div>

                        <div class="col-sm-6">

                            <div class="row mb-2">
                                <button type="button" name='delete' id='{{ $row->line_id }}'
                                    class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button>
                            </div>
                        </div>

                    </div>
                </td>
            </tr>

            @php
                $my_variable = $row->line_type;
            @endphp
        @endforeach
    </table>

    {{ $data->links('vendor.pagination.custom') }}
</div>
