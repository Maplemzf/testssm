<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link href="/static/common-css/bootstrap-datetimepicker.min.css"
	rel="stylesheet">
<link href="/static/common-css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<button type="button" class="btn btn-default Create pull-right">创建用户</button>
	<div id="tbCompanyAttribute_wrapper"
		class="dataTables_wrapper form-inline dt-bootstrap no-footer">
		<table class="display table table-bordered dataTable no-footer"
			id="tbCompanyAttribute" cellpadding="0" cellspacing="0" border="0"
			style="width: 100%" role="grid"
			aria-describedby="tbCompanyAttribute_info">
			<thead>
				<tr role="row">
					<th class="sorting_disabled" rowspan="1" colspan="1">用户名</th>
					<th class="sorting_disabled" rowspan="1" colspan="1">密码</th>
					<th class="sorting_disabled" rowspan="1" colspan="1">角色</th>
					<th class="sorting_disabled" rowspan="1" colspan="1">邮箱</th>
					<th class="sorting_disabled" rowspan="1" colspan="1">操作</th>
				</tr>
			</thead>
			<tbody id="tablet">

			</tbody>
		</table>
		<div class="clear"></div>
	</div>

</body>
<div class="hide" id="CreateRolePopup">
	<div class="container">
		<form role="form" class="formWidth">
			<div class="form-group">
				<label>用户名</label> <input id="user_name" class="form-control"
					type="text">
			</div>
			<div class="form-group">
				<label>密码</label> <input id="password" class="form-control"
					type="text">
			</div>
			<div class="form-group">
				<label>邮箱</label> <input id="email" class="form-control" type="text">
			</div>
			<div class="form-group">
				<label for="">角色</label> <select id="role" class="form-control">
					<option value="2">普通用户</option>
					<option value="1">管理员</option>
				</select>
			</div>
		</form>
	</div>
</div>
</html>
<script type="text/javascript" src="/static/common-js/jquery-2.1.1.js"></script>
<script type="text/javascript" src="/static/common-js/bootstrap.min.js"></script>
<script type="text/javascript" src="/static/common-js/bootbox.js"></script>
<script type="text/javascript"
	src="/static/common-js/bootstrapValidator.js"></script>
