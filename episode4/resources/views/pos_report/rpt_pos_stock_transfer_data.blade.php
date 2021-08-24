<div class="row">
    <div class="col-md-12">
        <div class="card">
            <div class="card-header border-0">
                <div class="card-tools">
                    <a href="#" class="btn btn-tool btn-sm" onclick="saveAsExcel('tableToExcel', 'rpt_pos_product_in_stock.xls')">
                        <i class="fas fa-download"></i>
                    </a>
                </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped table-bordered" id="tableToExcel">
                    <tr>
                        <th>tran_code</th>
                        <th>Item</th>
                        <th>from Stock</th>
                        <th>to Stock</th>
                        <th>Remark</th>
                        <th>Qty</th>
                        <th>Date</th>
                    </tr>


                    @if(isset($rpt_data))

                        @foreach($rpt_data as $row)
                        <tr>
                            <td>{{ $row->tran_code}}</td>
                            <td>{{ $row->pro_name}}</td>
                            <td>{{ $row->stockfrom}}</td>
                            <td>{{ $row->stockto}}</td>
                            <td>{{ $row->remark}}</td>
                            <td>{{ $row->qty}}</td>
                            <td>{{ $row->inputdate}}</td>
                        </tr>
                        @endforeach

                    @endif

                </table>
            </div>
        </div>
    </div>
</div>
