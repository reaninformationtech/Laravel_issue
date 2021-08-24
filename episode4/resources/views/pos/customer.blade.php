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
                            <a href="{{ url('customer_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>
                            <input type="hidden" name="action" id="action" />
                        </h3>

                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="col-md-6">
                            <!-- /.card-header -->
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
                                                <div class="col-sm-10">
                                                    <input type="text" name="name" id="name" class="form-control"
                                                        placeholder="Name ..." autocomplete="off">
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
                                                        @foreach ($gender as $row)
                                                            <option data-tokens="{{ $row->id }}"
                                                                value="{{ $row->id }}">{{ $row->name }}</option>
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
                                                        placeholder="Phone..." autocomplete="off">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">Inactive</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="inactive" id="inactive"
                                                        data-live-search="true">
                                                        @foreach ($inactive as $row1)
                                                            <option data-tokens="{{ $row1->id }}"
                                                                value="{{ $row1->id }}">{{ $row1->name }}</option>
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
                                                        placeholder="Address..." autocomplete="off">
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

            cleartext();

            function cleartext() {
                $('#action').val("Add");
                $('#hidden_id').val('');
                $('#name').val('');
                $('#gender').val('');
                $('#inactive').val('');
                $('#address').val('');
            }

            $('#form_data').on('submit', function(event) {
                event.preventDefault();

                if ($('#action').val() == 'Add') {
                    $.ajax({
                        url: "{{ route('pos-customer.add_customer') }}",
                        method: "POST",
                        async: false,
                        data: new FormData(this),
                        contentType: false,
                        cache: false,
                        processData: false,
                        dataType: "json",
                        async: false,
                        beforeSend: function() {
                            $("#create_record").attr("disabled", true)
                        },
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
                                    $("#create_record").attr("disabled", false)
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
                                $("#create_record").attr("disabled", false)

                                cleartext();
                                window.location.href = "/customer_list/all";
                            }
                        }
                    })
                }
            });
        });
    </script>

@endsection
