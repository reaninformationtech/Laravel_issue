@extends('layouts.app')
@section('content')

<div class="row">
    <div class="col-md-12">
        <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
            @csrf
            <div class="card card-outline card-info">
                <div class="card-header">
                    <h3 class="card-title">
                        <button type="submit" class="btn btn-outline-primary" name="authorize_record" id="authorize_record"><i
                                class="fas fa-edit" id='title'> Authorize</i></button>

                        <button type="submit" class="btn btn-outline-danger" name="delete_record" id="delete_record"><i
                                class="fas fa-trash-alt"> Delete</i></button>

                        <a href="{{url('pos_invoice_list/all')}}" class="text-center">
                            <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                Info</button>
                        </a>
                    </h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body pad">
                    <div class="row">
                        <div class="col-md-6">
                            <!-- /.card-header -->
                            <div class="card-body">
                                <input type="hidden" name="action" id="action" value="Edit" />
                                <input type="hidden" name="hidden_id" id="hidden_id" value="{{$customerinfo[0]->inv_num}}" />

                                <div class="row">
                                    <div class="col-sm-6">
                                        <!-- text input -->
                                        <div class="form-group">
                                            <label>Name</label>
                                            <input type="text" name="cus_name" id="cus_name"
                                                class="cus_name form-control" value="{{$customerinfo[0]->cus_name}}" disabled>
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="form-group">
                                            <label>Phone</label>
                                            <input type="text" name="phone" id="phone" class="form-control" value="{{$customerinfo[0]->cus_phone}}" disabled>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-6">
                                        <!-- text input -->
                                        <div class="form-group">
                                            <label>Address</label>
                                            <input type="text" name="address" id="address" class="form-control" value="{{$customerinfo[0]->cus_address}}" disabled>
                                        </div>
                                    </div>

                                    <div class="col-sm-6">
                                        <!-- text input -->
                                        <div class="form-group">
                                            <label>Delivery fee </label>
                                            <input type="text" name="delivery" id="delivery" class="number form-control" value="{{$invoice[0]->delivery}}"  disabled>
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
                                            <th width="30%">Items</th>
                                            <th width="15%">Stock</th>
                                            <th width="10%">Qty</th>
                                            <th width="10%">Unit-price</th>
                                            <th width="10%">Discount</th>
                                            <th width="10%">Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        @foreach($invoice as $row)
                                        <tr>
                                            <td>{{ $row->pro_name }}</td>
                                            <td>{{ $row->stockname }}</td>
                                            <td>{{ $row->pro_qty }}</td>
                                            <td>{{ $row->pro_up }}</td>
                                            <td>{{ $row->pro_discount }}</td>
                                            <td>{{ $row->pro_amount }}</td>
                                        </tr>
                                        @endforeach

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
                    url: "/pos_authorize_invoice/" + gb_id,
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
                window.location.href = "/pos_invoice_list/all";
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
                    url: "/pos_invoice_delete/" + gb_id,
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
                window.location.href = "/pos_invoice_list/all";
            }
        })
    });
});
</script>

@endsection