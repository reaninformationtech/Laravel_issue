@extends('layouts.app')
@section('content')
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title" name="create_record" id="create_record">
                            <button type="button" id="create" class="edit btn btn-xs btn-danger"><i class="fas fa-edit">
                                    Create</i></button>
                        </h3>
                        <!-- tools box -->
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool btn-danger btn-sm " data-card-widget="collapse"
                                data-toggle="tooltip" title="Collapse">
                                <i class="fas fa-minus"></i></button>
                            <button type="button" class="btn btn-tool btn-danger btn-sm" data-card-widget="remove"
                                data-toggle="tooltip" title="Remove">
                                <i class="fas fa-times"></i></button>
                        </div>
                        <!-- /. tools -->
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="mb-3">

                            <h4 align="center">Register profile</h4><br />
                            <div class="alert alert-success" style="display: none;"></div>

                            <div id="table_data">
                                @include('setting/setupprofile_data')
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.col-->
        </div>
        <!-- ./row -->
    </section>

    <div class="container">

        <div id="formModal" class="modal fade" id="modal-secondary">

            <div class="modal-dialog">
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h4 class="modal-title"></h4>

                    </div>

                    <div class="modal-content">
                        <form id="form_data" name="contact" role="form">
                            @csrf
                            <div class="modal-body">

                                <div class="form-group">
                                    <label>Branch</label>
                                    <select name="branch" id="branch" class="selectpicker form-control" style="width: 100%;"
                                        data-live-search="true">
                                        @foreach ($branch as $row)
                                            @if (old('branch') == $row->id)
                                                <option data-tokens="{{ $row->id }}" value="{{ $row->id }}"
                                                    selected>
                                                    {{ $row->name }}</option>
                                            @else
                                                <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                                    {{ $row->name }}</option>
                                            @endif

                                        @endforeach
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="name">Profile name</label>
                                    <input type="text" name="name" id="name" class="form-control">
                                </div>

                                <div class="form-group">
                                    <label>Inactive</label>
                                    <select name="inactive" id="inactive" class="form-control" style="width: 100%;">
                                        @foreach ($inactive as $row)
                                            @if (old('inactive') == $row->id)
                                                <option data-tokens="{{ $row->id }}" value="{{ $row->id }}"
                                                    selected>
                                                    {{ $row->name }}</option>
                                            @else
                                                <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                                    {{ $row->name }}</option>
                                            @endif
                                        @endforeach
                                    </select>
                                </div>

                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                <input type="hidden" name="action" id="action" />
                                <input type="hidden" name="hidden_id" id="hidden_id" />
                                <input type="submit" name="action_button" id="action_button" class="btn btn-success"
                                    id="submit" value="Ok">
                            </div>
                        </form>
                    </div>
                </div>
            </div>

        </div>

        <div class="modal fade" id="confirmModal">
            <div class="modal-dialog">
                <div class="modal-content bg-secondary">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span></button>
                    </div>
                    <div class="modal-body">
                        <h4 align="center" style="margin:0;">Are you sure you want to remove this data?</h4>
                    </div>
                    <div class="modal-footer justify-content-between">
                        <button type="button" class="btn btn-outline-light" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-outline-light" id="ok_button">Ok</button>
                    </div>
                </div>
                <!-- /.modal-content -->
            </div>
            <!-- /.modal-dialog -->
        </div>
        <!-- /.modal -->
    </div>

@endsection

@section('scripts')
    <script>
        $(document).ready(function() {


            function cleartext() {
                $('#name').val('');
                $('#inactive').val('');
            }

            $(document).on('click', '.delete', function(event) {
                user_id = $(this).attr('id');
                $('#confirmModal').modal('show');
            });

            $('#ok_button').click(function() {
                $.ajax({
                    url: "setup-profile/delete_profile/" + user_id,
                    beforeSend: function() {
                        $('#ok_button').text('Deleting...');
                    },
                    success: function(data) {
                        if (data.errors) {
                            $('#confirmModal').modal('hide');
                            $('#ok_button').text('Ok');
                            // Message sweet alert
                            Swal.fire({
                                icon: 'error',
                                title: 'Oops...',
                                text: data.errors[0]
                            })
                            return;
                        }
                        if (data.success) {
                            $('#confirmModal').modal('hide');
                            $('#ok_button').text('Ok');
                            fetch_data();

                            // Message sweet alert
                            Swal.fire({
                                position: 'top-end',
                                icon: 'success',
                                title: data.success,
                                showConfirmButton: false,
                                timer: 1500
                            })
                        }
                    }
                })
            });


            $('#create_record').click(function() {
                cleartext();
                $('.modal-title').text("Add New Record");
                $('#action_button').val("Add");
                $('#action').val("Add");
                $('#hidden_id').val("Add");
                $('#formModal').modal('show');
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Add') {
                    $.ajax({
                        url: "{{ route('setup-profile.add_setup_profile') }}",
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
                                fetch_data();
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
                            }
                        }
                    })
                }

                if ($('#action').val() == "Edit") {
                    $.ajax({
                        url: "{{ route('setup-profile.add_setup_profile') }}",
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
                                fetch_data();
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
                            }
                        }
                    });
                }
            });


            $(document).on('click', '.edit', function() {
                var id = $(this).attr('id');
                if (id == 'create') {
                    return;
                }
                $('#form_result').html('');
                $('#formModal').modal('show');
                $.ajax({
                    url: "/setup-profile/" + id + "/profile_edit",
                    dataType: "json",
                    success: function(html) {
                        $('#branch').val(html.data.branchcode);
                        $('#name').val(html.data.profilename);
                        $('#inactive').val(html.data.inactive);
                        $('#hidden_id').val(html.data.profileid);

                        $('.modal-title').text("Edit New Record");
                        $('#action_button').val("Edit");
                        $('#action').val("Edit");
                        $('#formModal').modal('show');
                    }
                })
            });

            $(document).on('click', '.pagination a', function(event) {
                event.preventDefault();
                var page = $(this).attr('href').split('page=')[1];
                fetch_data(page);
            });

            function fetch_data(page = '1') {
                $.ajax({
                    url: "/Admin/profile_fetch_data?page=" + page,
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            }
        });
    </script>

@endsection
