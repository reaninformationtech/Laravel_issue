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
                                    class="fas fa-edit" id='title'> Commit</i></button>
                            <a href="{{ url('land_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>

                            <input type="hidden" name="action" id="action" />
                        </h3>

                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">

                        <div class="col-md-6">
                            <!-- /.card-header -->
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label>Item Name</label>
                                                <input type="text" name="name" id="name" class="form-control is-valid"
                                                    placeholder="Name ...">
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
                                                    @foreach ($inactive as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach

                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label>Public</label>
                                                <select class="selectpicker form-control" name="public" id="public"
                                                    data-live-search="true">
                                                    @foreach ($inactive as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
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
                                                    @foreach ($Plan as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach

                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label>Pro-Line</label>
                                                <select class="selectpicker form-control" name="line" id="line"
                                                    data-live-search="true">
                                                    @foreach ($Line as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
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
                                                    @foreach ($Street as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach

                                                </select>
                                            </div>
                                        </div>


                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label>Size</label>
                                                <select class="selectpicker form-control" name="size" id="size"
                                                    data-live-search="true">
                                                    @foreach ($Size as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
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
                                                    @foreach ($Currency as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach

                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label>Cost</label>
                                                <input type="text" name="cost" id="cost" class="form-control"
                                                    placeholder="Cost ...">
                                            </div>
                                        </div>

                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label>Unit Price</label>
                                                <input type="text" name="unit_price" id="unit_price" class="form-control"
                                                    placeholder="Price ...">
                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label>Remark</label>
                                                <input type="text" name="remark" id="remark" class="form-control"
                                                    placeholder="Remark ...">
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
            cleartext();

            function cleartext() {
                $('#item_name').val('');
                $('#currency').val('');
                $('#plan').val('');
                $('#line').val('');
                $('#size').val('');
                $('#street').val('');
                $('#inactive').val('');
                $('#public').val('');
                $('#cost').val('');
                $('#unit_price').val('');
                $('#remark').val('');
            }

            $('#cost').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });

            $('#unit_price').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });

            function isNumberKey(evt) {
                var charCode = (evt.which) ? evt.which : evt.keyCode;
                if (charCode != 46 && charCode > 31 &&
                    (charCode < 48 || charCode > 57))
                    return false;
                return true;
            }


            $('#create_record').click(function() {
                $('#action').val("Add");
                $('#hidden_id').val("Add");
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Add') {
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
                                window.location.href = "/land_list/all";
                            }
                        }
                    })
                }
            });
        });
    </script>

@endsection
