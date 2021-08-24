@extends('layouts.app')
@section('content')

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
                            <a href="{{ url('/pos_expense_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>
                        </h3>
                    </div>
                    <div class="card-body pad">
                        <input type="hidden" name="hidden_id" id="hidden_id" value="{{ $data[0]->tran_code }}" />
                        <div class="row">
                            <div class="col-md-6">
                                <!-- /.card-header -->
                                <div class="card-body">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Code</label>
                                                <input type="text" name="referent" id="referent" class="form-control"
                                                    value="{{ $data[0]->tran_code }}" disabled>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Referent</label>
                                                <input type="text" name="referent" id="referent" class="form-control"
                                                    value="{{ $data[0]->referent }}" disabled>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Currency</label>
                                                <input type="text" name="referent" id="referent" class="form-control"
                                                    value="{{ $data[0]->currency }}" disabled>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">

                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Amount</label>
                                                <input type="text" name="referent" id="referent" class="form-control"
                                                    value="{{ $data[0]->amount }}" disabled>
                                            </div>
                                        </div>

                                    </div>

                                    <div class="row">

                                        <div class="col-sm-6">
                                            <!-- text input -->
                                            <div class="form-group">
                                                <label>Remark</label>
                                                <input type="text" name="referent" id="referent" class="form-control"
                                                    value="{{ $data[0]->remark }}" disabled>
                                            </div>
                                        </div>

                                    </div>

                                </div>
                            </div>
                        </div>

                        <div class="row">
                            @if (isset($file[0]->sysdonum))
                                <div class="timeline-item">
                                    <div class="timeline-body">
                                        @foreach ($file as $row)
                                            <img src="{{ route('pos.pos_exp_file',$row->file_name) }}" class="img-thumbnail" alt="None"
                                                width="200" height="250">

                                        @endforeach
                                    </div>
                                </div>
                            @else
                                <div class="timeline-item">
                                    <div class="timeline-body">
                                    </div>
    
                            @endif
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
                            url: "/pos_authorize_expense",
                            type: 'POST',
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
                        window.location.href = "/pos_expense_list/all";
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
                            url: "/pos_delete_expense",
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
                        window.location.href = "/pos_expense_list/all";
                    }
                })
            });
        });

    </script>
@endsection
