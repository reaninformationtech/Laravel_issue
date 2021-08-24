<?php

namespace App\Http\Controllers\Admin;

use Illuminate\Validation\Rule;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\SqlModel;
use Validator;
use DB;
use Illuminate\Support\Facades\Storage;
use Response;
class SettingController extends Controller
{
    //
    //
    public function __construct() {
        $this->middleware('guest')->except('logout');
    }

    public function setupbranchnew(Request $request)
    {
        $SqlModel = new SqlModel();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        return view('setting.setupbranchnew', ['inactive' => $inactive]);
    }

    public function setupbranch(Request $request) {
        $SqlModel=new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_user_id = $SqlModel->s_userid();
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $results = $SqlModel->proc_get_sql_by_branch(array('branch',$s_branchcode,$s_user_id,''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
        return view('setting.setupbranch', ['data' => $notices,'inactive'=>$inactive]);
    }

    public function setupbranch_view($id, Request $request)
    {
        $SqlModel = new SqlModel();
        $inactive =  $SqlModel->proc_get_data_sql(array('inactive', ''));
        $data = $SqlModel->proc_get_sql_by_branch(array('getbranch', $id,'',''));
        return view('setting.setupbranch_view', ['inactive' => $inactive, 'data' => $data]);
    }

    public function setupbranch_edit(Request $request) {
        $SqlModel=new SqlModel();
        $rules = array(
            'setname' => 'required|min:5|max:50',
            'setname' => [
                'required',
                Rule::unique('gb_sys_branch')->ignore($request->hidden_id, 'branchcode' )
            ],
            'branch_name' => 'required|min:5|max:50',
            'branch_short' => 'required',
            'inactive'  => 'required',
            'phone'     => 'required',
            'email'     => 'required',
            'website'   => 'required',
        );

        $error = Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
       $s_username = $SqlModel->s_email();
        $form_data = array(
            $status,
            $request->hidden_id,
            $request->setname,
            $request->branch_name,
            $request->branch_short,
            $request->inactive,
            $request->phone,
            $request->email,
            $request->website,
            $request->address,
            $s_username
        );

        DB::select('CALL proc_register_branch_full(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', $form_data);
        return response()->json(['success' => 'Data Added successfully.']);
    }

    public function branch_fetch_data(Request $request) {
        if ($request->ajax()) {
            $SqlModel=new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $s_user_id = $SqlModel->s_userid();

            $results = $SqlModel->proc_get_sql_by_branch(array('branch', $s_branchcode,$s_user_id,''));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

            return view('setting.setupbranch_data', ['data' => $notices])->render();
        }
    }

    public function setupuser(Request $request) {
        $SqlModel=new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_user_id = $SqlModel->s_userid();

        $branch =  $SqlModel->proc_get_sql_by_branch(array('getbranch', $s_branchcode,$s_user_id,''));
        $results = $SqlModel->proc_get_sql_by_branch(array('setup_user', $s_branchcode,'',''));
        $profile =  $SqlModel->proc_get_sql_by_branch(array('profile', $s_branchcode,$s_user_id,''));
        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());


        return view('setting.setupuser', ['data' => $notices,'branch' => $branch,'profile' => $profile, 'inactive'=>$inactive]);
    }

    public function register_user(Request $request) {
        $password='';
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
            $password =  \Hash::make('123456$');
        }

        $rules = array(
            'branch' => 'required',
            'profile' => 'required',
            'login_name' => 'required',
            'user_name' => 'required',
            'contact' => 'required',
            'inactive' => 'required'
        );
        $error = Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }

        $SqlModel=new SqlModel();

        $s_username = $SqlModel->s_email($request);
        $s_user_systemid = $SqlModel->s_systemid($request);
        $s_subofbranch = $SqlModel->s_subofbranch($request);

       // DD($s_branchcode);
        $form_data = array(
            $status,
            $request->hidden_id,
            $request->branch,
            $s_subofbranch,
            $request->user_name,
            $request->login_name,
            '123456$',
            $password,
            '0',
            $s_user_systemid,
            $request->contact,
            $request->inactive,
            $request->profile,
            'Referent',
            $s_username
        );
        DB::select('Call proc_add_users (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
        $message=$SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }

    public function user_fetch_data(Request $request) {
        if ($request->ajax()) {
            $SqlModel=new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $results = $SqlModel->proc_get_sql_by_branch(array('setup_user', $s_branchcode,'',''));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

            return view('setting.setupuser_data', ['data' => $notices])->render();
        }
    }

