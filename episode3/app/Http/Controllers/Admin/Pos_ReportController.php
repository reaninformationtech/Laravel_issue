<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SqlModel;
use DB;
use DateTime;

class Pos_ReportController extends Controller
{
    //
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }
    public function pos_report(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '04'));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '03'));
        $pos_product = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_product', $s_branchcode, ''));
        return view('pos_report.rpt_product_in_stock',['report'=>$report,'stock' => $stock,'pro_type' => $pos_type, 'pro_line' => $pos_line ,'pos_product'=>$pos_product]);
    }

    public function rpt_get_pos_product_in_stock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $status = 'product';
        $date='';
        try {
            $date = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException $e) {
            return response()->json(['errors' => array('0'=>'Invalid format date to !')]);
        }
        if($date==false){
            return response()->json(['errors' => array('0'=>'Invalid format date to !')]);
        }
        $form_data = array(
            $status,
            $s_branchcode,
            $request->stock,
            $request->product,
            $request->type,
            $request->line,
            $date->format('Y-m-d'),
            $s_username
        );

        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_product_in_stock(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        return view('pos_report.rpt_product_in_stock_data', ['rpt_data' => $notices])->render();
    }


    public function Ajax_rpt_get_pos_product_in_stock(Request $request)
    {
        if ($request->ajax()) {
            
            $SqlModel = new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $s_username = $SqlModel->s_email();
            
            $status = 'product';
            $date='';
            try {
                $date = DateTime::createFromFormat('d/m/Y', $request->get('datefrom'));
            } catch(\Illuminate\Database\QueryException $e) {
                return response()->json(['errors' => array('0'=>'Invalid format date to !')]);
            }
            if($date==false){
                return response()->json(['errors' => array('0'=>'Invalid format date to !')]);
            }
            $form_data = array(
                $status,
                $s_branchcode,
                $request->get('stock'),
                $request->get('product'),
                $request->get('type'),
                $request->get('line'),
                $date->format('Y-m-d'),
                $s_username
            );
            $results = $SqlModel->proc_get_data('CALL rpt_get_pos_product_in_stock(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
            $notices = $SqlModel->arrayPaginator($results, $request, 10000);
            return view('pos_report.rpt_product_in_stock_data', ['rpt_data' => $notices])->render();
            
        }
        
    }

    public function rpt_pos_sold_out(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '04'));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '03'));
        $pos_product = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_product', $s_branchcode, ''));
        return view('pos_report.rpt_pos_sold_out',['report'=>$report,'stock' => $stock,'pro_type' => $pos_type, 'pro_line' => $pos_line ,'pos_product'=>$pos_product]);
    }


    public function rpt_get_pos_sold_out(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $status = 'sold_out';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException $e) {
            return 'Invalid format date from !';
        }


        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->product,
            $request->type,
            $request->line,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );
      
        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_sold_out(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        return view('pos_report.rpt_pos_sold_out_data', ['rpt_data' => $notices])->render();
    }


    public function rpt_pos_sold_out_return(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '04'));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '03'));
        $pos_product = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_product', $s_branchcode, ''));
        return view('pos_report.rpt_pos_sold_out_return',['report'=>$report,'stock' => $stock,'pro_type' => $pos_type, 'pro_line' => $pos_line ,'pos_product'=>$pos_product]);
    }

    public function rpt_get_pos_sold_out_return(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        $status = 'sold_out_return';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }


        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->product,
            $request->type,
            $request->line,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );

        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_sold_out(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        return view('pos_report.rpt_pos_sold_out_return_data', ['rpt_data' => $notices])->render();
    }




    public function rpt_pos_income(Request $request)
    {
        $SqlModel = new SqlModel();

        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $currency = $SqlModel->proc_get_data_sql(array('combo_currency', ''));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '08'));
        return view('pos_report.rpt_pos_income',['report'=>$report,'currency' => $currency,'pos_line' => $pos_type]);
    }


    public function rpt_get_pos_income(Request $request)
    {
        $SqlModel = new SqlModel();

        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $status = 'income';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->line,
            $request->currency,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );
      
        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_income(?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        return view('pos_report.rpt_pos_income_data', ['rpt_data' => $notices])->render();
    }

    public function rpt_pos_income_img(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $id=$request->get('image_id');
            $s_branchcode = $SqlModel->s_branchcode();
            $file = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_income_file', $s_branchcode, $id, ''));
            return view('pos_report.rpt_pos_income_img', ['file' => $file])->render();
            
        }
        
    }


    public function rpt_pos_expense(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $currency = $SqlModel->proc_get_data_sql(array('combo_currency', ''));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '09'));
        return view('pos_report.rpt_pos_expense',['report'=>$report,'currency' => $currency,'pos_line' => $pos_type]);
    }

    public function rpt_get_pos_expense(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        $status = 'expense';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->line,
            $request->currency,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );
      
        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_income(?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        return view('pos_report.rpt_pos_expense_data', ['rpt_data' => $notices])->render();
    }


    public function rpt_pos_expense_img(Request $request)
    {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $id=$request->get('image_id');
            $s_branchcode = $SqlModel->s_branchcode();
            $file = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array('list_exp_file', $s_branchcode, $id, ''));
            return view('pos_report.rpt_pos_expense_img', ['file' => $file])->render();
        }
    }

    public function rpt_pos_purchase(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        $pos_type = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '04'));
        $pos_line = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '03'));
        $pos_product = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_product', $s_branchcode, ''));
        return view('pos_report.rpt_pos_purchase',['report'=>$report,'stock' => $stock,'pro_type' => $pos_type, 'pro_line' => $pos_line ,'pos_product'=>$pos_product]);
    }

    public function rpt_get_pos_purchase(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        $status = 'purchase';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->stock,
            $request->product,
            $request->type,
            $request->line,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );

        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_purchase(?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        return view('pos_report.rpt_pos_purchase_data', ['rpt_data' => $notices])->render();
    }

    public function rpt_pos_count_stock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        $pos_product = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_product', $s_branchcode, ''));
        return view('pos_report.rpt_pos_count_stock',['report'=>$report,'stock' => $stock ,'pos_product'=>$pos_product]);
    }


    public function rpt_get_pos_count_stock(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        $status = 'count';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->stockfrom,
            $request->product,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );

        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_count_stock(?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        return view('pos_report.rpt_pos_count_stock_data', ['rpt_data' => $notices])->render();
    }

    public function rpt_pos_stock_transfer(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $stock = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode, '02'));
        $pos_product = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_product', $s_branchcode, ''));
        return view('pos_report.rpt_pos_stock_transfer',['report'=>$report,'stock' => $stock ,'pos_product'=>$pos_product]);
    }


    public function rpt_get_pos_stock_transfer(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();

        $status = 'count';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->stockfrom,
            $request->stockto,
            $request->product,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );

        $results = $SqlModel->proc_get_data('CALL pos_rpt_get_stock_transfer(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);

        return view('pos_report.rpt_pos_stock_transfer_data', ['rpt_data' => $notices])->render();
    }


    public function rpt_pos_monthly_closing(Request $request)
    {
        $SqlModel = new SqlModel();
        $action = $SqlModel->get_currentRouteName();
        $report = $SqlModel->get_reportname('reportname',$action);
        $currency = $SqlModel->proc_get_data_sql(array('combo_currency', ''));

        return view('pos_report.rpt_pos_monthly_closing',['currency'=>$currency]);
    }

    public function rpt_get_pos_monthly_closing(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email();
        $status = 'monthly';
        $datefrom='';
        $data_to='';
        try {
            $datefrom = DateTime::createFromFormat('d/m/Y', $request->data_from);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        try {
            $data_to = DateTime::createFromFormat('d/m/Y', $request->data_to);
        } catch(\Illuminate\Database\QueryException  $e) {
            return 'Invalid format date from !';
        }

        if($datefrom==false or $data_to==false){
            return 'Invalid format date !';
        }

        $form_data = array(
            $status,
            $s_branchcode,
            $request->currency,
            $datefrom->format('Y-m-d'),
            $data_to->format('Y-m-d'),
            $s_username
        );

        $results = $SqlModel->proc_get_data('CALL rpt_pos_monthly_closing(?, ?, ?, ?, ?, ?)', $form_data);
        $notices = $SqlModel->arrayPaginator($results, $request, 100000);
        
        return view('pos_report.rpt_pos_monthly_closing_data', ['rpt_data' => $notices])->render();
    }

    
}
