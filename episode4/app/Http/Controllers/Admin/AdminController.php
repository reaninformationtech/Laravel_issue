<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SqlModel;
use DB;
use Illuminate\Support\Str;

class AdminController extends Controller
{
    //
    public function __construct()
    {
        $this->middleware('guest')->except('logout');
        $this->AdminModel = new \App\Models\AdminModel();
    }
    protected $AdminModel;

    public function index(Request $request)
    {
        return view('admin.index');
    }

    public function register()
    {
        $SqlModel = new SqlModel();
        $system = $SqlModel->proc_get_data('CALL proc_get_sql(?,?)', array('combo_system', ''));
        return view('admin.register', ['system' => $system]);
    }

    public function login()
    {
        return view('admin.login');
    }

    public function forgot()
    {
        return view('admin.forgot');
    }


    function userauth(Request $request)
    {
        $request->validate([
            'email' => 'required|email|exists:gb_sys_users,email',
            'password' => 'required|min:2|max:50'
        ], [
            'email.exists' => 'This user name does not exists !'
        ]);

        $login = $request->only('email', 'password');

        if (Auth::guard('admin')->attempt($login)) {

            $data = $this->AdminModel->userinfo($request->email);
            $arr = json_decode(json_encode($data, true), true);

            $session_array = array(
                'id' => $arr[0]['id'],
                'email' => Str::lower($arr[0]['email']),
                'name' => $arr[0]['name'],
                'contact' => Str::lower($arr[0]['contact']),
                'supper' => $arr[0]['supper'],
                'branchcode' => $arr[0]['branchcode'],
                'systemid' => $arr[0]['systemid'],
                'subofbranch' => $arr[0]['subofbranch']
            );
            $request->session()->put('userinfo', $session_array);

            return redirect()->route('adminpage');
        } else {
            return redirect()->route('login')->with('fail', 'Incorrect user name or password ');
        }
    }


    //
    public function registeruser(Request $request)
    {
        //Vailidate inpute
        $request->validate([
            'system' => 'required',
            'name' => 'required|min:5|max:20|unique:gb_sys_branch,setname',
            'email' => 'required|email|unique:gb_sys_users,email',
            'password' => 'required|min:5|max:20',
            'cpassword' => 'required|min:5|max:20|same:password'
        ]);

        $form_data = array(
            'I',
            '',
            $request->system,
            $request->name,
            $request->email,
            \Hash::make($request->password),
            \Hash::make($request->password),
            'IT.SYSTEM'
        );

        $data = DB::statement('CALL proc_register_branch(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);

        if ($data) {
            return redirect()->back()->with('success', 'You are now registered successfully');
        } else {
            return redirect()->back()->with('fail', 'Something went wrong failed ');
        }
    }


    public function menu_permission(Request $request) {
        $SqlModel = new SqlModel();
        $results = $SqlModel->proc_get_data_sql(array('permission', '%'));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('admin.menu_permission',['data' => $notices]);
    }

    public function permission_fetch_data(Request $request) {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $results = $SqlModel->proc_get_data_sql(array('permission', '%'));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('admin.menu_permission_data',['data' => $notices])->render();
        }
    }


    public function add_menu_permission(Request $request) {

        if($request->ajax())
        {
            $SqlModel = new SqlModel();
            $inputArray = $request->all();
            $arr_data=json_decode(json_encode($inputArray['arr_data']), true);
            $data=$SqlModel->str_re(explode( ',',$arr_data));

            $_token= uniqid();
            $s_username = $SqlModel->s_email($request);

            foreach ($data as $parr) {
                $arr=explode('-', $parr);
                $form_data = array(
                    'I',
                    $arr[0],
                    $arr[1],
                    $arr[2],
                    $arr[3],
                    $arr[4],
                    $arr[5],
                    $_token,
                    $s_username
                );

                //dd($form_data );
                DB::select('Call proc_add_permssion (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
            }

            $message= $SqlModel->insert_messages("insert");
            return response()->json(['success' =>  $message]);
        }
    }

    public function permission_list($id) {

        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $data = $SqlModel->proc_get_data_sql(array('permission_list', $id));
            return json_encode($data);
        }
    }

    public function admin_menu(Request $request) {
        $SqlModel = new SqlModel();
        $results = $SqlModel->proc_get_data_sql(array('admin_menu', ''));
        $notices = $SqlModel->arrayPaginator($results, $request, 5);
        return view('admin.admin_menu', ['data' => $notices]);


    }

    public function add_main_menu(Request $request) {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'menu_name' => 'required',
            'inactive' => 'required',
            'menu_icon1' => 'required',
            'menu_class1' => 'required',
        );
        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $SqlModel = new SqlModel();
        $form_data = array(
            $status,
            $request->hidden_id,
            $request->menu_name,
            $request->inactive,
            'IT.SYSTEM',
            $request->menu_icon1,
            $request->menu_icon2,
            $request->menu_icon3,
            $request->menu_class1,
            $request->menu_class2,
            $request->menu_class3,
        );

