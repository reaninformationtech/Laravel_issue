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
                            <button type="submit" class="btn btn-outline-primary" name="create_record" id="create_record"><i
                                    class="fas fa-edit" id='title'> Edit</i></button>
                            <a href="{{ url('supply_list/all') }}" class="text-center">
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

                                @foreach ($data as $row)
                                    <input type="hidden" name="action" id="action" value="Edit" />
                                    <input type="hidden" name="hidden_id" id="hidden_id" value="{{ $row->sup_id }}" />

                                    <form role="form">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group">
                                                    <label>Name</label>
                                                    <input type="text" name="name" id="name" class="form-control is-valid"
                                                        value="{{ $row->sup_name }}">
                                                </div>
                                            </div>
                                        </div>


                                        <div class="row">
                                            <div class="col-sm-6">
                                                <!-- select -->
                                                <div class="form-group">
                                                    <label>Type</label>
                                                    <select class="selectpicker form-control" name="type" id="type"
                                                        data-live-search="true">
                                                        @foreach ($pos_line as $row1)
                                                            <option value="{{ $row1->id }}"
                                                                {{ $row1->id == $row->sup_type ? 'selected="selected"' : '' }}>
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
                                                        @foreach ($inactive as $row2)
                                                            <option value="{{ $row2->id }}"
                                                                {{ $row2->id == $row->inactive ? 'selected="selected"' : '' }}>
                                                                {{ $row2->name }}</option>
                                                        @endforeach

                                                    </select>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-6">
                                                <!-- text input -->
                                                <div class="form-group">
                                                    <label>Phone</label>
                                                    <input type="text" name="phone" id="phone" class="form-control"
                                                        placeholder="Phone ..." value="{{ $row->sup_phone }}">
                                                </div>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="form-group">
                                                    <label>Email</label>
                                                    <input type="text" name="email" id="email" class="form-control"
                                                        placeholder="Email ..." value="{{ $row->sup_email }}">
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-6">
                                                <!-- text input -->
                                                <div class="form-group">
                                                    <label>Websit</label>
                                                    <input type="text" name="websit" id="websit" class="form-control"
                                                        placeholder="Websit ..." value="{{ $row->sup_website }}">
                                                </div>
                                            </div>
                                            <div class="col-sm-6">
                                                <div class="form-group">
                                                    <label>Address</label>
                                                    <input type="text" name="address" id="address" class="form-control"
                                                        placeholder="Address ..." value="{{ $row->sup_address }}">
                                                </div>
                                            </div>
                                        </div>
                            </div>

                            @endforeach

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
                        url: "{{ route('pos-supplier.add_pos_supplier') }}",
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
                                        title: data.errors
                                    })
                                    return;
                                }
                            }
                            if (data.success) {
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
