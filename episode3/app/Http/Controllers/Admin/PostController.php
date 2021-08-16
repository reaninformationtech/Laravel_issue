<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SqlModel;
use DB;
use Illuminate\Support\Facades\Storage;
use Response;
use Validator;

class PostController extends Controller
{
    //
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
    }

    public function quote()
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $quote = $SqlModel->proc_get_data('CALL proc_post_get_sql(?,?,?,?)', array('contant_fix', $s_branchcode, 'quote', ''));
        return view('post.quote', ['quote' => $quote]);
    }

    
    public function quote_list($search, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $results =  $SqlModel->proc_get_data('CALL proc_post_get_sql(?,?,?,?)', array('quote_list', $s_branchcode, $search, ''));
        $notices =  $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('post.quote_data', ['data' => $notices])->render();
    }

    public function quote_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $quote = $SqlModel->proc_get_data('CALL proc_post_get_sql(?,?,?,?)', array('contant_fix', $s_branchcode, 'quote', ''));
        $results =  $SqlModel->proc_get_data('CALL proc_post_get_sql(?,?,?,?)', array('quote_list', $s_branchcode, $id, ''));
        $notices =  $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('post.quote_view', ['data' => $notices,'quote' => $quote])->render();
    }


    public function add_quote(Request $request)
    {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'type' => 'required',
            'quote' => 'required'
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
            $request->quote,
            $s_username
        );

        DB::select('Call proc_post_add_quote (?, ?, ?,  ?,  ?,  ?)', $form_data);
        $message = $SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }

    public function delete_quote(Request $request)
    {
        $SqlModel = new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $form_data = array(
            'd_post_quote',
            $s_branchcode,
            $request->id,
        );
        DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
        $message = $SqlModel->insert_messages("delete");
        return response()->json(['success' =>  $message]);
    }

}