        DB::select('CALL  proc_add_main_menu (?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?, ?,  ?)', $form_data);
        $message= $SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }


    public function menu_edit($id) {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $data =  $SqlModel->proc_get_data_sql(array('admin_menu', $id));
            $arr = json_decode(json_encode($data), true);
            $array = array('menu_id' => $arr[0]['menu_id'],
                'menu_name' => $arr[0]['menu_name'],
                'menu_inactive' => $arr[0]['menu_inactive'],
                'status' => $arr[0]['status'],
                'menu_icon1' => $arr[0]['menu_glyphicon1'],
                'menu_icon2' => $arr[0]['menu_glyphicon2'],
                'menu_icon3' => $arr[0]['menu_glyphicon3'],
                'menu_class1' => $arr[0]['menu_class1'],
                'menu_class2' => $arr[0]['menu_class2'],
                'menu_class3' => $arr[0]['menu_class3'],
            );
            return ['data' => $array];
        }
    }

    public function delete_main_menu($id) {
        $form_data = array(
            'menu',
            $id
        );
        DB::select('CALL proc_delete_trans(?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function main_fetch_data(Request $request) {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $results = $SqlModel->proc_get_data_sql(array('admin_menu', '%'));
            $notices = $SqlModel->arrayPaginator($results, $request, 5);
            return view('admin.admin_menu_data', ['data' => $notices])->render();
        }
    }

    public function sub_menu(Request $request) {
        $SqlModel = new SqlModel();
        $results = $SqlModel->proc_get_data_sql(array('sub_menu', ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('admin.sub_menu', ['data' => $notices]);
    }


    public function fetch_data(Request $request) {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $results = $SqlModel->proc_get_data_sql(array('sub_menu', ''));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('admin.sub_menu_data', ['data' => $notices])->render();
        }
    }

    public function add_sub_menu(Request $request) {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'sub_name' => 'required',
            'main_system' => 'required',
            'inactive' => 'required',
            'controller' => 'required',
            'function' => 'required',
        );
        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $form_data = array(
            $status,
            $request->hidden_id,
            $request->main_system,
            $request->sub_name,
            $request->function,
            $request->inactive,
            $request->controller,
            'IT.SYSTEM'
        );


        DB::select('CALL proc_add_sub_menu(?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'Data Added successfully.']);
    }

    public function destroy_sub_menu($id) {
        $form_data = array(
            'sub_menu',
            $id
        );
        DB::select('CALL proc_delete_trans(?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function sub_edit($id) {
        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $data = $SqlModel->proc_get_data_sql(array('load_sub_menu', $id));
            $arr = json_decode(json_encode($data), true);

            $array = array('subm_id' => $arr[0]['subm_id'],
                'subm_name' => $arr[0]['subm_name'],
                'subm_controller' => $arr[0]['subm_controller'],
                'subm_function' => $arr[0]['subm_function'],
                'subm_inactive' => $arr[0]['subm_inactive'],
                'status' => $arr[0]['status'],
                'menu_id' => $arr[0]['menu_id'],
                'menu_name' => $arr[0]['menu_name'],
            );
            return ['data' => $array];
        }
    }


    public function create_system(Request $request) {
        $SqlModel = new SqlModel();
        $results =$SqlModel->proc_get_data_sql(array('system_controls', '%'));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('admin.create_system',['data' => $notices]);
    }

    public function add_create_system(Request $request) {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'system_name' => 'required',
            'short_name' => 'required',
            'Effective' => 'required',
            'inactive' => 'required'
        );
        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $SqlModel = new SqlModel();
        $s_username = $SqlModel->s_email($request);
        $form_data = array(
            $status,
            $request->hidden_id,
            $request->system_name,
            $request->short_name,
            $request->Effective,
            $request->inactive,
            $request->system_remark,
            $s_username
        );
        DB::select('Call proc_add_system_controls (?, ?, ?,  ?,  ?,  ?,  ?, ?)', $form_data);
        $message=$SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }

    public function system_fetch_data(Request $request) {
        if ($request->ajax()) {
            $SqlModel = new SqlModel();
            $results =  $SqlModel->proc_get_data_sql(array('system_controls', '%'));
            $notices =  $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('admin.create_system_data', ['data' => $notices])->render();
        }
    }

    public function create_system_edit($id) {

        if (request()->ajax()) {
            $SqlModel = new SqlModel();
            $data = $SqlModel->proc_get_data_sql(array('system_controls', $id));
            $arr = json_decode(json_encode($data), true);
            $array = array('sys_con_id' => $arr[0]['sys_con_id'],
                'sys_name' => $arr[0]['sys_con_name'],
                'short_name' => $arr[0]['sys_con_short_name'],
                'status' => $arr[0]['status'],
                'effective' => $arr[0]['sys_con_effective'],
                'inactive' => $arr[0]['sys_con_inactive'],
                'sys_remark' => $arr[0]['sys_con_remark']
            );
            return ['data' => $array];
        }
    }

    public function delete_system($id,Request $request) {

        $form_data = array(
            'system_control',
            $id
        );
        DB::select('CALL proc_delete_trans(?, ?)', $form_data);
        return response()->json(['success' => 'delete successfully.']);
    }

    public function combo_system(Request $request) {
        $SqlModel = new SqlModel();
        $results = $SqlModel->proc_get_data_sql(array('combo_system', ''));
        $output ='';
        foreach ($results as $row) {
            $output .= '<option value="' . $row->id . '">' . $row->name . '</option>';
        }
        return $output;
    }


    public function auto_permission(Request $request)
    {
        DB::select('CALL _Refresh_Permission_All()');
        return response()->json(['success' => 'Data Added successfully.']);
    }


    function logout(Request  $request)
    {
        Auth::guard('admin')->logout();
        $request->session()->forget('userinfo');
        return redirect('/');
    }
}
