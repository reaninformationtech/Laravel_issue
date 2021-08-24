@extends('layouts.app')
@section('content')
    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf

                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <a href="{{ url('/pos_countstock') }}" class="text-center">
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
                                    <th width="15%">ID</th>
                                    <th width="20%">Stock</th>
                                    <th width="20%">Remark</th>
                                    <th width="20%">Inputter</th>
                                    <th width="10%">Action</th>
                                </tr>
                                @foreach ($data as $row)
                                    <tr class="table-secondary">
                                        <td>{{ $row->tran_code }}</td>
                                        <td>{{ $row->stockname }}</td>
                                        <td>{{ $row->remark }}</td>
                                        <td>{{ $row->inputter }}</td>
                                        <td>

                                            <div class="row mb-12">
                                                <div class="col-sm-2">
                                                </div>
                                                <div class="col-sm-6">
                                                    <div class="row mb-2">
                                                        <a href="{{ url('pos_countstock_view/' . $row->tran_code) }}"
                                                            class="text-center">
                                                            <button type="button"
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
