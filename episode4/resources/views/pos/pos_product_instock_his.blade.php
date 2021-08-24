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

</head>


<body class="hold-transition sidebar-mini layout-fixed layout-navbar-fixed layout-footer-fixed">
    <div class="wrapper">

        <div class="content">
            <div class="container-fluid">
                <br>
                <div class="row mb-12">
                    <div class="col-sm-12">

                        <div class="modal-content">
                            <div class="modal-header">
                                <h4 class="modal-title"><strong>Item Name: </strong>
                                    {{ isset($history[0]->pro_name) ? $history[0]->pro_name . ' ( ' . $history[0]->pro_barcode . ' )' : '' }}
                                </h4>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="table-responsive">
                                    <span id="result"></span>
                                    <table class="table table-bordered table-striped" id="table_input">
                                        <thead>
                                            <tr class="table-primary">
                                                <th width="15%">Tracking</th>
                                                <th width="15%">Stock</th>
                                                <th width="15%">Qty</th>
                                                <th width="20%">Date</th>
                                                <th width="15%">Inputter</th>
                                                <th width="15%">Status</th>
                                            </tr>

                                        </thead>
                                        <tbody>

                                            @foreach ($history as $row)
                                                <tr class="table-secondary">
                                                    <td>{{ $row->sysdocnum }}</td>
                                                    <td>{{ $row->stockname }}</td>
                                                    <td>{{ $row->qty }}</td>
                                                    <td>{{ $row->inputdate }}</td>
                                                    <td>{{ $row->inputter }}</td>
                                                    <td>{{ $row->trn_status }}</td>
                                                </tr>

                                            @endforeach
                                        </tbody>

                                    </table>
                                </div>
                                {{ $history->links('vendor.pagination.custom') }}
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
