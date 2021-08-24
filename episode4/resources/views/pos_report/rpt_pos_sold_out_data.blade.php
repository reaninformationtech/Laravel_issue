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
                        <th>Inputter</th>
                        <th>View</th>
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
                            <td>{{ $row->inputter}}</td>
                            <td>
                                <div class="row mb-12">
                                    <div class="col-sm-4">
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="row mb-2">
                                            <a href="{{url('pos_invoices_show/'.$row->inv_num)}}"  target="_blank" class="text-center">
                                                <button type="button" class="edit btn btn-xs btn-danger btn-sm my-0"><i class="fas fa-print"></i></button>
                                            </a>
                                        </div>
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
