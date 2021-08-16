<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header border-0">
                <div class="card-tools">
                    <a href="#" class="btn btn-tool btn-sm" onclick="saveAsExcel('tableToExcel', 'rpt_pos_monthly_closing.xls')">
                        <i class="fas fa-download"></i>
                    </a>
                </div>
            </div>
            <div class="table-responsive">
                
                <table class="table table-striped table-bordered" id="tableToExcel">
                    <tr>
                        <th>Referent</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Close_date</th>
                    </tr>

                    @if(isset($rpt_data))
                        @foreach($rpt_data as $row)
                        <tr>
                            <td>{{ $row->trancode}}</td>
                            <td>{{ $row->amount}}</td>
                            <td>{{ $row->status}}</td>
                            <td>{{ $row->close_date}}</td>

                        </tr>
                        @endforeach

                    @endif

                </table>

            </div>


        </div>
    </div>
</div>
