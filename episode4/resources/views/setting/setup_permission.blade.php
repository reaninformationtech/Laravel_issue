@extends('layouts.app')
@section('content')
    <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
        @csrf
        <div class="row">
            <div class="col-md-12">

                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <div class="row">
                                <div class="form-group mx-sm-3 mb-2">
                                    <label>System :</label>
                                </div>
                                <div class="form-group mx-sm-3 mb-2">
                                    <select class="form-control" name="system" id="system" data-live-search="true">
                                        @foreach ($system as $row)
                                            <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                                {{ $row->name }}</option>
                                        @endforeach
                                    </select>
                                </div>
                                <div class="form-group mx-sm-3 mb-2">
                                    <select class="form-control" name="profile" id="profile" data-live-search="true"> </select>
                                </div>

                                <div class="form-group mb-2">
                                    <button type="submit" class="btn btn-labeled btn-success" name="create_record"
                                        id="create_record">
                                        <span class="btn-label"><i class="fas fa-edit"> Commit</i></span> </button>
                                </div>
                            </div>
                        </h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="table-responsive">
                            <div id="table_data">
                                @include('setting/setup_permission_data')
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

@endsection

@section('scripts')

    <script>
        $(document).ready(function() {

            $("#profile").attr("disabled", true);
            $("#create_record").attr("disabled", true);

            $("#system").change(function() {
                var id = $("#system").val();
                fetch_data(id);
                combo_profile(id);
            });

            $("#profile").change(function() {
                var system = $("#system").val();
                var profile = $("#profile").val();

                $.ajax({
                    url: "/setup_permission_check/" + system + '/' + profile,
                    dataType: "json",
                    success: function(data) {
                        $('#MenuList tr td input[type="checkbox"]').each(function() {
                            $(this).prop('checked', false);
                        });

                        for (var i = 0; i < data.length; i++) {
                            var row = data[i];
                            if (row["views"] == 'YES') {
                                $("#v" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#v" + row["menu_id"]).prop("checked", false);
                            }

                            if (row["booking"] == 'YES') {
                                $("#b" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#b" + row["menu_id"]).prop("checked", false);
                            }
                            if (row["edit"] == 'YES') {
                                $("#e" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#e" + row["menu_id"]).prop("checked", false);
                            }
                            if (row["deletes"] == 'YES') {
                                $("#d" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#d" + row["menu_id"]).prop("checked", false);
                            }
                        }
                    }
                })
            });

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var rows = [];
                var system = $('#system').val();

                if (system == '') {
                    // Message sweet alert
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Please choose System'
                    })
                    return;
                }

                //Get all the data row and put in array
                $('#MenuList tbody tr').each(function() {
                    var Id = $(this).find('td').eq(0).text().trim();
                    if (Id != '') {
                        var p_view = $(this).find('.p_view').is(':checked') ? 1 : 0;
                        var p_booking = $(this).find('.p_booking').is(':checked') ? 1 : 0;
                        var p_edit = $(this).find('.p_edit').is(':checked') ? 1 : 0;
                        var p_delete = $(this).find('.p_delete').is(':checked') ? 1 : 0;

                        var row = system + "_" + Id + "_" + p_view + "_" + p_booking + "_" +
                            p_edit + "_" + p_delete;
                        rows.push(row); //Push into array rows[]
                    }
                });
                var formData = $(this).serializeArray();
                $.ajax({
                    url: '{{ route('setup-permission.add_setup_permission') }}',
                    method: "POST",
                    data: formData,
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
                        }
                    }
                });
            });

            function fetch_data(systemid) {
                $.ajax({
                    url: "/setup_permission_fetch/" + systemid,
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            }

            function combo_profile(vsystemid) {
                $("#profile").attr("disabled", true);
                $("#create_record").attr("disabled", true);
                $.ajax({
                    url: "/combo_permission/" + vsystemid,
                    method: "get",
                    contentType: false,
                    cache: false,
                    processData: false,
                    success: function(data) {
                        $("#profile").attr("disabled", false);
                        $("#create_record").attr("disabled", false);
                        $('#profile').html(data);
                        return;
                    }
                });
            }

        });
    </script>

@endsection
