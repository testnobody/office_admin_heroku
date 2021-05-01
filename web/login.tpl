 <!DOCTYPE html>
<html lang="">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $page_config['title']; ?></title>

	<link rel="stylesheet" href="layui/css/layui.css" media="all">
    <link href="files/mslogo.png" rel="icon" type="image/png">
    <style>


    </style>
</head>

<body>



<div class="layui-container"> 

<blockquote class="layui-elem-quote" style="margin-top:25px;"><i class="layui-icon layui-icon-windows" style="font-size:25px;">  Office365全局管理</i></legend></blockquote>		
<form class="layui-form" method="post" action="./index.php?a=login">
  <div class="layui-form-item">
    <label class="layui-form-label">管理账号</label>
    <div class="layui-input-block">
      <input type="text" name="username" required  lay-verify="required"  autocomplete="off" class="layui-input">
    </div>
  </div>
  <div class="layui-form-item">
    <label class="layui-form-label">管理密码</label>
    <div class="layui-input-block">
      <input type="password" name="password" required lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input">
    </div>
  </div>
  <div class="layui-form-item">
    <label class="layui-form-label">选择全局</label>
    <div class="layui-input-block">
      <select name="account" lay-verify="required">
		<?php 
			$i = 0;
			foreach ($accounts as $value) {
			   ?>
			   <option value="<?php echo $i;?>"><?php echo $value['name'];?></option>
			   <?php
			}
			$i++;
		?>
      </select>
    </div>
  </div>

  <div class="layui-form-item">
    <div class="layui-input-block">
      <button class="layui-btn " lay-submit lay-filter="formDemo" type="submit"><i class="layui-icon layui-icon-auz"></i>  登 录</button>
      <button type="reset" class="layui-btn layui-btn-primary"><i class="layui-icon layui-icon-refresh-3"></i>  重 置</button>
    </div>
  </div>
</form>
 
</div>







    <script src="layui/layui.js"></script>

	<script>
	//Demo
	layui.use('form', function(){
	  var form = layui.form;
	  

	});
	</script>

</body>

</html>