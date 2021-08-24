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
                                <form role="form">
                                    <input type="hidden" name="action" id="action" value="Edit" />
                                    <input type="hidden" name="hidden_id" id="hidden_id"
                                        value="{{ isset($data[0]->id) ? $data[0]->id : '' }}" />

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label>ID</label>
                                                <input type="text" name="name" id="name" class="form-control is-valid"
                                                    value="{{ isset($data[0]->id) ? $data[0]->id : '' }}" readonly />
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label for="cus_name">Customer</label>
                                                <select class="selectpicker form-control" name="cus_name" id="cus_name"
                                                    data-live-search="true">
                                                    @foreach ($cus as $row1)
                                                        <option data-tokens="{{ $row1->id }}"
                                                            value="{{ $row1->id }}"
                                                            {{ $row1->id == (isset($data[0]->cus_id) ? $data[0]->cus_id : '') ? 'selected="selected"' : '' }}>
                                                            {{ $row1->name }}</option>
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

                                                    @foreach ($land_list as $row1)
                                                        <option data-tokens="{{ $row1->id }}"
                                                            value="{{ $row1->id }}"
                                                            {{ $row1->id == (isset($data[0]->rg_id) ? $data[0]->rg_id : '') ? 'selected="selected"' : '' }}>
                                                            {{ $row1->name }}</option>
                                                    @endforeach

                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="discount">Discount(%)</label>
                                                <select class="selectpicker form-control" name="discount" id="discount"
                                                    data-live-search="true">
                                                    @foreach ($percentage as $row1)
                                                        <option data-tokens="{{ $row1->id }}"
                                                            value="{{ $row1->id }}"
                                                            {{ $row1->id == (isset($data[0]->discount) ? $data[0]->discount : '') ? 'selected="selected"' : '' }}>
                                                            {{ $row1->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="price">Price</label>
                                                <input type="text" name="price" id="price" class="form-control" readonly
                                                    value="{{ isset($data[0]->cost) ? $data[0]->cost : '' }}" />
                                            </div>
                                        </div>

                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label for="saleprice">Sale Price</label>
                                                <input type="text" name="saleprice" id="saleprice" class="form-control" readonly
                                                    value="{{ isset($data[0]->amount) ? $data[0]->amount : '' }}" />
                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group">
                                                <label>Remark</label>
                                                <input type="text" name="remark" id="remark" class="form-control"
                                                    value="{{ isset($data[0]->remark) ? $data[0]->remark : '' }}" />
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
                            url: "/delete_sale_land/" + gb_id,
                            type: 'get',
                            async: false,
                            data: {
                                "id": gb_id,
                                "_token": _token,
                            },
                            success: function(data) {
                                if (data.errors) {
                                    return;
                                }
                            }
                        })
                        Swal.fire('Removed !' + gb_id, '', 'success')
                        window.location.href = "/sale_land_list/all";
                    }
                })

            });


        });
    </script>

@endsection
