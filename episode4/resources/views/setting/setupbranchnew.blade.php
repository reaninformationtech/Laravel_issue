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
                            <a href="{{ url('cus_land_list/all') }}" class="text-center">
                                <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                    Info</button>
                            </a>
                            <input type="hidden" name="action" id="action" value="Add" />
                        </h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="col-md-6">
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="setname" class="col-sm-2 col-form-label">Set-Name </label>
                                                <div class="col-sm-10">
                                                    <input type="text" name="setname" id="setname" class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="branch_name" class="col-sm-2 col-form-label">Branch Name</label>
                                                <div class="col-sm-10">
                                                    <input type="text" name="branch_name" id="branch_name"
                                                        class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="branch_short" class="col-sm-2 col-form-label">branch
                                                    Short</label>
                                                <div class="col-sm-10">
                                                    <input type="text" name="branch_short" id="branch_short"
                                                        class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="inactive" class="col-sm-2 col-form-label">Inactive</label>
                                                <div class="col-sm-5">
                                                    <select class="selectpicker form-control" name="inactive" id="inactive"
                                                        data-live-search="true">
                                                        @foreach ($inactive as $row)
                                                            <option data-tokens="{{ $row->id }}"
                                                                value="{{ $row->id }}">
                                                                {{ $row->name }}</option>
                                                        @endforeach
                                                    </select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="phone" class="col-sm-2 col-form-label">Phone</label>
                                                <div class="col-sm-10">
                                                    <input type="text" name="phone" id="phone" class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="email" class="col-sm-2 col-form-label">email</label>
                                                <div class="col-sm-10">
                                                    <input type="email" name="email" id="email" class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="website" class="col-sm-2 col-form-label">website</label>
                                                <div class="col-sm-10">
                                                    <input type="text" name="website" id="website" class="form-control">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group row">
                                                <label for="address" class="col-sm-2 col-form-label">address</label>
                                                <div class="col-sm-10">
                                                    <input type="text" name="address" id="address" class="form-control">
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
                $('#setname').val('');
                $('#branch_name').val('');
                $('#branch_short').val('');
                $('#inactive').val('');
                $('#phone').val('');
                $('#email').val('');
                $('#website').val('');
                $('#address').val('');
            }

            function containsOnlyKahmerCharakter(str) {
                return str.split('').some(function(char) {
                    var charCode = char.charCodeAt('0')
                    return (charCode >= 0x1780 && charCode <= 0x17FF || charCode >= 0x19e0 && charCode <=
                        0x19FF)
                })
            }


            $("#setname").keypress(function(e) {

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
                    var regex = new RegExp("^[a-zA-Z0-9 ]+$");
                    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
                    if (regex.test(str)) {
                        return true;
                    }

                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Set branch name allow only English !'
                    })

                    e.preventDefault();
                    return false;
                }
            });

            $('#phone').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\.]/g, '')) {
                    this.value = this.value.replace(/[^0-9\.]/g, '');
                }
            });

            function isNumberKey(evt) {
                var charCode = (evt.which) ? evt.which : evt.keyCode;
                if (charCode != 46 && charCode > 31 &&
                    (charCode < 48 || charCode > 57))
                    return false;
                return true;
            }

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var set_name = $('#setname').val();
                var hasSpace = $('#setname').val().indexOf(' ') >= 0;
                if (hasSpace == true) {
                    $('#setname').val(set_name.replace(/\s/g, ''));
                }

                if (containsOnlyKahmerCharakter(set_name) == true) {
                    event.preventDefault();
                    const Toast = Swal.mixin({
                        toast: true,
                        position: 'top-end',
                        showConfirmButton: false,
                        timer: 3000
                    });
                    Toast.fire({
                        icon: 'error',
                        title: 'Set branch name allow only English !'
                    })
                    e.preventDefault()
                    return;
                }
                if ($('#action').val() == 'Add') {
                    $.ajax({
                        url: "{{ route('setup-branch.setupbranch_edit') }}",
                        method: "POST",
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
                                window.location.href = "/setupbranch";
                            }
                        }
                    })
                }
            });
        });
    </script>
@endsection
