@extends('layouts.rpt_pos_master')
@section('rpt_content')
    <style>
        .btn:focus,
        .btn:active,
        button:focus,
        button:active {
            outline: none !important;
            box-shadow: none !important;
        }

        #image-gallery .modal-footer {
            display: block;
        }

        .thumb {
            margin-top: 15px;
            margin-bottom: 15px;
        }

    </style>
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
                                                <label for="currency" class="col-sm-2 col-form-label">Currency</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="currency" id="currency"
                                                        data-live-search="true">
                                                        @foreach ($currency as $row1)
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
                        @include('pos_report/rpt_pos_monthly_closing_data')
                    </div>

                </div>
                <!-- /.row -->
            </form>
        </div>
        <!-- /.col-->
    </div>
    <!-- ./row -->



    <div class="modal fade" id="confirmModal" role="dialog">
        <div class="modal-dialog modal-lg">
            
            <!--Modal Content-->
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                </div>
                <div class="container">
                    <div class="row">

                        <div id="table_img">
                            @include('pos_report/rpt_pos_income_img')
                        </div>

                        <div class="modal fade" id="image-gallery" tabindex="-1" role="dialog"
                            aria-labelledby="myModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h4 class="modal-title" id="image-gallery-title"></h4>
                                        <button type="button" class="close" data-dismiss="modal"><span
                                                aria-hidden="true">×</span><span class="sr-only">Close</span>
                                        </button>
                                    </div>
                                    <div class="modal-body">
                                        <img id="image-gallery-image" class="img-responsive col-md-12" src="">
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary float-left"
                                            id="show-previous-image"><i class="fa fa-arrow-left"></i>
                                        </button>

                                        <button type="button" id="show-next-image" class="btn btn-secondary float-right"><i
                                                class="fa fa-arrow-right"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>



@endsection

@section('scripts')


    <script>
        $(document).ready(function() {

            $("a").click(function(event) {
                event.preventDefault();
            });



            $(document).on('click', '.edit', function() {
                var id = $(this).attr('id');
                event.preventDefault();

                $.ajax({
                    url: "/rpt_pos_income_img",
                    method: "GET",
                    data: {
                        image_id: id
                    },
                    success: function(data) {
                        $('#table_img').html(data);
                        $('#confirmModal').modal('show');
                    }
                })

            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var v_txtDatefrom = $('#txtDatefrom').val();
                var v_txtDateto = $('#txtDateto').val();

                if (v_txtDatefrom.trim() == '' || v_txtDatefrom.trim() == null) {
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

                if (v_txtDateto.trim() == '' || v_txtDateto.trim() == null) {
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
                    url: "{{ route('pos_report.rpt_get_pos_monthly_closing') }}",
                    method: "POST",
                    async: false,
                    data: new FormData(this),
                    contentType: false,
                    processData: false,
                    dataType: "json",
                    beforeSend: function() {
                        $("#create_record").attr("disabled", true)
                    },
                    success: function(data) {
                        $('#table_data').html(data);
                    },
                    dataType: "html"
                })

                $("#create_record").attr("disabled", false)
            });
        });

    </script>

@endsection
