<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Http\Request;
use App\Models\SqlModel;

class MenuProvider extends ServiceProvider
{
    /**
     * Register services.
     *
     * @return void
     */
    public function register()
    {
        /*
        view()->composer('*', function ($view) 
        {
             $ss=\Session::get('userinfo');
             dd($ss);
        });  
        */

         view()->composer('*', function($view){
            $menu=new SqlModel();
            $s_userid=$menu->s_userid();

            if ($s_userid){
                $leftmenu=$menu->get_menu_left();
                return $view->with($leftmenu);
            }
            return $view;
        });
    }

    /**
     * Bootstrap services.
     *
     * @return void
     */
    public function boot()
    {
        //

        
    }
}
