<!doctype html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>{{ config('app.name', 'Toanchet-Market') }}</title>
    <link rel="shortcut icon" href="{{ URL::asset('admin/image/logo_icon.ico') }}">
    <meta name="description" content="Toanchet-Market, join global market , Call : 010 500 313">

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

<body class="hold-transition register-page">
    <div class="register-box">
        <div class="card card-outline card-primary">
            <div class="card-header text-center">
                <a href="../../index2.html" class="h1"><b>TC</b>-Market</a>
            </div>
            <div class="card-body">
                <p class="login-box-msg">Register a new membership</p>

                <form method="POST" id="login_form" action="{{ route('createuser') }}">

                    @if (Session::get('success'))
                        <div class="alert alert-success" role="alert">
                            {{ Session::get('success') }}
                        </div>
                    @endif

                    @if (Session::get('fail'))
                        <div class="alert alert-success">
                            {{ Session::get('fail') }}
                        </div>
                    @endif

                    @csrf

                    <div class="input-group mb-3">

                        <select class="selectpicker form-control  @error('system') is-invalid @enderror" name="system"
                            id="system" data-live-search="true">
                            @foreach ($system as $row)

                                @if (old('system') == $row->id)
                                    <option data-tokens="{{ $row->id }}" value="{{ $row->id }}" selected>
                                        {{ $row->name }}</option>
                                @else
                                    <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                        {{ $row->name }}</option>
                                @endif

                            @endforeach
                        </select>

                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-store"></span>
                            </div>
                        </div>

                        @error('system')
                            <span class="invalid-feedback" role="alert">
                                <strong>{{ $message }}</strong>
                            </span>
                        @enderror

                    </div>



                    <div class="input-group mb-3">
                        <input type="text" id="name" class="form-control @error('name') is-invalid @enderror"
                            name="name" value="{{ old('name') }}" autocomplete="name"
                            data-error="You must have a name." autofocus placeholder="Branch name">
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-user"></span>
                            </div>
                        </div>

                        @error('name')
                            <span class="invalid-feedback" role="alert">
                                <strong>{{ $message }}</strong>
                            </span>
                        @enderror

                    </div>
                    <div class="input-group mb-3">
                        <input type="email" id="email" class="form-control @error('email') is-invalid @enderror"
                            name="email" value="{{ old('email') }}" autocomplete="email" autofocus
                            placeholder="Email">

                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-envelope"></span>
                            </div>
                        </div>

                        @error('email')
                            <span class="invalid-feedback" role="alert">
                                <strong>{{ $message }}</strong>
                            </span>
                        @enderror

                    </div>
                    <div class="input-group mb-3">
                        <input type="password" id="password"
                            class="form-control @error('password') is-invalid @enderror" name="password"
                            value="{{ old('password') }}" autocomplete="password" autofocus placeholder="Password">
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-lock"></span>
                            </div>
                        </div>

                        @error('password')
                            <span class="invalid-feedback" role="alert">
                                <strong>{{ $message }}</strong>
                            </span>
                        @enderror

                    </div>
                    <div class="input-group mb-3">
                        <input type="password" id="cpassword"
                            class="form-control @error('cpassword') is-invalid @enderror" name="cpassword"
                            value="{{ old('cpassword') }}" autocomplete="cpassword" autofocus
                            placeholder="Repeat Password">
                        <div class="input-group-append">
                            <div class="input-group-text">
                                <span class="fas fa-lock"></span>
                            </div>
                        </div>


                        @error('password')
                            <span class="invalid-feedback" role="alert">
                                <strong>{{ $message }}</strong>
                            </span>
                        @enderror
                    </div>

                    <div class="row">
                        <div class="col-8">
                            <div class="icheck-primary">
                                <input type="checkbox" id="agreeTerms" name="terms" value="agree">
                                <label for="agreeTerms">
                                    I agree to the <a href="#">terms</a>
                                </label>
                            </div>
                        </div>
                        <!-- /.col -->
                        <div class="col-4">
                            <button type="submit" name="btnOk" id="btnOk"
                                class="btn btn-primary btn-block">Register</button>
                        </div>
                        <!-- /.col -->
                    </div>
                </form>
                <a href="{{ route('login') }}" class="text-center">I already have a membership</a>
            </div>
            <!-- /.form-box -->
        </div><!-- /.card -->

    </div>
    <!-- /.register-box -->

    <!-- REQUIRED SCRIPTS -->

    <!-- Admin Page SCRIPTS -->
    <script type="text/javascript" src="{{ URL::asset('admin/plugins/jquery/jquery.min.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/plugins/bootstrap/js/bootstrap.bundle.min.js') }} ">
    </script>
    <script type="text/javascript" src="{{ URL::asset('admin/dist/js/adminlte.min.js') }} "></script>
    <!-- ./wrapper -->

    <!-- Select2 -->
    <script type="text/javascript" src="{{ URL::asset('admin/plugins/select2/js/select2.full.min.js') }} "></script>

    <!-- select for combobox -->
    <script type="text/javascript" src="{{ URL::asset('admin/select/js/bootstrap-select.js') }} "></script>

    <script type="text/javascript" src="{{ URL::asset('admin/alert/sweetalert2.all.min.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/alert/sweetalert2.js') }} "></script>
    <script type="text/javascript" src="{{ URL::asset('admin/alert/sweetalert2.min.js') }} "></script>

    <script type="text/javascript">
        $(function() {
            const Toast = Swal.mixin({
                toast: true,
                position: 'top-end',
                showConfirmButton: false,
                timer: 3000
            });

            $('.swalDefaultSuccess').click(function() {
                Toast.fire({
                    icon: 'success',
                    title: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.swalDefaultInfo').click(function() {
                Toast.fire({
                    icon: 'info',
                    title: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.swalDefaultError').click(function() {
                Toast.fire({
                    icon: 'error',
                    title: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.swalDefaultWarning').click(function() {
                Toast.fire({
                    icon: 'warning',
                    title: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.swalDefaultQuestion').click(function() {
                Toast.fire({
                    icon: 'question',
                    title: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });

            $('.toastrDefaultSuccess').click(function() {
                toastr.success('Lorem ipsum dolor sit amet, consetetur sadipscing elitr.')
            });
            $('.toastrDefaultInfo').click(function() {
                toastr.info('Lorem ipsum dolor sit amet, consetetur sadipscing elitr.')
            });
            $('.toastrDefaultError').click(function() {
                toastr.error('Lorem ipsum dolor sit amet, consetetur sadipscing elitr.')
            });
            $('.toastrDefaultWarning').click(function() {
                toastr.warning('Lorem ipsum dolor sit amet, consetetur sadipscing elitr.')
            });

            $('.toastsDefaultDefault').click(function() {
                $(document).Toasts('create', {
                    title: 'Toast Title',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultTopLeft').click(function() {
                $(document).Toasts('create', {
                    title: 'Toast Title',
                    position: 'topLeft',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultBottomRight').click(function() {
                $(document).Toasts('create', {
                    title: 'Toast Title',
                    position: 'bottomRight',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultBottomLeft').click(function() {
                $(document).Toasts('create', {
                    title: 'Toast Title',
                    position: 'bottomLeft',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultAutohide').click(function() {
                $(document).Toasts('create', {
                    title: 'Toast Title',
                    autohide: true,
                    delay: 750,
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultNotFixed').click(function() {
                $(document).Toasts('create', {
                    title: 'Toast Title',
                    fixed: false,
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultFull').click(function() {
                $(document).Toasts('create', {
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.',
                    title: 'Toast Title',
                    subtitle: 'Subtitle',
                    icon: 'fas fa-envelope fa-lg',
                })
            });
            $('.toastsDefaultFullImage').click(function() {
                $(document).Toasts('create', {
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.',
                    title: 'Toast Title',
                    subtitle: 'Subtitle',
                    image: '../../dist/img/user3-128x128.jpg',
                    imageAlt: 'User Picture',
                })
            });
            $('.toastsDefaultSuccess').click(function() {
                $(document).Toasts('create', {
                    class: 'bg-success',
                    title: 'Toast Title',
                    subtitle: 'Subtitle',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultInfo').click(function() {
                $(document).Toasts('create', {
                    class: 'bg-info',
                    title: 'Toast Title',
                    subtitle: 'Subtitle',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultWarning').click(function() {
                $(document).Toasts('create', {
                    class: 'bg-warning',
                    title: 'Toast Title',
                    subtitle: 'Subtitle',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultDanger').click(function() {
                $(document).Toasts('create', {
                    class: 'bg-danger',
                    title: 'Toast Title',
                    subtitle: 'Subtitle',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
            $('.toastsDefaultMaroon').click(function() {
                $(document).Toasts('create', {
                    class: 'bg-maroon',
                    title: 'Toast Title',
                    subtitle: 'Subtitle',
                    body: 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr.'
                })
            });
        });
    </script>




    <script type="text/javascript">
        $(document).ready(function() {

            function containsOnlyKahmerCharakter(str) {
                return str.split('').some(function(char) {
                    var charCode = char.charCodeAt('0')
                    return (
                        charCode >= 0x1780 && charCode <= 0x17FF ||
                        charCode >= 0x19e0 && charCode <= 0x19FF
                    )
                })
            }

            $(function() {
                //Initialize Select2 Elements
                $('.select2').select2()
            })

            $('#btnOk').prop('disabled', true);
            $('input[type=checkbox]').change(function() {
                var count = 0;
                $.each($('input[type=checkbox]'), function() {
                    if ($(this).prop('checked') == true) {
                        count++;
                    }
                });
                if (count == 1) {
                    $('#btnOk').prop('disabled', false);
                } else {
                    $('#btnOk').prop('disabled', true);
                }
            });



            $("#name").keypress(function(e) {

                if (e.keyCode == 0 || e.keyCode == 32) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'System does not allow space'
                    })
                    e.preventDefault()
                    return;
                }else{
                    var regex = new RegExp("^[a-zA-Z0-9 ]+$");
                    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
                    if (regex.test(str)) {
                        return true;
                    }

                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Branch name allow only English !'
                    })

                    e.preventDefault();
                    return false;
                }
            });


            $('#login_form').on('submit', function(event) {
                var id = $('#name').val();
                if (containsOnlyKahmerCharakter(id) == true) {
                    event.preventDefault();
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Branch name allow only English !'
                    })
                    e.preventDefault()
                    return;
                }
            });

        });
    </script>

</body>

</html>
