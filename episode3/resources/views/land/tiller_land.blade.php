@extends('layouts.app')
@section('content')


<section class="content">
    <div class="row">
        <div class="col-md-12">
            <div class="card card-outline card-info">
                <div class="card-header">
                     <form method="post" id="dynamic_form" class="form-inline"> 

                        <div class="form-group mb-2">
                         @csrf
                             <button type="submit" class="btn btn-labeled btn-success"  name="create_record" id="create_record" >
                                <span class="btn-label"><i class="fas fa-edit"> Posting</i></span> </button>
                        </div>
                    </form>

                </div>
                <!-- /.card-header -->
                <div class="card-body pad">
                    <div class="mb-3">
                        <div class="alert alert-success" style="display: none;"></div>

                        <div id="table_data">
                            @include('land/tiller_land_data')
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
@section('scripts')

<script type="text/javascript">
$(document).ready(function(){
    $('#select_all').on('click',function(){
        if(this.checked){
            $('.p_view').each(function(){
                this.checked = true;
            });
        }else{
             $('.p_view').each(function(){
                this.checked = false;
            });
        }
    });
    
    $('.p_view').on('click',function(){
        if($('.p_view:checked').length == $('.p_view').length){
            $('#select_all').prop('checked',true);
        }else{
            $('#select_all').prop('checked',false);
        }
    });
});
</script>

<script>
    $(document).ready(function () {

        $(document).on('click', '.pagination a', function (event) {
            event.preventDefault();
            var page = $(this).attr('href').split('page=')[1];
            var vstatus = $('input[name=txtstatus]');
            var vtype = vstatus.val();
            fetch_data(vtype, page);
        });

        function fetch_data(vstatus, page)
        {
            $.ajax({
                url: "tiller-land/tiller_land_fetch/" + vstatus + "?page=" + page,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            })
        }

        //function
        function loaddata(vstatus='') {
            $.ajax({
                url: "tiller-land/tiller_land_fetch/"+ vstatus,
                success: function (data)
                {
                    $('#table_data').html(data);
                }
            })
        }

        $('#dynamic_form').on('submit', function(event){
            event.preventDefault();
            var rows = [];
            //Get all the data row and put in array
            $('#MenuList tbody tr').each(function () {
                var Id = $(this).find('td').eq(1).text().trim();
                if(Id!=''){
                    var p_view = $(this).find('.p_view').is(':checked') ? 1 : 0;
                    var row =Id + "_" + p_view;
                    rows.push(row); //Push into array rows[]
                }
            });

            
            var record = JSON.stringify({
                getRows: rows //Post to Controller action parameter
            });

            var formData = $(this).serializeArray();
            var a_string = JSON.stringify(rows);
            formData.push({name: 'arr_data', value: a_string});

             $.ajax({
                    url:'{{ route("tiller-land.add_tiller_land")}}',
                    method: "POST",
                    data: formData,
                    success: function (data)
                    {
                        if (data.success)
                        {
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

                        }
                        loaddata('1');

                    }
                });
        });
 


    });
</script>

@endsection
