@extends('layouts.app')
@section('content')

    @php
    $my_variable = '';
    @endphp

    <div class="row">
        <div class="col-md-12">
            <form method="post" id="form_data" class="form-horizontal" enctype="multipart/form-data">
                @csrf
                <div class="card card-outline card-info">
                    <div class="card-header">
                        <h3 class="card-title">
                            <button type="submit" class="btn btn-outline-primary" name="create_record" id="create_record"><i
                                    class="fas fa-edit" id='title'> Commit</i></button>

                            <input type="hidden" name="action" id="action" />
                            <input type="hidden" name="hidden_id" id="hidden_id" />
                        </h3>
                    </div>
                    <!-- /.card-header -->
                    <div class="card-body pad">

                        @php
                            $my_variable = '';
                        @endphp


                        <div class="table-responsive">
                            <table class="table table-striped table-bordered" id="MenuList">
                                <tr>
                                    <th width="5%">Checking</th>
                                    <th width="15%">ID</th>
                                    <th width="15%">Type</th>
                                    <th width="15%">Referent</th>
                                    <th width="15%">Currency</th>
                                    <th width="15%">Amount</th>
                                    <th width="15%">Remark</th>
                                    <th width="15%">Inputter</th>
                                </tr>
                                @foreach ($data as $row)

                                    @if ($my_variable != $row->list_order)

                                        <tr class="table-primary">
                                            <th width="5%">{{ $row->status }}</th>
                                            <th width="38%"></th>
                                            <th width="38%"></th>
                                            <th width="57%"></th>
                                            <th width="57%"></th>
                                            <th width="57%"></th>
                                            <th width="57%"></th>
                                            <th width="57%"></th>
                                        </tr>
                                    @endif

                                    <tr>
                                        <td>
                                            <div class="icheck-primary">
                                                <input type="checkbox" name="m_code[]" class="p_code" value="{{ $row->tran_code }}"
                                                    id="v{{ $row->tran_code }}">
                                                <label for="v{{ $row->tran_code }}"></label>
                                            </div>
                                        </td>
                                        <td >{{ $row->tran_code }}</td>
                                        <td>{{ $row->line }}</td>
                                        <td>{{ $row->referent }}</td>
                                        <td>{{ $row->currency }}</td>
                                        <td>{{ $row->amount }}</td>
                                        <td>{{ $row->remark }}</td>
                                        <td>{{ $row->inputter }}</td>
                                    </tr>

                                    @php
                                        $my_variable = $row->list_order;
                                    @endphp

                                @endforeach
                            </table>

                        </div>


                    </div>
                </div>
            </form>
        </div>
        <!-- /.col-->
    </div>
    <!-- ./row -->

@endsection


@section('scripts')

    <script>
        $(document).ready(function() {

            $('#form_data').on('submit', function(event) {
                event.preventDefault();
                var rows = [];
                var status = '';
                /// Assign value to post
                $('#action').val('I');

                if (status == '') {
                    var row = "I|";
                    rows.push(row);
                    var record = JSON.stringify({
                        getRows: rows //Post to Controller action parameter
                    });

                    var formData = $(this).serializeArray();
                    var a_string = JSON.stringify(rows);
                    formData.push({
                        name: 'arr_data',
                        value: a_string
                    });

                    $.ajax({
                        url: '{{ route('pos.pos_auth_tiller') }}',
                        method: "POST",
                        data: formData,
                        success: function(data) {
                            if (data.success) {
                                // Message sweet alert
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

                                window.location.href = "/pos_tiller";
                            }
                        }
                    });
                }
            });

        });

    </script>

@endsection
