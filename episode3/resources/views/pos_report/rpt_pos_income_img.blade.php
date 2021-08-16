@if (isset($file[0]->sysdonum))
    <div class="row">
        @foreach ($file as $row)
            <div class="col-lg-3 col-md-4 col-xs-6 thumb">
                <a class="thumbnail" data-target="#image-gallery" href="{{ route('pos.pos_income_file', $row->file_name) }}" download >
                    <img class="img-thumbnail" src="{{ route('pos.pos_income_file', $row->file_name) }}" alt="None">
                </a>
            </div>
        @endforeach
    </div>
@else

    <div class="modal-footer justify-content-between">
        <div class="col-md-12 text-right">
            <button type="submit" class="btn pull-right btn-outline-primary"
                data-dismiss="modal"><i class="fas fa-edit" id='title'>
                    No image</i></button>
        </div>
    </div>
    
@endif
