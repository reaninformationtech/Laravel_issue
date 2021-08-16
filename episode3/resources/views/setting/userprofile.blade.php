@extends('layouts.app')
@section('content')
    <link rel="stylesheet" href="https://unpkg.com/dropzone/dist/dropzone.css" />
    <link href="https://unpkg.com/cropperjs/dist/cropper.css" rel="stylesheet" />
    <script src="https://unpkg.com/dropzone"></script>
    <script src="https://unpkg.com/cropperjs"></script>
    <style>
        .image_area {
            position: relative;
        }

        img {
            display: block;
            max-width: 100%;
        }

        .preview {
            overflow: hidden;
            width: 160px;
            height: 160px;
            margin: 10px;
            border: 1px solid red;
        }

        .modal-lg {
            max-width: 1000px !important;
        }

        .overlay {
            position: absolute;
            bottom: 10px;
            left: 0;
            right: 0;
            background-color: rgba(255, 255, 255, 0.5);
            overflow: hidden;
            height: 0;
            transition: .5s ease;
            width: 100%;
        }

        .image_area:hover .overlay {
            height: 50%;
            cursor: pointer;
        }

    </style>

    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">
            <div class="row">

                <div class="col-md-3">
                    <!-- Profile Image -->
                    <div class="card card-primary card-outline">
                        <div class="card-body box-profile">
                            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                                @csrf
                                <div class="text-center">
                                    <div class="image_area">
                                        <label for="upload_image">
                                            <img class="profile-user-img img-fluid img-circle" id="_image"
                                                src="{{ route('id_img_userprofile', Session::get('userinfo')['id']) }}"
                                                alt="User profile">
                                            <div class="overlay">
                                                <div class="text">Click to Change Image</div>
                                            </div>
                                            <input type="file" name="upload_image" class="image" id="upload_image"
                                                style="display:none" />
                                        </label>
                                    </div>
                                </div>

                                <h3 class="profile-username text-center">
                                    {{ isset($userinfo[0]->name) ? $userinfo[0]->name : '' }}
                                </h3>

                                <p class="text-muted text-center">{{ isset($userinfo[0]->bio) ? $userinfo[0]->bio : '' }}
                                </p>
                                <ul class="list-group list-group-unbordered mb-3">
                                    <li class="list-group-item">
                                        <b>User ID : </b> <a class="float-right">
                                            {{ isset($userinfo[0]->id) ? $userinfo[0]->id : '' }}</a>
                                    </li>
                                    <li class="list-group-item">
                                        <b>User login : </b> <a class="float-right">
                                            {{ isset($userinfo[0]->email) ? $userinfo[0]->email : '' }}</a>
                                    </li>
                                    <li class="list-group-item">
                                        <b>Full Name : </b> <a class="float-right">
                                            <input class="form-control form-control-sm" type="text" name="username"
                                                id="username"
                                                value="{{ isset($userinfo[0]->name) ? $userinfo[0]->name : '' }}">
                                        </a>
                                    </li>
                                    <li class="list-group-item">
                                        <b>Gender : </b>
                                        <a class="float-right">
                                            <select class="selectpicker form-control" name="gender" id="gender"
                                                data-live-search="true">
                                                @foreach ($gender as $row)
                                                    <option value="{{ $row->id }}" data-tokens="{{ $row->id }}"
                                                        {{ $row->id == $userinfo[0]->gender ? 'selected="selected"' : '' }}>
                                                        {{ $row->name }}</option>
                                                @endforeach
                                            </select>
                                        </a>
                                    </li>

                                    <li class="list-group-item">
                                        <b>Phone : </b> <a class="float-right"> <input class="form-control form-control-sm"
                                                type="text" name="contact" id="contact" autocomplete="contact"
                                                value="{{ isset($userinfo[0]->contact) ? $userinfo[0]->contact : '' }}">
                                        </a>
                                    </li>
                                    <li class="list-group-item">
                                        <b>Bio : </b> <a class="float-right"> <input class="form-control form-control-sm"
                                                type="text" name="bio"
                                                value="{{ isset($userinfo[0]->bio) ? $userinfo[0]->bio : '' }}">
                                        </a>
                                    </li>
                                </ul>
                                <input type="hidden" name="hidden_image_name" id="hidden_image_name" />
                                <input type="hidden" name="org_image_name" id="org_image_name"
                                    value="{{ isset($userinfo[0]->photo) ? $userinfo[0]->photo : '' }}" />
                                <button type="submit" class="btn btn-outline-danger btn-block"><i class="fa fa-edit"></i>
                                    Update </button>
                                <button type="button" class="delete btn btn-outline-info btn-block"><i
                                        class="fa fa-edit"></i>
                                    Change password </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <form method="post" id="dynamic_form" enctype="multipart/form-data">
                @csrf
                <div class="modal fade" id="modal" tabindex="-1" role="dialog" aria-labelledby="modalLabel"
                    aria-hidden="true">

                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Upload your image</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">×</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="img-container">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <img src="" id="sample_image" />
                                        </div>
                                        <div class="col-md-4">
                                            <div class="preview"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" id="crop" class="btn btn-primary">Crop</button>
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>


        <div class="modal fade" id="confirmModal">
            <div class="modal-dialog">
                <form method="POST" id="form_reset" enctype="multipart/form-data">
                    @csrf
                    <div class="modal-content bg-secondary">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                        </div>

                        <div class="card-body">

                            <div class="form-group">
                                <div class="input-group mb-3">
                                    <input type="password" id="password" class="form-control" name="password"
                                        value="{{ old('password') }}" autocomplete="name" autofocus
                                        placeholder="Password">
                                    <div class="input-group-append">
                                        <div class="input-group-text">
                                            <span class="fas fa-key"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <div class="input-group mb-3">
                                    <input type="password" id="conpassword" class="form-control" name="conpassword"
                                        value="{{ old('conpassword') }}" autocomplete="conpassword" autofocus
                                        placeholder="Confirm Password">
                                    <div class="input-group-append">
                                        <div class="input-group-text">
                                            <span class="fas fa-key"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer justify-content-between">
                            <button type="button" class="btn btn-outline-light" data-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-outline-light" id="ok_reset">Ok</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->

                </form>
            </div>
            <!-- /.modal-dialog -->
        </div>

    </section>
