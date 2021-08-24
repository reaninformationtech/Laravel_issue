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
                            <a href="{{ url('/land_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>
                        </h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="col-md-6">
                            <div class="card-body">
                                @foreach ($data as $row)
                                    <input type="hidden" name="action" id="action" value="Edit" />
                                    <input type="hidden" name="hidden_id" id="hidden_id" value="{{ $row->rg_id }}" />

                                    <form role="form">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group">
                                                    <label>Item Code</label>
                                                    <input type="text" name="name" id="name" class="form-control is-valid"
                                                        value="{{ $row->rg_id }}" Readonly>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group">
                                                    <label>Item Name</label>
                                                    <input type="text" name="name" id="name" class="form-control is-valid"
                                                        value="{{ $row->rg_name }}">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <!-- select -->
                                                <div class="form-group">
                                                    <label>Inactive</label>
                                                    <select class="selectpicker form-control" name="inactive" id="inactive"
                                                        data-live-search="true">
                                                        @foreach ($inactive as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->inactive ? 'selected="selected"' : '' }}>
                                                                {{ $row1->name }}</option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="form-group">
                                                    <label>Public</label>
                                                    <select class="selectpicker form-control" name="public" id="public"
                                                        data-live-search="true">
                                                        @foreach ($inactive as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->p_view ? 'selected="selected"' : '' }}>
                                                                {{ $row1->name }}</option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <!-- select -->
                                                <div class="form-group">
                                                    <label>Plan</label>
                                                    <select class="selectpicker form-control" name="plan" id="plan"
                                                        data-live-search="true">
                                                        @foreach ($Plan as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->plan_id ? 'selected="selected"' : '' }}>
                                                                {{ $row1->name }}</option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="form-group">
                                                    <label>Pro-Line</label>
                                                    <select class="selectpicker form-control" name="line" id="line"
                                                        data-live-search="true">
                                                        @foreach ($Line as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->type_id ? 'selected="selected"' : '' }}>
                                                                {{ $row1->name }}</option>
                                                        @endforeach

                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <!-- select -->
                                                <div class="form-group">
                                                    <label>Street</label>
                                                    <select class="selectpicker form-control" name="street" id="street"
                                                        data-live-search="true">

                                                        @foreach ($Street as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->street_id ? 'selected="selected"' : '' }}>
                                                                {{ $row1->name }}</option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="form-group">
                                                    <label>Size</label>
                                                    <select class="selectpicker form-control" name="size" id="size"
                                                        data-live-search="true">
                                                        @foreach ($Size as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->size_id ? 'selected="selected"' : '' }}>
                                                                {{ $row1->name }}</option>
                                                        @endforeach

                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-4">
                                                <!-- select -->
                                                <div class="form-group">
                                                    <label>Currency</label>
                                                    <select class="selectpicker form-control" name="currency" id="currency"
                                                        data-live-search="true">
                                                        @foreach ($Currency as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->currency ? 'selected="selected"' : '' }}>
                                                                {{ $row1->name }}</option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="col-sm-4">
                                                <div class="form-group">
                                                    <label>Cost</label>
                                                    <input type="text" name="cost" id="cost" class="form-control"
                                                        value="{{ $row->cost }}">
                                                </div>
                                            </div>

                                            <div class="col-sm-4">
                                                <div class="form-group">
                                                    <label>Unit Price</label>
                                                    <input type="text" name="unit_price" id="unit_price"
                                                        class="form-control" value="{{ $row->unitprice }}">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group">
                                                    <label>Remark</label>
                                                    <input type="text" name="remark" id="remark" class="form-control"
                                                        value="{{ $row->remark }}">
                                                </div>
                                            </div>
                                        </div>
                                @endforeach
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
            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Edit') {
                    $.ajax({
                        url: "{{ route('register-land.add_registerland') }}",
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
                                cleartext();
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
                            url: "/delete_registerland/" + gb_id,
                            type: 'get',
                            async: false,
                            data: {
                                "id": gb_id,
                                "_token": _token,
                            },
                            beforeSend: function() {
                                $("#delete_record").attr("disabled", true)
                            },

                            success: function(data) {
                                if (data.errors) {
                                    Swal.fire({
                                        icon: 'error',
                                        text: data.errors
                                    })
                                    $("#delete_record").attr("disabled", false)
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
                                    $("#delete_record").attr("disabled", false)
                                    window.location.href = "/land_list/all";
                                }
                            }
                        })
                    }
                })
            });
        });
    </script>

@endsection
