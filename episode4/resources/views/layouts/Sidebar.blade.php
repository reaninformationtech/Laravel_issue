<!-- Sidebar -->
<div class="sidebar">
    <!-- Sidebar Menu -->
    <nav class="mt-2">
        <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
            @foreach ($main as $item => $data)
                @if ($data->menu_id == $data->current_menu_id)
                    <li class="nav-item menu-open">
                        <a href="#" class="nav-link active">
                            <i class="{{ $data->menu_glyphicon1 }}"></i>
                            <p>
                                {{ $data->menu_name }}
                                <i class="right fas fa-angle-left"></i>
                            </p>
                        </a>
                        <ul class="nav nav-treeview">
                            @foreach ($sub as $key => $subdata)
                                @if ($data->menu_id == $subdata->menu_id and $subdata->subm_id == $subdata->current_sub_id)
                                    <li class="nav-item">
                                        <a href="{{ url($subdata->subm_function) }}" class="nav-link active">
                                            <i class="far fa-circle nav-icon"></i>
                                            <p>{{ $subdata->subm_name }}</p>
                                        </a>
                                    </li>
                                @elseif ($data->menu_id == $subdata->menu_id)
                                    <li class="nav-item">
                                        <a href="{{ url($subdata->subm_function) }}" class="nav-link">
                                            <i class="far fa-circle nav-icon"></i>
                                            <p>{{ $subdata->subm_name }}</p>
                                        </a>
                                    </li>
                                @endif
                            @endforeach
                        </ul>
                    </li>
                @else
                    <li class="nav-item">
                        <a href="#" class="nav-link">
                            <i class="nav-icon fas fa-copy"></i>
                            <p>
                                {{ $data->menu_name }}
                                <i class="fas fa-angle-left right"></i>
                            </p>
                        </a>
                        <ul class="nav nav-treeview">
                            @foreach ($sub as $key => $subdata)
                                @if ($data->menu_id == $subdata->menu_id)
                                    @if (Str::limit($subdata->subm_function, 3, '') == 'rpt')
                                        <li class="nav-item">
                                            <a href="{{ url($subdata->subm_function) }}" class="nav-link"
                                                target="_blank">
                                                <i class="far fa-circle nav-icon"></i>
                                                <p>{{ $subdata->subm_name }}</p>
                                            </a>
                                        </li>
                                    @else
                                        <li class="nav-item">
                                            <a href="{{ url($subdata->subm_function) }}" class="nav-link">
                                                <i class="far fa-circle nav-icon"></i>
                                                <p>{{ $subdata->subm_name }}</p>
                                            </a>
                                        </li>
                                    @endif
                                @endif
                            @endforeach
                        </ul>
                    </li>
                @endif
            @endforeach

            <li class="nav-item">
                <a href="{{ url('/logout') }}" class="nav-link">
                    <i class="nav-icon fa fa-unlock"></i>
                    <p>
                        Logout
                        <span class="right badge badge-danger">exit </span>
                    </p>
                </a>
            </li>
        </ul>
    </nav>
    <!-- /.sidebar-menu -->
</div>
<!-- /.sidebar -->
