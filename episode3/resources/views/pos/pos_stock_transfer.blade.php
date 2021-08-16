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
                            <a href="{{ url('pos_stock_transfer_list/all') }}" class="text-center">
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
                                                <label>From Stock</label>
                                                <select class="selectpicker form-control" name="from_stockcode"
                                                    id="from_stockcode" data-live-search="true">
                                                    @foreach ($stock as $row)
                                                        <option value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="form-group">
                                                <label>To stock </label>
                                                <select class="selectpicker form-control" name="to_stockcode"
                                                    id="to_stockcode" data-live-search="true">
                                                    @foreach ($stock as $row)
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
                                                <label>Remark</label>
                                                <input type="text" name="remark" id="remark" class="form-control"
                                                    placeholder="Remark ...">
                                            </div>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="table-responsive">
                                <form method="post" id="dynamic_form">
                                    <span id="result"></span>
                                    <table class="table table-bordered table-striped" id="table_input">
                                        <thead>
                                            <tr>
                                                <th width="30%">Item</th>
                                                <th width="10%">Qty</th>
                                                <th width="10%" style="display:none;">Code</th>
                                                <th width="10%">Barcode</th>
                                                <th width="10%"></th>
                                            </tr>
                                        </thead>
                                        <tbody>

                                        </tbody>

                                    </table>
                                </form>
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
            var gb_index = 0;
            var count = 1;

            dynamic_field(count);

            function dynamic_field(number) {
                html = '<tr>';
                html += '<td class="p_name" id="tdname_' + number + '" ><input type="text" id="name_' + number +
                    '" name="items[]" class="pro_name form-control" autocomplete="off" /> <div id="countryList_' + number +
                    '"></div> </td>';
                html += '<td class="p_qty" id="tdqty_' + number + '"><input type="text" id="qty_' + number +
                    '" name="qty[]" class="number form-control" autocomplete="off" /></td>';
                html += '<td class="p_code" id="tdcode_' + number +
                    '" style="display:none;"><input type="text" id="code_' + number +
                    '" name="code[]" class="form-control" /></td>';
                html += '<td class="p_barcode" id="tdbarcode_' + number + '"><input type="text" id="barcode_' +
                    number + '" name="barcode[]" class="form-control" disabled /></td>';
                if (number > 1) {
                    html +=
                        '<td><button type="button" name="remove" id="remove" class="remove btn btn-xs btn-danger btn-sm my-0" ><i class="fas fa-trash"></i></button></td></tr>';
                    $('tbody').append(html);
                } else {
                    html +=
                        '<td><button type="button" name="add" id="add" class="btn btn-xs btn-success btn-sm my-0"><i class="fas fa-plus"></i></button></td></tr>';
                    $('tbody').html(html);
                }
            }

            $(document).on('click', '#add', function() {
                count++;
                dynamic_field(count);
            });

            $(document).on('click', '.remove', function() {
                count--;
                $(this).closest("tr").remove();
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var rows = [];
                var status = '';
                /// Assign value to post 
                $('#action').val('I');
                var v_id = $('#hidden_id').val();
                var v_from_stockcode = $('#from_stockcode').val();
                var v_to_stockcode = $('#to_stockcode').val();
                var v_remark = $('#remark').val();

                v_remark = v_remark.replace(",", "/");


                if (v_from_stockcode.trim() == '' || v_from_stockcode.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing choose stock nothing !'
                    })
                    status = 'error';
                    return false;
                }

                if (v_to_stockcode.trim() == '' || v_to_stockcode.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing choose stock nothing !'
                    })
                    status = 'error';
                    return false;
                }


                //Get all the data row and put in array
                $('#table_input tbody tr').each(function() {
                    var Id = $(this).find('td.p_code').attr('id');;
                    var splitid = Id.split('_');
                    var index = splitid[1];

                    if (Id != '') {

                        var p_name = $(this).find(".p_name > input[type=text]").val();
                        var p_qty = $(this).find(".p_qty > input[type=text]").val();
                        var p_code = $(this).find(".p_code > input[type=text]").val();

                        if (p_code.trim() == '' || p_code.trim() == null) {
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'top-end',
                                showConfirmButton: false,
                                timer: 3000
                            });
                            Toast.fire({
                                icon: 'error',
                                title: 'Missing input product nothing !'
                            })
                            status = 'error';
                            return false;
                        }
                        if (is_number(p_qty, 'qty') == false) {
                            status = 'error';
                            return false;
                        }

                    }
                });

                if (status == '') {
                    var row = "I|" + v_from_stockcode + "|" + v_to_stockcode + "|" + v_remark;
                    rows.push(row);


                    var record = JSON.stringify({
                        getRows: rows //Post to Controller action parameter
                    });



                    var formData = $(this).serializeArray();
                    var a_string = JSON.stringify(rows);
                    formData.push({
                        name: 'arr_data',
                        value: a_string
                    });

                    $.ajax({
                        url: '{{ route('pos.add_pos_stock_transfer') }}',
                        method: "POST",
                        data: formData,
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
                                window.location.href = "/pos_stock_transfer_list/all";
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

            $("#table_input").on('input', '.number', function(evt) {
                // code logic here
                var getValue = $(this).val();
                var self = $(this);
                self.val(self.val().replace(/[^0-9\.]/g, ''));
                if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which >
                    57)) {
                    evt.preventDefault();
                }
            });

            $(document).on('keydown', '.pro_name', function() {
                var id = this.id;
                var splitid = id.split('_');
                var index = splitid[1];
                var _token = $('input[name="_token"]').val();
                var query = $('#name_' + index).val();
                gb_index = index;
                // When string > 2 start to search
                if (query != '' && query.length > 1) {
                    $.ajax({
                        url: "{{ route('autocomplete.fetch') }}",
                        method: "POST",
                        data: {
                            query: query,
                            _token: _token
                        },
                        success: function(data) {
                            $('#countryList_' + index).fadeIn();
                            $('#countryList_' + index).html(data);
                        }
                    });
                }

            });

            $(document).on('click', '.li_product', function() {

                $('#name_' + gb_index).val($(this).text());
                $('#countryList_' + gb_index).fadeOut();

                if ($(this).text() != '') {
                    var _token = $('input[name="_token"]').val();
                    $.ajax({
                        url: "/pos/" + $(this).attr("id") + "/product_info",
                        method: "get",
                        dataType: "json",
                        success: function(html) {
                            $('#code_' + gb_index).val(html.data.pro_id);
                            $('#barcode_' + gb_index).val(html.data.barcode);
                        }
                    });
                }
            });

        });

    </script>

@endsection
