<!doctype html>
<html lang="en">

<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css"
        integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
    <link rel="stylesheet" href="https://pro.fontawesome.com/releases/v5.10.0/css/all.css"
        integrity="sha384-AYmEC3Yw5cVb3ZcuHtOA93w35dYTsvhLPVnYs9eStHfGJvOvKxVfELGroGkvsg+p" crossorigin="anonymous" />
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

</head>

<body>
    <table class="table">
        <thead class="thead-dark">
            <tr>
                <th scope="col">Code</th>
                <th scope="col">Menu</th>
                <th scope="col">Inactive</th>
                <th scope="col">Action</th>
            </tr>
        </thead>
        <tbody>
            @foreach ($menu as $row)
                <tr class="clickable js-tabularinfo-toggle" data-toggle="collapse" id="row2"
                    data-target=".a{{ $row->menu_id }}">
                    <th scope="row">{{ $row->menu_id }}</th>
                    <td>{{ $row->menu_name }}</td>
                    <td>{{ $row->inactive }}</td>
                    <td>
                        <div class="col-sm-6">
                            <div class="row mb-2">
                                <a href="#" class="link">
                                    <button type="button" name='edit' id='{{ $row->menu_id }}'
                                        class="edit btn btn-xs btn-outline-danger btn-sm my-0">
                                        <i class="fa fa-plus-circle"></i></button>
                                </a>
                            </div>
                        </div>
                    </td>
                </tr>

                <tr class="tabularinfo__subblock collapse a{{ $row->menu_id }}">
                    <td colspan="2">
                    </td>
                    <td colspan="8">
                        <table class="table-active table table-bordered">
                            <tr>
                                <th width="20%">Sub ID</th>
                                <th width="20%">Sub Name</th>
                                <th width="20%">Inactive</th>
                            </tr>

                            <tbody>
                                @foreach ($submenu as $sub)
                                    @if ($row->menu_id == $sub->menu_id)
                                        <tr>
                                            <td width="20%">{{ $sub->sub_id }}</td>
                                            <td width="20%">{{ $sub->sub_name }}</td>
                                            <td width="20%">{{ $sub->inactive }}</td>
                                        </tr>
                                    @endif
                                @endforeach
                            </tbody>
                        </table>
                    </td>
                </tr>

            @endforeach


        </tbody>
    </table>


    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"
        integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous">
    </script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"
        integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous">
    </script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"
        integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous">
    </script>
</body>

</html>
<script>
    $(document).ready(function() {

        $('.link').click(function() {
            event.preventDefault();
        });


        $('.js-tabularinfo').bootstrapTable({
            escape: false,
            showHeader: false
        });

    });
</script>
