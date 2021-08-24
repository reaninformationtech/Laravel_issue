@extends('layouts.app')
@section('content')
    <style>
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
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">

                            <button type="submit" class="authorize btn btn-outline-info" name="create_record"
                                id="create_record"><i class="fas fa-edit">Edit</i></button>
                            <button type="submit" class="btn btn-outline-danger" name="delete_record" id="delete_record"><i
                                    class="fas fa-trash-alt"> Delete</i></button>
                            <a href="{{ url('/cus_land_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>


                        </h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">

                        <div class="col-md-6">
                            <!-- /.card-header -->
                            <div class="card-body">
                                <input type="hidden" name="action" id="action" value="Edit" />
                                <input type="hidden" name="hidden_id" id="hidden_id"
                                    value="{{ isset($data[0]->cus_id) ? $data[0]->cus_id : '' }}" />
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <label>Cus_ID</label>
                                            <input type="text" name="name" id="name" class="form-control is-valid"
                                                value="{{ isset($data[0]->cus_id) ? $data[0]->cus_id : '' }}" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <label>Customer</label>
                                            <input type="text" name="name" id="name" class="form-control is-valid"
                                                value="{{ isset($data[0]->cus_namekh) ? $data[0]->cus_namekh : '' }}" />
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>Gender</label>
                                            <select class="selectpicker form-control" name="gender" id="gender"
                                                data-live-search="true">
                                                @foreach ($Gender as $row1)
                                                    <option data-tokens="{{ $row1->id }}" value="{{ $row1->id }}"
                                                        {{ $row1->id == (isset($data[0]->cus_gender) ? $data[0]->cus_gender : '') ? 'selected="selected"' : '' }}>
                                                        {{ $row1->name }}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>

                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>Inactive</label>
                                            <select class="selectpicker form-control" name="inactive" id="inactive"
                                                data-live-search="true">
                                                @foreach ($Inactive as $row1)
                                                    <option data-tokens="{{ $row1->id }}" value="{{ $row1->id }}"
                                                        {{ $row1->id == (isset($data[0]->cus_inactive) ? $data[0]->cus_inactive : '') ? 'selected="selected"' : '' }}>
                                                        {{ $row1->name }}</option>
                                                @endforeach

                                            </select>
                                        </div>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>Phone</label>
                                            <input type="text" name="phone" id="phone" class="form-control"
                                                value="{{ isset($data[0]->cus_phone) ? $data[0]->cus_phone : '' }}" />
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>Email</label>
                                            <input type="email" name="email" id="email" class="form-control"
                                                value="{{ isset($data[0]->cus_email) ? $data[0]->cus_email : '' }}" />
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <label>Address</label>
                                            <input type="text" name="address" id="address" class="form-control"
                                                value="{{ isset($data[0]->cus_address) ? $data[0]->cus_address : '' }}" />
                                        </div>
                                    </div>

                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group">
                                            <label>Remark</label>
                                            <input type="text" name="remark" id="remark" class="form-control"
                                                value="{{ isset($data[0]->cus_remark) ? $data[0]->cus_remark : '' }}" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
        <!-- /.col-->
    </div>
    <!-- ./row -->
@endsection
@section('scripts')
    <script>
        $(document).ready(function() {
            $('#phone').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.-]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.-]/g, '');
                }
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Edit') {
                    $.ajax({
                        url: "{{ route('customer-land.add_customer_land') }}",
                        method: "POST",
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        async: false,
                        beforeSend: function() {
                            $("#create_record").attr("disabled", true)
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
                                    $("#create_record").attr("disabled", false)
                                    return;
                                }
                            }


                            if (data.success) {
                                $('#formModal').modal('hide');
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
                                $("#create_record").attr("disabled", false)
                                window.location.href = "/cus_land_list/all";
                            }
                        }
                    })
                }
            });

            $('#delete_record').click(function() {
                event.preventDefault();
                var gb_id = $('#hidden_id').val();
                Swal.fire({
                    title: 'Do you want to delete record now?',
                    showDenyButton: true,
                    showCancelButton: false,
                    confirmButtonText: `Yes`,
                    denyButtonText: `No`,
                    customClass: {
                        cancelButton: 'order-1 right-gap',
                        confirmButton: 'order-2',
                        denyButton: 'order-3',
                    }
                }).then((result) => {
                    if (result.isConfirmed) {
                        var _token = $('input[name="_token"]').val();
                        $.ajax({
                            url: "/delete_customer_land/" + gb_id,
                            type: 'get',
                            async: false,
                            data: {
                                "id": gb_id,
                                "_token": _token,
                            },
                            success: function(data) {

                                if (data.errorsold) {
                                    Swal.fire({
                                        icon: 'error',
                                        text: data.errorsold
                                    })
                                    $("#delete_record").attr("disabled", false)
                                    $("#create_record").attr("disabled", false)
                                    return;
                                }

                                if (data.success) {
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
                                    $("#create_record").attr("disabled", false)
                                    window.location.href = "/cus_land_list/all";
                                }
                            }
                        })
                    }
                })

            });

        });
    </script>

@endsection
