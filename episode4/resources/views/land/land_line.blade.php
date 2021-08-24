@extends('layouts.app')
@section('content')

<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-info">
                <div class="card-header">
                    <div class="col-12 col-sm-12">
                        <div class="card-header p-0 border-bottom-0">
                            <ul class="nav nav-tabs" id="custom-tabs-four-tab" role="tablist">

                                <li class="nav-item">
                                    <div class="card-tools mt-2 mr-2">
                                        <h3 class="card-title" name="create_record" id="create_record" >
                                            <button type="button" id="create" class="edit btn btn-xs btn-danger"><i class="fas fa-edit"> Create</i></button>
                                        </h3>
                                    </div>

                                </li>
                                <li class="nav-item">
                                    <a class="nav-link active" id="Type" data-toggle="tab" href="#step1" role="tab" aria-controls="custom-tabs-four-home" aria-selected="true">Items Type</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="Size" data-toggle="tab" href="#step2" role="tab" aria-controls="custom-tabs-four-profile" aria-selected="false">Items Size</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="Street" data-toggle="tab" href="#step3" role="tab" aria-controls="custom-tabs-four-messages" aria-selected="false">Items Street</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="Plan" data-toggle="tab" href="#step4" role="tab" aria-controls="custom-tabs-four-settings" aria-selected="false">Items Plan</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="Expend" data-toggle="tab" href="#step4" role="tab" aria-controls="custom-tabs-four-settings" aria-selected="false">Expend</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="Income" data-toggle="tab" href="#step5" role="tab" aria-controls="custom-tabs-four-settings" aria-selected="false">Income</a>
                                </li>
                                <li class="nav-item">
                                    <a class="btn disabled" href="#"></a>
                                </li>
                                <li class="nav-item">
                                    <div class="card-tools mt-2 mr-2">
                                        <button type="button" class="btn btn-tool btn-danger btn-sm " data-card-widget="collapse" data-toggle="tooltip"
                                                title="Collapse">
                                            <i class="fas fa-minus"></i></button>
                                    </div>
                                </li>
                                <li class="nav-item">
                                    <div class="card-tools mt-2 mr-2">
                                        <button type="button" class="btn btn-tool btn-danger btn-sm" data-card-widget="remove" data-toggle="tooltip"
                                                title="Remove">
                                            <i class="fas fa-times"></i></button>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- /.card-header -->
                <div class="card-body pad">
                    <div class="mb-3">
                        <div class="alert alert-success" style="display: none;"></div>
                        <div id="table_data">
                            @include('land/land_line_data')
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
                                <label for="type">Status</label>
                                <input name="txtstatus" class="form-control" type="text" readonly>
                            </div>
                            <div class="form-group">
                                <label for="item_name">Item Name</label>
                                <input type="text" name="item_name" id="item_name"  class="form-control" placeholder="name">
                            </div>
                            <div class="form-group">
                                <label>Inactive</label>
                                <select name="inactive" id="inactive" class="form-control select2bs4" style="width: 100%;">
                                    <option selected="selected" value="0" >NO</option>
                                    <option value="1" >YES</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="remark">Remark</label>
                                <input type="text" name="remark" id="remark"  class="form-control"  placeholder="remark">
                            </div>



                            <div class="form-group">
                                <label id="lblprovince" name="lblprovince" >Location</label>
                                <select name="cboprovince" id="cboprovince"  class="form-control select2bs4" style="width: 100%;">
                                    <option value="">Province</option>
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

        function  cleartext(){
            $('#item_name').val('');
            $('#inactive').val('');
            $('#remark').val('');
            $('#cboprovince').val('');
        }

        // Set trigger and container variables
        $('input[name=txtstatus]').val('Type');
        loaddata('Type');

        $('#cboprovince').hide();
        $('#lblprovince').hide();

        function loaddata_combo() {
            var id = '';
            $.ajax({
                url: "/combo_province",
                method: "get",
                data: {state_id: id},
                success: function (data)
                {
                    $('#cboprovince').html(data);
                }
            });
        }

        $('.nav-tabs a').on('shown.bs.tab', function (e) {
            var currId = $(e.target).attr("id");
            $('input[name=txtstatus]').val(currId);

            if (currId == 'Type') {
                $('#myModal').find('.modal-title').text('Register type');
                $('#cboprovince').attr('disabled', 'disabled');

                $('#cboprovince').hide();
                $('#lblprovince').hide();
            } else if (currId == 'Size') {
                $('#myModal').find('.modal-title').text('Register Size');
                $('#cboprovince').attr('disabled', 'disabled');

                $('#cboprovince').hide();
                $('#lblprovince').hide();

            } else if (currId == 'Street') {
                $('#myModal').find('.modal-title').text('Register Street');
                $('#cboprovince').attr('disabled', 'disabled');
                $('#cboprovince').hide();
                $('#lblprovince').hide();
            } else if (currId == 'Expend') {
                $('#myModal').find('.modal-title').text('Register Expend');
                $('#cboprovince').attr('disabled', 'disabled');
                $('#cboprovince').hide();
                $('#lblprovince').hide();
            } else if (currId == 'Plan') {
                $('#myModal').find('.modal-title').text('Register Plan');
                $('#cboprovince').attr('disabled', false);

                $('#cboprovince').show();
                $('#lblprovince').show();
                loaddata_combo();
            }
        });

        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            var currId = $(e.target).attr("id");
            loaddata(currId);
        })

        $(document).on('click', '.pagination a', function (event) {
            event.preventDefault();
            var page = $(this).attr('href').split('page=')[1];
            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();
            fetch_data(vtype, page);
        });


        function fetch_data(vstatus, page)
        {
            $.ajax({
                url: "land-line/land_line_fetch_data/" + vstatus + "?page=" + page,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            })
        }

        //function
        function loaddata(vstatus) {
            $.ajax({
                url: "land-line/land_line_fetch_data/" + vstatus,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            })
        }
        $('#create_record').click(function () {
            cleartext();
            
            $('.modal-title').text("Add New Record");
            $('#action_button').val("Add");
            $('#action').val("Add");
            $('#hidden_id').val("Add");
            $('#formModal').modal('show');

            var vstatus = $('input[name=txtstatus]');
            if (vstatus.val() == '') {
                $('input[name=txtstatus]').val('Type');
                $('#cboprovince').attr('disabled', 'disabled');
                $('#cboprovince').hide();
                $('#lblprovince').hide();
            }

        });

        $(document).on('click', '.delete', function (event) {
            user_id = $(this).attr('id');
            $('#confirmModal').modal('show');
        });

        $('#ok_button').click(function () {
            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();

            $.ajax({
                url: "/land-line/delete_land_line/" + user_id,
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
                        text: data.errors
                        })
                        return;
                    }
                    if (data.success)
                    {
                        $('#confirmModal').modal('hide');
                        $('#ok_button').text('Ok');

                        // Message sweet alert
                        Swal.fire({
                        position: 'top-end',
                        icon: 'success',
                        title: data.success,
                        showConfirmButton: false,
                        timer: 1500
                        })
                        fetch_data(vtype, '1');
                    }
                }

            });

        });


        $('#form_data').on('submit', function (event) {
            event.preventDefault();
            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();

            if ($('#action').val() == 'Add')
            {
                $.ajax({
                    url: "{{route('land-line.add_land_line') }}",
                    method: "POST",
                    data: new FormData(this),
                    contentType: false,
                    cache: false,
                    async: false, //blocks window close
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
                            loaddata(vtype);

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
                var vstatus = $('input[name=txtstatus]');
                var vtype = vstatus.val();
                $.ajax({
                    url: "{{ route('land-line.add_land_line') }}",
                    method: "POST",
                    data: new FormData(this),
                    contentType: false,
                    cache: false,
                    async: false, //blocks window close
                    processData: false,
                    dataType: "json",
                    success: function (data)
                    {
                        if (data.errors)
                        {
                            for (var count = 0; count < data.errors.length; count++)
                            {
                                // Message sweet alert
                                Swal.fire({
                                icon: 'error',
                                title: 'Oops...',
                                text: data.errors[count],
                                footer: '<a href>Please input</a>'
                                })
                                return;
                            }
                        }
                        if (data.success)
                        {
                           $('#formModal').modal('hide');
                            loaddata(vtype);
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

            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();

            if (vtype != 'Plan') {
                $('#cboprovince').attr('disabled', 'disabled');
                $('#cboprovince').hide();
                $('#lblprovince').hide();
            }

            $('#form_result').html('');
            $('#formModal').modal('show');
            $.ajax({
                url: "/land-line/" + id + "/land_line_edit/" + vtype,
                dataType: "json",
                success: function (html) {
                    $('#txtstatus').val(html.data.type);
                    $('#item_name').val(html.data.item_name);
                    $('#inactive').val(html.data.item_inactive);
                    $('#remark').val(html.data.item_remark);
                    $('#cboprovince').val(html.data.id_location);

                    $('#hidden_id').val(html.data.item_id);

                    $('.modal-title').text("Edit New Record");
                    $('#action_button').val("Edit");
                    $('#action').val("Edit");
                    $('#formModal').modal('show');
                }
            })
        });
    });
</script>

@endsection
