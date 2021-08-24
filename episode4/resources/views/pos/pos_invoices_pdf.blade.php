<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ config('app.name', 'Toanchet-Market') }}</title>

    <!-- Admin Page -->
    <link rel="stylesheet" href="{{ URL::asset('admin/plugins/fontawesome-free/css/all.min.css') }}">
    <link rel="stylesheet" href="{{ URL::asset('admin/dist/css/adminlte.min.css') }}">

    <!-- Select2 -->
    <link rel="stylesheet" href="{{ URL::asset('admin/plugins/select2/css/select2.min.css') }}">
    <link rel="stylesheet"
        href="{{ URL::asset('admin/plugins/select2-bootstrap4-theme/select2-bootstrap4.min.css') }}">

    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="{{ URL::asset('admin/plugins/icheck-bootstrap/icheck-bootstrap.min.css') }}">

    <!-- Combobox select -->
    <link rel="stylesheet" href="{{ URL::asset('admin/select/css/bootstrap-select.css') }}">


    <!-- Fonts -->
    <link rel="dns-prefetch" href="//fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css?family=Nunito" rel="stylesheet">

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">

    <style>
        @media print {
            .noPrint {
                display: none;
            }
        }
        h1 {
            color: #f6f6;
        }
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

    </style>

</head>

<body class="hold-transition sidebar-collapse layout-top-nav">

    <div id="printableArea">

        @php
            $total_qty = 0;
        @endphp


        <div class="wrapper">
            <br>
            <div class="container">
                <div class="row">
                    <div class="col-12">

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
                                        <strong>{{ $customerinfo[0]->cus_name }}
                                            ({{ $customerinfo[0]->cus_id }})</strong><br>
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
                                                    <th>Delivery:</th>
                                                    <td>${{ $invoice[0]->delivery }}</td>
                                                </tr>
                                                <tr>

                                                    @php
                                                        $total_qty = $total_qty + $invoice[0]->delivery;
                                                    @endphp

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
                                    <a href="" onclick="window.print();" class="btn btn-primary float-right"><i
                                            class="fa fa-print"></i>Print</a>
                                </div>
                            </div>


                            <p>* Noted *</p>


                        </div>
                        <!-- /.invoice -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>

</html>

@section('scripts')
    <script type="text/javascript">
        function printDiv(divName) {
            var printContents = document.getElementById(divName).innerHTML;
            var originalContents = document.body.innerHTML;

            document.body.innerHTML = printContents;

            window.print();

            document.body.innerHTML = originalContents;
        }
    </script>
@endsection
