<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Routing\Route as IlluminateRoute;
use App\Http\Requests\CaseInsensitiveUriValidator;
use Illuminate\Routing\Matching\UriValidator;

use App\Http\Controllers\Admin\AdminController;
use App\Http\Controllers\Admin\SettingController;
use App\Http\Controllers\Admin\PosController;
use App\Http\Controllers\Admin\Pos_ReportController;
use App\Http\Controllers\Admin\LandController;
use App\Http\Controllers\Admin\PostController;
use App\Http\Controllers\ComboController;

/* Allow user can use URL lowercase or upper case  */

    $validators = IlluminateRoute::getValidators();
    $validators[] = new CaseInsensitiveUriValidator;
    IlluminateRoute::$validators = array_filter($validators, function($validator) {
    return get_class($validator) != UriValidator::class;
    });
/* End Allow user can use URL lowercase or upper case  */

Route::get('/', function () {
    Auth::guard('admin')->logout();
    session()->forget('userinfo');
    return redirect('/login');
});
Auth::routes();



// Route for sytem login

Route::middleware(['guest:admin','PreventBackHistory'])->group(function () {
    Route::get('/register',[AdminController::class,'register'])->name('register');
    Route::get('/login',[AdminController::class,'login'])->name('login');
    Route::get('/forgot',[AdminController::class,'forgot'])->name('forgot');
    Route::post('/createuser',[AdminController::class,'registeruser'])->name('createuser');
    Route::post('/userauth',[AdminController::class,'userauth'])->name('userauth');

    Route::get('/auto_permission',[AdminController::class,'auto_permission'])->name('auto_permission');


});

