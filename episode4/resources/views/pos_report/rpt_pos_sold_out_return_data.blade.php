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
                        <th>Invoice</th>
                        <th>Customer</th>
                        <th>Item</th>
                        <th>Type</th>
                        <th>Qty</th>
                        <th>Unitprice</th>
                        <th>Discount</th>
                        <th>Amount</th>
                        <th>Remark</th>
                        <th>Inputter</th>
                    </tr>

                    @if(isset($rpt_data))
                        @foreach($rpt_data as $row)
                        <tr>
                            <td>{{ $row->inv_num}}</td>
                            <td>{{ $row->cus_info}}</td>
                            <td>{{ $row->pro_name}}</td>
                            <td>{{ $row->pro_type}}</td>
                            <td>{{ $row->qty}}</td>
                            <td>{{ $row->pro_up}}</td>
                            <td>{{ $row->pro_discount}}</td>
                            <td>{{ $row->pro_amount}}</td>
                            <td>{{ $row->inv_reason}}</td>
                            <td>{{ $row->inputter}}</td>

                        </tr>
                        @endforeach

                    @endif

                </table>

            </div>

        </div>
    </div>
</div>
