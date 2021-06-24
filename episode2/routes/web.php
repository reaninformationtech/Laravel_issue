<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\HomeController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');

Auth::routes();

Route::get('/home', [App\Http\Controllers\HomeController::class, 'index'])->name('home');
Route::get('/create_menu', [App\Http\Controllers\HomeController::class, 'create_menu'])->name('create_menu');
Route::get('/create_user', [App\Http\Controllers\HomeController::class, 'create_user'])->name('create_user');
Route::get('/create_pos', [App\Http\Controllers\HomeController::class, 'create_pos'])->name('create_pos');

