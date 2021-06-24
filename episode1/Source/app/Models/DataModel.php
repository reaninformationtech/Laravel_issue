<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use DB;

class DataModel extends Model
{
    use HasFactory;


    public function getmenu(){
        $menu=DB::select('select * from tbl_left_menu where menu_inactive = ?', ['0']);
        $submenu=DB::select('select * from tbl_sub_left_menu where sub_inactive = ?', ['0']);

        return ['menu'=>$menu,'submenu'=>$submenu];
    }
}
