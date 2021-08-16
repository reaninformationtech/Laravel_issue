<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- CSRF Token -->
    <meta name="_token" content="{{ csrf_token() }}">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta http-equiv="Content-Security-Policy" content="block-all-mixed-content">
    <meta name="facebook-domain-verification" content="at5k4diviqkcx2zjknb5lq23ilwa0u" />
    <meta property="fb:pages" content="106214948192013" />
    <meta name="description" content="Toanchet-Market, join global market , Call : 010 500 313">

    <title>{{ config('app.name', 'Toanchet-Market') }}</title>
    <link rel="shortcut icon" href="{{ URL::asset('admin/image/logo_icon.ico') }}">
    
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
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

    <!-- Google Font: Source Sans Pro -->
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
    <!-- jQuery CDN -->

</head>

<body class="hold-transition sidebar-mini layout-fixed layout-navbar-fixed layout-footer-fixed">
    <div class="wrapper">
        <!-- Navbar -->
        <nav class="main-header navbar navbar-expand navbar-dark">
            @include('layouts.nav_menu')
        </nav>
        <!-- /.navbar -->

        <!-- Main Sidebar Container -->
        <aside class="main-sidebar sidebar-dark-primary elevation-4">
            <!-- Brand Logo -->
            <a href="index3.html" class="brand-link">
                <img src="{{ route('id_img_userprofile', Session::get('userinfo')['id']) }}" alt="TC Logo"
                    class="brand-image img-circle elevation-3" style="opacity: .8">
                <span class="brand-text font-weight-light">{{ Session::get('userinfo')['name'] }}</span>
            </a>

            @include('layouts.Sidebar')
        </aside>

        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper">
            <!-- Content Header (Page header) -->
            <div class="content-header">
                <div class="container-fluid">

                </div><!-- /.container-fluid -->
            </div>
            <!-- /.content-header -->

            <!-- Main content -->
            <div class="content">
                <div class="container-fluid">
                    @yield('content')
                    <!-- /.row -->
                </div><!-- /.container-fluid -->
            </div>
            <!-- /.content -->
        </div>
        <!-- /.content-wrapper -->

        <!-- Control Sidebar Right -->
        <aside class="control-sidebar control-sidebar-dark">
            <!-- Control sidebar content goes here -->
            <div class="p-3">
                <h5>Title</h5>
                <p>Sidebar content</p>
            </div>
        </aside>
        <!-- /.control-sidebar -->

        <!-- Main Footer -->
        @include('layouts.footer')
    </div>
    <!-- ./wrapper -->

    <!-- Admin Page SCRIPTS -->
    <script type="text/javascript" src="{{ URL::asset('admin/plugins/jquery/jquery.min.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/plugins/bootstrap/js/bootstrap.bundle.min.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/dist/js/adminlte.min.js') }} "></script>
    <!-- ./wrapper -->

    <!-- Select2 -->
    <script type="text/javascript" src="{{ URL::asset('admin/plugins/select2/js/select2.full.min.js') }} "></script>

    <!-- select for combobox -->
    <script type="text/javascript" src="{{ URL::asset('admin/select/js/bootstrap-select.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/alert/sweetalert2.all.min.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/alert/sweetalert2.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/alert/sweetalert2.min.js') }} "></script>

</body>

</html>
@yield('scripts')
