<?php

namespace App\Http\Controllers\Admin;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SqlModel;
use DB;
use Illuminate\Support\Facades\Storage;
use Response;
use Validator;
class PosController extends Controller
{
    //
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    function product_auto(Request $request)
    {
        if ($request->get('query')) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $query = $request->get('query');
            $data =  $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('limit_product', $s_branchcode, $query, ''));
            $output = '<ul class="list-group list-group-flush">';
            foreach ($data as $row) {
                $output .= '<li class="li_product list-group-item" id=' . $row->pro_id . '>' . $row->pro_name . '</li>';
            }
            $output .= '</ul>';
            echo $output;
        }
    }

    function customer_auto(Request $request)
    {
        if ($request->get('query')) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $query = $request->get('query');
            $data = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('limit_customer', $s_branchcode, $query, ''));
            $output = '<ul class="list-group list-group-flush">';
            foreach ($data as $row) {
                $output .= '<li class="li_name list-group-item" id=' . $row->cus_id . '>' . $row->cus_name . '</li>';
            }
            $output .= '</ul>';
            echo $output;
        }
    }


    public function registerproduct(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode($request);

        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $percentage = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_percentage', '', $s_branchcode, ''));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '04'));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '03'));

        return view('pos.pos_product', ['inactive' => $inactive, 'pro_type' => $pos_type, 'pro_line' => $pos_line, 'percentage' => $percentage]);
    }


    public function pos_product_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode($request);
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_product', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('pos.pos_product_list', ['data' => $notices])->render();
    }

    public function pos_product_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $percentage = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('land_percentage', '', $s_branchcode, ''));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '04'));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '03'));
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_product', $s_branchcode, $id, ''));
        return view('pos.pos_product_view', ['data' => $results, 'inactive' => $inactive, 'pro_type' => $pos_type, 'pro_line' => $pos_line, 'percentage' => $percentage]);
    }

    public function product_info($id, Request $request)
    {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode =  $SqlModel->s_branchcode();
            $data =  $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_product', $s_branchcode, $id, ''));
            $arr = json_decode(json_encode($data), true);
            $array = array(
                'pro_id' => $arr[0]['pro_id'],
                'barcode' => $arr[0]['barcode'],
                'pro_cost' => $arr[0]['pro_cost'],
                'pro_up' => $arr[0]['pro_up'],
                'pro_discount' => $arr[0]['pro_discount']
            );
            return ['data' => $array];
        }
    }


    public function add_pos_product(Request $request)
    {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'name' => 'required',
            'barcode' => 'required',
            'inactive' => 'required',
            'pro_type' => 'required',
            'pro_line' => 'required',
            'cost' => 'required',
            'unitprice' => 'required',
            'discount' => 'required'
        );

        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        try {
            $barcode = $request->barcode;
            $pro_id = $request->hidden_id;
            $SqlModel->proc_get_data('CALL proc_pos_checkerror(?,?,?,?)', array('pos_barcode', $barcode, $s_branchcode, $pro_id));
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['barcode' => 'Barcode already exsits !']);
        }

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->barcode,
            $request->pro_type,
            $request->pro_line,
            $request->name,
            $request->cost,
            $request->unitprice,
            $request->discount,
            $request->inactive,
            $request->remark,
            $s_username
        );

        DB::select('CALL proc_pos_add_product(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'Data Added successfully.']);
    }

    public function delete_pos_product($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();

        try {
            $cus = $SqlModel->proc_get_data('CALL proc_pos_checkerror(?,?,?,?)', array('pos_product', $id, $s_branchcode, ''));
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => 'This product current using !']);
        }

        $form_data = array(
            'd_pos_product',
            $s_branchcode,
            $id
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function pos(Request $request)
    {
        return view('pos.pos');
    }

    public function pos_invoices($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode($request);
        $company = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('company', $s_branchcode, '', ''));
        $customerinfo = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('una_customerinfo', $s_branchcode, $id, ''));
        $payment_method = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('payment_method', $s_branchcode, $id, ''));
        $invoice = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('una_invoice', $s_branchcode, $id, ''));

        return view('pos.pos_invoice', ['company' => $company, 'customerinfo' => $customerinfo, 'payment_method' => $payment_method, 'invoice' => $invoice]);
    }


    public function pos_invoices_pdf($id, Request $request)
    {
        $SqlModel = new SqlModel();

        $s_branchcode = $SqlModel->s_branchcode();
        $company = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('company', $s_branchcode, '', ''));
        $customerinfo = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('una_customerinfo', $s_branchcode, $id, ''));
        $payment_method = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('payment_method', $s_branchcode, $id, ''));
        $invoice = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('una_invoice', $s_branchcode, $id, ''));

        return view('pos.pos_invoices_pdf', ['company' => $company, 'customerinfo' => $customerinfo, 'payment_method' => $payment_method, 'invoice' => $invoice]);
    }

    public function pos_invoices_show($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $company =  $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('company', $s_branchcode, '', ''));
        $customerinfo =  $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('auth_customerinfo', $s_branchcode, $id, ''));
        $payment_method =  $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('payment_method', $s_branchcode, $id, ''));
        $invoice =  $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('auth_invoice', $s_branchcode, $id, ''));

        return view('pos.pos_invoices_pdf', ['company' => $company, 'customerinfo' => $customerinfo, 'payment_method' => $payment_method, 'invoice' => $invoice]);
    }


    public function pos_invoice_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_una_invoice', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('pos.pos_invoice_list', ['data' => $notices])->render();
    }

    public function pos_invoice_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $invoice = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('una_invoice', $s_branchcode, $id, ''));
        $customerinfo = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('una_customerinfo', $s_branchcode, $id, ''));
        return view('pos.pos_invoice_view', ['invoice' => $invoice, 'customerinfo' => $customerinfo]);
    }

    public function pos_authorize_invoice($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            'auth_pos_invoice',
            $s_branchcode,
            $id,
            $s_username
        );
        DB::select('CALL proc_pos_authorize(?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'authorized successfully.']);
    }


    public function pos_invoice_delete($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();

        $form_data = array(
            'd_pos_invoice',
            $s_branchcode,
            $id
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        $message = $SqlModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }


    public function pos_invoice(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $s_username = $SqlModel->s_email();
            $_token = $s_branchcode . '-' . uniqid();

            $rules = array(
                'cus_name' => 'required',
                'delivery' => 'required|between:0,99.99'
            );
            $error = \Validator::make($request->all(), $rules);
            if ($error->fails()) {
                return response()->json(['errors' => $error->errors()->all()]);
            }

            $status     = $request->action;
            $v_cus_id   = $request->hidden_id;
            $v_cus_name = $request->cus_name;
            $v_cus_phone = $request->phone;
            $v_cus_address = $request->address;
            $v_delivery = $request->delivery;


            $pro_code   = $request->code;
            $stock_code = $request->stock;
            $p_qty      = $request->qty;
            $p_unitprice = $request->unitprice;
            $p_udiscount = $request->discount;
            $p_amount = $request->amount;

            for ($count = 0; $count < count($pro_code); $count++) {
                $form_data = array(
                    $status,
                    '', // code
                    $s_branchcode,
                    $v_cus_id, /// Customer Name if no customerID system will auto create new customer with
                    $v_cus_name,
                    $v_cus_phone,
                    $v_cus_address,
                    $v_delivery,
                    $pro_code[$count],
                    $stock_code[$count],
                    $p_unitprice[$count],
                    $p_qty[$count],
                    $p_udiscount[$count],
                    $p_amount[$count],
                    $_token,
                    $s_username
                );
                DB::select('Call proc_pos_add_invoices (?, ?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, ?)', $form_data);
            }
            $message = $SqlModel->insert_messages("insert");
            return response()->json(['success' =>  $message]);
        }
    }

    public function return_pos(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        return view('pos.pos_return_pos', ['stock' => $stock])->render();
    }

    public function add_return_pos(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $s_username = $SqlModel->s_email();
            $_token = $s_branchcode . '-' . uniqid();

            $status     = $request->action;
            $v_id   = $request->hidden_id;
            $v_referent = $request->referent;
            $v_remark = $request->remark;

            $pro_code   = $request->code;
            $stock_code = $request->stock;
            $p_qty      = $request->qty;
            $p_unitprice = $request->unitprice;
            $p_udiscount = $request->discount;
            $p_amount = $request->amount;

            try {
                $v_referent = $request->referent;
                $SqlModel->proc_get_data('CALL proc_pos_checkerror(?,?,?,?)', array('pos_referent', $v_referent, $s_branchcode, ''));
            } catch (\Illuminate\Database\QueryException $ex) {
                return response()->json(['referent' => 'Referent invoice does not exsits !']);
            }
            // CHECK duplicate item
            for ($count = 0; $count < count($pro_code); $count++) {
                for ($i = 0; $i < count($pro_code); $i++) {
                    if ($pro_code[$count] == $pro_code[$i] && $count != $i) {
                        return response()->json(['duplicate' => 'System do not allow duplicate item !']);
                    }
                }
            }

            for ($count = 0; $count < count($pro_code); $count++) {
                $form_data = array(
                    $status,
                    $v_id, // code
                    $s_branchcode,
                    $v_referent,
                    $v_remark,
                    $pro_code[$count],
                    $stock_code[$count],
                    $p_unitprice[$count],
                    $p_qty[$count],
                    $p_udiscount[$count],
                    $p_amount[$count],
                    $_token,
                    $s_username
                );

                DB::select('Call proc_pos_return_invoices (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
            }
            $message = $SqlModel->insert_messages("insert");
            return response()->json(['success' =>  $message]);
        }
    }

    public function pos_return_pos_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results =  $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_return_pos', $s_branchcode, $search, ''));
        $notices =  $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.pos_return_pos_list', ['data' => $notices])->render();
    }
    public function pos_return_pos_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $invoice = $SqlModel->proc_get_data('CALL proc_pos_print(?,?,?,?)', array('una_return_pos', $s_branchcode, $id, ''));
        return view('pos.pos_return_pos_view', ['invoice' => $invoice]);
    }

    public function pos_delete_return_pos(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $form_data = array(
            'd_pos_return_pos',
            $s_branchcode,
            $request->id,
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        $message = $SqlModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }

    public function pos_authorize_return_pos(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username =  $SqlModel->s_email();

        $form_data = array(
            'auth_return_stock',
            $s_branchcode,
            $request->id,
            $s_username
        );

        DB::select('CALL proc_pos_authorize(?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'authorized successfully.']);
    }



    public function pos_countstock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        return view('pos.pos_count_stock', ['stock' => $stock])->render();
    }

    public function countstock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $s_username =  $SqlModel->s_email();
        $_token = $s_branchcode . '-' . uniqid();

        $status             = $request->action;
        $stockcode          = $request->stockcode;
        $remark             = $request->remark;
        $pro_code           = $request->code;
        $p_qty              = $request->qty;

        for ($count = 0; $count < count($pro_code); $count++) {
            for ($i = 0; $i < count($pro_code); $i++) {
                if ($pro_code[$count] == $pro_code[$i] && $count != $i) {
                    return response()->json(['duplicate' => 'System do not allow duplicate item !']);
                }
            }
        }

        for ($count = 0; $count < count($pro_code); $count++) {
            $form_data = array(
                $status,
                '', // code
                $s_branchcode,
                $stockcode,
                $pro_code[$count],
                $p_qty[$count],
                $remark,
                $_token,
                $s_username
            );
            DB::select('Call proc_pos_add_count_stock (?, ?, ?,  ?,  ?,  ?,  ?,  ?, ?)', $form_data);
        }
        $message = $SqlModel->insert_messages("insert");
        return response()->json(['success' =>  $message]);
    }

    public function pos_countstock_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_una_countstock_list', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.pos_count_stock_list', ['data' => $notices])->render();
    }

    public function pos_countstock_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_una_countstock_list', $s_branchcode, $id, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        $detail = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('detail_countstock_list', $s_branchcode, $id, ''));

        return view('pos.pos_count_stock_view', ['data' => $notices, 'detail' => $detail]);
    }


    public function pos_authorize_count_stock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            'auth_count_stock',
            $s_branchcode,
            $request->id,
            $s_username
        );

        DB::select('CALL proc_pos_authorize(?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'authorized successfully.']);
    }


    public function pos_delete_count_stock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $form_data = array(
            'd_pos_count_stock',
            $s_branchcode,
            $request->id,
        );

        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        $message = $SqlModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }



    public function pos_stock_transfer(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        return view('pos.pos_stock_transfer', ['stock' => $stock])->render();
    }

    public function add_pos_stock_transfer(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        $_token = $s_branchcode . '-' . uniqid();

        $status             = $request->action;
        $from_stockcode     = $request->from_stockcode;
        $to_stockcode       = $request->to_stockcode;
        $remark             = $request->remark;
        $pro_code           = $request->code;
        $p_qty              = $request->qty;

        for ($count = 0; $count < count($pro_code); $count++) {
            $form_data = array(
                $status,
                '', // code
                $s_branchcode,
                $from_stockcode,
                $to_stockcode,
                $pro_code[$count],
                $p_qty[$count],
                $remark,
                $_token,
                $s_username
            );
            DB::select('Call proc_pos_add_stock_transfer (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
        }
        $message = $SqlModel->insert_messages("insert");
        return response()->json(['success' =>  $message]);
    }


    public function pos_stock_transfer_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_una_stock_transfer', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.pos_stock_transfer_list', ['data' => $notices])->render();
    }

    public function pos_stock_transfer_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_una_stock_transfer', $s_branchcode, $id, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        $detail = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('detail_stock_transfer', $s_branchcode, $id, ''));

        return view('pos.pos_stock_transfer_view', ['data' => $notices, 'detail' => $detail]);
    }

    public function pos_authorize_stock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        $form_data = array(
            'auth_stock_transfer',
            $s_branchcode,
            $request->id,
            $s_username
        );
        DB::select('CALL proc_pos_authorize(?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'authorized successfully.']);
    }

    public function pos_delete_stock_transfer(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $form_data = array(
            'd_pos_stock_tf',
            $s_branchcode,
            $request->id,
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        $message = $SqlModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }




    public function purchase_order(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $pos_supply =  $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_supply_active', $s_branchcode, ''));
        $stock =  $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        return view('pos.purchase', ['pos_supply' => $pos_supply, 'stock' => $stock]);
    }

    public function add_purchase_order(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode =  $SqlModel->s_branchcode();
            $inputArray = $request->all();
            $arr_data = json_decode(json_encode($inputArray['arr_data']), true);
            $data = $SqlModel->str_re(explode(',', $arr_data));

            $_token = $s_branchcode . '-' . uniqid();
            $s_username = $SqlModel->s_email();

            foreach ($data as $parr) {
                $arr = explode('|', $parr);
                $form_data = array(
                    'I',
                    '',
                    $s_branchcode,
                    $arr[0],
                    $arr[1],
                    $arr[2],
                    $arr[3], // product code
                    $arr[4], // Stock code
                    $arr[6], // cost
                    $arr[7], //qty
                    $arr[8], //discount
                    $arr[9], //amount
                    $arr[10], //remark
                    $_token,
                    $s_username
                );
                DB::select('Call proc_pos_add_purchaseorder (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, ?)', $form_data);
            }
            $message = $SqlModel->insert_messages("insert");
            return response()->json(['success' =>  $message]);
        }
    }


    public function purchase_order_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_purchase_order', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.purchase_order_list', ['data' => $notices])->render();
    }

    public function purchase_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $results =    $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_purchase_order', $s_branchcode, $id, ''));
        $detail =     $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_purchase_detail', $s_branchcode, $id, ''));
        $pos_supply = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_supply_active', $s_branchcode, ''));

        return view('pos.purchase_view', ['data' => $results, 'pos_supply' => $pos_supply, 'detail' => $detail]);
    }

    public function purchase_order_delete($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $form_data = array(
            'd_pos_purchase',
            $s_branchcode,
            $id
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function purchase_order_authorize($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $s_username =  $SqlModel->s_email($request);
        $form_data = array(
            'auth_pos_purchase',
            $s_branchcode,
            $id,
            $s_username
        );
        DB::select('CALL proc_pos_authorize(?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function customer(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $gender = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('gender', $s_branchcode, 'gender'));
        return view('pos.customer', ['inactive' => $inactive, 'gender' => $gender]);
    }

    public function customer_info($id, Request $request)
    {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $data = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_customer', $s_branchcode, $id, ''));
            $arr = json_decode(json_encode($data), true);

            $array = array(
                'cus_id' => $arr[0]['cus_id'],
                'cus_gender' => $arr[0]['cus_gender'],
                'cus_name' => $arr[0]['cus_name'],
                'cus_address' => $arr[0]['cus_address'],
                'cus_phone' => $arr[0]['cus_phone']
            );
            return ['data' => $array];
        }
    }


    public function add_customer(Request $request)
    {

        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'name' => 'required',
            'gender' => 'required',
            'phone' => 'required',
            'inactive' => 'required',
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
            $s_branchcode,
            $request->hidden_id,
            $request->name,
            $request->gender,
            $request->phone,
            $request->inactive,
            $request->address,
            $s_username
        );

        DB::select('CALL proc_pos_add_customer(?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'Data Added successfully.']);
    }

    public function customer_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();

        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_customer', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.customer_list', ['data' => $notices])->render();
    }


    public function customer_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $inactive =  $SqlModel->proc_get_data_sql(array('inactive', ''));
        $gender = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('gender', $s_branchcode, 'gender'));
        $results =  $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_customer', $s_branchcode, $id, ''));
        return view('pos.customer_view', ['inactive' => $inactive, 'gender' => $gender, 'data' => $results]);
    }

    public function customer_delete($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $form_data = array(
            'd_pos_customer',
            $s_branchcode,
            $id
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        $message = $SqlModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }

    public function add_pos_supplier(Request $request)
    {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'name' => 'required|min:5',
            'type' => 'required',
            'inactive' => 'required',
            'phone' => 'required',
            'websit' => 'required',
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
            $request->type,
            $request->name,
            $request->inactive,
            $request->phone,
            $request->email,
            $request->websit,
            $request->address,
            $s_username
        );
        DB::select('CALL proc_pos_add_supplier(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'Data Added successfully.']);
    }


    public function register_supply()
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '07'));
        return view('pos.supply', ['pos_line' => $pos_line, 'inactive' => $inactive]);
    }

    public function supply_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_supplier', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.supply_list', ['data' => $notices])->render();
    }

    public function supply_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '07'));
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_supplier', $s_branchcode, $id, ''));
        return view('pos.supply_view', ['data' => $results, 'pos_line' => $pos_line, 'inactive' => $inactive])->render();
    }


    public function delete_pos_supply($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();

        try {
            $SqlModel->proc_get_data('CALL proc_pos_checkerror(?,?,?)', array('pos_supply', $id, $s_branchcode));
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => 'Supply current in used !']);
        }

        $form_data = array(
            'd_pos_supply',
            $s_branchcode,
            $id
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }


    public function product_instock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $stock =    $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        $results =  $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('product_instock', $s_branchcode, '%', ''));
        $notices =  $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        $product_instock = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('product_have_instock', $s_branchcode, '%', ''));
        $history = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('his_instock', $s_branchcode, '', ''));

        return view('pos.pos_product_instock', ['data' => $notices, 'stock' => $stock, 'p_instock' => $product_instock, 'history' => $history]);
    }


    public function get_instock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode =  $SqlModel->s_branchcode();
        $stockcode   = $request->stockcode;
        $productcode   = $request->productcode;

        $results =  $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('search_instock', $s_branchcode, $productcode, $stockcode));
        $notices =  $SqlModel->arrayPaginator_url($results, '/product_instock', $request, $SqlModel->row_number());

        return view('pos.pos_product_instock_data', ['data' => $notices])->render();
    }
    public function pos_in_stock_history($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('his_instock', $s_branchcode, $id, ''));
        $history = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.pos_product_instock_his', ['history' => $history])->render();
    }

    public function pos_line(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('pos_line', $s_branchcode, '', ''));

        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('pos.pos_line', ['data' => $notices,'inactive'=>$inactive]);
    }

    public function pos_line_fetch_data(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('pos_line', $s_branchcode, 'all', ''));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

            return view('pos.pos_line_data', ['data' => $notices])->render();
        }
    }

    public function pos_line_search_data($search, Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('pos_line', $s_branchcode, $search, ''));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('pos.pos_line_data', ['data' => $notices])->render();
        }
    }


    public function add_pos_line(Request $request)
    {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'line' => 'required',
            'line_name' => 'required',
            'inactive' => 'required'
        );

        $error = Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username =  $SqlModel->s_email();

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->line,
            $request->line_name,
            $request->inactive,
            $request->remark,
            $s_username
        );
        DB::select('CALL proc_pos_add_line(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'Data Added successfully.']);
    }

    public function edit_pos_line($id, Request $request)
    {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $data  = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('pos_line', $s_branchcode, $id, ''));
            $arr = json_decode(json_encode($data), true);

            $array = array(
                'line_id' => $arr[0]['line_id'],
                'line_name' => $arr[0]['line_name'],
                'inactive' => $arr[0]['inactive'],
                'status' => $arr[0]['status'],
                'line_remark' => $arr[0]['line_remark'],
                'line_type' => $arr[0]['line_type']
            );
            return ['data' => $array];
        }
    }

    public function delete_pos_line($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        try {
            $SqlModel->proc_get_data('CALL proc_pos_checkerror(?,?,?)', array('pos_line', $id, $s_branchcode,''));
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => 'The record has been posted in till !']);
        }

        $form_data = array(
            'd_pos_line',
            $s_branchcode,
            $id
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }



    public function pos_expense(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '09'));
        $currency = $SqlModel->proc_get_data_sql(array('combo_currency', ''));

        return view('pos.pos_expense', ['line' => $line, 'currency' => $currency])->render();
    }


    public function pos_add_expense(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $status = 'expense';
        $rules = array(
            'type.*'  => 'required',
            'referent.*'  => 'required',
            'currency.*'  => 'required',
            'amount.*'  => 'required',
            'remark.*'  => 'required'
        );

        $error = Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }

        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->type,
            $request->referent,
            $request->currency,
            $request->amount,
            $request->remark,
            $s_username
        );
        $recordid = DB::select('CALL proc_pos_add_expense(?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        $arr = json_decode(json_encode($recordid), true);
        $recordid = $arr[0]['trancode'];
        try {
            $files = [];
            if ($request->hasfile('file_name')) {
                foreach ($request->file('file_name') as $file) {
                    $filename = $s_branchcode . '-' . time() . rand(1, 100) . '.' . $file->extension();
                    $path = 'pos/expense/';
                    //$file->move(public_path($path), $filename);
                    //$file->move($path , $filename);
                    $file->storeAs($path, $filename);

                    //$file->move(storage_path($path), $filename);
                    $orgName = $file->getClientOriginalName();
                    $extension = '.' . $file->getClientOriginalExtension();
                    $form_data = array(
                        'I',
                        $recordid,
                        $s_branchcode,
                        $path,
                        $filename,
                        $orgName,
                        $extension,
                        'exspense',
                        $s_username
                    );

                    DB::select('CALL proc_pos_add_file(?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
                }
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }

        return response()->json(['success' => 'Data Added successfully.']);
    }

    public function pos_expense_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel ->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_expense', $s_branchcode, $search, ''));
        $notices = $SqlModel ->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('pos.pos_expense_list', ['data' => $notices])->render();
    }

    public function pos_expense_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel ->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_expense', $s_branchcode, $id, ''));
        $file = $SqlModel ->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_una_exp_file', $s_branchcode, $id, ''));
        return view('pos.pos_expense_view', ['data' => $results, 'file' => $file]);
    }


    public function pos_authorize_expense(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            'auth_expense',
            $s_branchcode,
            $request->id,
            $s_username
        );

        DB::select('CALL proc_pos_authorize(?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'authorized successfully.']);
    }

    public function destroy_file_public($file)
    {
        try {
            if (file_exists($file)) {
                unlink($file);
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }
    }

    public function destroy_file($file)
    {
        try {
            if (file_exists(storage_path('app/' . $file))) {
                unlink(storage_path('app/' . $file));
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }
    }

    public function pos_checking_file($status, $s_branchcode, $id)
    {
        try {
            $SqlModel = new SqlModel();
            $file =  $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array($status, $s_branchcode, $id, ''));
            foreach ($file as $p) {
                $this->destroy_file($p->link_file);
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }
    }


    public function pos_delete_expense(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        try {
            $recordid = $request->id;
            $this->pos_checking_file('list_una_exp_file', $s_branchcode, $recordid);

            $form_data = array(
                'd_pos_expense',
                $s_branchcode,
                $recordid,
            );
            DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }

        $message = $this->FunModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }


    public function pos_Income(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '08'));
        $currency = $SqlModel->proc_get_data_sql(array('combo_currency', ''));
        return view('pos.pos_income', ['line' => $line, 'currency' => $currency])->render();
    }


    public function pos_add_income(Request $request)
    {
        $SqlModel = new SqlModel();
        $status = 'income';
        $rules = array(
            'type.*'  => 'required',
            'referent.*'  => 'required',
            'currency.*'  => 'required',
            'amount.*'  => 'required',
            'remark.*'  => 'required'
        );

        $error = Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->type,
            $request->referent,
            $request->currency,
            $request->amount,
            $request->remark,
            $s_username
        );
        $recordid = DB::select('CALL proc_pos_add_expense(?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        $arr = json_decode(json_encode($recordid), true);
        $recordid = $arr[0]['trancode'];
        try {
            $files = [];
            if ($request->hasfile('file_name')) {
                foreach ($request->file('file_name') as $file) {
                    $filename = $s_branchcode . '-' . time() . rand(1, 100) . '.' . $file->extension();
                    $path = 'pos/income';
                    $file->storeAs($path, $filename);
                    $orgName = $file->getClientOriginalName();
                    $extension = '.' . $file->getClientOriginalExtension();
                    $form_data = array(
                        'I',
                        $recordid,
                        $s_branchcode,
                        $path,
                        $filename,
                        $orgName,
                        $extension,
                        'income',
                        $s_username
                    );

                    DB::select('CALL proc_pos_add_file(?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
                }
            }
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }

        return response()->json(['success' => 'Data Added successfully.']);
    }


    public function pos_income_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_income', $s_branchcode, $search, ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('pos.pos_income_list', ['data' => $notices])->render();
    }


    public function pos_income_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_income', $s_branchcode, $id, ''));
        $file = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_una_income_file', $s_branchcode, $id, ''));
        return view('pos.pos_income_view', ['data' => $results, 'file' => $file]);
    }

    public function pos_authorize_income(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            'auth_income',
            $s_branchcode,
            $request->id,
            $s_username
        );

        DB::select('CALL proc_pos_authorize(?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'authorized successfully.']);
    }


    public function pos_delete_income(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        try {
            $recordid = $request->id;
            $this->pos_checking_file('list_una_income_file', $s_branchcode, $recordid);

            $form_data = array(
                'd_pos_income',
                $s_branchcode,
                $recordid,
            );
            DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }

        $message = $this->FunModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }

    public function pos_tiller(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results = $this->FunModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_tiller', $s_branchcode, '', ''));
        return view('pos.pos_tiller', ['data' => $results]);
    }


    public function pos_auth_tiller(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $s_username = $SqlModel->s_email();
            $_token = $s_branchcode . '-' . uniqid();
            $status     = $request->action;
            $p_code = $request->m_code;

            for ($count = 0; $count < count($p_code); $count++) {
                $form_data = array(
                    $status,
                    $p_code[$count],
                    $s_branchcode,
                    $_token,
                    $s_username
                );
                DB::select('Call proc_pos_auth_tiller (?, ?, ?,  ?,  ?)', $form_data);
            }

            $message = $SqlModel->insert_messages("insert");
            return response()->json(['success' =>  $message]);
        }
    }

    public function pos_exp_file($filename)
    {
        //check image exist or not
        $exists = Storage::disk('pos')->exists('expense/' . $filename);
        if ($exists) {
            //get content of image
            //$content = Storage::get('pos/expense'.$filename);
            $content = Storage::disk('pos')->get('expense/' . $filename);
            //get mime type of image
            //$mime = Storage::mimeType('pos/expense/'.$filename);
            $mime = Storage::disk('pos')->mimeType('expense/' . $filename);      //prepare response with image content and response code
            $response = Response::make($content, 200);      //set header
            $response->header("Content-Type", $mime);      // return response
            return $response;
        } else {
            abort(404);
        }
    }

    public function pos_income_file($filename)
    {
        //check image exist or not
        $exists = Storage::disk('pos')->exists('income/' . $filename);
        if ($exists) {
            //get content of image
            $content = Storage::disk('pos')->get('income/' . $filename);
            //get mime type of image
            $mime = Storage::disk('pos')->mimeType('income/' . $filename);      //prepare response with image content and response code
            $response = Response::make($content, 200);      //set header
            $response->header("Content-Type", $mime);      // return response
            return $response;
        } else {
            abort(404);
        }
    }






}
