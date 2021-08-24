<div class="table-responsive">
<table class="table table-striped table-valign-middle" id="MenuList" >
                <thead>
                    <tr>
                        <th ><input type="checkbox"  id="select_all" /> all</th>
                        <th>Item</th>
                        <th>ID</th>
                        <th>Currency</th>
                        <th>Price</th>
                        <th>Date</th>
                        <th>Referent</th>
                    </tr>
                </thead>
                <tbody>

                @foreach($data as $row)
                <tr>
                    <td>
                        <div class="icheck-primary">
                            <input type="checkbox" name="m_view[]" class="p_view" value="" id="v{{ $row->exp_id }}">
                            <label for="v{{ $row->exp_id }}"></label>
                        </div>
                    </td>
                    <td>{{ $row->exp_id}}</td>
                    <td>{{ $row->item_name }}</td>
                    <td>{{ $row->currency }}</td>
                    <td>{{ $row->amount }}</td>
                    <td>{{ $row->exp_date }}</td>
                    <td>{{ $row->exp_referent }}</td>
                </tr>
                @endforeach

    </tbody>
</table>
{{ $data->links('vendor.pagination.custom') }}
</div>