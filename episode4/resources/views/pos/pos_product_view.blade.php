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
                                    class="fas fa-edit" id='title'> Edit</i></button>

                            <button type="submit" class="btn btn-outline-danger" name="delete_record" id="delete_record"><i
                                    class="fas fa-trash-alt"> Delete</i></button>

                            <a href="{{ url('pos_product_list/all') }}" class="text-center">
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

                                @foreach ($data as $row)
                                    <input type="hidden" name="action" id="action" value="Edit" />
                                    <input type="hidden" name="hidden_id" id="hidden_id" value="{{ $row->pro_id }}" />

                                    <form role="form">
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Pro_ID</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" name="pro_id" id="pro_id" class="form-control"
                                                            value="{{ $row->pro_id }}" Readonly>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" name="name" id="name" class="form-control"
                                                            value="{{ $row->pro_name }}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Barcode</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" name="barcode" id="barcode" class="form-control"
                                                            value="{{ $row->barcode }}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3"
                                                        class="col-sm-2 col-form-label">Inacitve</label>
                                                    <div class="col-sm-5">
                                                        <select class="selectpicker form-control" name="inactive"
                                                            id="inactive" data-live-search="true">
                                                            @foreach ($inactive as $row1)
                                                                <option value="{{ $row1->id }}"
                                                                    {{ $row1->id == $row->pro_inactive ? 'selected="selected"' : '' }}>
                                                                    {{ $row1->name }}</option>
                                                            @endforeach
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Product
                                                        type</label>
                                                    <div class="col-sm-5">
                                                        <select class="selectpicker form-control" name="pro_type"
                                                            id="pro_type" data-live-search="true">
                                                            @foreach ($pro_type as $row2)
                                                                <option value="{{ $row2->id }}"
                                                                    {{ $row2->id == $row->code_type ? 'selected="selected"' : '' }}>
                                                                    {{ $row2->name }}</option>
                                                            @endforeach
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Product
                                                        line</label>
                                                    <div class="col-sm-5">
                                                        <select class="selectpicker form-control" name="pro_line"
                                                            id="pro_line" data-live-search="true">
                                                            @foreach ($pro_line as $row3)
                                                                <option value="{{ $row3->id }}"
                                                                    {{ $row3->id == $row->code_line ? 'selected="selected"' : '' }}>
                                                                    {{ $row3->name }}</option>

                                                            @endforeach
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>


                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Cost</label>
                                                    <div class="col-sm-5">
                                                        <input type="text" name="cost" id="cost" class="form-control"
                                                            value="{{ $row->pro_cost }}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Unit
                                                        Price</label>
                                                    <div class="col-sm-5">
                                                        <input type="text" name="unitprice" id="unitprice"
                                                            class="form-control" value="{{ $row->pro_up }}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3"
                                                        class="col-sm-2 col-form-label">Discount</label>
                                                    <div class="col-sm-5">
                                                        <select class="selectpicker form-control" name="discount"
                                                            id="discount" data-live-search="true">
                                                            @foreach ($percentage as $row4)
                                                                <option value="{{ $row4->id }}"
                                                                    {{ $row4->id == $row->pro_discount ? 'selected="selected"' : '' }}>
                                                                    {{ $row4->name }}</option>
                                                            @endforeach
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Remark</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" name="remark" id="remark" class="form-control"
                                                            value="{{ $row->remark }}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                @endforeach
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


            $('#cost').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });
            $('#unitprice').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });
            $('#discount').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });

            $("#barcode").keypress(function(e) {
                if (e.keyCode == 0 || e.keyCode == 32) {
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'System does not allow space'
                    })
                    e.preventDefault()
                    return;
                } else {
                    console.log('not key');
                }
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();

                if ($('#action').val() == 'Edit') {
                    $.ajax({
                        url: "{{ route('pos-product.add_pos_product') }}",
                        method: "POST",
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        success: function(data) {
                            if (data.errors) {
                                for (var count = 0; count < data.errors.length; count++) {
                                    // Message sweet alert
                                    const Toast = Swal.mixin({
                                        toast: true,
                                        position: 'top-end',
                                        showConfirmButton: false,
                                        timer: 3000
                                    });
                                    Toast.fire({
                                        icon: 'error',
                                        title: data.errors[count]
                                    })
                                    return;
                                }
                            }

                            if (data.barcode) {
                                // Message sweet alert
                                const Toast = Swal.mixin({
                                    toast: true,
                                    position: 'top-end',
                                    showConfirmButton: false,
                                    timer: 3000
                                });
                                Toast.fire({
                                    icon: 'error',
                                    title: data.barcode
                                })
                                return;
                            }

                            if (data.success) {
                                $('#formModal').modal('hide');
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
                                cleartext();
                            }
                        }
                    })
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
                            url: "/pos-product/delete_pos_product/" + gb_id,
                            type: 'get',
                            async: false,
                            data: {
                                "id": gb_id,
                                "_token": _token,
                            },
                            success: function(data) {
                                if (data.errors) {
                                    Swal.fire({
                                        icon: 'error',
                                        text: data.errors,
                                    })
                                    return;
                                } else {
                                    Swal.fire('Removed !' + gb_id, '', 'success')
                                    window.location.href = "/pos_product_list/all";
                                }
                            }
                        })

                    }
                })

            });

        });
    </script>

@endsection
