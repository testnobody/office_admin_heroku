<?php
require('common.php');
if(empty($_GET['a'])){
    if(check_login()){
        header('location:./index.php?a=show');
        exit();
    }else{
        require('login.tpl');
        exit();
    }
}

$ii=0;

if($_GET['a'] == 'login'){
    $username = !empty($_POST['username']) ? $_POST['username'] : '';
    $password = !empty($_POST['password']) ? $_POST['password'] : '';
    if($username == $admin['username'] && md5($password) == $admin['password']){
        $_SESSION['token'] = md5($admin['username'] . $admin['password']);
		$_SESSION['account'] = !empty($_POST['account']) ? $_POST['account'] : '0';
        header('location:./index.php?a=show');
        exit();
    }else{
        require('login.tpl');
        exit();
    }
}

if($_GET['a'] == 'show'){
    if(!check_login()){
        require('login.tpl');
        exit();
    }
	$token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
	$domains = getdomains($token);
    require('admin.tpl');
    exit();
}

if($_GET['a'] == 'getusers'){
    if(!check_login()){
        response(1,"登录已失效");
    }

	$token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
	
	$data = getusers($token);
    foreach($data as $k =>$v){
		if($v['assignedLicenses'][0]['skuId'] == ""){
			$data[$k]['sku'] = '无许可';
		}
        elseif ($v['assignedLicenses'][0]['skuId'] == "314c4481-f395-4525-be8b-2ec4bb1e9d91"){
			$data[$k]['sku'] = 'A1学生';
		}
		elseif($v['assignedLicenses'][0]['skuId'] == "94763226-9b3c-4e75-a931-5c89701abe66"){
			$data[$k]['sku'] = 'A1教职工';
		}
		elseif($v['assignedLicenses'][0]['skuId'] == "e82ae690-a2d5-4d76-8d30-7c6e01e6022e"){
			$data[$k]['sku'] = 'A1P学生';
		}
		elseif($v['assignedLicenses'][0]['skuId'] == "78e66a63-337a-4a9a-8959-41c6654dfb56"){
			$data[$k]['sku'] = 'A1P教职工';
		}
		else{
			$data[$k]['sku'] = '未知';
		};
    }
	response(0,"获取成员信息成功",$data,count($data));
	//echo "aaaaaaaaaaaaaaaaaaaaaaaa";
}



if($_GET['a'] == 'admin_add_account'){
    if(!check_login()){
        response(1,"登录已失效");
    }

	$domain=$_POST['domain'];
	$password=$_POST['password'];
	$forceChangePassword=$_POST['forceChangePassword'];
	$location=$_POST['location'];
	$sku_id=$_POST['sku'];
					
	$request = [
		'username'=>$_POST['add_user'],
		'firstname'=>$_POST['firstname'],
		'lastname'=>$_POST['lastname'],
	];

	$token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
	if(empty($token)){
		response(1,'获取token失败,请检查参数配置是否正确');
	}
	admin_create_user($request,$token,$domain,$sku_id,$password,$forceChangePassword,$location);
	
    response(0,'创建用户成功');
}




if($_GET['a'] == 'admin_delete'){
    if(!check_login()){
        response(1,"登录已失效");
    }
    $token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
    $user_email = !empty($_POST['email']) ? $_POST['email'] : 0;
    if($user_email){
        $resultaccount=accountdelete($user_email,$token);
    }else{
        $resultaccount=false;
    }
    if(!empty($resultaccount)){
        response(0,"用户账户删除成功");
    }
	else{
        response(1,"删除失败");
    }
}

if($_GET['a'] == 'invitation_code_activeaccount'){
    if(!check_login()){
        response(1,"登录已失效");
    }
    $token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
    $user_email = !empty($_POST['email']) ? $_POST['email'] : 0;
    $result=accountactive($user_email,$token);
    if(!empty($result)){
        response(0,$user_email."解锁失败");
    }else{
        response(1,$user_email."解锁成功");
    }
}

if($_GET['a'] == 'invitation_code_inactiveaccount'){
    if(!check_login()){
        response(1,"登录已失效");
    }
    $token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
    $user_email = !empty($_POST['email']) ? $_POST['email'] : 0;
    $result=accountinactive($user_email,$token);
    if(!empty($result)){
        response(0,$user_email."禁用失败");
    }else{
        response(1,$user_email."成功禁用");
    }
}

if($_GET['a'] == 'invitation_code_setuserasadminbyid'){
    if(!check_login()){
        response(1,"登录已失效");
    }
    $token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
    $user_id = !empty($_POST['id']) ? $_POST['id'] : 0;
    $result=setuserasadminbyid($user_id,$token);
    if(!empty($result)){
        response(0,"设置管理失败".$result);
    }else{
        response(1,"设置管理成功");
    }
}

if($_GET['a'] == 'invitation_code_deluserasadminbyid'){
    if(!check_login()){
        response(1,"登录已失效");
    }
    $token = get_ms_token($accounts[$ii]['tenant_id'],$accounts[$ii]['client_id'],$accounts[$ii]['client_secret']);
    $user_id = !empty($_POST['id']) ? $_POST['id'] : 0;
    $result=deluserasadminbyid($user_id,$token);
    if(!empty($result)){
        response(0,"取消管理失败".$result);
    }else{
        response(1,"取消管理成功");
    }
}

if($_GET['a'] == 'changeaccount'){
	$_SESSION['account']=$_POST['account'];
    if(!check_login()){
        response(1,"登录已失效");
    }
    response(1,"切换全局成功");

}

if($_GET['a'] == 'logout'){
	$_SESSION['account']=$_POST['account'];
	$_SESSION['token']="";
	session_stop;
    if(!check_login()){
        response(1,"登录已失效");
    }
	

}