<script type="text/javascript" src="/static/common-js/common.js"></script>
<script type="text/javascript" src="/static/common-js/zh_CN.js"></script>
<script type="text/javascript">
	function gettable() {
		$('#tablet').empty();
		$.ajax({
					type : "POST",
					url : "/user/getUser.do",
					dataType : "json",
					contentType : 'application/json',
					data : JSON.stringify({}),//md5
					success : function(jsonResult) {
						for (var i = 0; i < jsonResult.length; i++) {
							$('#tablet')
									.append(
											'<tr role="row" class="odd"><td>'
													+ jsonResult[i].user_name
													+ '</td><td>'
													+ jsonResult[i].password
													+ '</td><td>'
													+ (jsonResult[i].role == 1 ? "管理员"
															: "普通用户")
													+ '</td><td>'
													+ (jsonResult[i].email==null?"":jsonResult[i].email)
													+ '</td><td>  <button type="button" class="btn  btn-xs " name="modify" dataid="'+jsonResult[i].id+'">修改</button> <button type="button" class="btn  btn-xs" name="delete"  dataid="'+jsonResult[i].id+'">删除</button></td></tr>');
							click(jsonResult[i].id);
						}
						
					},
					error : function(data, textStatus, message) {
						$('#loginBtn').button('reset');
						if (textStatus == 'timeout') {
							bootbox.alert('对不起 请求超时,与检查网络联接或与管理员取得联系！');
						} else {
							bootbox.alert('对不起 请求失败({0}) : {1}'.format(
									textStatus, message));
						}
					}
				});
	}
	gettable();
	function click(dataid){
		$('[name="modify"][dataid="'+dataid+'"]').click(function(){
			obj.$currentDlg = bootbox
					.dialog({
						title : "创建",
						// size: 'large',
						message : obj.html_dialog_CreateRole,
						buttons : {
							success : {
								label : "提交",
								className : "btn-success btn-orgName",
								callback : function() {
									if($('#user_name').val().trim()==""){
										bootbox.alert('对不起用户名不能为空！');
										return false;
									}
									if($('#password').val().trim()==""){
										return false;
										bootbox.alert('对不起密码不能为空！');
									}
									if($('#email').val().trim()==""){
										bootbox.alert('对不起邮箱不能为空！');
										return false;
									}
									$.ajax({
										type : "POST",
										url : "/user/update.do",
										dataType : "json",
										contentType : 'application/json',
										data : JSON.stringify({id:dataid,"user_name":$("#user_name").val().trim(),"password":$("#password").val().trim(),"email":$("#email").val().trim(),"role":$("#role").val().trim()}),//md5
										success : function(jsonResult) {
											 if(jsonResult.re>0){
												 bootbox.alert('操作成功！'); 
												 gettable();
											 }else{
												 bootbox.alert('操作失败！'+(jsonResult.error==null?"":jsonResult.error));
											 }
										},
										error : function(data, textStatus, message) {
											if (textStatus == 'timeout') {
												bootbox.alert('对不起 请求超时,与检查网络联接或与管理员取得联系！');
											} else {
												bootbox.alert('对不起 请求失败({0}) : {1}'.format(
														textStatus, message));
											}
										}
									});
								}
							},
							caner : {
								label : "取消",
								className : "btn-default",
								callback : function() {
								}
							}
						}
					});
			$.ajax({
				type : "POST",
				url : "/user/getUser.do",
				dataType : "json",
				contentType : 'application/json',
				data : JSON.stringify({id:dataid}),//md5
				success : function(jsonResult) {
					$('#user_name').val(jsonResult[0].user_name)
					$('#password').val(jsonResult[0].password)
					$('#email').val(jsonResult[0].email)
					 $('#role option[value=' + jsonResult[0].role + ']').attr("selected", "selected");
				},
				error : function(data, textStatus, message) {
					if (textStatus == 'timeout') {
						bootbox.alert('对不起 请求超时,与检查网络联接或与管理员取得联系！');
					} else {
						bootbox.alert('对不起 请求失败({0}) : {1}'.format(
								textStatus, message));
					}
				}
			});
		})
		$('[name="delete"][dataid="'+dataid+'"]').click(function(){
			obj.$currentDlg = bootbox
					.dialog({
						title : "删除",
						// size: 'large',
						message : "是否确认删除？",
						buttons : {
							success : {
								label : "确定",
								className : "btn-success btn-orgName",
								callback : function() {
									$.ajax({
										type : "get",
										url : "/user/delete.do?id="+dataid,
										dataType : "json",
										contentType : 'application/json',
										success : function(jsonResult) {
											 if(jsonResult.re>0){
												 bootbox.alert('操作成功！'); 
												 gettable();
											 }else{
												 bootbox.alert('操作失败！'+(jsonResult.error==null?"":jsonResult.error));
											 }
										},
										error : function(data, textStatus, message) {
											if (textStatus == 'timeout') {
												bootbox.alert('对不起 请求超时,与检查网络联接或与管理员取得联系！');
											} else {
												bootbox.alert('对不起 请求失败({0}) : {1}'.format(
														textStatus, message));
											}
										}
									});
								}
							},
							caner : {
								label : "取消",
								className : "btn-default",
								callback : function() {
								}
							}
						}
					});
		})
		
	}
	obj.html_dialog_CreateRole = $('#CreateRolePopup .container').html();
	$('#CreateRolePopup .container').remove();
	$('.Create')
			.click(
					'CreateRole',
					function() {
						obj.$currentDlg = bootbox
								.dialog({
									title : "创建",
									// size: 'large',
									message : obj.html_dialog_CreateRole,
									buttons : {
										success : {
											label : "提交",
											className : "btn-success btn-orgName",
											callback : function() {
												if($('#user_name').val().trim()==""){
													bootbox.alert('对不起用户名不能为空！');
													return false;
												}
												if($('#password').val().trim()==""){
													return false;
													bootbox.alert('对不起密码不能为空！');
												}
												if($('#email').val().trim()==""){
													bootbox.alert('对不起邮箱不能为空！');
													return false;
												}
												$.ajax({
													type : "POST",
													url : "/user/insert.do",
													dataType : "json",
													contentType : 'application/json',
													data : JSON.stringify({"user_name":$("#user_name").val().trim(),"password":$("#password").val().trim(),"email":$("#email").val().trim(),"role":$("#role").val().trim()}),//md5
													success : function(jsonResult) {
														 if(jsonResult.re>0){
															 bootbox.alert('操作成功！'); 
															 gettable();
														 }else{
															 bootbox.alert('操作失败！');
														 }
													},
													error : function(data, textStatus, message) {
														if (textStatus == 'timeout') {
															bootbox.alert('对不起 请求超时,与检查网络联接或与管理员取得联系！');
														} else {
															bootbox.alert('对不起 请求失败({0}) : {1}'.format(
																	textStatus, message));
														}
													}
												});
											}
										},
										caner : {
											label : "取消",
											className : "btn-default",
											callback : function() {
											}
										}
									}
								});
					})
</script>