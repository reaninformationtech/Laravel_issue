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
                            <a href="{{ url('/purchase_order') }}" class="text-center">
                                <button type="button" class="btn btn-outline-primary" name="create_record"
                                    id="create_record"><i class="fas fa-plus"> New</i></button>
                            </a>
                        </h3>

                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">
                        <div class="table-responsive">
                            <table class="table table-striped table-bordered">
                                <tr class="table-primary">
                                    <th width="5%">ID</th>
                                    <th width="38%">Supply</th>
                                    <th width="38%">Invoice</th>
                                    <th width="57%">Inputter</th>
                                    <th width="57%">Date</th>
                                    <th width="57%">Action</th>
                                </tr>
                                @foreach ($data as $row)
                                    <tr class="table-secondary">
                                        <td>{{ $row->pur_id }}</td>
                                        <td>{{ $row->sup_name }}</td>
                                        <td>{{ $row->pur_invoice }}</td>
                                        <td>{{ $row->inputter }}</td>
                                        <td>{{ $row->inputdate }}</td>
                                        <td>
                                            <div class="row mb-12">
                                                <div class="col-sm-2">
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="row mb-2">
                                                        <a href="{{ url('purchase_view/' . $row->pur_id) }}"
                                                            class="text-center">
                                                            <button type="button" name='edit' id='{{ $row->pur_id }}'
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
@endsection
