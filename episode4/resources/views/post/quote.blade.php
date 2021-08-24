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
                            <button type="submit" class="btn btn-outline-primary" name="create_record" id="create_record"><i
                                    class="fas fa-edit" id='title'> Commit</i></button>
                            <a href="{{ url('quote_list/all') }}" class="text-center">
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
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">Type :</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="type" id="type"
                                                        data-live-search="true">
                                                        @foreach ($quote as $row)
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
                                                <label for="inputEmail3" class="col-sm-2 col-form-label">Quote :</label>
                                                <div class="col-sm-10">
                                                    <textarea type="text" name="quote" id="quote" class="form-control" rows="3" placeholder="Quote meaning ..." autocomplete="off"></textarea>
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
                $('#type').val('');
                $('#quote').val('');
            }

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                if ($('#action').val() == 'Add') {
                    $.ajax({
                        url: "{{ route('quote.add_quote') }}",
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
                                window.location.href = "/quote_list/all";
                            }
                        }
                    })
                }
            });
        });
    </script>

@endsection
