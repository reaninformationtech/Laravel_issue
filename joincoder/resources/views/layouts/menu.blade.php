
@foreach ($menu as $item=>$value)


    <li class="nav-item">
        <a href="#" class="nav-link">
        <i class="nav-icon fas fa-tachometer-alt"></i>
        <p>
            {{$value->menu_name}}
            <i class="right fas fa-angle-left"></i>
        </p>
        </a>
        <ul class="nav nav-treeview">
            @foreach ($submenu as $key=>$sub)

                @if($value->menu_id==$sub->menu_id)

                <li class="nav-item">
                    <a href="#" class="nav-link">
                    <i class="far fa-circle nav-icon"></i>
                    <p>{{$sub->sub_name}}</p>
                    </a>
                </li>

                @endif

            @endforeach

        </ul>
    </li>

    @endforeach
