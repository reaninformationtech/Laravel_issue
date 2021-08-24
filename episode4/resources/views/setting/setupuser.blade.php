@extends('layouts.app')
@section('content')

    <style>
        body {
            background: #EECDA3;
            background: -webkit-linear-gradient(to top, #EF629F, #EECDA3);
            background: linear-gradient(to top, #EF629F, #EECDA3);
        }

        .container {
            max-width: 550px;
        }

        .has-error label,
        .has-error input,
        .has-error textarea {
            color: red;
            border-color: red;
        }

        .list-unstyled li {
            font-size: 13px;
            padding: 4px 0 0;
            color: red;
        }

    </style>
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title" name="create_record" id="create_record">
                            <button type="button" id="create" class="edit btn btn-xs btn-danger"><i class="fas fa-edit">
                                    Create</i></button>
                        </h3>
                        <!-- tools box -->
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool btn-danger btn-sm " data-card-widget="collapse"
                                data-toggle="tooltip" title="Collapse">
                                <i class="fas fa-minus"></i></button>
                            <button type="button" class="btn btn-tool btn-danger btn-sm" data-card-widget="remove"
                                data-toggle="tooltip" title="Remove">
                                <i class="fas fa-times"></i></button>
                        </div>
                        <!-- /. tools -->
                    </div>


                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="mb-3">

                            <h4 align="center">Setup user</h4><br />
                            <div class="alert alert-success" style="display: none;"></div>

                            <div id="table_data">
                                @include('setting/setupuser_data')
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.col-->
        </div>
        <!-- ./row -->
    </section>



    <div id="formModal" class="modal fade">
        <div class="modal-dialog">
            <div class="card card-outline card-info">
                <div class="card-header">
                    <h4 class="modal-title"></h4>

                </div>

                <div class="modal-content">
                    <form id="form_data" name="contact" role="form">
                        @csrf
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="name">Branch name</label>
                                <select class="selectpicker form-control" name="branch" id="branch" data-live-search="true">
                                    @foreach ($branch as $row)
                                        <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                            {{ $row->name }}</option>
                                    @endforeach
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="name">Profile</label>
                                <select class="selectpicker form-control" name="profile" id="profile"
                                    data-live-search="true">
                                    @foreach ($profile as $row)
                                        <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                            {{ $row->name }}</option>
                                    @endforeach
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="name">Login name</label>
                                <input type="text" name="login_name" id="login_name" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">User Name</label>
                                <input type="text" name="user_name" id="user_name" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">Contact</label>
                                <input type="text" name="contact" id="contact" class="form-control">
                            </div>
                            <div class="form-group">
                                <label>Inactive</label>
                                <select name="inactive" id="inactive" class="form-control" style="width: 100%;">
                                    @foreach ($inactive as $row)
                                        @if (old('inactive') == $row->id)
                                            <option data-tokens="{{ $row->id }}" value="{{ $row->id }}" selected>
                                                {{ $row->name }}</option>
                                        @else
                                            <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                                {{ $row->name }}</option>
                                        @endif

                                    @endforeach
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <input type="hidden" name="action" id="action" />
                            <input type="hidden" name="hidden_id" id="hidden_id" />
                            <input type="submit" name="action_button" id="action_button" class="btn btn-success" value="Ok">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div id="formModalReset" class="modal fade">
        <div class="modal-dialog">
            <div class="card card-outline card-danger">
                <div class="modal-content">
                    <form id="formResetpassword" name="contact" role="form">
                        @csrf
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="name">Profile</label>
                                <input type="text" name="r_profile" id="r_profile" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">Login name</label>
                                <input type="text" name="r_name" id="r_name" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">User Name</label>
                                <input type="text" name="r_user_name" id="r_user_name" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">Password</label>
                                <input type="password" name="password" id="password" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">Confirm Password</label>
                                <input type="password" name="conpassword" id="conpassword" class="form-control">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <input type="hidden" name="r_branchcode" id="r_branchcode" />
                            <input type="hidden" name="r_action" id="r_action" />
                            <input type="hidden" name="r_hidden_id" id="r_hidden_id" />
                            <input type="submit" name="action_reset" id="action_reset" class="btn btn-success" value="Ok">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>


@endsection

@section('scripts')
    <script>
        $(document).ready(function() {

            $(document).on('click', '.delete', function(event) {
                user_id = $(this).attr('id');
                $('#confirmModal').modal('show');
            });

            function cleartext() {
                $("#branch").selectpicker('val', '');
                $("#profile").selectpicker('val', '');
                $("#login_name").prop("readonly", false).eq(0).focus(); // THEN focus the first

                $('#login_name').val('');
                $('#inactive').val('');
                $('#contact').val('');
                $('#user_name').val('');
            }

            $('#create_record').click(function() {
                cleartext();
                $('.modal-title').text("Register User");
                $('#action_button').val("Add");
                $('#action').val("Add");
                $('#hidden_id').val("");
                $('#formModal').modal('show');
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();

                if ($('#action').val() == 'Add') {
                    if (check_mail() == 'YES') {
                        return;
                    }

                    $.ajax({
                        url: "{{ route('setup-user.register_user') }}",
                        method: "POST",
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        success: function(data) {
                            if (data.errors) {
                                for (var count = 0; count < data.errors.length; count++) {
                                    // Message sweet alert
                                    const Toast = Swal.mixin({
                                        toast: true,
                                        position: 'top-end',
                                        showConfirmButton: false,
                                        timer: 3000
                                    });
                                    Toast.fire({
                                        icon: 'error',
                                        title: data.errors[count]
                                    })
                                    return;
                                }
                            }
                            if (data.success) {
                                $('#formModal').modal('hide');
                                fetch_data();
                                // Message sweet alert
                                const Toast = Swal.mixin({
                                    toast: true,
                                    position: 'top-end',
                                    showConfirmButton: false,
                                    timer: 3000
                                });
                                Toast.fire({
                                    icon: 'success',
                                    title: data.success
                                })
                            }
                        }
                    })
                }

                if ($('#action').val() == "Edit") {
                    $.ajax({
                        url: "{{ route('setup-user.register_user') }}",
                        method: "POST",
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        success: function(data) {
                            if (data.errors) {
                                for (var count = 0; count < data.errors.length; count++) {
                                    // Message sweet alert
                                    const Toast = Swal.mixin({
                                        toast: true,
                                        position: 'top-end',
                                        showConfirmButton: false,
                                        timer: 3000
                                    });
                                    Toast.fire({
                                        icon: 'error',
                                        title: data.errors[count]
                                    })
                                    return;
                                }
                            }
                            if (data.success) {
                                $('#formModal').modal('hide');
                                fetch_data();
                                // Message sweet alert
                                const Toast = Swal.mixin({
                                    toast: true,
                                    position: 'top-end',
                                    showConfirmButton: false,
                                    timer: 3000
                                });
                                Toast.fire({
                                    icon: 'success',
                                    title: data.success
                                })
                            }
                        }
                    });
                }
            });

            $(document).on('click', '.edit', function() {
                var id = $(this).attr('id');
                if (id == 'create') {
                    return;
                }
                $('#formModal').modal('show');
                $.ajax({
                    url: "/setup-user/" + id + "/register_user_edit",
                    dataType: "json",
                    success: function(html) {

                        $('#login_name').attr('readonly', 'true');

                        $('#branch').val(html.data.branchcode);
                        $('#login_name').val(html.data.username);

                        $("#profile").selectpicker('val', html.data.profileid)
                        $('#inactive').val(html.data.inactive);

                        $('#contact').val(html.data.contact);
                        $('#user_name').val(html.data.name);

                        $('#hidden_id').val(html.data.id);
                        $('.modal-title').text("Edit New Record");
                        $('#action_button').val("Edit");
                        $('#action').val("Edit");
                        $('#formModal').modal('show');
                    }
                })
            });

            $(document).on('click', '.pagination a', function(event) {
                event.preventDefault();
                var page = $(this).attr('href').split('page=')[1];
                fetch_data(page);
            });

            function fetch_data(page = '1') {
                $.ajax({
                    url: "/setupuser/user_fetch_data?page=" + page,
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            }

            $("#login_name").keyup(function() {
                var id = $('#login_name').val();
                if (id.length <= 0) {
                    return;
                }
                $.ajax({
                    url: "/user-acc/getusername/" + id,
                    method: "get",
                    dataType: "json",
                    success: function(data) {
                        if (data.data.status == 'YES') {
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'top-end',
                                showConfirmButton: false,
                                timer: 3000
                            });
                            Toast.fire({
                                icon: 'error',
                                title: 'User name already exsits'
                            })

                            var element = $("#login_name");
                            $(element)
                                .closest('.form-group')
                                .removeClass('has-error')
                                .removeClass('has-success')
                                .addClass('has-error')
                                .find('.text-danger').remove();

                        } else {

                            $(".form-group").removeClass('has-error').removeClass(
                            'has-success');
                            $('.help-block with-errors').empty();
                        }
                    }

                })
            });

            function check_mail() {
                var id = $('#login_name').val();
                if (id.length <= 0) {
                    return;
                }
                var status = '';
                $.ajax({
                    url: "/user-acc/getusername/" + id,
                    method: "get",
                    async: false,
                    dataType: "json",
                    success: function(data) {
                        if (data.data.status == 'YES') {
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'top-end',
                                showConfirmButton: false,
                                timer: 3000
                            });
                            Toast.fire({
                                icon: 'error',
                                title: 'User name already exsits'
                            })

                            var element = $("#login_name");
                            $(element)
                                .closest('.form-group')
                                .removeClass('has-error')
                                .removeClass('has-success')
                                .addClass('has-error')
                                .find('.text-danger').remove();

                        } else {

                            $(".form-group").removeClass('has-error').removeClass('has-success');
                            $('.help-block with-errors').empty();

                        }

                        status = data.data.status;

                    }
                })
                return status;
            }


            $(document).on('click', '.resetpwd', function(event) {
                var id = $(this).attr('id');
                $('#formModalReset').modal('show');
                $.ajax({
                    url: "/setup-user/" + id + "/register_user_edit",
                    dataType: "json",
                    success: function(html) {

                        $('#r_name').attr('readonly', 'true');
                        $('#r_profile').attr('readonly', 'true');
                        $('#r_user_name').attr('readonly', 'true');
                        $('#r_name').val(html.data.username);
                        $('#r_profile').val(html.data.profilename);
                        $('#r_user_name').val(html.data.name);

                        $('#r_branchcode').val(html.data.branchcode);
                        $('#r_hidden_id').val(html.data.id);
                        $('#action_resetpwd').val("Reset");
                        $('#r_action').val("Resetpwd");
                        $('#formModalReset').modal('show');
                    }
                })

            });


            $('#formResetpassword').on('submit', function(event) {
                event.preventDefault();

                if ($('#r_action').val() == 'Resetpwd') {
                    if ($('#password').val() == '') {
                        // Message sweet alert
                        const Toast = Swal.mixin({
                            toast: true,
                            position: 'top-end',
                            showConfirmButton: false,
                            timer: 3000
                        });
                        Toast.fire({
                            icon: 'error',
                            title: 'Please input complex password !'
                        })
                        return;
                    } else if ($('#password').val() != $('#conpassword').val()) {
                        // Message sweet alert
                        const Toast = Swal.mixin({
                            toast: true,
                            position: 'top-end',
                            showConfirmButton: false,
                            timer: 3000
                        });
                        Toast.fire({
                            icon: 'error',
                            title: 'Please input Password & Matching!'
                        })
                        return;
                    }

                    $.ajax({
                        url: "{{ route('setup-user.register_resetpwd') }}",
                        method: "POST",
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        success: function(data) {
                            if (data.errors) {
                                for (var count = 0; count < data.errors.length; count++) {
                                    // Message sweet alert
                                    const Toast = Swal.mixin({
                                        toast: true,
                                        position: 'top-end',
                                        showConfirmButton: false,
                                        timer: 3000
                                    });
                                    Toast.fire({
                                        icon: 'error',
                                        title: data.errors[count]
                                    })
                                    return;
                                }
                            }
                            if (data.success) {
                                $('#formModalReset').modal('hide');
                                fetch_data();
                                // Message sweet alert
                                const Toast = Swal.mixin({
                                    toast: true,
                                    position: 'top-end',
                                    showConfirmButton: false,
                                    timer: 3000
                                });
                                Toast.fire({
                                    icon: 'success',
                                    title: data.success
                                })
                            }
                        }
                    })


                }
            });

        });
    </script>

@endsection
