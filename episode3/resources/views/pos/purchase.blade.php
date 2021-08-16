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
                            <a href="{{ url('purchase_order_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>
                            <input type="hidden" name="action" id="action" />
                            <input type="hidden" name="hidden_id" id="hidden_id" />
                        </h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="col-md-6">
                            <!-- /.card-header -->
                            <div class="card-body">

                                <div class="row">
                                    <div class="col-sm-6">
                                        <!-- text input -->
                                        <div class="form-group">
                                            <label>Office Supply</label>
                                            <select class="selectpicker form-control" name="supply" id="supply"
                                                data-live-search="true">
                                                @foreach ($pos_supply as $row)
                                                    <option value="{{ $row->id }}">
                                                        {{ $row->name }}</option>
                                                @endforeach
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>Invoice</label>
                                            <input type="text" name="invoice" id="invoice" class="form-control"
                                                placeholder="Invoice ..." autocomplete="off">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <!-- text input -->
                                        <div class="form-group">
                                            <label>Remark</label>
                                            <input type="text" name="remark" id="remark" class="form-control"
                                                placeholder="Remark ..." autocomplete="off">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Default box -->
                        <div class="card">
                            <div class="card-body p-0">
                                <table class="table table-striped projects" name='table_input' id='table_input'>
                                    <thead>
                                        <tr>
                                            <th style="width: 1%">
                                                #
                                            </th>
                                            <th style="width: 20%">
                                                Item
                                            </th>

                                            <th style="width: 12%">
                                                Stock
                                            </th>

                                            <th style="width: 7%">
                                                Cost
                                            </th>
                                            <th style="width: 7%">
                                                Qty
                                            </th>
                                            <th>
                                                Discount
                                            </th>
                                            <th>
                                                Amount
                                            </th>
                                            <th>
                                                Remark
                                            </th>
                                            <th style="display:none;">
                                                Code
                                            </th>
                                            <th>

                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr class='tr_input' data-id='1'>
                                            <td>
                                                1
                                            </td>
                                            <td class="p_name">
                                                <input type='text' class="pro_name form-control" id='productname_1'
                                                    name='productname_1' placeholder='Enter username' autocomplete="off">
                                                <div id="countryList1"></div>
                                            </td>
                                            <td class="p_stock">
                                                <select class="form-control" name="stock_1" id="stock_1">
                                                    @foreach ($stock as $row)
                                                        <option value="{{ $row->id }}">
                                                            {{ $row->name }}</option>
                                                    @endforeach
                                                </select>
                                            </td>

                                            <td class="p_cost">
                                                <input type='text' class='number form-control' id='cost_1'
                                                    placeholder='Cost' autocomplete="off">
                                            </td>
                                            <td class="p_qty">
                                                <input type='text' class='number form-control' id='qty_1' placeholder='Qty'
                                                    autocomplete="off">
                                            </td>
                                            <td class="p_discount">
                                                <input type='text' class='number form-control' id='discount_1'
                                                    placeholder='Dis' autocomplete="off">
                                            </td>
                                            <td class="p_amount">
                                                <input type='text' class="form-control" id='amount_1' placeholder='Amount'
                                                    autocomplete="off" disabled>
                                            </td>
                                            <td class="p_remark">
                                                <input type='text' class="form-control" id='remark_1' placeholder='Remark'
                                                    autocomplete="off">
                                            </td>
                                            <td style="display:none;" class="p_code">
                                                <input type='text' class="form-control" id='code_1' placeholder='code'
                                                    autocomplete="off" disabled>
                                            </td>

                                            <td class="project-actions text-right">
                                                <a class="delete btn btn-danger btn-sm" id='delete_1' href="#">
                                                    <i class="fas fa-trash" disabled>
                                                    </i>
                                                    Delete
                                                </a>
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>
                            </div>
                            <!-- /.card-body -->
                        </div>
                        <!-- /.card -->
                    </div>

                    <div class="card-footer">
                        <div class="float-left">
                            <button type="button" id='create' class="btn btn-info btn-sm"
                                class="edit btn btn-xs btn-danger"><i class="fa fa-plus">Add</i></button>
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

            $(document).on('click', '.delete', function(event) {
                var id = this.id;
                var splitid = id.split('_');
                var index = splitid[1];
                $('#hidden_id').val(index);

                if (index == 1) {
                    return;
                }

                Swal.fire({
                    title: 'Do you want to remove record now?',
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
                        $('[data-id=' + index + ']').remove();
                        Swal.fire('Removed !', '', 'success')
                    }
                })
            });

            $('#supply').change(function() {
                event.preventDefault();
                gb_index = 0;
                cal_amount();
            });

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

            $('#create').click(function() {
                // Get last id 
                var lastname_id = $('.tr_input input[type=text]:nth-child(1)').last().attr('id');
                var split_id = lastname_id.split('_');

                // New index
                var index = Number(split_id[1]) + 1;



                // Create row with input elements
                var html = "<tr class='tr_input' data-id='" + index + "'>";
                html += "<td>" + index + "</td>";
                html +=
                    "<td class='p_name' ><input type='text' class='pro_name form-control' id='productname_" +
                    index + "' placeholder='Enter username' autocomplete='off' > <div id='countryList" +
                    index + "' ></div> </td>";


                html += "<td class='p_stock'><select type='select'  name='stock_" + index + "' id='stock_" +
                    index +
                    "' class='form-control' style='width: 100%;>'";
                html += "</select> </td>";


                html += "<td class='p_cost' ><input type='text' class='number form-control' id='cost_" +
                    index +
                    "' placeholder='Cost' autocomplete='off' ></td>";
                html += "<td class='p_qty' ><input type='text' class='number form-control' id='qty_" +
                    index +
                    "' placeholder='Qty' autocomplete='off' ></td>";
                html +=
                    "<td class='p_discount' ><input type='text' class='number form-control' id='discount_" +
                    index +
                    "' placeholder='Discount' autocomplete='off' ></td>";
                html += "<td class='p_amount'><input type='text' class='number form-control' id='amount_" +
                    index +
                    "' placeholder='Amount' disabled></td>";
                html +=
                    "<td class='p_remark'><input type='text' class='form-control' autocomplete='off' id='remark_" +
                    index +
                    "' placeholder='Remark'></td>";
                html +=
                    "<td style='display:none;' class='p_code' ><input type='text' class='form-control' id='code_" +
                    index +
                    "' placeholder='code' autocomplete='off' disabled></td>";
                html +=
                    "<td class='project-actions text-right'><a class='delete btn btn-danger btn-sm' id='delete_" +
                    index + "' href='#'><i class='fas fa-trash'></i> Delete </a></td>";
                html += "</tr>";

                // Append data
                $('tbody').append(html);
                var stockid = '#stock_' + index;
                loaddata_combo(index, stockid);
            });


            $(document).on('click', 'li', function() {

                $('#code_' + gb_index).val($(this).attr("id"));
                $('#productname_' + gb_index).val($(this).text());
                $('#countryList' + gb_index).fadeOut();
            });

            $('.number').on("input", function(evt) {
                var self = $(this);
                self.val(self.val().replace(/[^0-9\.]/g, ''));
                if ((evt.which != 46 || self.val().indexOf('.') != -1) && (evt.which < 48 || evt.which >
                    57)) {
                    evt.preventDefault();
                }
            });

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
                var query = $('#productname_' + index).val();
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
                            $('#countryList' + index).fadeIn();
                            $('#countryList' + index).html(data);
                        }
                    });
                }
            });


            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var rows = [];
                var status = '';
                var v_supply = $('#supply').val();
                var v_invoice = $('#invoice').val();
                var v_remark = $('#remark').val();

                if (v_supply.trim() == '') {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing select supply nothing !'
                    })
                    return false;
                }

                if (v_invoice.trim() == '') {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Missing input invoice nothing !'
                    })
                    return false;
                }

                //Get all the data row and put in array
                $('#table_input tbody tr').each(function() {
                    var Id = $(this).find('td').eq(0).text().trim();
                    var stockcode = '';
                    if (Id != '') {

                        stockcode = "#stock_" + Id;
                        $(stockcode).find("option:selected").each(function() {
                            stockcode = $(this).val();
                        });

                        var p_name = $(this).find(".p_name > input[type=text]").val();
                        var p_stock = stockcode;
                        var p_cost = $(this).find(".p_cost > input[type=text]").val();
                        var p_qty = $(this).find(".p_qty > input[type=text]").val();
                        var p_discount = $(this).find(".p_discount > input[type=text]").val();
                        var p_amount = $(this).find(".p_amount > input[type=text]").val();
                        var p_remark = $(this).find(".p_remark > input[type=text]").val();
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

                        if (is_number(p_cost, 'cost') == false) {
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

                        var row = v_supply + "|" + v_invoice + "|" + v_remark + "|" + p_code + "|" +
                            p_stock + "|" + p_name + "|" + p_cost + "|" + p_qty + "|" +
                            p_discount + "|" + p_amount + "|" + p_remark;

                        rows.push(row); //Push into array rows[]
                    }
                });


                if (status == '') {
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
                        url: '{{ route('purchase-order.add_purchase_order') }}',
                        method: "POST",
                        data: formData,
                        async: false,
                        beforeSend: function() {
                            $("#create_record").attr("disabled", true)
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
                                $("#create_record").attr("disabled", false)
                            }
                            window.location.href = "/purchase_order_list/all";
                        }
                    });
                }

            });

            function cal_amount() {
                $('#table_input tbody tr').each(function() {
                    var Id = $(this).find('td').eq(0).text().trim();
                    console.log(Id);
                    if (Id != '') {
                        var p_cost = $(this).find(".p_cost > input[type=text]").val();
                        var p_qty = $(this).find(".p_qty > input[type=text]").val();
                        var p_discount = $(this).find(".p_discount > input[type=text]").val();

                        if (p_cost == 0 || p_cost.trim() == '') {
                            return false;
                        } else if (p_qty == 0 || p_qty.trim() == '') {
                            return false;
                        } else if (p_qty == 0 || p_qty.trim() == '') {
                            return false;
                        } else if (p_discount.trim() == '') {
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
                if (v_number == 0 || v_number.trim() == '') {
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
        });
    </script>
@endsection
