<div class="table-responsive">
    <table class="table table-striped table-bordered">
        <tr>
            <th width="5%">ID</th>
            <th width="38%">Type</th>
            <th width="5%">Currency</th>
            <th >Amount</th>
            <th >Referent</th>
            <th >Remark</th>
            <th >Inputter</th>
            <th width="5%">Action</th>
        </tr>
        @foreach($data as $row)
        <tr>
            <td>{{ $row->exp_id}}</td>
            <td>{{ $row->line_type }}</td>
            <td>{{ $row->currency }}</td>
            <td>{{ $row->exp_unitprice }}</td>
            <td>{{ $row->exp_referent }}</td>
            <td>{{ $row->exp_remark }}</td>
            <td>{{ $row->exp_inputter }}</td>
            <td>

                <div class="row mb-12">
                    <div class="col-sm-3">
                    </div>

                    <div class="col-sm-6">

                        <div class="row mb-2">
                            <button type="button" name='delete' id='{{ $row->exp_id }}'  class="delete btn btn-xs btn-danger"><i class="far fa-trash-alt"></i></button>
                        </div>
                    </div>

                </div>
            </td>

        </tr>
        @endforeach
    </table>

    {{ $data->links('vendor.pagination.custom') }}

</div>
 