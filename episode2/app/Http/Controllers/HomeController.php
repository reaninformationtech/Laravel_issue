<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\DataModel;
class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        $menu=new DataModel();

        $leftmenu=$menu->getmenu();


        return view('home',$leftmenu);
    }

    public function create_menu (){
        $menu=new DataModel();
        $leftmenu=$menu->getmenu();

        return view('home.create_menu',$leftmenu);
    }

    public function create_user (){
        $menu=new DataModel();
        $leftmenu=$menu->getmenu();

        return view('home.create_user',$leftmenu);
    }
    public function create_pos (){
        $menu=new DataModel();
        $leftmenu=$menu->getmenu();

        return view('home.create_pos',$leftmenu);
    }
}
