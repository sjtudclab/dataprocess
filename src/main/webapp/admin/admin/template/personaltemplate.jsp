<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>开发者作业组合管理</title>
    <link href="/DataProcess_WEB/css/bootstrap.css" rel="stylesheet">
       <script type="text/javascript" src="/DataProcess_WEB/js/jquery.js"></script>
    <script src="/DataProcess_WEB/js/bootstrap.js"></script> 
 <script src="../js/bootstrap-confirm.js"></script>
</head>

<body>
<div id="fileModal" class="modal hide fade">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h3>Please Upload Your File First</h3>
			</div>
			<form id="file_upload_form" class="form-horizontal" >
			<div class="modal-body" style="height: 50px">
				
					<div class="control-group">
						<label class="control-label" for="name">upload</label>
						<div class="controls">
							<div style="position: absolute; width: 340px" class="form-search">
							
								<input type='text' name="file" id="upload"
									style="width: 150px" class="form_value" /> <input type='button' class='btn'
									value='select' /> <input type="file" name="fileField"
									class="file" id="fileField" size="36"
									style="position: absolute; top: 0; right: 80px; height: 32px; filter: alpha(opacity : 0); opacity: 0; width: 300px"
									onchange="document.getElementById('upload').value=this.value" />
							</div>
						</div>
					</div>
				
			</div>
			<div class="modal-footer">
				<a href="#" class="btn">Close</a> <a href="#"
					class="btn btn-primary form_submit">upload</a>
			</div>
			</form>
		</div>
		
<div class="container">
<div class="container" style="text-align:right">

<form action="getPersonalTemplate.action" method="post" class="form-search">
<!-- <a href="#fileModal" role="button" class="btn btn-primary"
					data-toggle="modal">Create Temp</a>  -->
<label for="search-type">类型：</label>
<select id="searchKey" name="searchKey">
  <option value="1">关键字</option>
</select>
  <div class="input-append">
  
  
    <input id="searchValue" name="searchValue" type="text" class="span2 search-query">
    <button type="submit" class="btn">Search</button>
    
  </div>

  
  </form>
  
</div>
<legend>开发者作业组合管理</legend>

<table class="table table-striped">
<thead>
	<tr>
	<td>作业名</td>
	<td>作业描述</td>
	<td>开发者</td>
	<td>操作</td>
	</tr>
	</thead>
	<tbody>
	<c:forEach items="${requestScope['list']}" var="list">
	<tr>
		<td>${list.name }</td>
		<td>${list.description }</td>
		<td>${list.developer.name }</td>
		<td><a onclick="openDialog('getTemplateById.action?id=${list.id }')">查看</a>
		<a onclick="openDialog('modifyTempInfo.action?id=${list.id }')">修改</a>
		<a href="deleteTemplate.action?id=${list.id }">删除</a>
		<a href="flex.action?tempId=${list.id }">使用</a>
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>
<div class="form-actions">
<ul class="pager" style="text-align:right">

	<c:if test="${page.hasPreviousPage}"><li><a href="getPersonalTemplate.action?pno=1${searchString}">首页</a></li>
	<li><a href="getPersonalTemplate.action?pno=${page.currentPage-1 }${searchString}">上一页</a></li></c:if>
	<li>每页<c:out value="${page.pageSize}"></c:out>条记录</li>
	<li>共<c:out value="${page.rowCount}"></c:out>条记录</li>
	<li>当前第<c:out value="${page.currentPage}"></c:out>/<c:out value="${page.totalPage}"></c:out>页</li>
	<c:if test="${page.hasNextPage}"><li><a href="getPersonalTemplate.action?pno=${page.currentPage+1 }${searchString}">下一页</a></li>
	<li><a href="getPersonalTemplate.action?pno=${page.totalPage }${searchString}">末页</a></li></c:if>
	</ul>
</div>
</div>

<div id="tempModal" class="modal hide fade">
				<div class="modal-header">
					<a href="#" onclick="closeDialog()" class="close">&times;</a>
					<h3>Template Detail</h3>
					</div>
				<div class="modal-body">
					</div>
				<div class="modal-footer">
					<button class="btn" onclick="closeDialog()">Cancel</button>
					</div>
				</div>
				<script type="text/javascript">
				function openDialog(path){
					$("#tempModal").confirmModal({
		                heading: 'Upload your template',
		                body: "<iframe src=\"/DataProcess_WEB/admin/"+path+"\" frameborder='no' scrolling=auto width=500 height=360></iframe>",
		                callback: function () {
		                    alert('callback test');
		                }
		            });

				};
				
				$(document).ready(function(){
					
					$("#file_upload_form").keydown(function(e){if(e.keyCode==13){upload();}});
					$("#file_upload_form .form_submit").click(function(){upload();});
					});
					function upload(){
						$.ajax({
							type: "post",
					        dataType: "json",
					        url : "upload.action",
					        data: "file="+document.getElementById("upload").value,
					        success: function(data){
					        	$("#fileModal").modal('hide');
					        	openDialog("tempTrans.action",data.localPath);
							},
							error: function(jqXHR, textStatus, errorThrown){
								alert("fail");
							}
						});
					}
					
</script>
</body>
</html>
