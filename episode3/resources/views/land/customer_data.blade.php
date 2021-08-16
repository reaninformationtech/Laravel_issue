@extends('layouts.app')
@section('content')
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title" name="create_record" id="create_record">
                            <a href="{{ url('/customer_land') }}" class="text-center">
                                <button type="button" class="btn btn-outline-primary" name="create_record"
                                    id="create_record"><i class="fas fa-plus"> New</i></button>
                            </a>
                        </h3>
                        <div class="card-tools">
                            <button type="button" class="btn btn-tool btn-danger btn-sm " data-card-widget="collapse"
                                data-toggle="tooltip" title="Collapse">
                                <i class="fas fa-minus"></i></button>
                            <button type="button" class="btn btn-tool btn-danger btn-sm" data-card-widget="remove"
                                data-toggle="tooltip" title="Remove">
                                <i class="fas fa-times"></i></button>
                        </div>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="mb-3">
                            <h4 align="center">Register Customer</h4><br />
                            <div class="alert alert-success" style="display: none;"></div>

                            <div class="table-responsive">
                                <table class="table table-striped table-bordered">
                                    <tr>
                                        <th width="5%">Cus_ID</th>
                                        <th>Cus name</th>
                                        <th>Gender</th>
                                        <th>Phone</th>
                                        <th>Email</th>
                                        <th>Address</th>
                                        <th>Inactive</th>
                                        <th>Remark</th>
                                        <th width="5%">Action</th>
                                    </tr>
                                    @foreach ($data as $row)
                                        <tr>
                                            <td>{{ $row->cus_id }}</td>
                                            <td>{{ $row->cus_nameeng }}</td>
                                            <td>{{ $row->v_gender }}</td>
                                            <td>{{ $row->cus_phone }}</td>
                                            <td>{{ $row->cus_email }}</td>
                                            <td>{{ $row->cus_address }}</td>
                                            <td>{{ $row->v_inactive }}</td>
                                            <td>{{ $row->cus_remark }}</td>

                                            <td>
                                                <div class="row mb-12">
                                                    <div class="col-sm-2">
                                                    </div>
                                                    <div class="col-sm-6">
                                                        <div class="row mb-2">
                                                            <a href="{{ url('customer_land/' . $row->cus_id) }}"
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
                </div>
            </div>
            <!-- /.col-->
        </div>
        <!-- ./row -->
    </section>
@endsection
