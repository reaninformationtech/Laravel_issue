<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header border-0">
                <div class="card-tools">
                    <a href="#" class="btn btn-tool btn-sm" id="link"
                        onclick="saveAsExcel('tableToExcel', 'rpt_pos_.xls')">
                        <i class="fas fa-download"></i>
                    </a>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered" id="tableToExcel">
                    <tr>
                        <th>Trancode</th>
                        <th>Type</th>
                        <th>Referent</th>
                        <th>Currency</th>
                        <th>Amount</th>
                        <th>Remark</th>
                        <th>Date</th>
                        <th>Image</th>
                    </tr>

                    @if (isset($rpt_data))
                        @foreach ($rpt_data as $row)
                            <tr>
                                <td>{{ $row->tran_code }}</td>
                                <td>{{ $row->line_name }}</td>
                                <td>{{ $row->referent }}</td>
                                <td>{{ $row->currency }}</td>
                                <td>{{ $row->amount }}</td>
                                <td>{{ $row->remark }}</td>
                                <td>{{ $row->inputdate }}</td>
                                <td>
                                    <div class="col-sm-5">
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="row mb-2">
                                            <a href="{{ url('customer_view/' . $row->tran_code) }}" class="text-center">
                                                <button type="button" name='edit' id='{{ $row->tran_code }}'
                                                    class="edit btn btn-xs btn-success btn-sm my-0">
                                                    <i class="fas fa-eye"></i></button>
                                            </a>
                                        </div>

                                    </div>

                                </td>
                            </tr>
                        @endforeach
                    @endif
                </table>
            </div>

        </div>
    </div>
</div>
