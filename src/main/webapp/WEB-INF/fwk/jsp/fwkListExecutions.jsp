<%@ page session="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
<title>Business Operation Executions</title>
</head>
	<body>
		<h3>Events</h3>
		<table border="1">
			<tr>
				<th>Key</th>
				<th>firstCallTime</th>
				<th>lastCallTime</th>
				<th>numberOfCalls</th>
				<th>acumulatedTime</th>
				<th>longestCall</th>
				<th>shortestCall</th>
				<th>averageCall</th>
				<th>runningTime</th>
			</tr>
			<c:forEach items="${stats}" var="s">
				<tr>
					<td><c:out value="${s.value.key}" /></td>
					<td><c:out value="${s.value.firstCallTime}" /></td>
					<td><c:out value="${s.value.lastCallTime}" /></td>
					<td><c:out value="${s.value.numberOfCalls}" /></td>
					<td><c:out value="${s.value.acumulatedTime}" /></td>
					<td><c:out value="${s.value.longestCall}" /></td>
					<td><c:out value="${s.value.shortestCall}" /></td>
					<td><c:out value="${s.value.acumulatedTime - s.value.numberOfCalls}" /></td>
					<td><c:out value="${s.value.lastCallTime - s.value.firstCallTime}" /></td>
				</tr>
			</c:forEach>
		</table>
	</body>
</html>