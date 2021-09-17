<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\MenuModel;
class MenuController extends Controller
{
    //

    public function menu(){
        $MenuModel =new MenuModel();
        $menu= $MenuModel->getdata('select * from tblmenu t ;');
        $submenu = $MenuModel->getdata('select * from tblsubmenu t ;');
        return \view('menu',['menu'=> $menu,'submenu' => $submenu]);
    }

}
