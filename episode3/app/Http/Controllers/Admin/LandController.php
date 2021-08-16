<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SqlModel;
use DB;


class LandController extends Controller
{
    //
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
        $this->AdminModel = new \App\Models\AdminModel();
    }
    protected $AdminModel;

    public function land_line(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL pro_land_get_items(?,?,?)', array('', $s_branchcode, 'Type'));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('land.land_line', ['data' => $notices]);
    }

    public function land_line_fetch_data($type, Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $results = $SqlModel->proc_get_data('CALL pro_land_get_items(?,?,?)', array('', $s_branchcode, $type));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('land.land_line_data', ['data' => $notices])->render();
        }
    }


    public function add_land_line(Request $request)
    {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'txtstatus' => 'required',
            'item_name' => 'required',
            'inactive' => 'required'
        );
        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }

        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->item_name,
            $request->txtstatus,
            $request->inactive,
            $request->remark,
            $request->cboprovince,
            $s_username
        );
        DB::select('Call proc_land_add_items (?, ?, ?,  ?,  ?,  ?,  ?,  ?, ?)', $form_data);
        $message = $SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }


    public function land_line_edit($id, $type, Request $request)
    {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();

            $data = $SqlModel->proc_get_data('CALL pro_land_get_items(?,?,?)', array($id, $s_branchcode, $type));
            $arr = json_decode(json_encode($data), true);

            $array = array(
                'item_id' => $arr[0]['item_id'],
                'branchcode' => $arr[0]['branchcode'],
                'item_name' => $arr[0]['item_name'],
                'item_type' => $arr[0]['item_type'],
                'type' => $arr[0]['type'],
                'item_inactive' => $arr[0]['item_inactive'],
                'item_remark' => $arr[0]['item_remark'],
                'item_location' => $arr[0]['item_location'],
                'id_location' => $arr[0]['id_location']
            );
            return ['data' => $array];
        }
    }

    public function delete_land_line($id, Request $request)
    {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();

            try {
                $SqlModel->proc_get_data('CALL proc_check_sql_land(?,?,?)', array('land_line', $id, $s_branchcode));
            } catch (\Illuminate\Database\QueryException $ex) {
                return response()->json(['errors' => 'This item current in use !']);
            }
            $form_data = array(
                'd_land_line',
                $s_branchcode,
                $id
            );
            DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
            return response()->json(['success' => 'Record has been removed']);
        }
    }

    public function registerland(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $currency = $SqlModel->proc_get_data_sql(array('combo_currency', ''));
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $Plan = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Plan'));
        $Type = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Type'));
        $Street = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Street'));
        $Size = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Size'));
        return view('land.registerland', ['inactive' => $inactive, 'Currency' => $currency, 'Plan' => $Plan, 'Line' => $Type, 'Street' => $Street, 'Size' => $Size]);
    }

    public function add_registerland(Request $request)
    {
        if ($request->action == 'Edit') {
            $status = 'U';
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            try {
                $SqlModel->proc_get_data('CALL proc_check_sql_land(?,?,?)', array('land_sold', $request->hidden_id, $s_branchcode));
            } catch (\Illuminate\Database\QueryException $ex) {
                return response()->json(['errorsold' => 'This item has been sold !']);
            }

        } else {
            $status = 'I';
        }

        $rules = array(
            'name' => 'required',
            'inactive' => 'required',
            'public' => 'required',
            'plan' => 'required',
            'line' => 'required',
            'street' => 'required',
            'size' => 'required',
            'currency' => 'required',
            'cost' => 'required|numeric|min:1',
            'unit_price' => 'required|numeric|min:1'
        );
        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }

        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->currency,
            $request->name,
            $request->plan,
            $request->line,
            $request->size,
            $request->street,
            $request->inactive,
            $request->public,
            $request->cost,
            $request->unit_price,
            $request->remark,
            $s_username
        );
        DB::select('Call proc_land_register (?, ?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, ?, ?)', $form_data);
        $message = $SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }
    public function registerland_view($id)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $currency = $SqlModel->proc_get_data_sql(array('combo_currency', ''));
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $Plan = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Plan'));
        $Type = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Type'));
        $Street = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Street'));
        $Size = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, 'Size'));
        $data = $SqlModel->proc_get_data('CALL proc_land_get_register_items(?,?)', array($id, $s_branchcode));
        return view('land.registerland_view', ['inactive' => $inactive, 'Currency' => $currency, 'Plan' => $Plan, 'Line' => $Type, 'Street' => $Street, 'Size' => $Size, 'data' => $data]);
    }

    public function registerland_list(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_land_get_register_items(?,?)', array('', $s_branchcode));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('land.registerland_data', ['data' => $notices])->render();
    }


    public function delete_registerland($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        try {
            $SqlModel->proc_get_data('CALL proc_check_sql_land(?,?,?)', array('land_sold', $id, $s_branchcode));
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => 'This item has been sold !']);
        }
        $form_data = array(
            'registerland',
            $id
        );
        DB::select('CALL proc_delete_trans(?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function customer_land(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $gender = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('gender', $s_branchcode, 'gender'));
        return view('land.customer_land', ['Inactive' => $inactive, 'Gender' => $gender]);
    }

    public function cus_land_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $gender = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('gender', $s_branchcode, 'gender'));
        $results = $SqlModel->proc_get_data('CALL proc_land_get_customers(?,?)', array($id, $s_branchcode));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('land.customer_view', ['data' => $notices, 'Inactive' => $inactive, 'Gender' => $gender]);
    }

    public function cus_land_list(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_land_get_customers(?,?)', array('', $s_branchcode));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('land.customer_data', ['data' => $notices]);
    }

    public function add_customer_land(Request $request)
    {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'name' => 'required',
            'gender' => 'required',
            'inactive' => 'required',
            'phone' => 'required',
            'email' => 'required',
            'address' => 'required'
        );
        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->name,
            $request->gender,
            $request->inactive,
            $request->phone,
            $request->email,
            $request->address,
            $request->remark,
            $s_username
        );


        DB::select('Call proc_land_add_customers (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
        $message = $SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }

    public function delete_customer_land($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        try {
            $SqlModel->proc_get_data('CALL proc_check_sql_land(?,?,?)', array('land_customer', $id, $s_branchcode));
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errorsold' => 'Customer has been use !']);
        }

        $form_data = array(
            'customer_land',
            $id
        );

        DB::select('CALL proc_delete_trans(?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }


    public function sale_land(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $cus = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_cus_land', '', $s_branchcode, ''));
        $percentage = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_percentage', '', $s_branchcode, ''));
        $land = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_sale', '', $s_branchcode, ''));
        $land_list = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('list_land_sale', '', $s_branchcode, ''));
        $notices = $SqlModel->arrayPaginator($land, $request, $SqlModel->row_number());

        $data = ['data' => $notices, 'cus' => $cus, 'percentage' => $percentage, 'land_list' => $land_list];
        return view('land.sale_land', $data);
    }

    public function sale_land_list(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $land = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_sale', '', $s_branchcode, ''));
        $notices = $SqlModel->arrayPaginator($land, $request, $SqlModel->row_number());
        $data = ['data' => $notices];
        return view('land.sale_data', $data);
    }

    public function sale_land_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $cus = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_cus_land', '', $s_branchcode, ''));
        $percentage = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_percentage', '', $s_branchcode, ''));
        $land = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_sale', $id, $s_branchcode, ''));
        $land_list = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('list_land_sale', '', $s_branchcode, ''));
        $notices = $SqlModel->arrayPaginator($land, $request, $SqlModel->row_number());

        $data = ['data' => $notices, 'cus' => $cus, 'percentage' => $percentage, 'land_list' => $land_list];
        return view('land.sale_land_view', $data);
    }

    public function add_sale_land(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
            try {
                $SqlModel->proc_get_data('CALL proc_check_sql_land(?,?,?)', array('land_sold', $request->land, $s_branchcode));
            } catch (\Illuminate\Database\QueryException $ex) {
                return response()->json(['errorexsit' => 'This item has been sold !']);
            }
        }

        $rules = array(
            'cus_name' => 'required',
            'land' => 'required',
            'discount' => 'required',
            'price' => 'required',
            'saleprice' => 'required'
        );

        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->cus_name,
            $request->land,
            $request->price,
            $request->discount,
            $request->saleprice,
            $request->remark,
            $s_username
        );
        DB::select('Call  proc_land_sale (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?, ?)', $form_data);
        $message = $SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }


    public function delete_sale_land($id, Request $request)
    {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $form_data = array(
                'd_sale_land',
                $s_branchcode,
                $id
            );
            DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
            return response()->json(['success' => 'delete successfully.']);
        }
    }

    public function add_expend_land(Request $request)
    {

        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'txtstatus' => 'required',
            'cbotype' => 'required',
            'referent' => 'required',
            'currency' => 'required',
            'amount' => 'required'
        );
        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->cbotype,
            $request->referent,
            $request->currency,
            $request->amount,
            $request->remark,
            $s_username
        );

        DB::select('Call proc_land_add_expend (?, ?, ?,  ?,  ?,  ?,  ?,  ?, ?)', $form_data);
        $message = $SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }

    public function delete_expend_land($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        try {
            $SqlModel->proc_get_data('CALL proc_check_sql_land(?,?,?)', array('income_exp', $id, $s_branchcode));
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => 'The record has been posted in till !']);
        }
        $form_data = array(
            'expend_land',
            $id
        );
        DB::select('CALL proc_delete_trans(?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function income_land(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_land_get_customers(?,?)', array('', $s_branchcode));
        $cus = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_cus_land', '', $s_branchcode, ''));
        $percentage = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_percentage', '', $s_branchcode, ''));
        $land = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_sale', '', $s_branchcode, ''));

        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        $data = ['data' => $notices, 'cus' => $cus, 'percentage' => $percentage, 'land' => $land];
        return view('land.income_land', $data, ['data' => $notices]);
    }

    public function income_land_fetch($type, Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $results = $SqlModel->proc_get_data('CALL proc_land_load_expend(?,?,?)', array('', $s_branchcode, $type));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('land.income_land_data', ['data' => $notices])->render();
        }
    }

    public function tiller_land(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_get_sql_land_payments(?,?,?,?)', array('tiller', $s_branchcode, '', ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        $data = ['data' => $notices];
        return view('land.tiller_land', $data, ['data' => $notices]);
    }

    public function tiller_land_fetch($type, Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $results = $SqlModel->proc_get_data('CALL proc_get_sql_land_payments(?,?,?,?)', array('tiller', $s_branchcode, '', ''));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('land.tiller_land_data', ['data' => $notices])->render();
        }
    }

    public function add_tiller_land(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $s_username = $SqlModel->s_email();

            $inputArray = $request->all();
            $arr_data = json_decode(json_encode($inputArray['arr_data']), true);
            $data = $SqlModel->str_re(explode(',', $arr_data));

            $_token = uniqid();

            foreach ($data as $parr) {
                $arr = explode('_', $parr);
                $form_data = array(
                    'tiller',
                    $s_branchcode,
                    $arr[0],
                    $arr[1],
                    $_token,
                    $s_username
                );
                DB::select('Call proc_pos_land_tiller (?, ?, ?,  ?,  ?,  ?)', $form_data);
            }

            $datapost = array(
                'Auth_tiller',
                $s_branchcode,
                '',
                '',
                $_token,
                $s_username
            );
            DB::select('Call proc_pos_land_tiller (?, ?, ?,  ?,  ?,  ?)', $datapost);

            $message = $SqlModel->insert_messages($request->action);
            return response()->json(['success' =>  $message]);
        }
    }
}
