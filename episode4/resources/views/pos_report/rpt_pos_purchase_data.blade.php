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
                        <th width="10%">Code</th>
                        <th>Item</th>
                        <th>Stock</th>
                        <th>Type</th>
                        <th>Qty</th>
                        <th>Supply</th>
                    </tr>


                    @if(isset($rpt_data))

                        @foreach($rpt_data as $row)
                        <tr>
                            <td>{{ $row->pur_id}}</td>
                            <td>{{ $row->pro_name}}</td>
                            <td>{{ $row->stock}}</td>
                            <td>{{ $row->pro_typ}}</td>
                            <td>{{ $row->qty}}</td>
                            <td>{{ $row->sup_name}}</td>
                        </tr>
                        @endforeach

                    @endif


                </table>

            </div>


        </div>
    </div>
</div>
