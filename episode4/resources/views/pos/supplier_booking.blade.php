<div class="col-md-6">
    <!-- /.card-header -->
    <div class="card-body">
        <form role="form">
            <div class="row">
                <div class="col-sm-12">
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" name="name" id="name" class="form-control is-valid" placeholder="Name ...">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    <!-- select -->
                    <div class="form-group">
                        <label>Type</label>
                        <select class="selectpicker form-control" name="type" id="type" data-live-search="true">
                            @foreach ($pos_line as $row)
                                <option data-tokens="{{ $row->id }}" value="{{ $row->id }}">
                                    {{ $row->name }}</option>
                            @endforeach

                        </select>
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <label>Inactive</label>
                        <select class="selectpicker form-control" name="inactive" id="inactive" data-live-search="true">
                            @foreach ($inactive as $row2)
                                <option data-tokens="{{ $row2->id }}" value="{{ $row2->id }}">
                                    {{ $row2->name }}</option>
                            @endforeach
                        </select>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    <!-- text input -->
                    <div class="form-group">
                        <label>Phone</label>
                        <input type="text" name="phone" id="phone" class="form-control" placeholder="Phone ...">
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <label>Email</label>
                        <input type="text" name="email" id="email" class="form-control" placeholder="Email ...">
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-sm-6">
                    <!-- text input -->
                    <div class="form-group">
                        <label>Websit</label>
                        <input type="text" name="websit" id="websit" class="form-control" placeholder="Websit ...">
                    </div>
                </div>
                <div class="col-sm-6">
                    <div class="form-group">
                        <label>Address</label>
                        <input type="text" name="address" id="address" class="form-control" placeholder="Address ...">
                    </div>
                </div>
            </div>
    </div>

</div>
