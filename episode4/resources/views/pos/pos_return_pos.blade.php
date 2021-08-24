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
                            <a href="{{ url('pos_return_pos_list/all') }}" class="text-center">
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
                                                <label>Referent</label>
                                                <input type="text" name="referent" id="referent" class="form-control"
                                                    placeholder="Referent invoice ...">
                                            </div>
                                        </div>
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
                                                <th width="15%">Stock</th>
                                                <th width="10%">Qty</th>
                                                <th width="10%">Unit-price</th>
                                                <th width="10%">Discount</th>
                                                <th width="10%">Amount</th>
                                                <th width="10%" style="display:none;">Code</th>
                                                <th width="10%" style="display:none;">Barcode</th>
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

            function cal_amount() {
                $('#table_input tbody tr').each(function() {
                    var Id = $(this).find('td').eq(0).text().trim();
                    if (Id != '') {
                        var p_cost = $(this).find(".p_unitprice > input[type=text]").val();
                        var p_qty = $(this).find(".p_qty > input[type=text]").val();
                        var p_discount = $(this).find(".p_discount > input[type=text]").val();

                        if (p_cost == 0 || p_cost.trim() == '') {
                            return false;
                        } else if (p_qty == 0 || p_qty.trim() == '') {
                            return false;
                        } else if (p_qty == 0 || p_qty.trim() == '') {
                            return false;
                        } else if (p_discount.trim() == '' || p_discount > 100) {
                            return false;
                        }

                        var t_total = parseFloat(p_cost * p_qty);
                        var t_discount = parseFloat((t_total * p_discount) / 100);
                        var t_amount = parseFloat(t_total - t_discount);
                        var total = t_amount.toFixed(3);
                        if (total >= 0) {
                            $(this).find(".p_amount > input[type=text]").val(total);
                        } else {
                            $(this).find(".p_amount > input[type=text]").val('0.00');
                        }
                    }
                });
            }

            function loaddata_combo(id, control) {
                var id = '';
                $.ajax({
                    url: "/combo_pos_line/02",
                    method: "get",
                    data: {
                        state_id: id
                    },
                    success: function(data) {
                        $(control).html(data);
                    }
                });
            }

            function dynamic_field(number) {
                html = '<tr>';
                html += '<td class="p_name" id="tdname_' + number + '" ><input type="text" id="name_' + number +
                    '" name="items[]" class="pro_name form-control" autocomplete="off" /> <div id="countryList_' +
                    number + '"></div> </td>';
                html += '<td class="p_stock" id="tdstock_' + number + '"><select type="select" id="stock_' +
                    number + '"  name="stock[]" class="form-control" autocomplete="off" ></select></td>';
                html += '<td class="p_qty" id="tdqty_' + number + '"><input type="text" id="qty_' + number +
                    '" name="qty[]" class="number form-control" autocomplete="off" /></td>';
                html += '<td class="p_unitprice" id="tdunitprice_' + number +
                    '"><input type="text" id="unitprice_' + number +
                    '" name="unitprice[]" class="number form-control" autocomplete="off"/></td>';
                html += '<td class="p_discount" id="tddiscount_' + number + '"><input type="text" id="discount_' +
                    number +
                    '" name="discount[]" class="number form-control" value="0" autocomplete="off" /></td>';
                html += '<td class="p_amount" id="tdamount_' + number + '" ><input type="text" id="amount_' +
                    number + '" name="amount[]" class="number form-control" autocomplete="off" /></td>';
                html += '<td class="p_code" id="tdcode_' + number +
                    '" style="display:none;"><input type="text" id="code_' + number +
                    '" name="code[]" class="form-control" /></td>';
                html += '<td class="p_barcode" id="tdbarcode_' + number +
                    '" style="display:none;"><input type="text" id="barcode_' + number +
                    '" name="barcode[]" class="form-control" /></td>';
                if (number > 1) {
                    html +=
                        '<td><button type="button" name="remove" id="remove" class="remove btn btn-xs btn-danger btn-sm my-0" ><i class="fas fa-trash"></i></button></td></tr>';
                    $('tbody').append(html);
                } else {
                    html +=
                        '<td><button type="button" name="add" id="add" class="btn btn-xs btn-success btn-sm my-0"><i class="fas fa-plus"></i></button></td></tr>';
                    $('tbody').html(html);
                }
                var stockid = '#stock_' + number;
                loaddata_combo(number, stockid);
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
                var v_referent = $('#referent').val();
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
                        title: 'Missing  referent invoice nothing !'
                    })
                    status = 'error';
                    return false;
                }
                if (v_remark.trim() == '' || v_remark.trim() == null) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing input remark nothing !'
                    })
                    status = 'error';
                    return false;
                }

                //Get all the data row and put in array
                $('#table_input tbody tr').each(function() {
                    var Id = $(this).find('td.p_code').attr('id');;
                    var splitid = Id.split('_');
                    var index = splitid[1];
                    var stockcode = '';


                    if (Id != '') {

                        stockcode = "#stock_" + index;
                        $(stockcode).find("option:selected").each(function() {
                            stockcode = $(this).val();
                        });


                        var p_name = $(this).find(".p_name > input[type=text]").val();
                        var p_stock = stockcode;
                        var p_unitprice = $(this).find(".p_unitprice > input[type=text]").val();
                        var p_qty = $(this).find(".p_qty > input[type=text]").val();
                        var p_discount = $(this).find(".p_discount > input[type=text]").val();
                        var p_amount = $(this).find(".p_amount > input[type=text]").val();
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

                        if (p_stock.trim() == '' || p_stock.trim() == null) {
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


                        if (is_number(p_unitprice, 'unitprice') == false) {
                            status = 'error';
                            return false;
                        }
                        if (is_number(p_qty, 'qty') == false) {
                            status = 'error';
                            return false;
                        }
                        if (is_number(p_qty, 'qty') == false) {
                            status = 'error';
                            return false;
                        }
                        if ((is_number_discount(p_discount, 'discount') == false) || p_discount >
                            100) {
                            status = 'error';
                            return false;
                        }
                    }
                });

                if (status == '') {
                    var row = "I|" + v_referent + "|" + v_remark;
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
                        url: '{{ route('pos.add_return_pos') }}',
                        method: "POST",
                        data: formData,
                        async:false,
                        beforeSend:function(){
                            $("#create_record").attr("disabled",true)
                        },
                        success: function(data) {

                            if (data.duplicate) {
                                // Message sweet alert
                                const Toast = Swal.mixin({
                                    toast: true,
                                    position: 'top-end',
                                    showConfirmButton: false,
                                    timer: 3000
                                });
                                Toast.fire({
                                    icon: 'error',
                                    title: data.duplicate
                                })
                                $("#create_record").attr("disabled",false)
                                return;
                            }

                            if (data.referent) {
                                // Message sweet alert
                                const Toast = Swal.mixin({
                                    toast: true,
                                    position: 'top-end',
                                    showConfirmButton: false,
                                    timer: 3000
                                });
                                Toast.fire({
                                    icon: 'error',
                                    title: data.referent
                                })
                                $("#create_record").attr("disabled",false)
                                return;
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
                                $("#create_record").attr("disabled",false)
                                window.location.href = "/pos_return_pos_list/all";
                            }
                        }
                    });
                }


            });


            function is_number_discount(v_number, v_letter = '') {
                if (v_number.trim() == '' || v_number > 100) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing ' + v_letter + ' nothing value'
                    })
                    return false;
                } else {
                    return true;
                }
            }

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
                cal_amount();
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

            $(document).on('click', '.li_name', function() {
                var record_id = this.id;
                $('#cus_name').val($(this).text());
                $('#customerlist').fadeOut();
                $('#hidden_id').val(record_id);

                if (record_id != '') {
                    var _token = $('input[name="_token"]').val();

                    $.ajax({
                        url: "/pos/" + record_id + "/customer_info",
                        method: "get",
                        dataType: "json",
                        success: function(html) {
                            $('#phone').val(html.data.cus_phone);
                            $('#address').val(html.data.cus_address);
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
                            $('#unitprice_' + gb_index).val(html.data.pro_up);
                            $('#discount_' + gb_index).val(html.data.pro_discount);
                            $('#qty_' + gb_index).val('0');
                            $('#amount_' + gb_index).val('0.00');
                        }
                    });

                    cal_amount();
                }
            });

        });

    </script>

@endsection
