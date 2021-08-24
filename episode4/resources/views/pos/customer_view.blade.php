@extends('layouts.app')
@section('content')

    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf

                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <button type="submit" class="authorize btn btn-outline-info" name="create_record"
                                id="create_record"><i class="fas fa-edit">Edit</i></button>
                            <button type="submit" class="btn btn-outline-danger" name="delete_record" id="delete_record"><i
                                    class="fas fa-trash-alt"> Delete</i></button>
                            <a href="{{ url('/customer_list/all') }}" class="text-center">
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
                                    <input type="hidden" name="hidden_id" id="hidden_id" value="{{ $row->cus_id }}" />

                                    <form role="form">

                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Pro_ID</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" name="pro_id" id="pro_id" class="form-control"
                                                            value="{{ $row->cus_id }}" Readonly>
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
                                                            value="{{ $row->cus_name }}">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-sm-12">
                                                <div class="form-group row">
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Gender</label>
                                                    <div class="col-sm-5">
                                                        <select class="selectpicker form-control" name="gender" id="gender"
                                                            data-live-search="true">
                                                            @foreach ($gender as $row1)
                                                                <option value="{{ $row1->id }}" {{ $row1->id == $row->cus_gender ? 'selected="selected"' : '' }}>
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
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Phone</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" name="phone" id="phone" class="form-control"
                                                            value="{{ $row->cus_phone }}">
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
                                                            @foreach ($inactive as $row2)
                                                                <option value="{{ $row2->id }}"
                                                                    {{ $row2->id == $row->inactive ? 'selected="selected"' : '' }}>
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
                                                    <label for="inputEmail3" class="col-sm-2 col-form-label">Address</label>
                                                    <div class="col-sm-10">
                                                        <input type="text" name="address" id="address" class="form-control"
                                                            value="{{ $row->cus_address }}">
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

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Edit') {
                    $.ajax({
                        url: "{{ route('pos-customer.add_customer') }}",
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
                            url: "/customer_delete/" + gb_id,
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
                        window.location.href = "/customer_list/all";

                    }
                })

            });
        });
    </script>

@endsection
