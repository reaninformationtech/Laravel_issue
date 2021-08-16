@extends('layouts.app')
@section('content')

<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-info">
                <div class="card-header">
                    <h3 class="card-title" name="create_record" id="create_record" >
                        <button type="button" id="create" class="edit btn btn-xs btn-danger"><i class="fas fa-edit"> Create</i></button>
                    </h3>
                    <!-- tools box -->
                    <div class="card-tools">
                        <button type="button" class="btn btn-tool btn-danger btn-sm " data-card-widget="collapse" data-toggle="tooltip"
                                title="Collapse">
                            <i class="fas fa-minus"></i></button>
                        <button type="button" class="btn btn-tool btn-danger btn-sm" data-card-widget="remove" data-toggle="tooltip"
                                title="Remove">
                            <i class="fas fa-times"></i></button>
                    </div>
                    <!-- /. tools -->
                </div>
                <!-- /.card-header -->
                <div class="card-body pad">
                    <div class="mb-3">

                        <h4 align="center">Register profile</h4><br />
                        <div class="alert alert-success" style="display: none;"></div>

                        <div id="table_data">
                            @include('admin/setpermission_data')
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- /.col-->
    </div>
    <!-- ./row -->
</section>

<div class="container">

    <div id="formModal" class="modal fade" id="modal-secondary">
        <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
            @csrf
            <div class="modal-dialog">

                <div class="modal-content bg-secondary">
                    <div class="modal-header">
                        <h4 class="modal-title"></h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>

                    </div>
                    <div class="modal-body">
                        <span id="form_result"></span>
                        <div class="card-body">
                            <div class="form-group">
                                <label>system</label>
                                <select name="system" id="system" class="form-control select2bs4" style="width: 100%;">
                                </select>
                            </div>
                             <div class="form-group">
                                <label>main menu</label>
                                <select name="main_menu" id="main_menu" class="form-control select2bs4" style="width: 100%;">
                                </select>
                            </div>
                             <div class="form-group">
                                <label>sub menu</label>
                                <select name="sub_menu" id="sub_menu" class="form-control select2bs4" style="width: 100%;">
                                </select>
                            </div>
                        </div>
                        <!-- /.card-body -->
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-outline-light" data-dismiss="modal">Close</button>
                        <input type="hidden" name="action" id="action" />
                        <input type="hidden" name="hidden_id" id="hidden_id" />
                        <input type="submit" name="action_button" id="action_button"  class="btn btn-outline-light" value="Add" />
                    </div>

                    </form>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
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
                    <button type="button" class="btn btn-outline-light" id="ok_button" >Ok</button>
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
    $(document).ready(function () {

        loaddata_combo();
        main_menu_combo();

        $(document).on('click', '.delete', function (event) {
            user_id = $(this).attr('id');
            $('#confirmModal').modal('show');
        });


        $('#create_record').click(function () {
            $('.modal-title').text("Add New Record");
            $('#action_button').val("Add");
            $('#action').val("Add");
            $('#hidden_id').val("Add");
            $('#formModal').modal('show');
        });

        $('#form_data').on('submit', function (event) {
            event.preventDefault();
            if ($('#action').val() == 'Add')
            {
                $.ajax({
                    url: "{{route('set-permission.add_setpermission') }}",
                    method: "POST",
                    data: new FormData(this),
                    contentType: false,
                    cache: false,
                    processData: false,
                    dataType: "json",
                    success: function (data)
                    {
                        if (data.errors)
                        {
                            for (var count = 0; count < data.errors.length; count++)
                            {
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
                        if (data.success)
                        {
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

            if ($('#action').val() == "Edit")
            {
                $.ajax({
                    url: "{{ route('set-permission.add_setpermission') }}",
                    method: "POST",
                    data: new FormData(this),
                    contentType: false,
                    cache: false,
                    processData: false,
                    dataType: "json",
                    success: function (data)
                    {
                        var html = '';
                        if (data.errors)
                        {
                            html = '<div class="alert alert-danger">';
                            for (var count = 0; count < data.errors.length; count++)
                            {
                                html += '<p>' + data.errors[count] + '</p>';
                            }
                            html += '</div>';
                        }
                        if (data.success)
                        {
                            html = '<div class="alert alert-success">' + data.success + '</div>';
                            $('#form_data')[0].reset();
                            $('#user_table').DataTable().ajax.reload();
                            $('#formModal').modal('hide');
                            $('.alert-success').html('Menu update successfully').fadeIn().delay(4000).fadeOut('slow');
                            fetch_data('1');
                        }
                        $('#form_result').html(html).fadeIn().delay(4000).fadeOut('slow');

                    }
                });
            }
        });


        $(document).on('click', '.edit', function () {
            var id = $(this).attr('id');
            if(id=='create'){
              return;
            }

            $('#form_result').html('');
            $('#formModal').modal('show');
            $.ajax({
                url: "/set-permission/" + id + "/permission_edit",
                dataType: "json",
                success: function (html) {
                    $('#system').val(html.data.sys_con_id);
                    $('#main_menu').val(html.data.menu_id);

                    $('#sub_menu').val(html.data.subm_id);
                    $('#hidden_id').val(html.data.id);

                    $('.modal-title').text("Edit New Record");
                    $('#action_button').val("Edit");
                    $('#action').val("Edit");
                    $('#formModal').modal('show');
                }
            })
        });

        $(document).on('click', '.pagination a', function (event) {

            event.preventDefault();
            var page = $(this).attr('href').split('page=')[1];
            fetch_data(page);
        });

        function fetch_data(page='1')
        {
            $.ajax({
               url: "/Admin/permission_fetch_data?page=" + page,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            });
        }

        function loaddata_combo() {
            var id = '';
            $.ajax({
                url: "/combo_profile",
                method: "get",
                data: {state_id: id},
                success: function (data)
                {
                    $('#system').html(data);
                }
            });
        }

        function main_menu_combo() {
            var id = '';
            $.ajax({
                url: "/combo_main_menu",
                method: "get",
                data: {state_id: id},
                success: function (data)
                {
                    $('#main_menu').html(data);
                }
            });
        }


        $('#main_menu').change(function () {
                    var id = $('#main_menu').val();
                    if (id != '')
                    {
                        $.ajax({
                            url: "/combo_sub_menu/"+ id,
                            method: "get",
                            data: {id: id},
                            success: function (data)
                            {
                                $('#sub_menu').html(data);
                            }
                        });
                    } else
                    {
                        $('#sub_menu').html('<option value="">Select sub menu</option>');
                    }
                });
    });
</script>

@endsection
