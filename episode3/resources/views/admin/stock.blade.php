@extends('layouts.app')
@section('content')


<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-info">
                <div class="card-header">
                    <h3 class="card-title" align="center">
                        Stock menu
                    </h3>
                    <!-- tools box -->
                    <div class="card-tools">
                        <button type="button" class="btn btn-tool btn-sm" data-card-widget="collapse" data-toggle="tooltip"
                                title="Collapse">
                            <i class="fas fa-minus"></i></button>
                        <button type="button" class="btn btn-tool btn-sm" data-card-widget="remove" data-toggle="tooltip"
                                title="Remove">
                            <i class="fas fa-times"></i></button>
                    </div>
                    <!-- /. tools -->
                </div>
                <!-- /.card-header -->
                <div class="card-body pad">
                    <div class="mb-3">

                        <div id="table_data">
                            @include('pagination_data')
                        </div>

                    </div>
                    <p class="text-sm mb-0">
                        www.toanchet.com <a href="https://github.com/summernote/summernote">Documentation and license information.</a>
                    </p>
                </div>
            </div>
        </div>
        <!-- /.col-->
    </div>
    <!-- ./row -->
</section>


@endsection
@section('scripts')
<script>

    $(document).ready(function () {

        $(document).on('click', '.stock a', function (event) {
            event.preventDefault();
            var page = $(this).attr('href').split('page=')[1];
            fetch_data(page);
        });

        function fetch_data(page)
        {
            $.ajax({
                url: "/admin/fetch_data?page=" + page,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            });
        }

    });
</script>

@endsection

