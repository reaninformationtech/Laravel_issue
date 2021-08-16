<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Models\SqlModel;
use DB;
class ComboController extends Controller
{
    //
    public function combo_pos_line($type, Request $request) {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel ->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('pos_line', $s_branchcode,$type));
        $output = '<option value="">Select </option>';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }
    public function combo_admin($type) {
        $SqlModel=new SqlModel();
        $results = $SqlModel->proc_get_data_sql(array($type, ''));
        $output = '';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }

    public function combo_permission($type) {
        $SqlModel=new SqlModel();
        $results = $SqlModel->proc_get_data_sql(array('combo_permission',$type));
        $output = '';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }

    public function combo_pos($type,Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel ->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_pos_get_sql(?,?,?,?)', array($type, $s_branchcode,'',''));
        $output = '<option value="">Select sytem</option>';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }

    public function combo_inactive(Request $request) {
        $SqlModel = new SqlModel();
        $results = $SqlModel ->proc_get_data_sql(array('inactive', ''));
        $output = '<option value="">Select Option</option>';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }

    public function combo_currency(Request $request) {
        $SqlModel = new SqlModel();
        $results = $SqlModel ->proc_get_data_sql(array('combo_currency', ''));
        $output = '<option value="">Select currency</option>';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        // dd($output);
        return $output;
    }

    public function combo_land_line($type, Request $request) {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel ->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('combo_land_line', '', $s_branchcode, $type));
        $output = '<option value="">Select </option>';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }

    public function combo_price($id,Request $request) {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel ->s_branchcode();
        $price = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array('list_land_sale', $id, $s_branchcode,''));
        return  json_encode($price);
    }

    public function combo_expend($type, Request $request) {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel ->s_branchcode();
        $results = $SqlModel->proc_get_data('CALL proc_get_sql_land(?,?,?,?)', array($type, '', $s_branchcode, $type));
        $output = '<option value="">Select </option>';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }




}
