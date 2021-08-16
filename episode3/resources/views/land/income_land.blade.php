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
                                    <a class="nav-link active" id="income" data-toggle="tab" href="#step1" role="tab" aria-controls="custom-tabs-four-home" aria-selected="true">Income</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" id="expend" data-toggle="tab" href="#step2" role="tab" aria-controls="custom-tabs-four-profile" aria-selected="false">Expend</a>
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

                    <div class="modal-body">
                        <span id="form_result"></span>
                        <div class="card-body">
                            <div class="form-group">
                                <label for="type">Paid line</label>
                                <input name="txtstatus" class="form-control" type="text" readonly>
                            </div>
                            <div class="form-group">
                                <label>Type</label>
                                <select name="cbotype" id="cbotype" class="form-control select2bs4" style="width: 100%;">
                                    <option selected="selected" value="0" >NO</option>
                                    <option value="1" >YES</option>
                                </select>
                            </div>


                            <div class="form-group">
                                <label for="remark">Referent</label>
                                <input type="text" name="referent" id="referent"  class="form-control"  placeholder="referent">
                            </div>

                            <div class="row">
                                <div class="col-sm-6">
                                    <!-- text input -->
                                    <div class="form-group">
                                        <label>Currency</label>
                                        <select name="currency" id="currency" class="form-control select2bs4" style="width: 100%;">
                                        </select>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label for="cost">Amount</label>
                                        <input type="text" name="amount" id="amount"  class="form-control" placeholder="Cost">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="remark">Remark</label>
                                <input type="text" name="remark" id="remark"  class="form-control"  placeholder="remark">
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
            $('#cbotype').val('');
            $('#currency').val('');
            $('#amount').val('');
            $('#referent').val('');
            $('#remark').val('');
        }

        // Set trigger and container variables
        $('input[name=txtstatus]').val('income');
        loaddata('income');
        loaddata_data('income');
        combo_currency();

        $('#amount').keyup(function () {
            if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            }
        });

        function isNumberKey(evt)
        {
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode != 46 && charCode > 31
                    && (charCode < 48 || charCode > 57))
                return false;
            return true;
        }

        function loaddata_data(vstatus) {
            $.ajax({
                url: "/combo_expend/" + vstatus,
                success: function (data)
                {
                    $('#cbotype').html(data);
                }
            })
          }

        function combo_currency() {
            var id = '';
            $.ajax({
                url: "/combo_currency",
                method: "get",
                data: {state_id: id},
                success: function (data)
                {
                    $('#currency').html(data);
                }
            });
        }

        $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
            var currId = $(e.target).attr("id");
            loaddata(currId);
            loaddata_data(currId);
            $('input[name=txtstatus]').val(currId);
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
                url: "income-land/income_land_fetch/" + vstatus + "?page=" + page,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            })
        }

        //function
        function loaddata(vstatus) {
            $.ajax({
                url: "income-land/income_land_fetch/" + vstatus,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            })
        }

        $(document).on('click', '.delete', function (event) {
            user_id = $(this).attr('id');
            $('#confirmModal').modal('show');
        });

        $('#ok_button').click(function () {
            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();

            $.ajax({
                url: "/expend-land/delete_expend_land/" + user_id,
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
                        loaddata(vtype);

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
            cleartext();
            $('.modal-title').text("Add New Record");
            $('#action_button').val("Add");
            $('#action').val("Add");
            $('#hidden_id').val("Add");
            $('#formModal').modal('show');
        });

        $('#form_data').on('submit', function (event) {
            event.preventDefault();
            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();

            if ($('#action').val() == 'Add')
            {
                $.ajax({
                    url: "{{route('expend-land.add_expend_land') }}",
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

        });
        $(document).on('click', '.edit', function () {
            var id = $(this).attr('id');

            if(id=='create'){
              return;
            }
            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();

            $('#form_result').html('');
            $('#formModal').modal('show');
            $.ajax({
                url: "/expend-land/" + id + "/expend_land_edit/" + vtype,
                dataType: "json",
                success: function (html) {
                    $('#txtstatus').val(html.data.exp_name);
                    $('#cbotype').val(html.data.exp_itmes);
                    $('#currency').val(html.data.exp_currency);
                    $('#amount').val(html.data.exp_unitprice);
                    $('#remark').val(html.data.exp_remark);

                    $('#hidden_id').val(html.data.exp_id);

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
