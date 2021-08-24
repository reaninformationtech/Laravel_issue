@extends('layouts.app')
@section('content')

    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <button type="submit" class="btn btn-outline-primary" name="create_record" id="create_record"><i
                                    class="fas fa-edit" id='title'> Commit</i></button>
                            <a href="{{ url('pos_expense_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>
                            <input type="hidden" name="action" id="action" />
                            <input type="hidden" name="hidden_id" id="hidden_id" />
                        </h3>
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
                                                <label>Type</label>
                                                <select class="selectpicker form-control" name="type" id="type"
                                                    data-live-search="true">
                                                    @foreach ($line as $row)
                                                        <option value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Currency</label>
                                                <select class="selectpicker form-control" name="currency" id="currency"
                                                    data-live-search="true">
                                                    @foreach ($currency as $row)
                                                        <option value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Referent</label>
                                                <input type="text" name="referent" id="referent" class="form-control"
                                                    placeholder="Referent ...">
                                            </div>
                                        </div>
                                    </div>



                                    <div class="row">

                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Amount</label>
                                                <input type="text" name="amount" id="amount" class="number form-control"
                                                    placeholder="Amount ...">
                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Remark</label>
                                                <input type="text" name="remark" id="remark" class="form-control"
                                                    placeholder="Remark ...">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="increment row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <input type="file" name="file_name[]"   class="file_name form-control" />
                                            </div>
                                        </div>

                                        <div class="col-sm-3">
                                            <div class="input-group-btn">
                                                <button class="add_more btn btn-outline-primary" type="button">
                                                    <i class="fa fa-plus" aria-hidden="true"></i></button>
                                            </div>
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
            var count = 0;
            $('.add_more').click(function(e) {
                e.preventDefault();
                var html =
                    '<div class="deleteclose row"><div class="col-sm-6"><div class="form-group"><input type="file" name="file_name[]"   class="file_name form-control" ></div></div>';
                html +=
                    '<div class="col-sm-3"><div class="input-group-btn"><button class="btn btn-danger" type="button"><i class="fa fa-trash" aria-hidden="true"></i></button></div></div></div>';
                $(".increment").after(html);
                html = '';
                count++;
            });

            $("body").on("click", ".btn-danger", function() {
                $(this).parents(".deleteclose").remove();
                count--;
            });


            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var rows = [];
                var status = '';
                /// Assign value to post 
                $('#action').val('I');
                var v_id = $('#hidden_id').val();
                var v_referent = $('#referent').val();
                var v_currency = $('#currency').val();
                var v_amount = $('#amount').val();
                var v_remark = $('#remark').val();

                v_referent = v_referent.replace(",", "-");
                v_remark = v_remark.replace(",", "-");

                if (v_referent.trim() == '' || v_referent.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing referent nothing !'
                    })
                    status = 'error';
                    return false;
                }
                if (v_currency.trim() == '' || v_currency.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing input phone nothing !'
                    })
                    status = 'error';
                    return false;
                }


                if (v_amount.trim() == '' || v_amount.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing input amount nothing !'
                    })
                    status = 'error';
                    return false;
                }


                if (is_number(v_amount, 'qty') == false) {
                    status = 'error';
                    return false;
                }

                if (status == '') {
                    var data = new FormData();
                    //Form data
                    var form_data = $('#form_data').serializeArray();
                    $.each(form_data, function(key, input) {
                        data.append(input.name, input.value);
                    });

                    //File data
                    
                    for(var j=0 ; j<= count ; j++)
                    {
                        $.each($(".file_name")[j].files, function (i, file)
                        { 
                            data.append("file_name[]", file);
                        });
                    }

                    console.log(data);

                    $.ajax({
                        url: '{{ route('pos.pos_add_expense') }}',
                        method: "POST",
                        data: data,
                        processData: false,
                        contentType: false,
                        async:false,
                        beforeSend:function(){
                            $("#create_record").attr("disabled",true)
                        },
                        success: function(data) {
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
                                $("#create_record").attr("disabled",false)
                                window.location.href = "/pos_expense_list/all";
                            }
                        }
                    });
                }
            });


            function is_number(v_number, v_letter = '') {
                if (v_number <= 0 || v_number.trim() == '') {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing ' + v_letter + ' zero value'
                    })
                    return false;
                } else {
                    return true;
                }
            }

            $("#form_data").on('input', '.number', function(evt) {
                // code logic here
                var getValue = $(this).val();
                var self = $(this);
                self.val(self.val().replace(/[^0-9\.]/g, ''));
                if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which >
                        57)) {
                    evt.preventDefault();
                }
            });

        });

    </script>

@endsection