    public function register_user_edit($id,Request $request) {
        if (request()->ajax()) {
            $SqlModel=new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $data=  $SqlModel->proc_get_sql_by_branch(array('setup_user',$s_branchcode,$id,''));
            $arr = json_decode(json_encode($data), true);

            $array = array('id' => $arr[0]['id'],
                'profileid' => $arr[0]['profile'],
                'branchcode'    => $arr[0]['branchcode'],
                'name'          => $arr[0]['name'],
                'username'      => $arr[0]['username'],
                'contact'       => $arr[0]['contact'],
                'profilename'   => $arr[0]['profilename'],
                'systemid'      => $arr[0]['systemid'],
                'inactive'      => $arr[0]['inactive']
            );
            // dd($array);
            return ['data' => $array];
        }
    }

    public function register_resetpwd(Request $request) {
        $status='';
        if ($request->r_action == 'Resetpwd') {
            $status = 'Resetpwd';
        }
        $rules = array(
            'r_name' => 'required',
            'password' => 'required|min:5|max:20',
            'conpassword' => 'required|min:5|max:20|same:password'
        );
        $error = Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }

        $SqlModel=new SqlModel();
        $s_username = $SqlModel->s_email();
        $salt_password = \Hash::make($request->password);

        $form_data = array(
            $status,
            $request->r_hidden_id,
            $request->r_branchcode,
            $salt_password,
            $salt_password,
            $s_username
        );


