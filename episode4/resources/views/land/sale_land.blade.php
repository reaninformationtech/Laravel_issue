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
                            <a href="{{ url('sale_land_list/all') }}" class="text-center">
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
                                                <label for="cus_name">Customer</label>
                                                <select class="selectpicker form-control" name="cus_name" id="cus_name"
                                                    data-live-search="true">
                                                    @foreach ($cus as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="land">Land ID</label>
                                                <select class="selectpicker form-control" name="land" id="land"
                                                    data-live-search="true">
                                                    @foreach ($land_list as $row)
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
                                            <div class="form-group">
                                                <label for="discount" >Discount(%)</label>
                                                <select class="selectpicker form-control" name="discount" id="discount"
                                                    data-live-search="true">
                                                    @foreach ($percentage as $row)
                                                        <option data-tokens="{{ $row->id }}"
                                                            value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="price">Price</label>
                                                <input type="text" name="price" id="price" class="form-control"
                                                    placeholder="Price ...">
                                            </div>
                                        </div>

                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="saleprice" >Sale Price</label>
                                                <input type="text" name="saleprice" id="saleprice" class="form-control"
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
                $('#cus_name').val('');
                $('#land').val('');
                $('#discount').val('');
                $('#price').val('0.00');
                $('#saleprice').val('0.00');
            }

            $('#price').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });

            $('#saleprice').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });

            $('#create_record').click(function() {
                $('#action').val("Add");
                $('#hidden_id').val("Add");
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Add') {
                    $.ajax({
                        url: "{{ route('sale-land.add_sale_land') }}",
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
                            
                            if (data.errorexsit) {
                                const Toast = Swal.mixin({
                                        toast: true,
                                        position: 'top-end',
                                        showConfirmButton: false,
                                        timer: 3000
                                    });
                                    Toast.fire({
                                        icon: 'error',
                                        title: data.errorexsit
                                    })
                                    $("#create_record").attr("disabled", false)
                                    return;
                            }

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
                                window.location.href = "/sale_land_list/all";
                            }
                        }
                    })
                }
            });

            $('#land').change(function() {

                var id = $('#land').val();
                var discount = $('#discount').val();
                if (id !== '') {
                    $.ajax({
                        type: 'ajax',
                        method: 'get',
                        url: "/combo_price/" + id,
                        data: {
                            itemid: id
                        },
                        async: false,
                        dataType: 'json',

                        success: function(data) {
                            $('input[name=price]').val(data[0].unitprice);
                            $('input[name=saleprice]').val(data[0].unitprice - (data[0]
                                .unitprice *
                                discount / 100));
                        },
                        error: function() {
                            alert('Could not Edit Data');
                        }
                    });
                }
            });

            $('#discount').change(function() {
                var id = $('#land').val();
                var discount = $('#discount').val();
                if (id !== '') {
                    $.ajax({
                        type: 'ajax',
                        method: 'get',
                        url: "/combo_price/" + id,
                        data: {
                            itemid: id
                        },
                        async: false,
                        dataType: 'json',

                        success: function(data) {
                            $('input[name=price]').val(data[0].unitprice);
                            $('input[name=saleprice]').val(data[0].unitprice - (data[0]
                                .unitprice *
                                discount / 100));
                        },
                        error: function() {
                            alert('Could not Edit Data');
                        }
                    });
                }
            });

        });
    </script>

@endsection
