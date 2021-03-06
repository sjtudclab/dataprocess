<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
    <link href="/DataProcess_WEB/css/bootstrap.css" rel="stylesheet">
       <script type="text/javascript" src="/DataProcess_WEB/js/jquery.js"></script>
    <script src="/DataProcess_WEB/js/bootstrap.js"></script> 
 <script src="../js/bootstrap-confirm.js"></script>
</head>

<body>
<div class="container">
<div class="container" style="text-align:right">

<form action="getTemplateList.action" method="post" class="form-search">
<label for="search-type">类型：</label>
<select id="searchKey" name="searchKey">
  <option value="1">关键字</option>
  <option value="2">开发者</option>
</select>
  <div class="input-append">
  
  
    <input id="searchValue" name="searchValue" type="text" class="span2 search-query">
    <button type="submit" class="btn">Search</button>
    
  </div>

  
  </form>
  
</div>
<legend>Template List</legend>

<table class="table table-striped">
<thead>
	<tr>
	<td>组合名</td>
	<td>使用时间</td>
	<td>开发者</td>
	<td>操作</td>
	</tr>
	</thead>
	<tbody>
	<c:forEach items="${requestScope['list']}" var="list">
	<tr>
		<td>${list.name }</td>
		<td>${list.usedTime }</td>
		<td>${list.user.name }</td>
		<td><a onclick="openDialog('getTemplateById.action?id=${list.id }')">查看</a>
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>
<div class="form-actions">
<ul class="pager" style="text-align:right">

	<c:if test="${page.hasPreviousPage}${searchString}"><li><a href="getJobListAction.action?pno=1">首页</a></li>
	<li><a href="getJobListAction.action?pno=${page.currentPage-1 }${searchString}">上一页</a></li></c:if>
	<li>每页<c:out value="${page.pageSize}"></c:out>条记录</li>
	<li>共<c:out value="${page.rowCount}"></c:out>条记录</li>
	<li>当前第<c:out value="${page.currentPage}"></c:out>/<c:out value="${page.totalPage}"></c:out>页</li>
	<c:if test="${page.hasNextPage}"><li><a href="getJobListAction.action?pno=${page.currentPage+1 }${searchString}">下一页</a></li>
	<li><a href="getJobListAction.action?pno=${page.totalPage }${searchString}">末页</a></li></c:if>
	</ul>
</div>
</div>

<div id="temp]Modal" class="modal hide fade">
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
					$("#jobModal").confirmModal({
		                heading: 'Confirm your action',
		                body: "<iframe src=\"/DataProcess_WEB/admin/"+path+"\" frameborder='no' scrolling=auto width=500 height=360></iframe>",
		                callback: function () {
		                    alert('callback test');
		                }
		            });

				};
				
function closeDialog () {
	$('#tempModal').modal('hide'); 
	};
</script>
</body>
</html>