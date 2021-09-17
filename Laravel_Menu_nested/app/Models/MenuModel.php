<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use DB;
class MenuModel extends Model
{
    use HasFactory;
    public function getdata($sql){
        return $data=DB::select($sql);
    }

}
