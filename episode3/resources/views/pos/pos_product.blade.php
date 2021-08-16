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
    .custom-select{
        border-radius:1.5rem;
    }
    .selectpicker{
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
                        <button type="submit" class="btn btn-outline-primary" name="create_record" id="create_record" ><i class="fas fa-edit" id='title' > Create</i></button>
                        <a href="{{url('pos_product_list/all')}}" class="text-center">
                            <button type="button" class="btn btn-outline-info" name="list_record" id="list_record" >List Info</button>
                        </a>

                        <input type="hidden" name="action" id="action" />
                    </h3>

                </div>
                <!-- /.card-header -->
                <div class="card-body pad">

                    <div class="col-md-6">
                        <!-- /.card-header -->
                        <div class="card-body">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">Name</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="name" id="name" class="form-control"placeholder="Name ...">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">Barcode</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="barcode" id="barcode" class="form-control"  placeholder="Barcode...">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">Inacitve</label>
                                            <div class="col-sm-5">
                                                <select class="selectpicker form-control" name="inactive" id="inactive" data-live-search="true">
                                                    @foreach($inactive as $row1)
                                                    <option data-tokens="{{ $row1->id }}" value="{{ $row1->id }}">{{ $row1->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">P-Type</label>
                                            <div class="col-sm-5">
                                                <select class="selectpicker form-control" name="pro_type" id="pro_type" data-live-search="true">
                                                    @foreach($pro_type as $row2)
                                                    <option data-tokens="{{ $row2->id }}" value="{{ $row2->id }}">{{ $row2->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">P-Line</label>
                                            <div class="col-sm-5">
                                                <select class="selectpicker form-control" name="pro_line" id="pro_line" data-live-search="true">
                                                    @foreach($pro_line as $row3)
                                                    <option data-tokens="{{ $row3->id }}" value="{{ $row3->id }}">{{ $row3->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">Cost</label>
                                            <div class="col-sm-5">
                                                <input type="text" name="cost" id="cost" class="form-control" placeholder="Cost...">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">Unit Price</label>
                                            <div class="col-sm-5">
                                                <input type="text" name="unitprice" id="unitprice" class="form-control" placeholder="Unit Price...">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">Discount</label>
                                            <div class="col-sm-5">
                                                <select class="selectpicker form-control" name="discount" id="discount" data-live-search="true">
                                                    @foreach($percentage as $row4)
                                                    <option data-tokens="{{ $row4->id }}" value="{{ $row4->id }}">{{ $row4->name }}</option>
                                                    @endforeach
                                                </select>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="inputEmail3" class="col-sm-2 col-form-label">Remark</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="remark" id="remark" class="form-control" placeholder="Remark...">
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
    $(document).ready(function () {

        cleartext();
        function  cleartext() {
            $('#action').val("Add");
            $('#hidden_id').val('');
            $('#name').val('');
            $('#barcode').val('');
            $('#inactive').val('');
            $('#pro_type').val('');
            $('#pro_line').val('');
            $('#cost').val('');
            $('#unitprice').val('');
            $('#discount').val('');
            $('#remark').val('');
        }

        $('#cost').keyup(function () {
            if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            }
        });
        $('#unitprice').keyup(function () {
            if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            }
        });
        $('#discount').keyup(function () {
            if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                this.value = this.value.replace(/[^0-9\.]/g, '');
            }
        });

        $("#barcode").keypress(function (e) {
            if (e.keyCode == 0 || e.keyCode == 32) {
                const Toast = Swal.mixin({
                    toast: true,
                    position: 'top-end',
                    showConfirmButton: false,
                    timer: 3000
                });
                Toast.fire({
                    icon: 'error',
                    title: 'System does not allow space'
                })
                e.preventDefault()
                return;
            } else {
                console.log('not key');
            }
        });



        $('#form_data').on('submit', function (event) {
            event.preventDefault();

            if ($('#action').val() == 'Add')
            {
                $.ajax({
                    url: "{{route('pos-product.add_pos_product') }}",
                    method: "POST",
                    data: new FormData(this),
                    contentType: false,
                    cache: false,
                    processData: false,
                    dataType: "json",
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
                                return;
                            }
                        }

                        if (data.barcode)
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
                                title: data.barcode
                            })
                            return;

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
                            cleartext();
                            window.location.href = "/pos_product_list/all";
                        }
                    }
                })
            }
        });
    });
</script>

@endsection



