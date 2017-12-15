<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>用户登录</title> 
    <link href="/static/common-css/bootstrap.min.css" rel="stylesheet">
    <link href="/static/common-font-awesome/css/font-awesome.css" rel="stylesheet">
    <!-- Toastr style -->
    <link href="/static/common-css/plugins/toastr/toastr.min.css" rel="stylesheet">
    <!-- Gritter -->
    <link href="/static/common-js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
    <link href="/static/common-css/animate.css" rel="stylesheet">
    <link href="/static/common-css/style.css" rel="stylesheet">
	<style>
		.ibox-content {
			clear: both;
			border-radius: 8px;
			opacity: 0.7;
			filter: alpha(opacity=50);
		}
		.border-bottom{
			border-left:none;
			border-right:none;
			border-top:none;
			border-bottom:1px solid #0F2543;
		}
		.footer{
			background:none;
			border:none;
		}
	</style>
</head>
<body class="gray-bg" style="background-image: url('/static/image/loginBackground.jpg');background-size:cover;">
<!--<a href="{ReturnBack}" class="Link"></a>-->
<!--    <div class="middle-box text-center loginscreen animated fadeInDown">-->
<!--        <div>-->
<!--          -->
<!--        </div>-->
<!--    </div>-->
<div class="loginColumns animated fadeInDown">
	<div class="row">
		<div class="col-md-6 col-md-offset-3">
			<div class="ibox-content" style="text-align: center">
<!--				<h3>{WebsiteName}</h3>-->
				<!--<img src="../../static/image/LoginLogo.png" alt="">-->
				<div id="div-login" class="hide">
					<form class="m-t" role="form" action="#" id="defaultForm" data-bv-message="This value is not valid" data-bv-feedbackicons-valid="glyphicon glyphicon-ok" data-bv-feedbackicons-invalid="glyphicon glyphicon-remove" data-bv-feedbackicons-validating="glyphicon glyphicon-refresh">
						<div class="form-group">
							<input id="userName" type="usercode" class="form-control border-bottom" name="firstName" placeholder="登录帐号" required data-bv-notempty-message="不能为空" data-bv-stringlength="true" data-bv-stringlength-min="1" data-bv-stringlength-max="30">
						</div>
						<div class="form-group">
							<input id="password" type="password" class="form-control border-bottom" placeholder="用户密码" name="lastName" required data-bv-notempty-message="不能为空">
						</div>
						<div class="form-group">
							<input id="code" type="text" autocomplete="off" class="form-control border-bottom" placeholder="验证码" name="code" required data-bv-notempty-message="不能为空" data-bv-stringlength="true" data-bv-stringlength-min="4" data-bv-stringlength-max="4" style="position: relative">
							<img id="imgObj" alt="验证码" style="position: absolute;top:-10px;right:0px" onclick="changeImg()"/>
						</div>
						<button class="btn btn-sm btn-primary btn-block loginBtn" type="1">登录</button>
						<button class="btn  btn-primary btn-block loginBtn" type="2">注册</button>
					</form>
				</div>
				
			</div>
		</div>
	</div>

</div>

<script>
//	var isLogin = {IsLogin};
	var ticket = "{Ticket}";
	var return_to = "{ReturnTo}";
</script>
</body>
</html>
<script type="text/javascript" src="/static/common-js/jquery-2.1.1.js"></script>
<script type="text/javascript" src="/static/common-js/bootstrap.min.js"></script>
<script type="text/javascript" src="/static/common-js/bootbox.js"></script>
<script type="text/javascript" src="/static/common-js/bootstrapValidator.js"></script>
<script type="text/javascript" src="/static/common-js/common.js"></script>
<script type="text/javascript" src="/static/common-js/zh_CN.js"></script>
<script type="text/javascript">

