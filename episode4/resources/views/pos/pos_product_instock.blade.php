@extends('layouts.app')
@section('content')
    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf

                <div class="card card-outline card-info">
                    <div class="card-header">
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">

                        <div class="row">
                            <div class="col-md-6">
                                <!-- /.card-header -->
                                <div class="card-body">

                                    <div class="row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Stock</label>
                                                <select class="selectpicker form-control" name="stockcode" id="stockcode"
                                                    data-live-search="true">
                                                    @foreach ($stock as $row)
                                                        <option value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label>Product</label>
                                                <select class="selectpicker form-control" name="productcode"
                                                    id="productcode" data-live-search="true">
                                                    @foreach ($p_instock as $row)
                                                        <option value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div id="table_data">
                            @include('pos/pos_product_instock_data')
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


            $('#stockcode').change(function() {
                event.preventDefault();
                var token = $("meta[name='csrf-token']").attr("content");
                var stockcode = $('#stockcode').val();
                var productcode = $('#productcode').val();

                if (stockcode == '') {
                    stockcode = '%';
                }

                if (productcode == '') {
                    productcode = '%';
                }

                $.ajax({
                    url: "/get_instock",
                    data: {
                        "stockcode": stockcode,
                        "productcode": productcode,
                        "_token": token,
                    },
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });

            });


            $('#productcode').change(function() {
                var token = $("meta[name='csrf-token']").attr("content");
                var stockcode = $('#stockcode').val();
                var productcode = $('#productcode').val();

                if (stockcode == '') {
                    stockcode = '%';
                }

                if (productcode == '') {
                    productcode = '%';
                }

                $.ajax({
                    url: "/get_instock",
                    data: {
                        "stockcode": stockcode,
                        "productcode": productcode
                    },
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            });

        });
    </script>

@endsection
