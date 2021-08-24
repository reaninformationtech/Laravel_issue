@extends('layouts.app')
@section('content')

    <style>
        .btn {
            background-color: DodgerBlue;
            border: none;
            color: white;
            padding: 10px 10px;
            font-size: 12px;
            cursor: pointer;
        }

        /* Darker background on mouse-over */
        .btn:hover {
            background-color: RoyalBlue;
        }

    </style>

    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <form method="post" id="dynamic_form" class="form-inline">
                            <div class="form-group mb-2">
                                <label>System :</label>
                            </div>
                            <div class="form-group mx-sm-3 mb-2">
                                <select class="form-control" name="system" id="system" data-live-search="true">
                                    @foreach ($profile as $row)
                                        <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                            {{ $row->name }}</option>
                                    @endforeach
                                </select>
                            </div>

                            <div class="form-group mb-2">
                                @csrf
                                <button type="submit" class="btn btn-labeled btn-success" name="create_record"
                                    id="create_record">
                                    <span class="btn-label"><i class="fas fa-edit"> Commit</i></span> </button>
                            </div>
                        </form>

                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="mb-3">
                            <div class="alert alert-success" style="display: none;"></div>

                            <div id="table_data">
                                @include('setting/setuser_permission_data')
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.col-->
        </div>
        <!-- ./row -->
    </section>

@endsection

@section('scripts')

    <script>
        $(document).ready(function() {

            $("#system").change(function() {
                var id = $("#system").val();
                $.ajax({
                    url: "/setuser-permission/permission_by_branch/" + id,
                    dataType: "json",
                    success: function(data) {

                        $('#MenuList tr td input[type="checkbox"]').each(function() {
                            $(this).prop('checked', false);
                        });

                        for (var i = 0; i < data.length; i++) {
                            var row = data[i];

                            if (row["views"] == '1') {
                                $("#v" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#v" + row["menu_id"]).prop("checked", false);
                            }

                            if (row["booking"] == '1') {
                                $("#b" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#b" + row["menu_id"]).prop("checked", false);
                            }
                            if (row["edit"] == '1') {
                                $("#e" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#e" + row["menu_id"]).prop("checked", false);
                            }
                            if (row["deletes"] == '1') {
                                $("#d" + row["menu_id"]).prop("checked", true);
                            } else {
                                $("#d" + row["menu_id"]).prop("checked", false);
                            }
                        }

                    }
                })
            });


            $('#dynamic_form').on('submit', function(event) {
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
                    url: '{{ route('setuser-permission.add_setuser_permission') }}',
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


            $(document).on('click', '.pagination a', function(event) {
                event.preventDefault();
                var page = $(this).attr('href').split('page=')[1];
                fetch_data(page);
            });

            function fetch_data(page = '1') {
                $.ajax({
                    url: "/Admin/permission_fetch_data?page=" + page,
                    success: function(data) {
                        $('#table_data').html(data);
                    }
                });
            }
        });
    </script>

@endsection
