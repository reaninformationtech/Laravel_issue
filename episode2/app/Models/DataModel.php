<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use DB;
use Route;

class DataModel extends Model
{
    use HasFactory;


    public function getmenu(){
        $Routname=Route::currentRouteName();

        $menu=DB::select('select * from tbl_left_menu where menu_inactive = ?', ['0']);
        $submenu=DB::select('select * from tbl_sub_left_menu where sub_inactive = ?', ['0']);
        $menuid=DB::select('select menu_id from tbl_sub_left_menu where frmaction = ?', [$Routname]);
        $subid=DB::select('select sub_id from tbl_sub_left_menu where frmaction = ?', [$Routname]);

        return ['menu'=>$menu,'submenu'=>$submenu,'menuid'=>$menuid ,'subid'=>$subid];
    }
}
