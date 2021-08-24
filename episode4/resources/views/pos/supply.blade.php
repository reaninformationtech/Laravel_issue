@extends('layouts.app')
@section('content')
<style>
    .note
    {
        text-align: center;
        height: 80px;
        background: -webkit-linear-gradient(left, #0072ff, #8811c5);
        color: #fff;
        font-weight: bold;
        line-height: 80px;
    }
    .form-content
    {
        padding: 5%;
        border: 1px solid #ced4da;
        margin-bottom: 2%;
    }
    .form-control{
        border-radius:1.5rem;
    }
    .btnSubmit
    {
        border:none;
        border-radius:1.5rem;
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
                        <button type="submit" class="btn btn-outline-primary" name="create_record" id="create_record" ><i class="fas fa-edit" id='title' > Commit</i></button>
                        <a href="{{url('supply_list/all')}}" class="text-center">
                            <button type="button" class="btn btn-outline-info" name="list_record" id="list_record" >List Info</button>
                        </a>
                        
                        <input type="hidden" name="action" id="action" />
                    </h3>

                </div>
                <!-- /.card-header -->
                <div class="card-body pad">

                        <div id="table_data">
                            @include('pos/supplier_booking')
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
    $(document).ready(function () {

        cleartext();
        function  cleartext() {
            $('#action').val("Add");
            $('#hidden_id').val("Add");
            $('#hidden_id').val("Add");

            $('#line').val('');
            $('#line_name').val('');
            $('#inactive').val('');
            $('#remark').val('');
        }


        $('#form_data').on('submit', function (event) {
            event.preventDefault();

            if ($('#action').val() == 'Add')
            {
                $.ajax({
                    url: "{{route('pos-supplier.add_pos_supplier') }}",
                    method: "POST",
                    data: new FormData(this),
                    contentType: false,
                    cache: false,
                    processData: false,
                    dataType: "json",
                    async:false,
                    beforeSend:function(){
                        $("#create_record").attr("disabled",true)
                    },
                    success: function (data)
                    {
                        if (data.errors)
                        {
                            for (var count = 0; count < data.errors.length; count++)
                            {
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
                                $("#create_record").attr("disabled",false)
                                return;
                            }
                        }
                        if (data.success)
                        {
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

                            $("#create_record").attr("disabled",false)
                        }
                    }
                })
            }
        });
    });
</script>

@endsection



