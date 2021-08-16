
@extends('layouts.app')
@section('content')
    <section class="content">
        <div class="row">
            <div class="col-md-12">
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title" name="create_record" id="create_record">
                            <a href="{{ url('/sale_land') }}" class="text-center">
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
                                        <th width="5%">ID</th>
                                        <th>Item Name</th>
                                        <th>Customer</th>
                                        <th >Phone</th>
                                        <th >Currency</th>
                                        <th >Cost</th>
                                        <th >Discount</th>
                                        <th >Amount</th>
                                        <th >Plan</th>
                                        <th >Type</th>
                                        <th >Size</th>
                                        <th >Street</th>
                                        <th width="5%">Action</th>
                                    </tr>
                                    @foreach($data as $row)
                                    <tr>
                                        <td>{{ $row->id }}</td>
                                        <td>{{ $row->name }}</td>
                                        <td>{{ $row->cus_name }}</td>
                                        <td>{{ $row->cus_phone }}</td>
                                        <td>{{ $row->currencyshort }}</td>
                                        <td>{{ $row->cost }}</td>
                                        <td>{{ $row->discount }}</td>
                                        <td>{{ $row->amount }}</td>
                                        <td>{{ $row->item_plan }}</td>
                                        <td>{{ $row->item_type }}</td>
                                        <td>{{ $row->item_size }}</td>
                                        <td>{{ $row->item_street }}</td>
                                        <td>
                                            <div class="row mb-12">
                                                <div class="col-sm-2">
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="row mb-2">
                                                        <a href="{{ url('sale_land/' . $row->id) }}"
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




 