@extends('layouts.app')
@section('content')
    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <a href="{{ url('/registerland') }}" class="text-center">
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
                                    <th width="5%">Item_ID</th>
                                    <th>Item name</th>
                                    <th>Plan</th>
                                    <th>Item Type</th>
                                    <th>Size</th>
                                    <th>Street</th>
                                    <th>Currency</th>
                                    <th>Cost</th>
                                    <th>UnitPrice</th>
                                    <th>Inactive</th>
                                    <th>Remark</th>
                                    <th width="5%">Action</th>
                                </tr>
                                @foreach ($data as $row)
                                    <tr>
                                        <td>{{ $row->rg_id }}</td>
                                        <td>{{ $row->rg_name }}</td>
                                        <td>{{ $row->plan }}</td>
                                        <td>{{ $row->type }}</td>
                                        <td>{{ $row->size }}</td>
                                        <td>{{ $row->street }}</td>
                                        <td>{{ $row->currencyshort }}</td>
                                        <td>{{ $row->cost }}</td>
                                        <td>{{ $row->unitprice }}</td>
                                        <td>{{ $row->v_inactive }}</td>
                                        <td>{{ $row->remark }}</td>
                                        <td>
                                            <div class="row mb-12">
                                                <div class="col-sm-2">
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="row mb-2">
                                                        <a href="{{ url('registerland/' . $row->rg_id) }}"
                                                            class="text-center">
                                                            <button type="button" name='edit' id='{{ $row->rg_id }}'
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
    </div>
    <!-- ./row -->
@endsection
