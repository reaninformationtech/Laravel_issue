@extends('layouts.app')
@section('content')

<section class="content">
<style>
  nav svg{
    max-height: 20px;
  }

</style>

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

                        <h4 align="center">Register sub menu</h4><br />
                        <div class="alert alert-success" style="display: none;"></div>

                        <div id="table_data">
                            @include('admin/sub_menu_data')

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
                        <h4 class="modal-title">Register sub menu .</h4>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>

                    </div>
                    <div class="modal-body">
                        <span id="form_result"></span>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="sub_name">Menu Name</label>
                                <input type="text" name="sub_name" id="sub_name"  class="form-control" placeholder="name">
                            </div>
                            <div class="form-group">
                                <label>Main</label>
                                <select name="main_system" id="main_system" class="form-control select2bs4" style="width: 100%;">
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Inactive</label>
                                <select name="inactive" id="inactive" class="form-control select2bs4" style="width: 100%;">
                                    <option selected="selected" value="0" >NO</option>
                                    <option value="1" >YES</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="controller">Controller</label>
                                <input type="text" name="controller" id="controller"  class="form-control"  placeholder="Controller">
                            </div>
                            <div class="form-group">
                                <label for="function">Function</label>
                                <input type="text" name="function" id="function"  class="form-control"  placeholder="Function">
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
        var gb_id='';
        loaddata_combo();

        $(document).on('click', '.delete', function (event) {
            gb_id = $(this).attr('id');
            $('#confirmModal').modal('show');
        });

        $('#ok_button').click(function () {
            var token = $("meta[name='csrf-token']").attr("content");
            $.ajax({
                url: "/sub-menu/delete_sub_menu/" + gb_id,
                type: 'get',
                data: {
                    "id": gb_id,
                    "_token": token,
                },
                beforeSend: function () {
                    $('#ok_button').text('Deleting...');
                },
                success: function (data)
                {
                    if (data.errors)
                    {
                        $('#confirmModal').modal('hide');
                        $('#ok_button').text('Ok');
                        // Message sweet alert
                        Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: data.errors[0]
                        })
                        return;
                    }
                    if (data.success)
                    {
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
                    url: "{{route('sub-menu.add_sub_menu') }}",
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
                    url: "{{ route('sub-menu.add_sub_menu') }}",
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
                url: "/sub-menu/" + id + "/sub_edit",
                dataType: "json",
                success: function (html) {
                    $('#sub_name').val(html.data.subm_name);
                    $('#main_system').val(html.data.menu_id);
                    $('#inactive').val(html.data.subm_inactive);
                    $('#controller').val(html.data.subm_controller);
                    $('#function').val(html.data.subm_function);
                    $('#hidden_id').val(html.data.subm_id);
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
                url: "/Admin/fetch_data?page=" + page,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            });
        }

        function loaddata_combo() {
            var id = '';
            $.ajax({
                url: "/combo_system/list_main_menu",
                method: "get",
                success: function (data)
                {
                    $('#main_system').html(data);
                }
            });
        }
    });
</script>

@endsection
