@extends('layouts.app')
@section('content')
    <style>
        nav svg {
            max-height: 20px;
        }

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

    <div class="container">
        <h2 class="text-center p-4 bg-dark text-white">Attach <span>Documents </span></h2>

        <form action="/document_upload" class="dropzone" id="dropzonewidget" method="POST" enctype="multipart/form-data">
            @csrf
            <input hidden name="documents" id="documents" type="text" />
        </form>
    </div>

@endsection

@section('javascript')
    <script>
        var segments = location.href.split('/');
        var action = segments[4];
        console.log(action);
        if (action == 'dropzone') {
            var acceptedFileTypes = "image/*, .psd"; //dropzone requires this param be a comma separated list
            var fileList = new Array;
            var i = 0;
            var callForDzReset = false;
            $("#dropzonewidget").dropzone({

                url: "/document_upload",
                addRemoveLinks: true,
                maxFiles: 4,
                acceptedFiles: 'image/*',
                maxFilesize: 5,
                init: function() {
                    this.on("success", function(file, serverFileName) {
                        file.serverFn = serverFileName;
                        fileList[i] = {
                            "serverFileName": serverFileName,
                            "fileName": file.name,
                            "fileId": i
                        };
                        i++;
                    });
                }
            });
        }

    </script>
@endsection
