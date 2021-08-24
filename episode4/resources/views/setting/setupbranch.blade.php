@extends('layouts.app')
@section('content')
<div class="row">
    <div class="col-md-12">
        <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
            @csrf
            <div class="card card-outline card-info">
                <div class="card-header">
                    <h3 class="card-title">
                        <a href="{{ url('/add_setupbranch') }}" class="text-center">
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
                                <th width="5%">Code</th>
                                <th width="38%">Branch name</th>
                                <th width="38%">Full name</th>
                                <th width="38%">Short name</th>
                                <th width="38%">Phone</th>
                                <th width="38%">Email</th>
                                <th width="57%">Website</th>
                                <th width="38%">Inactive</th>
                                <th width="57%">Action</th>
                            </tr>
                            @foreach($data as $row)
                            <tr>
                                <td>{{ $row->branchcode }}</td>
                                <td>{{ $row->setname }}</td>
                                <td>{{ $row->branchname }}</td>
                                <td>{{ $row->branchshort }}</td>
                                <td>{{ $row->phone }}</td>
                                <td>{{ $row->email }}</td>
                                <td>{{ $row->website }}</td>
                                <td>{{ $row->status }}</td>
                                <td>
                                    <div class="row mb-12">
                                        <div class="col-sm-2">
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="row mb-2">
                                                <a href="{{ url('setupbranch/' . $row->branchcode) }}"
                                                    class="text-center">
                                                    <button type="button" name='edit' id='{{ $row->branchcode }}'
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
