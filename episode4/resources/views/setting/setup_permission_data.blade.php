<div class="table-responsive">
    <table class="table table-hover" id="MenuList">
        <tr>
            <th width="5%">ID</th>
            <th width="38%">Menu name</th>
            <th width="38%">View</th>
            <th width="38%">Booking</th>
            <th width="38%">Edit</th>
            <th width="38%">delete</th>
        </tr>
        @foreach ($data as $row)
            @if ($row->status == 'YES')
                <tr class="table-primary">
                    <td>{{ $row->menu_id }}
                        <div class="icheck-primary">
                            <input type="text" name="m_id[]" class="p_id" value="{{ $row->menu_id }}"
                                id="{{ $row->menu_id }}">
                        </div>
                    </td>
                    <td>{{ $row->menu_name }}</td>
                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_view[]" class="p_view" value="{{ $row->menu_id }}"
                                id="v{{ $row->menu_id }}">
                            <label for="v{{ $row->menu_id }}"></label>
                        </div>
                    </td>
                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_booking[]" class="p_booking" value="{{ $row->menu_id }}"
                                id="b{{ $row->menu_id }}">
                            <label for="b{{ $row->menu_id }}"></label>
                        </div>
                    </td>

                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_edit[]" class="p_edit" value="{{ $row->menu_id }}"
                                id="e{{ $row->menu_id }}">
                            <label for="e{{ $row->menu_id }}"></label>
                        </div>
                    </td>

                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_delete[]" class="p_delete" value="{{ $row->menu_id }}"
                                id="d{{ $row->menu_id }}">
                            <label for="d{{ $row->menu_id }}"></label>
                        </div>
                    </td>
                </tr>
            @else
                <tr>
                    <td>{{ $row->menu_id }}
                        <div class="icheck-primary">
                            <input type="text" name="m_id[]" class="p_id" value="{{ $row->menu_id }}"
                                id="{{ $row->menu_id }}">
                        </div>
                    </td>
                    <td>{{ $row->menu_name }}</td>
                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_view[]" class="p_view" value="{{ $row->menu_id }}"
                                id="v{{ $row->menu_id }}">
                            <label for="v{{ $row->menu_id }}"></label>
                        </div>
                    </td>
                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_booking[]" class="p_booking" value="{{ $row->menu_id }}"
                                id="b{{ $row->menu_id }}">
                            <label for="b{{ $row->menu_id }}"></label>
                        </div>
                    </td>
                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_edit[]" class="p_edit" value="{{ $row->menu_id }}" id="e{{ $row->menu_id }}">
                            <label for="e{{ $row->menu_id }}"></label>
                        </div>
                    </td>

                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_delete[]" class="p_delete" value="{{ $row->menu_id }}"
                                id="d{{ $row->menu_id }}">
                            <label for="d{{ $row->menu_id }}"></label>
                        </div>
                    </td>
                </tr>
            @endif
        @endforeach
    </table>

    {!! $data->render() !!}

</div>

</div>
