<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
    <%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>作业列表</title>
    <link href="../css/bootstrap.css" rel="stylesheet">
       <script type="text/javascript" src="../js/jquery.js"></script>
    <script src="../js/bootstrap.js"></script> 
 <script src="../js/bootstrap-confirm.js"></script>
</head>

<body>
<div class="container">
<div class="container" style="text-align:right">

<form action="getJobList.action" class="form-search" method="post">
<label for="search-type">类型：</label>
<select id="searchKey" name="searchKey">
  <option value="1">关键字</option>
  <option value="2">数据模型</option>
  <option value="3">开发者</option>
</select>
  <div class="input-append">
  
  
    <input type="text" id="searchValue" name="searchValue" class="span2 search-query">
    <button type="submit" class="btn">Search</button>
    
  </div>

  
  </form>
  
</div>
<legend>作业列表</legend>

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
	<c:forEach items="${requestScope['list']}" var="job">
	<tr>
		<td>${job.name }</td>
		<td>${job.description }</td>
		<td>${job.developer.name }</td>
		<td><a onclick="openDialog('getJobById.action?id=${job.id }')">查看</a>
		</td>
	</tr>
	</c:forEach>
	</tbody>
</table>
<div class="form-actions">
<ul class="pager" style="text-align:right">

	<c:if test="${page.hasPreviousPage}"><li><a href="getJobList.action?pno=1${searchString}">首页</a></li>
	<li><a href="getJobList.action?pno=${page.currentPage-1 }${searchString}">上一页</a></li></c:if>
	<li>每页<c:out value="${page.pageSize}"></c:out>条记录</li>
	<li>共<c:out value="${page.rowCount}"></c:out>条记录</li>
	<li>当前第<c:out value="${page.currentPage}"></c:out>/<c:out value="${page.totalPage}"></c:out>页</li>
	<c:if test="${page.hasNextPage}"><li><a href="getJobList.action?pno=${page.currentPage+1 }${searchString}">下一页</a></li>
	<li><a href="getJobList.action?pno=${page.totalPage }${searchString}">末页</a></li></c:if>
	</ul>
</div>
</div>

<div id="jobModal" >

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
	$('#jobModal').modal('hide'); 
	};
</script>
</body>
</html>