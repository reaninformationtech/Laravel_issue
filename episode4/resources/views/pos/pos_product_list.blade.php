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
                            <a href="{{ url('/registerproduct') }}" class="text-center">
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
                                    <th width="38%">Pro name</th>
                                    <th width="15%">Barcode</th>
                                    <th width="15%">Type</th>
                                    <th width="20%">line</th>
                                    <th width="10%">cost</th>
                                    <th width="10%">U/P</th>
                                    <th width="10%">Discount</th>
                                    <th width="10%">Status</th>
                                    <th width="10%">Action</th>
                                </tr>
                                @foreach ($data as $row)
                                    <tr>
                                        <td>{{ $row->pro_id }}</td>
                                        <td>{{ $row->pro_name }}</td>
                                        <td>{{ $row->barcode }}</td>
                                        <td>{{ $row->pro_type }}</td>
                                        <td>{{ $row->pro_line }}</td>
                                        <td>{{ $row->pro_cost }}</td>
                                        <td>{{ $row->pro_up }}</td>
                                        <td>{{ $row->pro_discount }}</td>
                                        <td>{{ $row->status }}</td>
                                        <td>

                                            <div class="row mb-12">
                                                <div class="col-sm-2">
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="row mb-2">
                                                        <a href="{{ url('pos_product_view/' . $row->pro_id) }}"
                                                            class="text-center">
                                                            <button type="button" name='edit' id='{{ $row->pro_id }}'
                                                                class="edit btn btn-xs btn-success btn-sm my-0"><i
                                                                    class="fas fa-eye"></i></button>
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
