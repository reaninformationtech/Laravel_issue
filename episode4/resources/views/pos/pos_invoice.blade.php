@extends('layouts.app')

@section('content')

    <style type="text/css" media="print">
        @page {
            size: auto;
            /* auto is the initial value */
            margin: 0mm;
            /* this affects the margin in the printer settings */
        }

        html {
            background-color: #FFFFFF;
            margin: 0px;
            /* this affects the margin on the html before sending to printer */
        }

        body {
            border: solid 1px blue;
            margin: 10mm 15mm 10mm 15mm;
            /* margin you want for the content */
        }

    </style>

    @php
    $total_qty = 0;
    @endphp

    <div id='printMe'>
        <div class="container">
            <div class="row">
                <!-- Main content -->
                <div class="invoice p-3 mb-3">
                    <!-- title row -->
                    <div class="row">
                        <div class="col-12">
                            <h4>
                                <i class="fa fa-globe"></i> {{ $company[0]->branchname }}
                                <small class="float-right">Date: {{ $customerinfo[0]->inv_date }}</small>
                            </h4>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- info row -->
                    <div class="row invoice-info">
                        <div class="col-sm-4 invoice-col">
                            From
                            <address>
                                <strong>{{ $company[0]->branchname }}.</strong><br>
                                {{ $company[0]->address }}<br>
                                Phone: {{ $company[0]->phone }}<br>
                                Email: {{ $company[0]->email }}
                            </address>
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-4 invoice-col">
                            To
                            <address>
                                <strong>{{ $customerinfo[0]->cus_name }} ({{ $customerinfo[0]->cus_id }})</strong><br>
                                {{ $customerinfo[0]->cus_address }}<br>
                                Phone: {{ $customerinfo[0]->cus_phone }}<br>

                            </address>
                        </div>
                        <!-- /.col -->
                        <div class="col-sm-4 invoice-col">
                            <b>Invoice #{{ $customerinfo[0]->inv_num }}</b><br>
                            <br>
                            <b>Inputter:</b> {{ $customerinfo[0]->inputter }}<br>
                            <b>Payment Due:</b> {{ $customerinfo[0]->todaynow }}<br>

                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <!-- Table row -->
                    <div class="row">
                        <div class="col-12 table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Qty</th>
                                        <th>Product</th>
                                        <th>Serial #</th>
                                        <th>Unit price</th>
                                        <th>Discount</th>
                                        <th>Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @foreach ($invoice as $row)
                                        <tr>
                                            <td>{{ $row->pro_qty }}</td>
                                            <td>{{ $row->pro_name }}</td>
                                            <td>{{ $row->sto_num }}</td>
                                            <td>{{ $row->pro_up }}</td>
                                            <td>{{ $row->pro_discount }}</td>
                                            <td>{{ $row->pro_amount }}</td>
                                        </tr>

                                        @php
                                            $total_qty = $total_qty + $row->pro_amount;
                                        @endphp

                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <div class="row">
                        <!-- accepted payments column -->
                        <div class="col-6">
                            <p class="lead">Payment Methods:</p>
                            <p class="text-muted well well-sm no-shadow" style="margin-top: 10px;">
                            <div class="col-sm-4 invoice-col">
                                <address>
                                    @foreach ($payment_method as $row)
                                        {{ $row->payment_method }} <br>
                                    @endforeach

                                </address>
                            </div>
                            </p>
                        </div>
                        <!-- /.col -->
                        <div class="col-6">
                            <div class="table-responsive">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <th style="width:50%">Subtotal:</th>
                                            <td>$ {{ $total_qty }}</td>
                                        </tr>
                                        <tr>
                                            <th>Tax (0%)</th>
                                            <td>$ 0.00</td>
                                        </tr>
                                        <tr>
                                            <th>Shipping:</th>
                                            <td>$0.00</td>
                                        </tr>
                                        <tr>
                                            <th>Total:</th>
                                            <td>$ {{ $total_qty }}</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <!-- /.col -->
                    </div>
                    <!-- /.row -->

                    <!-- this row will not appear when printing -->
                    <div class="row no-print">
                        <div class="col-12">

                            <a href="" onclick="printDiv('printMe')" class="btn btn-default"><i class="fa fa-print"></i>
                                Print</a>

                        </div>
                    </div>

                </div>
                <!-- /.invoice -->
            </div>


        </div>
    </div>

    </div>

@endsection

@section('scripts')
    <script type="text/javascript">
        function printDiv(divName) {
            var printContents = document.getElementById(divName).innerHTML;
            var originalContents = document.body.innerHTML;
            document.body.innerHTML = printContents;
            document.title = "Thank for your coming again !";
            var curURL = window.location.href;
            history.replaceState(history.state, '', '/');

            window.print();
            document.body.innerHTML = originalContents;
            history.replaceState(history.state, '', curURL);

        }
    </script>
@endsection