@endsection

@section('scripts')
    <script>
        $(document).ready(function() {
            var $modal = $('#modal');
            var image = document.getElementById('sample_image');
            var cropper;


            $(document).on('click', '.delete', function(event) {
                user_id = $(this).attr('id');
                $('#confirmModal').modal('show');
            });

            $('#contact').keyup(function() {
                if (this.value != this.value.replace(/[^0-9\./]/g, '')) {
                    this.value = this.value.replace(/[^0-9\./]/g, '');
                }
            });

            $('#upload_image').change(function(event) {
                var files = event.target.files;
                var done = function(url) {
                    image.src = url;
                    $modal.modal('show');
                };

                if (files && files.length > 0) {
                    reader = new FileReader();
                    reader.onload = function(event) {
                        done(reader.result);
                    };
                    reader.readAsDataURL(files[0]);
                }
            });
            $modal.on('shown.bs.modal', function() {
                cropper = new Cropper(image, {
                    aspectRatio: 1,
                    viewMode: 3,
                    preview: '.preview'
                });
            }).on('hidden.bs.modal', function() {
                cropper.destroy();
                cropper = null;
            });

            $('#crop').click(function() {
                canvas = cropper.getCroppedCanvas({
                    width: 400,
                    height: 400
                });

                canvas.toBlob(function(blob) {
                    url = URL.createObjectURL(blob);
                    var reader = new FileReader();
                    reader.readAsDataURL(blob);
                    reader.onloadend = function() {
                        var base64data = reader.result;
                        $.ajax({
                            type: "POST",
                            dataType: "json",
                            url: "{{ route('userprofile.profileimage') }}",
                            data: {
                                '_token': $('meta[name="_token"]').attr('content'),
                                'image': base64data
                            },
                            success: function(data) {
                                $modal.modal('hide');
                                var url = '{{ route('img_userprofile', '/') }}' +
                                    '/' + data.image_name;
                                $('#_image').attr("src", url);
                                $('#hidden_image_name').val(data.image_name);
                                // $("#_image").html(img); 
                            }
                        });
                    };
                });
            });


            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var rows = [];
                var v_username = $('#username').val();
                var v_gender = $('#gender').val();
                var v_contact = $('#contact').val();

                if (v_username == '') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Please input user name'
                    })
                    return;
                }

                if (v_gender == '') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Please select gender'
                    })
                    return;
                }

                if (v_contact == '') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Please input contact'
                    })
                    return;
                }

                var formData = $(this).serializeArray();
                $.ajax({
                    url: '{{ route('setting.add_userprofile') }}',
                    method: "POST",
                    data: formData,
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
                                return;
                            }
                        }
                        if (data.success) {
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
                            var id = $('#hidden_image_name').val();
                            $('#org_image_name').val(id);
                        }
                    }
                });
            });


            $('#form_reset').on('submit', function(event) {
                event.preventDefault();
                var v_password = $('#password').val();
                var v_conpassword = $('#conpassword').val();

                if (v_password == '') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Please input password !'
                    })
                    return;
                }

                if (v_conpassword == '') {
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Please input confirm password !'
                    })
                    return;
                }

                if (v_password != v_conpassword) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Oops...',
                        text: 'Password and confirm password does not match !'
                    })
                    return;
                }

                var formData = $(this).serializeArray();
                $.ajax({
                    url: '{{ route('setting.resetpassword') }}',
                    method: "POST",
                    data: formData,
                    timeout: 500, 
                    async: false,
                    success: function(data) {
                        if (data.errors) {
                            for (var count = 0; count < data.errors.length; count++) {
                                Swal.fire({
                                    icon: 'error',
                                    text: data.errors[count]
                                })
                                return;
                            }
                        }
                        if (data.success) {
                            $('#confirmModal').modal('hide');
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

        });
    </script>
    ​
@endsection
