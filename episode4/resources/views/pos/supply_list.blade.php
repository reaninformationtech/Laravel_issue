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
                        <a href="{{url('register_supply')}}" class="text-center">
                            <button type="button" class="btn btn-outline-primary" name="create_record"
                                id="create_record"><i class="fas fa-plus"> New</i></button>
                        </a>
                    </h3>

                </div>
                <!-- /.card-header -->
                <div class="card-body pad">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered">
                            <tr class="table-primary">
                                <th width="5%">ID</th>
                                <th width="38%">Supply Name</th>
                                <th width="57%">Phone</th>
                                <th width="57%">Email</th>
                                <th width="57%">Websit</th>
                                <th width="57%">Type</th>
                                <th width="38%">Status</th>
                                <th width="57%">Action</th>
                            </tr>


                            @foreach($data as $row)

                            <tr class="table-secondary">
                                <td>{{ $row->sup_id }}</td>
                                <td>{{ $row->sup_name }}</td>
                                <td>{{ $row->sup_phone }}</td>
                                <td>{{ $row->sup_email }}</td>
                                <td>{{ $row->sup_website }}</td>
                                <td>{{ $row->line_name }}</td>
                                <td>{{ $row->status }}</td>
                                <td>

                                    <div class="row mb-12">
                                        <div class="col-sm-6">
                                            <div class="row mb-2">
                                                <a href="{{url('supply_view/'.$row->sup_id)}}" class="text-center">
                                                    <button type="button" name='edit' id='{{ $row->sup_id }}'
                                                        class="edit btn btn-xs btn-success btn-sm my-0"><i
                                                            class="fas fa-edit"></i></button>
                                                </a>
                                            </div>

                                        </div>

                                        <div class="col-sm-6">

                                            <div class="row mb-2">

                                                <button type="button" name='delete' id='{{ $row->sup_id }}'
                                                    class="delete btn btn-xs btn-danger"><i
                                                        class="far fa-trash-alt"></i></button>
                                            </div>
                                        </div>

                                    </div>
                                </td>
                            </tr>


                            @endforeach
                        </table>

                        {{ $data->links('vendor.pagination.custom') }}
                    </div>


                </div>
            </div>
        </form>
    </div>
    <!-- /.col-->


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

</div>
<!-- ./row -->
@endsection
@section('scripts')
<script>
$(document).ready(function() {
    var gb_id = '';
    $(document).on('click', '.delete', function(event) {
        gb_id = $(this).attr('id');
        $('#confirmModal').modal('show');
    });

    $('#ok_button').click(function() {
        var token = $("meta[name='csrf-token']").attr("content");
        $.ajax({
            url: "/pos-supply/delete_pos_supply/" + gb_id,
            type: 'get',
            data: {
                "id": gb_id,
                "_token": token,
            },
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
                        text: data.errors
                    })
                    return;
                }
                if (data.success) {
                    $('#confirmModal').modal('hide');
                    $('#ok_button').text('Ok');
                    // Message sweet alert
                    Swal.fire({
                        position: 'top-end',
                        icon: 'success',
                        title: data.success,
                        showConfirmButton: false,
                        timer: 1500
                    })

                    window.location.href = "/supply_list/all";
                }
            }
        })
    });
});
</script>

@endsection