@extends('layouts.app')
@section('content')

<div class="row">
    <div class="col-md-12">
        <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
            @csrf
            <div class="card card-outline card-info">
                <div class="card-header">
                    <h3 class="card-title">
                        <button type="submit" class="authorize btn btn-outline-danger" name="create_record"
                            id="create_record"><i class="fas fa-edit">Edit</i></button>
                        <a href="{{ url('/setupbranch') }}" class="text-center">
                            <button type="button" class="btn btn-outline-info" name="list_record" id="list_record">List
                                Info</button>
                        </a>
                    </h3>
                </div>
                <!-- /.card-header -->
                <div class="card-body pad">
                    <div class="col-md-6">
                        <!-- /.card-header -->
                        <div class="card-body">
                            @foreach ($data as $row)
                            <input type="hidden" name="action" id="action" value="Edit" />
                            <input type="hidden" name="hidden_id" id="hidden_id" value="{{ $row->id }}" />
                            <form role="form">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="branchcode" class="col-sm-2 col-form-label">branch Code</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="branchcode" id="branchcode"
                                                    class="form-control" value="{{ $row->id }}" Readonly>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="setname" class="col-sm-2 col-form-label">Set-Name </label>
                                            <div class="col-sm-10">
                                                <input type="text" name="setname" id="setname" class="form-control"
                                                    value="{{ $row->setname }}">
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
                                                    class="form-control" value="{{ $row->name }}">
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
                                                    class="form-control" value="{{ $row->branchshort }}">
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
                                                    @foreach ($inactive as $row1)
                                                    <option value="{{ $row1->id }}"
                                                        {{ $row1->id == $row->inactive ? 'selected="selected"' : '' }}>
                                                        {{ $row1->name }}</option>
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
                                                <input type="text" name="phone" id="phone" class="form-control"
                                                    value="{{ $row->phone }}">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="email" class="col-sm-2 col-form-label">email</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="email" id="email" class="form-control"
                                                    value="{{ $row->email }}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="website" class="col-sm-2 col-form-label">website</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="website" id="website" class="form-control"
                                                    value="{{ $row->website }}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="form-group row">
                                            <label for="address" class="col-sm-2 col-form-label">address</label>
                                            <div class="col-sm-10">
                                                <input type="text" name="address" id="address" class="form-control"
                                                    value="{{ $row->address }}">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                @endforeach
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


            function containsOnlyKahmerCharakter(str) {
                    return str.split('').some(function(char) {
                    var charCode = char.charCodeAt('0')
                    return ( charCode >= 0x1780 && charCode <= 0x17FF || charCode>= 0x19e0 && charCode <= 0x19FF ) })
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
                }else{
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

            $('#form_data').on('submit', function(event) {
                event.preventDefault();

                var set_name = $('#setname').val();
                var hasSpace = $('#setname').val().indexOf(' ')>=0;
                if(hasSpace==true){
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

                if ($('#action').val() == 'Edit') {
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
                            }
                        }
                    })
                }
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
                            url: "/customer_delete/" + gb_id,
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
                        window.location.href = "/setupbranch";
                    }
                })
            });
        });
</script>

@endsection
