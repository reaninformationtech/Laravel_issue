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

.custom-select {
    border-radius: 1.5rem;
}

.selectpicker {
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
                        <button type="submit" class="authorize btn btn-outline-info" name="authorize_record"
                            id="authorize_record"><i class="fas fa-edit">Authorize</i></button>
                        <button type="submit" class="btn btn-outline-danger" name="delete_record" id="delete_record"><i
                                class="fas fa-trash-alt"> Delete</i></button>
                        <a href="{{url('/purchase_order_list/all')}}" class="text-center">
                            <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                Info</button>
                        </a>
                    </h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body pad">

                    @foreach($data as $row)
                    <input type="hidden" name="action" id="action" value="Edit" />
                    <input type="hidden" name="hidden_id" id="hidden_id" value="{{ $row->pur_id}}" />

                    <div class="col-md-6">
                        <!-- /.card-header -->
                        <div class="card-body">

                            <div class="row">
                                <div class="col-sm-6">
                                    <!-- text input -->
                                    <div class="form-group">
                                        <label>Office Supply</label>
                                        <select class="selectpicker form-control" name="supply" id="supply"
                                            data-live-search="true" disabled>

                                            @foreach($pos_supply as $row1)
                                            <option value="{{ $row1->id }}"
                                                {{ $row1->id == $row->sup_id ? 'selected="selected"' : '' }}>
                                                {{ $row1->name }}</option>
                                            @endforeach

                                        </select>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="form-group">
                                        <label>Invoice</label>
                                        <input type="text" name="invoice" id="invoice" class="form-control"
                                            value="{{ $row->pur_invoice}}" disabled>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <!-- text input -->
                                    <div class="form-group">
                                        <label>Remark</label>
                                        <input type="text" name="remark" id="remark" class="form-control"
                                            value="{{ $row->remark}}" disabled>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    @endforeach

                    <div class="card">
                        <div class="card-body p-0">
                            <table class="table table-striped projects" name='table_input' id='table_input'>
                                <thead>
                                    <tr>
                                        <th style="width: 1%">
                                            Code
                                        </th>
                                        <th style="width: 20%">
                                            Product Name
                                        </th>
                                        <th style="width: 20%">
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
                                    </tr>
                                </thead>
                                <tbody>

                                    @foreach($detail as $record)

                                    <tr class='tr_input' data-id='1'>
                                        <td>
                                            {{ $record->pur_id}}
                                        </td>
                                        <td class="p_name">
                                            {{ $record->pro_name}}
                                        </td>
                                        <td class="p_stock">
                                            {{ $record->line_name}}
                                        </td>
                                        <td class="p_cost">
                                            {{ $record->pro_cost}}
                                        </td>
                                        <td class="p_qty">
                                            {{ $record->pro_qty}}
                                        </td>
                                        <td class="p_discount">
                                            {{ $record->pro_discount}}
                                        </td>
                                        <td class="p_amount">
                                            {{ $record->pur_amount}}
                                        </td>
                                        <td class="p_remark">
                                            {{ $record->pur_remark}}
                                        </td>
                                    </tr>

                                    @endforeach
                                </tbody>
                            </table>
                        </div>
                        <!-- /.card-body -->
                    </div>
                    <!-- /.card -->


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

    $('#authorize_record').click(function() {
        event.preventDefault();
        var gb_id = $('#hidden_id').val();
        Swal.fire({
            title: 'Do you want to authorize record now?',
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
                    url: "/purchase-order/purchase_order_authorize/" + gb_id,
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
                Swal.fire('Authorized record ! ' + gb_id, '', 'success')
                window.location.href = "/purchase_order_list/all";
            }
        })

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
                    url: "/purchase-order/purchase_order_delete/" + gb_id,
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
                window.location.href = "/purchase_order_list/all";

            }
        })

    });





});
</script>

@endsection