<html lang="en">

<head>
    <title>Laravel Multiple File Upload Example</title>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
</head>

<body><br>
    <div class="container">
         

    <div class="container-fluid">
    <div class="row justify-content-center">
        <h2 class="card-header w-100 m-1 text-center">Upload Image</h2>
    </div>
    <div class="row justify-content-center">
        <form class="m-2" method="post" action="/file-upload" enctype="multipart/form-data">
            @csrf
            <div class="form-group">

                <input type="text" class="form-control" id="name" placeholder="Enter file Name" name="name">
            </div>
            <div class="form-group">
                <label for="image">Choose Image</label>
                <input id="image" type="file" name="image">
            </div>
            <button type="submit" class="btn btn-dark d-block w-75 mx-auto">Upload</button>
        </form>
    </div>

</div>

        
    </div>
</body>

</html>
