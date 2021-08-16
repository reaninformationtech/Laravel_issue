<div class="table-responsive">
    <span id="result"></span>
    <table class="table table-bordered table-striped" id="table_input">
        <thead>
            <tr>
                <th width="5%">ID</th>
                <th width="38%">Pro name</th>
                <th width="15%">stockname</th>
                <th width="15%">qty</th>
                <th width="15%"></th>
            </tr>

        </thead>
        <tbody>

            @foreach($data as $row)
            <tr>

                <td>{{ $row->pro_code }}</td>
                <td>{{ $row->pro_name }}</td>
                <td>{{ $row->stockname }}</td>
                <td>{{ $row->qty }}</td>
                <td>

                    <div class="row mb-12">
                    <div class="col-sm-2">
                    </div>
                        <div class="col-sm-6">
                            <div class="row mb-2">
                                <a href="{{url('pos_in_stock_history/'.$row->pro_code)}}" target="_blank" class="text-center">
                                    <button type="button" class="edit btn btn-xs btn-success btn-sm my-0"><i  class="fas fa-eye"></i></button>
                                </a>
                            </div>

                        </div>
                    </div>
                </td>
            </tr>

            @endforeach

        </tbody>

    </table>
    <div>
        {{$data->links('vendor.pagination.custom') }}
    </div>

   
</div>

