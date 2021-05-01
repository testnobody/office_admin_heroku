<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8" />
        <title>Microsoft Office365 全局管理</title>
        <link rel="stylesheet" href="layui/css/layui.css">
		<link href="files/mslogo.png" rel="icon" type="image/png">
    </head>
    <body class="layui-layout-body" style="overflow-y:visible;background: #fff;">
        <div class="layui-form">
            <blockquote class="layui-elem-quote quoteBox">
                <div class="layui-inline" style="margin-left: 2rem;">

					<a class="layui-btn" id="add_account"><i class="layui-icon layui-icon-username"></i> 新建用户</a>
                </div>

                <div class="layui-inline" style="margin-left: 2rem;">      				
					<select name="account"  id="account" lay-verify="required">
						<option value="<?php echo $ii;?>"><?php echo $accounts[$ii]['name'];?></option>
						<?php 
							$i = 0;
							foreach ($accounts as $value) {
								if ($i != $ii){
							   ?>
							   <option value="<?php echo $i;?>"><?php echo $value['name'];?></option>
							   <?php
							   }
							   $i++;
							}
						?>
					</select>
                </div>
				<div class="layui-inline" style="margin-left: 2rem;">  
					<a class="layui-btn" id="change_account"><i class="layui-icon layui-icon-template-1"></i> 切换全局</a>
				</div>
				<div class="layui-inline" style="margin-left: 2rem;">  
					<a class="layui-btn" id="logout"><i class="layui-icon layui-icon-logout"></i> 注销登录</a>
				</div>
				
            </blockquote>
        </div>
        <table class="layui-hide" id="table" lay-filter="table">
            
        </table>


		
		<div id="add_account_content" class="layui-form layui-form-pane" style="display: none;margin:1rem 3rem;">
		<form class="layui-form" >
          <div class="layui-form-item">
            <label class="layui-form-label">姓/Lastname</label>
            <div class="layui-input-inline">
              <input type="text" placeholder="英文/拼音" class="layui-input" id="lastname" pattern="[A-z0-9]{1,50}" required lay-verify="required">
            </div>
			<label class="layui-form-label">名/Firstname</label>
            <div class="layui-input-inline">
              <input type="text" placeholder="英文/拼音" class="layui-input" id="firstname" pattern="[A-z0-9]{1,50}" required lay-verify="required">
            </div>
          </div>

          <div class="layui-form-item">
            <label class="layui-form-label">用户账号</label>
            <div class="layui-input-inline">
              <input type="text" placeholder="请输入前缀" class="layui-input" id="add_user" pattern="[A-z0-9]{1,50}" required lay-verify="required">
            </div>
			<div class="layui-input-inline">
			  <select name="domain" lay-verify="required" id="domain">
				<?php 
					foreach ($domains as $value) {
					   ?>
					   <option value="<?php echo $value['id'];?>"><?php echo $value['id'];?></option>
					   <?php
					}
				?>
			  </select>
			</div>
          </div>
          <div class="layui-form-item">
            <label class="layui-form-label">密码</label>
            <div class="layui-input-inline">
              <input type="password" placeholder="请输入密码" class="layui-input" id="password" pattern="[A-z0-9]{8,50}" required lay-verify="required">
            </div>
			<div class="layui-input-inline">
			  <input type="checkbox" name="forceChangePassword" id="forceChangePassword" lay-skin="switch" lay-text="首登强制重设密码|首登无需重设密码">
			</div>
          </div>
		  
		  <div class="layui-form-item">
            <label class="layui-form-label">国家(地区)</label>
			<div class="layui-input-inline">
			  <select name="location" lay-verify="required" id="location">
				<?php 
					foreach ($locations as $key => $value) {
					   ?>
					   <option value="<?php echo $value;?>"><?php echo $key;?></option>
					   <?php
					}
				?>
			  </select>
			</div>
			<div class="layui-form-mid layui-word-aux">建议和全局申请时区域一致</div>
          </div>
		  <div class="layui-form-item">
            <label class="layui-form-label">许可证</label>
			<div class="layui-input-inline">
			  <select name="sku" lay-verify="required" id="sku">
				<?php 
					foreach ($accounts[$ii]['sku_ids'] as $key => $value) {
					   ?>
					   <option value="<?php echo $value;?>"><?php echo $key;?></option>
					   <?php
					}
				?>
			  </select>
			</div>
			<div class="layui-form-mid layui-word-aux">请在config文件配置</div>
          </div>
          <div class="layui-form-item">
            <div class="layui-input-block">
              <button class="layui-btn" lay-filter="formDemo" id="submitaccount">立即提交</button>
            </div>
          </div>
		</form>  
        </div>

    </body>
	
    <script type="text/html" id="buttons">
      <a class="layui-btn layui-btn-normal layui-btn-xs" lay-event="accountactive">允许</a>
      <a class="layui-btn layui-btn-warm layui-btn-xs" lay-event="accountinactive">禁止</a>
      <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="setuserasadminbyid">设为管理</a>
	  <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="deluserasadminbyid">取消管理</a>
      <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
    </script>
    <script src="./layui/layui.js" charset="utf-8"></script>
    <script src="./layui/jquery.js"></script>
    <script type="text/javascript" charset="utf-8">
        layui.use(['table','form','layer'], function(){
          var table = layui.table;
          var form = layui.form;
          var layer = layui.layer;
            table.render({
                elem: '#table',//表格id
                url:"./index.php?a=getusers",//list接口地址
                cellMinWidth: 60,//全局定义常规单元格的最小宽度
                height: 'full-120',
				loading: true,
                cols: [[
                //align属性是文字在列表中的位置 可选参数left center right
                //sort属性是排序功能
                //title是这列的标题
                //field是取接口的字段值
                //width是宽度，不填则自动根据值的长度
                  {field:'displayName', title: 'displayName',align: 'center'},
				  {field:'userPrincipalName',title: '账号',align: 'center',templet:function(d){
                          if(d.userPrincipalName){
                              return d.userPrincipalName;
                          }else{
                              return '-';
                          }
                  }},
				  {field:'accountEnabled', title: '账户状态',align: 'center',templet:function(d){
                          if(d.accountEnabled == true){
                              return '<span style="color:#99CC00">正常</span>';
                          }else{
                              return '<span style="color:red;">禁用</span>';
                          }
                  }},
                  {field:'usageLocation',title: 'usageLocation',align: 'center'},

                  {field:'id',title: 'id',width: 335,align: 'center',templet:function(d){
                          if(d.id){
                              return d.id;
                          }else{
                              return '-';
                          }
                  }},
                  {field:'createdDateTime', title: '创建时间',align: 'center'},
                  {field:'sku', title: '许可证',align: 'center',templet:function(d){
                          if(d.sku == '无许可'){
                              return '<span style="color:#ff461f">无许可</span>';
                          }else{
                              return d.sku;
                          }
                  }},
                  {fixed:'right',title: '操作', width: 335, align:'center', toolbar: '#buttons'}
                ]]
          });
           //监听
          table.on('tool(table)', function(obj){
              if(obj.event === 'del'){
                  layer.confirm('真的删除吗', function(index){
                      $.post("./index.php?a=admin_delete",{email:obj.data.userPrincipalName,id:obj.data.id},function(res){
                        if (res.code == 0) {
                            obj.del();//删除表格这行数据
                        }
                        layer.msg(res.msg);
                      },'json');
                  });
              }
              if(obj.event === 'accountactive'){
                  layer.confirm('允许登录?', function(index){
                      $.post("./index.php?a=invitation_code_activeaccount",{email:obj.data.userPrincipalName},function(res){
                       if (res.code == 1) {
                          layer.closeAll();
                          layui.use('table', function(){
                              var table = layui.table;
                              table.reload('table', { //表格的id
                                  url:"./index.php?a=getusers",
                              });
                             })
                        }
                        layer.msg(res.msg);
                      },'json');
                  });
              }
              if(obj.event === 'setuserasadminbyid'){
                  layer.confirm('设为管理?', function(index){
                      $.post("./index.php?a=invitation_code_setuserasadminbyid",{id:obj.data.id},function(res){
                       if (res.code == 1) {
                          layer.closeAll();
                          layui.use('table', function(){
                              var table = layui.table;
                              table.reload('table', { //表格的id
                                  url:"./index.php?a=getusers",
                              });
                             })
                        }
                        layer.msg(res.msg);
                      },'json');
                  });
              }
			  if(obj.event === 'deluserasadminbyid'){
                  layer.confirm('取消管理?', function(index){
                      $.post("./index.php?a=invitation_code_deluserasadminbyid",{id:obj.data.id},function(res){
                       if (res.code == 1) {
                          layer.closeAll();
                          layui.use('table', function(){
                              var table = layui.table;
                              table.reload('table', { //表格的id
                                  url:"./index.php?a=getusers",
                              });
                             })
                        }
                        layer.msg(res.msg);
                      },'json');
                  });
              }

              if(obj.event === 'accountinactive'){
                  layer.confirm('禁止登录?', function(index){
                      $.post("./index.php?a=invitation_code_inactiveaccount",{email:obj.data.userPrincipalName},function(res){
                       if (res.code == 1) {
                          layer.closeAll();
                          layui.use('table', function(){
                              var table = layui.table;
                              table.reload('table', { //表格的id
                                  url:"./index.php?a=getusers",
                              });
                             })
                        }
                        layer.msg(res.msg);
                      },'json');
                  });
              }
            });

			$('#change_account').click(function(){
                  layer.confirm('确认切换全局?', function(index){
                      var accountid = $('#account').val();
                      $.post("./index.php?a=changeaccount",{account:accountid},function(res){
                       if (res.code == 1) {
                          layer.closeAll();
                        }
                        layer.msg(res.msg);
						window.location.reload();
                      },'json');
                  });
            });
			$('#logout').click(function(){
                  layer.confirm('确认注销登录?', function(index){
                      $.post("./index.php?a=logout",function(res){
                       if (res.code == 1) {
                          layer.closeAll();
                        }
                        layer.msg(res.msg);
						window.location.reload();
                      },'json');
                  });
            });

			$('#add_account').click(function(){
                layer.open({
                    type: 1,
                    title:'新建账号',
					end: function(){
						$('#add_account_content').hide();
					  },
                    skin: 'layui-layer-rim', //加上边框
                    //area: ['48rem;', '28rem;'], //宽高
                    content: $('#add_account_content'),
                });
            });
            $('#submitaccount').click(function(){
                var data = {
                    //email:$('#add_email').val(),
					firstname:$('#firstname').val(),
					lastname:$('#lastname').val(),
					add_user:$('#add_user').val(),
					domain:$('#domain').val(),
					password:$('#password').val(),
					forceChangePassword:$('#forceChangePassword').is(':checked'),
					location:$('#location').val(),
					sku:$('#sku').val(),
                };
                $.post("./index.php?a=admin_add_account",data,function(res){
                    if (res.code == 0) {
                        layer.closeAll();
                        layui.use('table', function(){
                            var table = layui.table;
                            table.reload('table', { //表格的id
                                url:"./index.php?a=getusers",
                            });
                        })
                    }
                    layer.msg(res.msg);
                },'json');
            })

        });
    </script>
</html>