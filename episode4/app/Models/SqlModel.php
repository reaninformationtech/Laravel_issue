<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use DB;
use Illuminate\Support\Facades\Route;
use Illuminate\Pagination\LengthAwarePaginator;
class SqlModel extends Model
{
    use HasFactory, Notifiable;

    protected $table = 'gb_sys_branch';

    protected $fillable = [
        'setname',
        'branchname',
        'branchshort',
        'inactive',
        'phone',
        'email',
        'website',
        'address'
    ];



    public function fun_replace($str, $val)
    {
        $v_str=str_replace($val,'',$str);;
        return  $v_str;
    }

    public function str_re($str)
    {
        $v_str=$this->fun_replace($str,'"');
        $v_str=$this->fun_replace($v_str,']');
        $v_str=$this->fun_replace($v_str,'[');
        $v_str=$this->fun_replace($v_str,',');
        $v_str=$this->fun_replace($v_str,'%');
        return  $v_str;
    }

    public function row_number()
    {
        return 10;
    }

    public function proc_get_data($procedure,array $sql)
    {
        $data= DB::select($procedure, $sql);
        return $data;
    }


    public function get_currentRouteName()
    {
        Route::currentRouteName();
        return  Route::currentRouteName();
    }

    public function proc_get_sql_by_branch(array $sql)
    {
        $data= DB::select('CALL proc_get_sql_by_branch(?,?,?,?)', $sql );
        return $data;
    }

    public function proc_get_data_sql(array $sql)
    {
        $data= DB::select('CALL proc_get_sql(?,?)', $sql );
        return $data;
    }

    public function get_reportname($status='',$vreport='')
    {
      $data= DB::select('CALL proc_get_sql(?, ?)',array($status,$vreport));
      return $data;
    }

    public function arrayPaginator($array, $request, $perPage=3)
    {
        $page = request('page', 1);
        //$perPage = 3;
        $offset = ($page * $perPage) - $perPage;
        return new LengthAwarePaginator(
            array_slice($array, $offset, $perPage, true),
            count($array),
            $perPage,
            $page,
            ['path' => $request->url(), 'query' => $request->query()]
        );
    }

    public function arrayPaginator_url($array,$url, $request, $perPage=3)
    {
        $page = request('page', 1);
        $offset = ($page * $perPage) - $perPage;
        return new LengthAwarePaginator(
            array_slice($array, $offset, $perPage, true),
            count($array),
            $perPage,
            $page,
            ['path' => $url, 'query' => $request->query()]
        );
    }

    public function get_menu($status='')
    {
      // code...
      $s_username=$this->s_email();
      $s_userid=$this->s_userid();
      $current_menu=$this->get_currentRouteName();
      $data= DB::select('CALL proc_get_menu_by_user(?, ?, ?, ?)',array($status,$s_userid,$s_username,$current_menu));

      return $data;
    }

    public function get_menu_left()
    {
        $main=$this->get_menu('main');
        $sub=$this->get_menu('sub');
        return ['main'=>$main,'sub'=>$sub];
    }

    public function s_userid()
    {
        $userinfo=\Session::get('userinfo');
        if($userinfo){
            return $userinfo['id'];
        }
        return '';
    }

    public function s_email()
    {
        $userinfo=\Session::get('userinfo');
        if($userinfo){
            return $userinfo['email'];
        }
        return '';
    }

    public function s_name()
    {
        $userinfo=\Session::get('userinfo');
        if($userinfo){
            return $userinfo['name'];
        }
        return '';
    }
    public function s_contact()
    {
        $userinfo=\Session::get('userinfo');
        if($userinfo){
            return $userinfo['contact'];
        }
        return '';
    }


    public function s_branchcode()
    {
        $userinfo=\Session::get('userinfo');
        if($userinfo){
            return $userinfo['branchcode'];
        }
        return '';
    }

    public function s_systemid()
    {
        $userinfo=\Session::get('userinfo');
        if($userinfo){
            return $userinfo['systemid'];
        }
        return '';
    }

    public function s_subofbranch()
    {
        $userinfo=\Session::get('userinfo');
        if($userinfo){
            return $userinfo['subofbranch'];
        }
        return '';
    }

    public function insert_messages($vstatus, $request='')
    {
        $message='';
        if ($vstatus == 'Edit') {
            $message = 'Data has been updated .';
        }elseif  ($vstatus == 'delete') {
            $message = 'Data has been removed .';
        } else {
            $message ='Data has been record .';
        }
        return  $message;
    }

}
