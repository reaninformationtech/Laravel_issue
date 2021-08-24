@extends('layouts.app')
@section('content')

    <section class="content">
        <style>
            nav svg {
                max-height: 20px;
            }

            .note {
                text-align: center;
                height: 80px;
                background: -webkit-linear-gradient(left, #0072ff, #8811c5);
                color: #fff;
                font-weight: bold;
                line-height: 80px;
            }

            .form-content {
                padding: 5%;
                border: 1px solid #ced4da;
                margin-bottom: 2%;
            }

            .form-control {
                border-radius: 1.5rem;
            }

            .btnSubmit {
                border: none;
                border-radius: 1.5rem;
                padding: 1%;
                width: 20%;
                cursor: pointer;
                background: #0062cc;
                color: #fff;
            }

        </style>

        <div class="row">
            <div class="col-md-12">
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title" name="create_record" id="create_record">
                            <button type="button" id="create" class="edit btn btn-xs btn-danger"><i class="fas fa-edit">
                                    Commit</i></button>
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

                            <div id="table_data">
                                @include('pos/pos_line_data')
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.col-->
        </div>
        <!-- ./row -->
    </section>

    <div class="card card-info">

        <div id="formModal" class="modal fade" id="modal-secondary">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf

                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">Register Supplier</h3>
                            </div>
                        </div>
                        <div class="card-body">

                            <div class="form-group">
                                <label>line</label>
                                <select name="line" id="line" class="form-control select2bs4" style="width: 100%;">
                                    <option selected="selected" value="0">NO</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="sub_name">Line Name</label>
                                <input type="text" name="line_name" id="line_name" class="form-control" placeholder="name">
                            </div>
                            <div class="form-group">
                                <label>Inactive</label>
                                <select class="selectpicker form-control" name="inactive" id="inactive" data-live-search="true">
                                    @foreach ($inactive as $row2)
                                        <option data-tokens="{{ $row2->id }}" value="{{ $row2->id }}">
                                            {{ $row2->name }}</option>
                                    @endforeach
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="controller">Remark</label>
                                <input type="text" name="remark" id="remark" class="form-control" placeholder="Remark">
                            </div>
                        </div>
                        <!-- /.card-body -->
                        <div class="modal-footer justify-content-between">
                            <button type="button" class="btn btn-info" data-dismiss="modal">Close</button>
                            <input type="hidden" name="action" id="action" />
                            <input type="hidden" name="hidden_id" id="hidden_id" />
                            <input type="submit" name="action_button" id="action_button" class="btn btn-info" value="Add" />
                        </div>

                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </form>
        </div>

        <div class="modal fade" id="confirmModal">
            <div class="modal-dialog">
                <div class="modal-content bg-secondary">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <h4 align="center" style="margin:0;">Are you sure you want to remove this data?</h4>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-outline-light" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-outline-light" id="ok_button">Ok</button>
                    </div>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
        <!-- /.modal -->
    </div>
@endsection
@section('scripts')
    <script>
        $(document).ready(function() {

            loaddata_combo('line');
            cleartext();


            function cleartext() {
                $('#line').val('');
                $('#line_name').val('');
                $('#inactive').val('');
                $('#remark').val('');
            }

            $('#btnsearch').click(function() {
                event.preventDefault();
                var search = $('#search').val();
                if (search == '') {
                    search = 'all';
                }
                $.ajax({
                    url: "/pos/pos_line_search_data/" + search,
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            });


            $(document).on('click', '.delete', function(event) {
                user_id = $(this).attr('id');
                $('#confirmModal').modal('show');
            });

            $('#ok_button').click(function() {
                $.ajax({
                    url: "pos-line/delete_pos_line/" + user_id,
                    beforeSend: function() {
                        $('#ok_button').text('Deleting...');
                    },
                    success: function(data) {
                        if (data.errors) {
                            $('#confirmModal').modal('hide');
                            $('#ok_button').text('Ok');
                            // Message sweet alert
                            Swal.fire({
                                icon: 'error',
                                title: 'Oops...',
                                text: data.errors
                            })
                            return;
                        }
                        if (data.success) {
                            $('#confirmModal').modal('hide');
                            $('#ok_button').text('Ok');
                            fetch_data();

                            // Message sweet alert
                            Swal.fire({
                                position: 'top-end',
                                icon: 'success',
                                title: data.success,
                                showConfirmButton: false,
                                timer: 1500
                            })
                        }
                    }
                })
            });


            $('#create_record').click(function() {
                cleartext();
                $("#line").removeAttr("disabled");
                $('.modal-title').text("Add New Record");
                $('#action_button').val("Add");
                $('#action').val("Add");
                $('#hidden_id').val("Add");
                $('#formModal').modal('show');

            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Add') {
                    $.ajax({
                        url: "{{ route('pos-line.add_pos_line') }}",
                        method: "POST",
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        async: false,
                        beforeSend: function() {
                            $("#action_button").attr("disabled", true)
                        },
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
                                    $("#action_button").attr("disabled", false)
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
                                $("#action_button").attr("disabled", false)
                            }
                        }
                    })
                }

                if ($('#action').val() == "Edit") {
                    $(this).find('#line').prop('disabled', false);
                    $.ajax({
                        url: "{{ route('pos-line.add_pos_line') }}",
                        method: "POST",
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        beforeSend: function() {
                            $("#action_button").attr("disabled", true)
                        },
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
                                    $("#action_button").attr("disabled", false)
                                    return;
                                }
                            }
                            if (data.success) {
                                fetch_data();
                                $('#formModal').modal('hide');
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
                    $("#line").prop('disabled', true);
                    $("#action_button").attr("disabled", false)
                }
            });


            $(document).on('click', '.edit', function() {
                var id = $(this).attr('id');
                if (id == 'create') {
                    return;
                }
                $('#form_result').html('');
                $('#formModal').modal('show');
                $.ajax({
                    url: "/pos-line/" + id + "/edit_pos_line",
                    dataType: "json",
                    success: function(html) {
                        $("#line").prop('disabled', true);
                        $('#line').val(html.data.line_type);
                        $('#line_name').val(html.data.line_name);
                        $('#inactive').val(html.data.inactive);
                        $('#remark').val(html.data.line_remark);

                        $('#hidden_id').val(html.data.line_id);
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
                    url: "/pos/pos_line_fetch_data?page=" + page,
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            }

            function loaddata_combo(vstatus) {
                $.ajax({
                    url: "/combo_pos/"+vstatus,
                    method: "get",
                    success: function(data) {
                        $('#line').html(data);
                    }
                });
            }
        });
    </script>

@endsection
