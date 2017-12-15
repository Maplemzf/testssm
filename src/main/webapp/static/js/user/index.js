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
	function on_success_login(ticket){
		
		$('#div-login').addClass('hide');
		$('#div-jumping').removeClass('hide');
		$.ajax({
            type: "GET",
            url: "/api/sso/getDomainList",//可信用域列表
            dataType: "json",
			crossDomain:true,
            success: function (res) {
                var xxx=new Array();
				obj.sso_target_sum = res.length;
                for(var i = 0 ; i < res.length ; ++i ){

					var url="{0}/api/sso/setsso/{1}/{2}".format(res[i],ticket,new Date().getTime());//针对每个站去生成一个访问URL
					//var url = "/setCookies/{0}/{1}/{2}/".format(web,ticket,new Date().getTime());//生成一个本地网站的访问URL
					xxx[i]=$.ajax({
					  type:"get", dataType:"jsonp", jsonp:"callback",url: url,crossDomain:true,async:false,//调用生成后的url
					  success:function(data){
						  console.log(data);
						  obj.sso_success();
					  },
					  error:function(data){
						  obj.sso_success();
					  }
					});
				}

                setTimeout(function(){
                        for(var i=0;i<xxx.length;i++){
                            if(xxx[i].status!=200){
                                xxx[i].abort();
                            }
                        }
                    },
                    obj.sso_target_sum*timeOut
                );

            },
            error: function (data, textStatus, message) {
				bootbox.alert('对不起 登录平台失败(SSO {0}) : {1}'.format(textStatus , message));
            }
      });
			
	}

	$("#logoutBtn").click(function () {
		$.ajax({
            type: "GET",
            url: API_UserLogout + ticket,
			success:function(data){
				window.location.reload();
			}
		});
	});
	$("#backBtn").click(function () {
		var url = "/";
		if(typeof(return_to) == 'string' && return_to.length > 0){
			url = return_to;
		}
		window.location.href = url;
	});
    // 登录
    $("#loginBtn").click(function () {
        var mobile = $.trim($("#mobile").val());
        var password = $("#password").val();
		var flag = $('#defaultForm').data('bootstrapValidator').isValid();
		if(flag == true){
			$('#loginBtn').button('loading');
			$.ajax({
				type: "POST",
				url: "/api/sso/userLogin?code="+$('#code').val()+"&timestamp="+timestamp,
				dataType: "json",
				data: {"mobile":mobile,"password":md5(password) ,"portrait":getFB()},//md5
				success: function (jsonResult) {
					$('#loginBtn').button('reset');
					if (jsonResult.result == 0) {
						if(jsonResult.detail != null && jsonResult.detail.length > 0){
							on_success_login( jsonResult.detail);
						}else{
							bootbox.alert('对不起 登录结果异常,请管理员取得联系！');
						}

					} else {
						bootbox.alert("{0} {1}".format(jsonResult.message , jsonResult.detail == null ? '' : jsonResult.detail));
						changeImg();
						$('#code').val("")
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

    // 手机号码验证
    function mobileValid(obj) {
        var mobileRegex = /^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\d{8}$/;
        var mobile = $.trim(obj);
        if (!isEmpty(mobile)) {
            if ((mobileRegex.test(mobile))) {
                return true;
            }
        }
        return false;
    }


    return obj;
}();