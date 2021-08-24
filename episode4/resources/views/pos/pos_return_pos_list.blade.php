@extends('layouts.app')
@section('content')
<div class="row">
    <div class="col-md-12">
        <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
            @csrf

            <div class="card card-outline card-info">
                <div class="card-header">
                    <h3 class="card-title">
                        <a href="{{url('/registerproduct')}}" class="text-center">
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
                                <th width="15%">Invoice</th>
                                <th width="20%">Customer</th>
                                <th width="20%">Phone</th>
                                <th width="20%">Inputter</th>
                                <th width="20%">Date</th>
                                <th width="10%">Action</th>
                            </tr>


                            @foreach($data as $row)

                            <tr class="table-secondary">
                                <td>{{ $row->inv_num }}</td>
                                <td>{{ $row->cus_name }}</td>
                                <td>{{ $row->cus_phone }}</td>
                                <td>{{ $row->inputter }}</td>
                                <td>{{ $row->trandate }}</td>
                                <td>

                                    <div class="row mb-12">
                                        <div class="col-sm-2">
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="row mb-2">
                                                <a href="{{url('pos_return_pos_view/'.$row->inv_num)}}" class="text-center">
                                                    <button type="button" class="edit btn btn-xs btn-success btn-sm my-0"><i  class="fas fa-eye"></i></button>
                                                </a>
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
            url: "/pos-product/delete_pos_product/" + gb_id,
            type: 'DELETE',
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
                        text: data.errors[0]
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

                    window.location.href = "/pos_product_list/all";
                }
            }
        })
    });
});
</script>

@endsection
