@extends('layouts.app')
@section('content')
    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <a href="{{ url('/add_customer') }}" class="text-center">
                                <button type="button" class="btn btn-outline-primary" name="create_record"
                                    id="create_record"><i class="fas fa-plus"> New</i></button>
                            </a>
                        </h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered">
                                <tr>
                                    <th width="5%">ID</th>
                                    <th width="38%">Cus name</th>
                                    <th width="10%">Gender</th>
                                    <th width="15%">Phone</th>
                                    <th width="30%">Address</th>
                                    <th width="38%">Status</th>
                                    <th width="57%">Action</th>
                                </tr>
                                @foreach ($data as $row)
                                    <tr>
                                        <td>{{ $row->cus_id }}</td>
                                        <td>{{ $row->cus_name }}</td>
                                        <td>{{ $row->gender }}</td>
                                        <td>{{ $row->cus_phone }}</td>
                                        <td>{{ $row->cus_address }}</td>
                                        <td>{{ $row->status }}</td>
                                        <td>
                                            <div class="row mb-12">
                                                <div class="col-sm-2">
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="row mb-2">
                                                        <a href="{{ url('customer_view/' . $row->cus_id) }}"
                                                            class="text-center">
                                                            <button type="button" name='edit' id='{{ $row->cus_id }}'
                                                                class="edit btn btn-xs btn-success btn-sm my-0">
                                                                <i class="fas fa-eye"></i></button>
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
    </div>
    <!-- ./row -->
@endsection
