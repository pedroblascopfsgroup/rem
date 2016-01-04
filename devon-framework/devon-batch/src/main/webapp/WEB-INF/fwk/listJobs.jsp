<%@ page session="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
</head>
	<body>
		<h3>Jobs</h3>
		<table border="1">
			<tr>
				<th>Nombre</th>
			</tr>
			<c:forEach items="${jobs}" var="j">
				<tr>
					<td><a href="/pfs/admin/batch/launch.htm?jobName=<c:out value='${j.value.name}'/>"><c:out value="${j.value.name}"/></a></td>
				</tr>
			</c:forEach>
		</table>
		<br />
		<c:if test="${exitCode!=null}">exitCode:<c:out value="${exitCode}" /></c:if>
	</body>
</html>