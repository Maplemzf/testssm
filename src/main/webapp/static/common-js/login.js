
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
    $("#loginBtn").click(function () {
        debugger
        var userName = $.trim($("#userName").val());
        var password = $("#password").val();
        var flag = $('#defaultForm').data('bootstrapValidator').isValid();
        if(flag == true){
            $('#loginBtn').button('loading');
            $.ajax({
                type: "POST",
                url: "/user/login.do?codes="+$('#code').val()+"&timestamp="+timestamp,
                dataType: "json",
                data: JSON.stringify({"userName":userName,"password":password }),//md5
                success: function (jsonResult) {
                    if(jsonResult.re>=0){

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