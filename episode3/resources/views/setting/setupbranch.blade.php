@extends('layouts.app')
@section('content')

    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="card card-outline card-info">
                    <div class="card-header">
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

                            <h4 align="center">Setup Branch</h4><br />
                            <div class="alert alert-success" style="display: none;"></div>

                            <div id="table_data">
                                @include('setting/setupbranch_data')
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.col-->
        </div>
        <!-- ./row -->
    </section>



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
                                <label for="name">Branch name</label>
                                <input type="text" name="name" id="name" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">Full name</label>
                                <input type="text" name="full_name" id="full_name" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="name">Short Name</label>
                                <input type="text" name="shot_name" id="shot_name" class="form-control">
                            </div>
                            <div class="form-group">
                                <label>Inactive</label>
                                <select name="inactive" id="inactive" class="form-control" style="width: 100%;">
                                    @foreach ($inactive as $row)
                                        @if (old('inactive') == $row->id)
                                            <option data-tokens="{{ $row->id }}" value="{{ $row->id }}" selected>
                                                {{ $row->name }}</option>
                                        @else
                                            <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                                {{ $row->name }}</option>
                                        @endif
                                    @endforeach
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <input type="text" name="phone" id="phone" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" name="email" id="email" class="form-control">
                            </div>
                            <div class="form-group">
                                <label for="website">Websit</label>
                                <input type="text" name="website" id="website" class="form-control">
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <input type="hidden" name="action" id="action" />
                            <input type="hidden" name="hidden_id" id="hidden_id" />
                            <input type="submit" name="action_button" id="action_button" class="btn btn-success" id="submit"
                                value="Ok">
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

@endsection

@section('scripts')
    <script>
        $(document).ready(function() {
            function cleartext() {
                $('#name').val('');
                $('#full_name').val('');
                $('#shot_name').val('');
                $('#inactive').val('');
                $('#phone').val('');
                $('#email').val('');
                $('#website').val('');
            }

            $(document).on('click', '.delete', function(event) {
                user_id = $(this).attr('id');
                $('#confirmModal').modal('show');
            });

            $('#create_record').click(function() {
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
                        url: "{{ route('setup-branch.setupbranch_edit') }}",
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
                        url: "{{ route('setup-branch.setupbranch_edit') }}",
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
                    url: "/setup-branch/" + id + "/branch_edit",
                    dataType: "json",
                    success: function(html) {
                        $('#name').attr('readonly', 'true');
                        $('#name').val(html.data.setname);
                        $('#full_name').val(html.data.branchname);
                        $('#shot_name').val(html.data.branchshort);
                        $('#inactive').val(html.data.inactive);
                        $('#phone').val(html.data.phone);
                        $('#email').val(html.data.email);
                        $('#website').val(html.data.website);

                        $('#hidden_id').val(html.data.branchcode);
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
                    url: "/setupbranch/branch_fetch_data?page=" + page,
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            }
        });
    </script>

@endsection
