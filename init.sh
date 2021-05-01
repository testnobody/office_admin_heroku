cat << EOF > /var/www/html/config.php
<?php
return [
	//全局账号相关配置
	'accounts'=>[
		$count
	],
	
	
	
	'locations'=>[//自己配置，写了几个我常用的
		'中国'=>'CN',
		'台湾'=>'TW',
		'香港'=>'HK',
		'日本'=>'JP',
		'美国'=>'US',
		'新加坡'=>'SG',
		'英国'=>'GB'
	],
	
	//后台相关配置
	'admin'=>[
		'username'=>'$username',
		'password'=>'$passwd',//自行输入密码 https://md5jiami.51240.com/  将32位 小写结果填入
		'invitation_code_num'=>'8',//随机生成的邀请码位数
	],

];
EOF


/etc/init.d/httpd start
