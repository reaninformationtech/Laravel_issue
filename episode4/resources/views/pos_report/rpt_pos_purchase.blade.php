@extends('layouts.rpt_pos_master')
@section('rpt_content')

    <br />
    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf
                <div class="col-md-12">
                    <div class="row">
                        <div class="col-lg-4">
                            <div class="card card-outline card-info">
                                <div class="card-header border-0">
                                    <div class="d-flex justify-content-between">
                                        <h2 class="card-title">
                                            {{ isset($report[0]->reportname) ? $report[0]->reportname : '' }}</h2>
                                    </div>
                                </div>

                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">Stock</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="stock" id="stock"
                                                        data-live-search="true">
                                                        @foreach ($stock as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}">{{ $row1->name }}
                                                            </option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">Product</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="product" id="product"
                                                        data-live-search="true">
                                                        @foreach ($pos_product as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}">{{ $row1->name }}
                                                            </option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">P-Type</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="type" id="type"
                                                        data-live-search="true">
                                                        @foreach ($pro_type as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}">{{ $row1->name }}
                                                            </option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">P-Line</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="line" id="line"
                                                        data-live-search="true">
                                                        @foreach ($pro_line as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}">{{ $row1->name }}
                                                            </option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="data_to" class="col-sm-2 col-form-label">Date From</label>
                                                <div class="col-sm-5">
                                                    <div class="input-group date" data-target-input="nearest">
                                                        <input type="text" name="data_from" ID="txtDatefrom" runat="server"
                                                            class="form-control datetimepicker-input"
                                                            data-target="#reservationdate" />
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="data_to" class="col-sm-2 col-form-label">Date To</label>
                                                <div class="col-sm-5">
                                                    <div class="input-group date" data-target-input="nearest">
                                                        <input type="text" name="data_to" ID="txtDateto" runat="server"
                                                            class="form-control datetimepicker-input"
                                                            data-target="#reservationdate" />
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                                <div class="modal-footer justify-content-between">
                                    <div class="col-md-12 text-right">
                                        <button type="submit" class="btn pull-right btn-outline-primary"
                                            name="create_record" id="create_record"><i class="fas fa-edit" id='title'>
                                                Report</i></button>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <!-- /.card -->
                    </div>

                    <div id="table_data">
                        @include('pos_report/rpt_pos_purchase_data')
                    </div>

                </div>
                <!-- /.row -->
            </form>
        </div>
        <!-- /.col-->
    </div>
    <!-- ./row -->

@endsection

@section('scripts')

    <script>
        $(document).ready(function() {

            $("a").click(function(event){
                 event.preventDefault();
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var v_datefrom = $('#txtDatefrom').val();
                var v_date_to = $('#txtDateto').val();

                if (v_datefrom.trim() == '' || v_datefrom.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Please input date to get data !'
                    })
                    status = 'error';
                    return false;
                }

                if (v_date_to.trim() == '' || v_date_to.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Please input date to get data !'
                    })
                    status = 'error';
                    return false;
                }


                $.ajax({
                    url: "{{ route('pos_report.rpt_get_pos_purchase') }}",
                    method: "POST",
                    async: false,
                    data: new FormData(this),
                    contentType: false,
                    processData: false,
                    dataType: "json",
                    beforeSend: function() {
                        $("#create_record").attr("disabled", false)
                    },
                    success: function(data) {
                        $('#table_data').html(data);
                    },
                    dataType: "html"
                })
            });
        });

    </script>

@endsection