;var ObjLoginIndex = function(
) { 			//定义对象

    var obj = new Object();

    function  setCookie(name, value, expires, path, domain, secure) {
        document.cookie = name + "=" + escape (value) +
            ((expires) ? "; expires=" + expires : "") +
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            ((secure) ? "; secure" : "");
    };

    obj.ID = '';
    obj.init			= function(id){		//初始化函数,请在页面$(document).ready调用
        obj.ID = id;//记录ID编号
        $('#defaultForm').bootstrapValidator();

    };
    obj.sso_target_sum = 0;
    obj.sso_target_count = 0;



    obj.sso_success = function(){

        obj.sso_target_count += 1;
        if(obj.sso_target_sum <= obj.sso_target_count && typeof(return_to) == 'string' && return_to.length > 0){
            window.location.href = '/index';/*\*/
        }
    };
    //debugger;
    if(typeof(isLogin ) == 'number' && isLogin  == 1){
        $('#div-login').addClass('hide');
        $('#div-info').removeClass('hide');
    }else{
        $('#div-login').removeClass('hide');
    }

    // 登录
    $(".loginBtn").click(function () {
        var  type=$(this).attr("type")
        var userName = $.trim($("#userName").val());
        var password = $("#password").val();
        var flag = $('#defaultForm').data('bootstrapValidator').isValid();
        if(flag == true){
            $('#loginBtn').button('loading');
            $.ajax({
                type: "POST",
                url: "/user/login.do?codes="+$('#code').val()+"&timestamp="+timestamp+"&type="+type,
                dataType: "json",
                contentType : 'application/json',  
                data: JSON.stringify({"user_name":userName,"password":password }),//md5
                success: function (jsonResult) {
                	 $('#loginBtn').button('reset');
                    if(jsonResult.re>0){
						if(type==1){
							if(jsonResult.role==1){
								window.location.href="/jsp/one.jsp";
							}else{
								window.location.href="/jsp/two.jsp";
							}
						}else{
							 bootbox.alert("注册成功");	
							 $('#code').val("");
							 changeImg();
						}
                    }else{
                        bootbox.alert(jsonResult.error);
                    }

                },
                error: function (data, textStatus, message) {
                    $('#loginBtn').button('reset');
                    if(textStatus == 'timeout'){
                        bootbox.alert('对不起 请求超时,与检查网络联接或与管理员取得联系！');
                    }else{
                        bootbox.alert('对不起 登录请求失败({0}) : {1}'.format(textStatus , message));
                    }
                }
            });
        }else{
            return true;
        }
        return true;
    });

    function getFB(){
        var canvas = document.createElement('canvas');
        var ctx = canvas.getContext('2d');
        var txt = 'http://security.tencent.com/';
        ctx.textBaseline = "top";
        ctx.font = "14px 'Arial'";
        ctx.textBaseline = "tencent";
        ctx.fillStyle = "#f60";
        ctx.fillRect(125,1,62,20);
        ctx.fillStyle = "#069";
        ctx.fillText(txt, 2, 15);
        ctx.fillStyle = "rgba(102, 204, 0, 0.7)";
        ctx.fillText(txt, 4, 17);
        var b64 = canvas.toDataURL().replace("data:image/png;base64,","");
        var bin = atob(b64);
        return md5(bin);
    }



    return obj;
}();

$(document).ready(ObjLoginIndex.init('{ID}'));
var timestamp
function changeImg() {
    var imgSrc = $("#imgObj");
    var src = "/user/validateCode";
    imgSrc.attr("src", changeUrl(src));
}
//为了使每次生成图片不一致，即不让浏览器读缓存，所以需要加上时间戳
function changeUrl(url) {
    timestamp = (new Date()).valueOf();
    var index = url.indexOf("?",url);
    if (index > 0) {
        url = url.substring(0, url.indexOf( "?"));
    }
    if ((url.indexOf("&") >= 0)) {
        url = url + "×tamp=" + timestamp;
    } else {
        url = url + "?timestamp=" + timestamp;
    }
    return url;
}
changeImg();
</script>