Route::middleware(['auth:admin','PreventBackHistory'])->group(function(){
    Route::get('/adminpage',[AdminController::class,'index'])->name('adminpage');
    Route::get('/logout',[AdminController::class,'logout'])->name('logout');

    //Route::get('/auto_permission', [App\Http\Controllers\AdminController::class, 'auto_permission'])->name('auto_permission');
    Route::post('/autocomplete/fetch', [PosController::class,'product_auto'])->name('autocomplete.fetch');
    Route::post('/customer_auto', [PosController::class,'customer_auto'])->name('autocomplete.customer_auto');
    Route::get('/autosearch/fetch', [PosController::class,'Autocomplete'])->name('autosearch.fetch');


    // menu_permission
    Route::get('/menu_permission', [AdminController::class,'menu_permission'])->name('menu_permission');
    Route::post('/add_menu_permission',[AdminController::class,'add_menu_permission'])->name('menu-permission.add_menu_permission');
    Route::get('/menu-permission/permission_list/{id}', [AdminController::class,'permission_list'])->name('permission_list');
    Route::get('/Admin/permission_fetch_data', [AdminController::class,'permission_fetch_data'])->name('permission_fetch_data');

    // admin_menu
    Route::get('/admin_menu',[AdminController::class,'admin_menu'])->name('admin_menu');
    Route::post('/admin-menu/add_main_menu',[AdminController::class,'add_main_menu'])->name('admin-menu.add_main_menu');
    Route::get('/admin-menu/{id}/menu_edit', [AdminController::class,'menu_edit'])->name('menu_edit');
    Route::get('/Admin/main_fetch_data', [AdminController::class,'main_fetch_data'])->name('main_fetch_data');
    Route::get('/admin-menu/delete_main_menu/{id}',[AdminController::class,'delete_main_menu'])->name('delete_main_menu');

    Route::get('/Admin/fetch_data', [AdminController::class,'fetch_data'])->name('fetch_data');


    /// sub_menu
    Route::get('/sub_menu',[AdminController::class,'sub_menu'])->name('sub_menu');
    Route::post('/sub-menu/add_sub_menu',[AdminController::class,'add_sub_menu'])->name('sub-menu.add_sub_menu');
    Route::get('/sub-menu/{id}/sub_edit',[AdminController::class,'sub_edit'])->name('sub_edit');
    Route::get('/sub-menu/delete_sub_menu/{id}',[AdminController::class,'destroy_sub_menu'])->name('destroy_sub_menu');

    /// create_system
    Route::get('/create_system', [AdminController::class,'create_system'])->name('create_system');
    Route::post('/create-system/add_create_system',[AdminController::class,'add_create_system'])->name('create-system.add_create_system');
    Route::get('/create-system/{id}/create_system_edit',[AdminController::class,'create_system_edit'])->name('create_system_edit');
    Route::get('/Admin/system_fetch_data',[AdminController::class,'system_fetch_data'])->name('system_fetch_data');
    Route::get('/create-system/delete_system/{id}',[AdminController::class,'delete_system'])->name('delete_system');


    // setupbranch

    Route::get('/setupbranch',[SettingController::class,'setupbranch'])->name('setupbranch');
    Route::get('/add_setupbranch', [SettingController::class, 'setupbranchnew'])->name('setupbranch');
    Route::get('/setupbranch/{id}', [SettingController::class,'setupbranch_view'])->name('setupbranch');
    Route::post('/setupbranch_edit', [SettingController::class,'setupbranch_edit'])->name('setup-branch.setupbranch_edit');
    Route::get('/setupbranch/branch_fetch_data', [SettingController::class,'branch_fetch_data'])->name('branch_fetch_data');

    // setupbranch
    Route::get('/setupuser', [SettingController::class,'setupuser'])->name('setupuser');
    Route::post('/setup-user/register_user',[SettingController::class,'register_user'])->name('setup-user.register_user');
    Route::get('/setupuser/user_fetch_data', [SettingController::class,'user_fetch_data'])->name('user_fetch_data');
    Route::get('/setup-user/{id}/register_user_edit', [SettingController::class,'register_user_edit'])->name('register_user_edit');
    Route::post('/setup-user/register_resetpwd', [SettingController::class,'register_resetpwd'])->name('setup-user.register_resetpwd');

    // setup_profile Setting
    Route::get('/setup_profile', [SettingController::class,'setup_profile'])->name('setup_profile');
    Route::post('/setup-profile/add_setup_profile',[SettingController::class,'add_setup_profile'])->name('setup-profile.add_setup_profile');
    Route::get('/setup-profile/delete_profile/{id}',[SettingController::class,'delete_profile'])->name('delete_profile');
    Route::get('/setup-profile/{id}/profile_edit',[SettingController::class,'profile_edit'])->name('profile_edit');
    Route::get('/Admin/profile_fetch_data', [SettingController::class,'profile_fetch_data'])->name('profile_fetch_data');

    // setuser_permission SettingController
    Route::get('/setuser_permission',[SettingController::class,'setuser_permission'])->name('setuser_permission');
    Route::get('/setuser-permission/permission_by_branch/{id}', [SettingController::class,'permission_by_branch'])->name('permission_by_branch');
    Route::post('/add_setuser_permission', [SettingController::class,'add_setuser_permission'])->name('setuser-permission.add_setuser_permission');


    // set all_permission SettingController
    Route::get('/setup_permission',[SettingController::class,'setup_permission'])->name('setup_permission');
    Route::get('/setup_permission_check/{systemid}/{profileid}', [SettingController::class,'setup_permission_check'])->name('setup_permission_check');
    Route::post('/add_setup_permission', [SettingController::class,'add_setup_permission'])->name('setup-permission.add_setup_permission');
    Route::get('/setup_permission_fetch/{id}', [SettingController::class,'setup_permission_fetch'])->name('setup_permission_fetch');

    // set userprofile SettingController
    Route::get('/userprofile',[SettingController::class,'userprofile'])->name('userprofile');
    Route::post('/userprofile/upload',[SettingController::class,'userprofileimage'])->name('userprofile.profileimage');
    Route::post('setting/add_userprofile',[SettingController::class,'add_userprofile'])->name('setting.add_userprofile');
    Route::post('setting/resetpassword',[SettingController::class,'resetpassword'])->name('setting.resetpassword');


    // Add add_customer PosController
    Route::get('/add_customer', [PosController::class,'customer'])->name('add_customer');
    Route::post('/add_customer', [PosController::class,'add_customer'])->name('pos-customer.add_customer');
    Route::get('/customer_list/{search}', [PosController::class,'customer_list'])->name('add_customer');
    Route::get('/customer_view/{id}', [PosController::class,'customer_view'])->name('add_customer');
    Route::get('/customer_delete/{id}', [PosController::class,'customer_delete'])->name('add_customer');


    // Add product PosController
    Route::get('/registerproduct', [PosController::class,'registerproduct'])->name('registerproduct');
    Route::post('/pos-product/add_pos_product', [PosController::class,'add_pos_product'])->name('pos-product.add_pos_product');
    Route::get('/pos_product_list/{search}', [PosController::class,'pos_product_list'])->name('registerproduct');
    Route::get('/pos_product_view/{id}', [PosController::class,'pos_product_view'])->name('registerproduct');
    Route::get('/pos-product/delete_pos_product/{id}', [PosController::class,'delete_pos_product'])->name('delete_pos_product');

    // Add supply PosController
    Route::get('/supplier', [PosController::class,'supplier'])->name('supplier');
    Route::post('/pos-supplier/add_pos_supplier', [PosController::class,'add_pos_supplier'])->name('pos-supplier.add_pos_supplier');
    Route::get('/pos/pos_supplier_list', [PosController::class,'pos_supplier_list'])->name('pos_supplier_list');
    Route::get('/pos/pos_supplier_booking',  [PosController::class,'pos_supplier_booking'])->name('pos_supplier_booking');

    Route::get('/register_supply', [PosController::class,'register_supply'])->name('register_supply');
    Route::get('/supply_list/{search}', [PosController::class,'supply_list'])->name('register_supply');
    Route::get('/supply_view/{id}', [PosController::class,'supply_view'])->name('register_supply');
    Route::get('/pos-supply/delete_pos_supply/{id}', [PosController::class,'delete_pos_supply'])->name('delete_pos_supply');


    // product_instock PosController
    Route::get('/product_instock',  [PosController::class,'product_instock'])->name('product_instock');
    Route::get('/get_instock', [PosController::class,'get_instock'])->name('get_instock');
    Route::get('/pos_in_stock_history/{id}', [PosController::class,'pos_in_stock_history'])->name('product_instock');

    // POS PosController
    Route::get('/pos_pos', [PosController::class,'pos'])->name('pos_pos');
    Route::post('/insert', [PosController::class,'insert'] )->name('pos.insert');
    Route::get('/menu', [PosController::class,'menu'])->name('menu');
    Route::get('/pos/pos_line_fetch_data', [PosController::class,'pos_line_fetch_data'])->name('pos_line_fetch_data');
    Route::get('/pos/pos_line_search_data/{search}', [PosController::class,'pos_line_search_data'])->name('pos_line_search_data');

    // pos
    Route::get('/pos_invoices/{id}',[PosController::class,'pos_invoices'])->name('pos_pos');
    Route::get('/pos_invoice_list/{search}', [PosController::class,'pos_invoice_list'])->name('pos_pos');
    Route::get('/pos_invoice_view/{id}', [PosController::class,'pos_invoice_view'])->name('pos_pos');
    Route::get('/pos_authorize_invoice/{id}', [PosController::class,'pos_authorize_invoice'])->name('pos_pos');
    Route::get('/pos_invoice_delete/{id}', [PosController::class,'pos_invoice_delete'])->name('pos_pos');

    Route::get('/pos_in_stock_history', [PosController::class,'pos_in_stock_history'])->name('pos');
    Route::get('/pos_invoices_pdf/{id}', [PosController::class,'pos_invoices_pdf'])->name('pos');
    Route::get('/pos_invoices_show/{id}', [PosController::class,'pos_invoices_show'])->name('pos');


    Route::get('/pos/{id}/product_info',  [PosController::class,'product_info'])->name('product_info');
    Route::get('/pos/{id}/customer_info', [PosController::class,'customer_info'])->name('customer_info');
    Route::post('/pos/pos_invoice', [PosController::class,'pos_invoice'])->name('pos.pos_invoice');


    /// Pos return_pos PosController
    Route::get('/return_pos',[PosController::class,'return_pos'] )->name('return_pos');
    Route::POST('/add_return_pos', [PosController::class,'add_return_pos'])->name('pos.add_return_pos');
    Route::get('/pos_return_pos_list/{search}', [PosController::class,'pos_return_pos_list'])->name('return_pos');
    Route::get('/pos_return_pos_view/{id}', [PosController::class,'pos_return_pos_view'])->name('return_pos');
    Route::POST('/pos_authorize_return_pos', [PosController::class,'pos_authorize_return_pos'])->name('return_pos');
    Route::get('/pos_delete_return_pos', [PosController::class,'pos_delete_return_pos'])->name('return_pos');


    /// Pos count stock  PosController
    Route::get('/pos_countstock', [PosController::class,'pos_countstock'] )->name('pos_countstock');
    Route::POST('/countstock', [PosController::class,'countstock'])->name('pos.countstock');
    Route::get('/pos_countstock_list/{search}', [PosController::class,'pos_countstock_list'])->name('pos_countstock');
    Route::get('/pos_countstock_view/{id}', [PosController::class,'pos_countstock_view'])->name('pos_countstock');
    Route::POST('/pos_authorize_count_stock', [PosController::class,'pos_authorize_count_stock'])->name('pos_authorize_count_stock');
    Route::get('/pos_delete_count_stock', [PosController::class,'pos_delete_count_stock'])->name('pos_countstock');


    //pos_stock_transfer PosController

    Route::get('/pos_stock_transfer', [PosController::class,'pos_stock_transfer'])->name('pos_stock_transfer');
    Route::POST('/add_pos_stock_transfer', [PosController::class,'add_pos_stock_transfer'])->name('pos.add_pos_stock_transfer');
    Route::get('/pos_stock_transfer_list/{search}',  [PosController::class,'pos_stock_transfer_list'])->name('pos_stock_transfer');
    Route::get('/pos_stock_transfer_view/{id}', [PosController::class,'pos_stock_transfer_view'])->name('pos_stock_transfer');
    Route::get('/pos_authorize_stock', [PosController::class,'pos_authorize_stock'])->name('pos_stock_transfer');
    Route::get('/pos_delete_stock_transfer', [PosController::class,'pos_delete_stock_transfer'])->name('pos_stock_transfer');

    //purchase_order PosController
    Route::get('/purchase_order', [PosController::class,'purchase_order'])->name('purchase_order');
    Route::post('/add_purchase_order', [PosController::class,'add_purchase_order'])->name('purchase-order.add_purchase_order');
    Route::get('/purchase_order_list/{search}', [PosController::class,'purchase_order_list'])->name('purchase_order');
    Route::get('/purchase_view/{id}', [PosController::class,'purchase_view'])->name('purchase_order');
    Route::get('/purchase-order/purchase_order_delete/{id}',[PosController::class,'purchase_order_delete'])->name('purchase_order');
    Route::get('/purchase-order/purchase_order_authorize/{id}', [PosController::class,'purchase_order_authorize'])->name('purchase_order');


    /// Pos expense
    Route::get('/pos_expense', [PosController::class,'pos_expense'])->name('pos_expense');
    Route::post('/pos/pos_add_expense', [PosController::class,'pos_add_expense'] )->name('pos.pos_add_expense');
    Route::get('/pos_expense_list/{search}', [PosController::class,'pos_expense_list'] )->name('pos_expense');
    Route::get('/pos_expense_view/{id}', [PosController::class,'pos_expense_view'] )->name('pos_expense');
    Route::POST('/pos_authorize_expense', [PosController::class,'pos_authorize_expense'] )->name('pos_authorize_expense');
    Route::get('/pos_delete_expense', [PosController::class,'pos_delete_expense'])->name('pos_delete_expense');


    /// Pos expense
    Route::get('/pos_income', [PosController::class,'pos_income'])->name('pos_income');
    Route::post('/pos/pos_add_income', [PosController::class,'pos_add_income'] )->name('pos.pos_add_income');
    Route::get('/pos_income_list/{search}', [PosController::class,'pos_income_list'])->name('pos_income');
    Route::get('/pos_income_view/{id}', [PosController::class,'pos_income_view'] )->name('pos_income');
    Route::POST('/pos_authorize_income', [PosController::class,'pos_authorize_income'] )->name('pos_authorize_income');
    Route::get('/pos_delete_income', [PosController::class,'pos_delete_income'])->name('pos_income');


    // pos_line PosController
    Route::get('/pos_line', [PosController::class,'pos_line'] )->name('pos_line');
    Route::post('/pos-line/add_pos_line', [PosController::class,'add_pos_line'] )->name('pos-line.add_pos_line');
    Route::get('/pos-line/{id}/edit_pos_line', [PosController::class,'edit_pos_line'] )->name('edit_pos_line');
    Route::get('/pos-line/delete_pos_line/{id}', [PosController::class,'delete_pos_line'])->name('delete_pos_line');


    // POS get report
    Route::get('/rpt_pos_product_in_stock', [Pos_ReportController::class,'pos_report'])->name('rpt_pos_product_in_stock');
    Route::post('/rpt_get_pos_product_in_stock',[Pos_ReportController::class,'rpt_get_pos_product_in_stock'])->name('pos_report.rpt_get_pos_product_in_stock');

    Route::get('/rpt_pos_sold_out', [Pos_ReportController::class,'rpt_pos_sold_out'])->name('rpt_pos_sold_out');
    Route::post('/rpt_get_pos_sold_out', [Pos_ReportController::class,'rpt_get_pos_sold_out'])->name('pos_report.rpt_get_pos_sold_out');


    Route::get('/rpt_pos_income', [Pos_ReportController::class,'rpt_pos_income'])->name('rpt_pos_income');
    Route::post('/rpt_get_pos_income',[Pos_ReportController::class,'rpt_get_pos_income'])->name('pos_report.rpt_get_pos_income');
    Route::get('/rpt_pos_income_img',[Pos_ReportController::class,'rpt_pos_income_img'])->name('rpt_pos_income_img');


    Route::get('/rpt_pos_expense',[Pos_ReportController::class,'rpt_pos_expense'])->name('rpt_pos_expense');
    Route::post('/rpt_get_pos_expense', [Pos_ReportController::class,'rpt_get_pos_expense'])->name('pos_report.rpt_get_pos_expense');
    Route::get('/rpt_pos_expense_img', [Pos_ReportController::class,'rpt_pos_expense_img'])->name('rpt_pos_expense_img');


    Route::get('/rpt_pos_purchase', [Pos_ReportController::class,'rpt_pos_purchase'] )->name('rpt_pos_purchase');
    Route::post('/rpt_get_pos_purchase', [Pos_ReportController::class,'rpt_get_pos_purchase'])->name('pos_report.rpt_get_pos_purchase');

    Route::get('/rpt_pos_count_stock',[Pos_ReportController::class,'rpt_pos_count_stock'])->name('rpt_pos_count_stock');
    Route::post('/rpt_get_pos_count_stock', [Pos_ReportController::class,'rpt_get_pos_count_stock'])->name('pos_report.rpt_get_pos_count_stock');


    Route::get('/rpt_pos_stock_transfer', [Pos_ReportController::class,'rpt_pos_stock_transfer'])->name('rpt_pos_stock_transfer');
    Route::post('/rpt_get_pos_stock_transfer',[Pos_ReportController::class,'rpt_get_pos_stock_transfer'] )->name('pos_report.rpt_get_pos_stock_transfer');

    Route::get('/rpt_pos_monthly_closing',[Pos_ReportController::class,'rpt_pos_monthly_closing'])->name('rpt_pos_monthly_closing');
    Route::post('/rpt_get_pos_monthly_closing',[Pos_ReportController::class,'rpt_get_pos_monthly_closing'])->name('pos_report.rpt_get_pos_monthly_closing');

    Route::get('/rpt_pos_sold_out_return',[Pos_ReportController::class,'rpt_pos_sold_out_return'])->name('rpt_pos_sold_out_return');
    Route::post('/rpt_get_pos_sold_out_return', [Pos_ReportController::class,'rpt_get_pos_sold_out_return'])->name('pos_report.rpt_get_pos_sold_out_return');

    // Controller LandController

    Route::get('/land_line', [LandController::class,'land_line'])->name('land_line');
    Route::post('/land-line/add_land_line', [LandController::class,'add_land_line'])->name('land-line.add_land_line');
    Route::get('/land-line/land_line_fetch_data/{type}',[LandController::class,'land_line_fetch_data'])->name('land_line_fetch_data');

    Route::get('/land-line/{id}/land_line_edit/{type}', [LandController::class,'land_line_edit'])->name('land_line_edit');
    Route::get('/land-line/delete_land_line/{id}',  [LandController::class,'delete_land_line'])->name('delete_land_line');

    // Controller LandController Land

    Route::get('/registerland', [LandController::class,'registerland'])->name('registerland');
    Route::post('/register-land/add_registerland', [LandController::class,'add_registerland'] )->name('register-land.add_registerland');
    Route::get('/land_list/{search}', [LandController::class,'registerland_list'] )->name('registerland');
    Route::get('/delete_registerland/{id}', [LandController::class,'delete_registerland'])->name('delete_registerland');
    Route::get('/registerland/{id}', [LandController::class,'registerland_view'])->name('registerland');

    // Controller LandController Customer

    Route::get('/customer_land', [LandController::class,'customer_land'] )->name('customer_land');
    Route::post('/customer-land/add_customer_land', [LandController::class,'add_customer_land'])->name('customer-land.add_customer_land');
    Route::get('/cus_land_list/{search}', [LandController::class,'cus_land_list'])->name('customer_land');
    Route::get('/delete_customer_land/{id}', [LandController::class,'delete_customer_land'])->name('delete_customer_land');
    Route::get('/customer_land/{id}', [LandController::class,'cus_land_view'] )->name('customer_land');

    // Controller LandController Sale land

    Route::get('/sale_land', [LandController::class,'sale_land'])->name('sale_land');
    Route::post('/add_sale_land', [LandController::class,'add_sale_land'])->name('sale-land.add_sale_land');
    Route::get('/sale_land_list/{search}', [LandController::class,'sale_land_list'])->name('sale_land');
    Route::get('/delete_sale_land/{id}', [LandController::class,'delete_sale_land'] )->name('delete_sale_land');
    Route::get('/sale_land/{id}', [LandController::class,'sale_land_view'] )->name('sale_land');

    // Controller LandController Income_land
    Route::get('/income_land', [LandController::class,'income_land'])->name('income_land');
    Route::get('/income-land/income_land_fetch/{type}', [LandController::class,'income_land_fetch'])->name('income_land_fetch');
    Route::post('/expend-land/add_expend_land', [LandController::class,'add_expend_land'])->name('expend-land.add_expend_land');
    Route::get('/expend-land/delete_expend_land/{id}', [LandController::class,'delete_expend_land'])->name('delete_expend_land');

    // tiller
    Route::get('/tiller_land', [LandController::class,'tiller_land'])->name('tiller_land');
    Route::get('/tiller-land/tiller_land_fetch/{type}', [LandController::class,'tiller_land_fetch'])->name('tiller_land_fetch');
    Route::post('add_tiller_land', [LandController::class,'add_tiller_land'])->name('tiller-land.add_tiller_land');


    // POS get image link_file
    Route::get('/pos_exp_file/{filename}',[PosController::class,'pos_exp_file'])->name('pos.pos_exp_file');
    Route::get('/pos_income_file/{filename}', [PosController::class,'pos_income_file'] )->name('pos.pos_income_file');
    Route::get('/img_userprofile/{filename}', [SettingController::class,'img_userprofile'] )->name('img_userprofile');
    Route::get('/id_img_userprofile/{userid}', [SettingController::class,'id_img_userprofile'] )->name('id_img_userprofile');



    Route::get('/quote', [PostController::class,'quote'])->name('quote');
    Route::post('/quote-add/add_quote', [PostController::class,'add_quote'])->name('quote.add_quote');
    Route::get('/quote_list/{search}', [PostController::class,'quote_list'])->name('quote');
    Route::get('/quote_view/{id}', [PostController::class,'quote_view'] )->name('quote');
    Route::get('/delete_quote/{id}', [PostController::class,'delete_quote'] )->name('quote');


    /// Load all combobox Admin
     /// Route::get('/combo_main_menu/{type}', [AdminController::class,'combo_main_menu'])->name('combo_main_menu');
    Route::get('/combo_system/{type}',  [ComboController::class,'combo_admin'])->name('combo_system');
    Route::get('/combo_permission/{type}',  [ComboController::class,'combo_permission'])->name('combo_permission');
    Route::get('/combo_pos_line/{type}', [ComboController::class,'combo_pos_line'])->name('combo_pos_line');
    Route::get('/combo_pos/{type}', [ComboController::class,'combo_pos'])->name('combo_pos');
    Route::get('/combo_inactive',  [ComboController::class,'combo_inactive'])->name('combo_inactive');

    Route::get('/combo_currency',  [ComboController::class,'combo_currency'])->name('combo_currency');
    Route::get('/combo_land_line/{type}', [ComboController::class,'combo_land_line'])->name('combo_land_line');
    Route::get('/combo_price/{id}', [ComboController::class,'combo_price'])->name('combo_price');
    Route::get('/combo_expend/{type}', [ComboController::class,'combo_expend'])->name('combo_expend');

});
