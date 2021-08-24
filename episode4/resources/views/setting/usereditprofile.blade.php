@extends('layouts.app')
@section('content')
    <!-- Main content -->
    <section class="content">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-3">
                    <!-- Profile Image -->
                    <div class="card card-primary card-outline">
                        <div class="card-body box-profile">
                            <div class="text-center">
                                <img class="profile-user-img img-fluid img-circle"
                                    src="{{ URL::to('/admin/image/user.jpg') }}" alt="User profile picture">
                            </div>

                            <h3 class="profile-username text-center">
                                {{ isset($userinfo[0]->name) ? $userinfo[0]->name : '' }}</h3>

                            <p class="text-muted text-center">
                                {{ isset($userinfo[0]->pro_name) ? $userinfo[0]->pro_name : '' }}</p>

                            <ul class="list-group list-group-unbordered mb-3">
                                <li class="list-group-item">
                                    <b>User ID : </b> <a
                                        class="float-right">{{ isset($userinfo[0]->id) ? $userinfo[0]->id : '' }}</a>
                                </li>
                                <li class="list-group-item">
                                    <b>Full Name : </b>
                                    <a class="float-right">
                                        <input id="email" type="email"
                                            class="form-control @error('email') is-invalid @enderror" name="email"
                                            value="{{ $userinfo[0]->name }}" autocomplete="email" placeholder="Email"
                                            autofocus>
                                    </a>
                                </li>
                                <li class="list-group-item">
                                    <b>Phone</b> 
                                    <a class="float-right">
                                      <input id="email" type="email"
                                          class="form-control @error('contact') is-invalid @enderror" name="contact"
                                          value="{{ $userinfo[0]->contact }}" autocomplete="contact" placeholder="contact"
                                          autofocus>
                                    </a>
                                </li>
                            </ul>

                            <a href="#" class="btn btn-primary btn-block"><b>Follow</b></a>
                        </div>
                        <!-- /.card-body -->
                    </div>
                    <!-- /.card -->
                </div>
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </section>
    <!-- /.content -->

@endsection
@section('scripts')


@endsection