        DB::select('Call proc_reset_pwd_user (?, ?, ?,  ?,  ?,  ?)', $form_data);
        $message=$SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }



    public function setup_profile(Request $request) {
        $SqlModel=new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_user_id = $SqlModel->s_userid();

        $inactive = $SqlModel->proc_get_data_sql(array('inactive', ''));
        $branch = $SqlModel->proc_get_sql_by_branch(array('getbranch', $s_branchcode,$s_user_id,''));
        $results = $SqlModel->proc_get_sql_by_branch(array('getprofile', $s_branchcode,$s_user_id,''));
        $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());

        return view('setting.setupprofile', ['data' => $notices,'branch' => $branch,'inactive'=>$inactive]);
    }

    public function add_setup_profile(Request $request) {
        if ($request->action == 'Edit') {
            $status = 'U';
        } else {
            $status = 'I';
        }
        $rules = array(
            'branch' => 'required',
            'name' => 'required',
            'inactive' => 'required'
        );
        $error = Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $SqlModel=new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_username = $SqlModel->s_email($request);

        $form_data = array(
            $status,
            $request->hidden_id,
            $s_branchcode,
            $request->name,
            $request->inactive,
            $s_username
        );
        DB::select('Call proc_add_system_profile (?, ?, ?,  ?,  ?,  ?)', $form_data);
        $message=$SqlModel->insert_messages($request->action);
        return response()->json(['success' =>  $message]);
    }

    public function profile_edit($id,Request $request) {

        if (request()->ajax()) {
            $SqlModel=new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $data= $SqlModel->proc_get_sql_by_branch(array('setup_profile',$s_branchcode,$id,''));
            $arr = json_decode(json_encode($data), true);

            $array = array('profileid' => $arr[0]['profileid'],
                'branchcode' => $arr[0]['branchcode'],
                'setname' => $arr[0]['setname'],
                'branchname' => $arr[0]['branchname'],
                'status' => $arr[0]['status'],
                'profilename' => $arr[0]['profilename'],
                'inactive' => $arr[0]['inactive']
            );
            // dd($array);
            return ['data' => $array];
        }
    }

    public function profile_fetch_data(Request $request) {
        if ($request->ajax()) {
            $SqlModel=new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            $s_user_id =  $SqlModel->s_email();

            $results = $SqlModel->proc_get_sql_by_branch(array('getprofile', $s_branchcode,$s_user_id,''));
            $notices = $SqlModel->arrayPaginator($results, $request, $SqlModel->row_number());
            return view('setting.setupprofile_data', ['data' => $notices])->render();
        }
    }

    public function delete_profile($id,Request $request) {
         if (request()->ajax()) {
            $SqlModel=new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode();
            try {
                 $SqlModel->proc_get_data('CALL proc_check_sql_land(?,?,?)', array('delete_profile', $id, $s_branchcode));
            } catch(\Illuminate\Database\QueryException $ex){
                return response()->json(['errors' => 'This item current in use !']);
            }

            $form_data = array(
                'delete_profile',
                $s_branchcode,
                $id
            );

            DB::select('CALL proc_delete_trans_by_branch(?, ?, ?)', $form_data);
            return response()->json(['success' => 'delete successfully.']);
         }
    }

    public function setuser_permission(Request $request) {
        $SqlModel=new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_user_systemid = $SqlModel->s_systemid();

        $profile =  $SqlModel->proc_get_sql_by_branch(array('profile_active', $s_branchcode,'',''));
        $results =  $SqlModel->proc_get_sql_by_branch(array('branchpermission', $s_branchcode,$s_user_systemid ,''));
        $notices =  $SqlModel->arrayPaginator($results, $request, 1000);

        return view('setting.setuser_permission', ['data' => $notices,'profile'=>$profile]);
    }

    public function permission_by_branch($id,Request $request) {

        if (request()->ajax()) {
            $SqlModel=new SqlModel();
            $s_branchcode = $SqlModel->s_branchcode($request);
            $data = $SqlModel->proc_get_sql_by_branch(array('permission_by_branch', $s_branchcode,$id ,''));
            return json_encode($data);
        }
    }

    public function add_setuser_permission(Request $request) {

        if($request->ajax())
        {
            $SqlModel=new SqlModel();
            $inputArray = $request->all();
            $arr_data=json_decode(json_encode($inputArray['arr_data']), true);
            $data=$SqlModel->str_re(explode( ',',$arr_data));
            $s_branchcode = $SqlModel->s_branchcode($request);

            $_token= uniqid();
            $s_username = $SqlModel->s_email();
            foreach ($data as $parr) {
                $arr=explode('_', $parr);
                $form_data = array(
                    'I',
                    $s_branchcode,
                    $arr[0],
                    $arr[1],
                    $arr[2],
                    $arr[3],
                    $arr[4],
                    $arr[5],
                    $_token,
                    $s_username
                );

                DB::select('Call proc_add_permission_by_branch (?, ?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
            }

            $message=$SqlModel->insert_messages("insert");
            return response()->json(['success' =>  $message]);
        }
    }

    public function setup_permission(Request $request) {
        $SqlModel=new SqlModel();
        $system =   $SqlModel->proc_get_data_sql(array('combo_system', ''));
        $results =  $SqlModel->proc_get_data('CALL proc_get_sql(?,?)', array('setup_permission','%'));
        $notices =  $SqlModel->arrayPaginator($results, $request, 100000);
        return view('setting.setup_permission', ['data' => $notices,'system'=>$system]);
    }

    public function setup_permission_fetch($id,Request $request) {
        if ($request->ajax()) {
            $SqlModel=new SqlModel();
            $results =  $SqlModel->proc_get_data('CALL proc_get_sql(?,?)', array('setup_permission',$id));
            $notices =  $SqlModel->arrayPaginator($results, $request, 1000);
            return view('setting.setup_permission_data', ['data' => $notices])->render();
        }
    }
    public function setup_permission_check($systemid,$profileid) {
        if (request()->ajax()) {
            $SqlModel=new SqlModel();
            $data = $SqlModel->proc_get_data('CALL proc_get_sql_multi(?,?,?,?)', array('setup_permission',$systemid,$profileid,'%','%'));
            return json_encode($data);
        }
    }

    function check_existing($arr,$value){

        if( is_array($arr)){
            for ($co = 0; $co < count($arr); $co++) {
                if($arr[$co]==$value){
                    return '1';
                }
            }
        }
        return '0';
    }

    public function add_setup_permission(Request $request) {

        if($request->ajax())
        {
            $SqlModel=new SqlModel();
            $_token= uniqid();
            $s_username = $SqlModel->s_email();

            $systemid    = $request->system;
            $profileid    = $request->profile;
            $menu_id    = $request->m_id;
            $m_view     = $request->m_view;
            $m_booking  = $request->m_booking;
            $m_edit     = $request->m_edit;
            $m_delete     = $request->m_delete;

            for ($count = 0; $count < count($menu_id); $count++) {

                $form_data = array(
                    'I',
                    $menu_id[$count],
                    $systemid,
                    $profileid,
                    $_token,
                    $s_username,
                    $this->check_existing($m_view,$menu_id[$count]),
                    $this->check_existing($m_booking,$menu_id[$count]),
                    $this->check_existing($m_edit,$menu_id[$count]),
                    $this->check_existing($m_delete,$menu_id[$count]),

                );
                DB::select('Call proc_add_permission_gb (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
            }
            $message=$SqlModel->insert_messages("insert");
            return response()->json(['success' =>  $message]);
        }
    }

    public function userprofile(Request $request) {
        $SqlModel=new SqlModel();
        $s_branchcode = $SqlModel->s_branchcode();
        $s_user_id = $SqlModel->s_userid();

        $SqlModel=new SqlModel();
        $data = $SqlModel->proc_get_data('CALL proc_get_sql_multi(?,?,?,?)', array('userprofile', $s_branchcode, $s_user_id,'%','%'));
        $gender = $SqlModel->proc_get_data('CALL gb_get_combobox(?,?,?)', array('gender', $s_branchcode, 'gender'));
        return view('setting.userprofile', ['userinfo' =>$data,'gender' => $gender]);
    }

    public function userprofileimage(Request $request)
    {
        try {
            $SqlModel=new SqlModel();
            $s_user_id = $SqlModel->s_userid();
            $image_64 = $request->image; //your base64 encoded data
            $extension = explode('/', explode(':', substr($image_64, 0, strpos($image_64, ';')))[1])[1];
            $replace = substr($image_64, 0, strpos($image_64, ',')+1);
            $image = str_replace($replace, '', $image_64);
            $image = str_replace(' ', '+', $image);
            $imageName = $s_user_id.'_'.\Str::random(5).'.'.$extension;

            Storage::disk('storeimage')->put($imageName, base64_decode($image));

            return response()->json([
                'message'   => 'Image Upload Successfully',
                'image_name' => $imageName,
                'class_name'  => 'alert-success'
               ]);
        } catch (\Illuminate\Database\QueryException $ex) {
            return response()->json(['errors' => $ex]);
        }
    }


    public function img_userprofile($filename)
    {
        $exists = Storage::disk('storeimage')->exists($filename);
        if ($exists) {
            $content = Storage::disk('storeimage')->get($filename);
            $mime = Storage::disk('storeimage')->mimeType($filename);      //prepare response with image content and response code
            $response = Response::make($content, 200);      //set header
            $response->header("Content-Type", $mime);      // return response
            return $response;
        } else {
            abort(404);
        }
    }

    public function id_img_userprofile($userid)
    {
        $SqlModel=new SqlModel();
        $data =  $SqlModel->proc_get_data('CALL proc_get_sql(?,?)', array('user_image',$userid));
        $arr = json_decode(json_encode($data), true);
        $filename=$arr[0]['photo'];
        $exists = Storage::disk('userimage')->exists($filename);
        if ($exists) {
            $content = Storage::disk('userimage')->get($filename);
            $mime = Storage::disk('userimage')->mimeType($filename);      //prepare response with image content and response code
            $response = Response::make($content, 200);      //set header
            $response->header("Content-Type", $mime);      // return response
            return $response;
        } else {
            abort(404);
        }
    }

    function add_userprofile(Request $request)
    {
        $status = 'I';
        $rules = array(
            'username' => 'required|min:5|max:100',
            'gender' => 'required',
            'contact' => 'required|min:5|max:100',
            'bio' => 'required|max:200',
        );

        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }
        $v_imagename='';

        if($request->hidden_image_name !='' &&  ($request->hidden_image_name !=$request->org_image_name)){
            $v_imagename=$request->hidden_image_name;
        }else{
            $v_imagename=$request->org_image_name;
        }

        $exists = Storage::disk('storeimage')->exists($v_imagename);
        if($exists){
             $this->copyToDisk('storeimage',$v_imagename,'userimage',$v_imagename);
             Storage::disk('storeimage')->delete($v_imagename);
             Storage::disk('userimage')->delete($request->org_image_name);
        }


        $SqlModel=new SqlModel();
        $s_user_id = $SqlModel->s_userid();
        $s_username = $SqlModel->s_email();

        $form_data = array(
            $status,
            $s_user_id,
            '01',
            $request->username,
            $request->contact,
            $request->gender,
            $request->bio,
             $v_imagename,
            $s_username
        );

        session()->put('userinfo.name',$request->username);

        DB::select('Call proc_add_userinfo (?, ?, ?,  ?,  ?,  ?,  ?,  ?,  ?)', $form_data);
        $message=$SqlModel->insert_messages('Edit');
        return response()->json(['success' =>  $message]);
    }

    public function copyToDisk($local_disk, $local_path, $remote_disk, $remote_path)
    {
        // Load local file into memory
        $local_contents = Storage::disk($local_disk)->get($local_path);
        // Stream file contents
        return Storage::disk($remote_disk)->put($remote_path, $local_contents);
    }


    function resetpassword(Request $request)
    {
        $status = 'Resetpwd';
        $rules = array(
            'password' => 'required|min:5|max:20',
            'conpassword' => 'required|min:5|max:20|same:password'
        );

        $error = \Validator::make($request->all(), $rules);
        if ($error->fails()) {
            return response()->json(['errors' => $error->errors()->all()]);
        }

        $SqlModel=new SqlModel();
        $s_user_id = $SqlModel->s_userid();
        $s_username = $SqlModel->s_email();
        $s_branchcode = $SqlModel->s_branchcode();

        $form_data = array(
            $status,
            $s_user_id,
            $s_branchcode,
            \Hash::make($request->password),
            \Hash::make($request->conpassword),
            $s_username
        );

        DB::select('Call proc_reset_pwd_user (?, ?, ?,  ?,  ?,  ?)', $form_data);
        $message=$SqlModel->insert_messages('Edit');
        return response()->json(['success' =>  $message]);
    }


}
