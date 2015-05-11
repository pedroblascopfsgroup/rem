<%@ page session="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
</head>
	<body>
		<h3>Users</h3>
		<table border="1">
			<tr>
				<th>Entidad	</th>
				<th>username</th>
				<th>Nombre</th>
				<th>Apellido1</th>
				<th>Apellido2</th>
				<th>email</th>
				<th>enabled</th>
			</tr>
			<c:forEach items="${users}" var="u">
				<tr>
					<td><c:out value="${u.entidad.descripcion}" /></td>
					<td><c:out value="${u.username}" /></td>
					<td><c:out value="${u.nombre}" /></td>
					<td><c:out value="${u.apellido1}" /></td>
					<td><c:out value="${u.apellido2}" /></td>
					<td><c:out value="${u.email}" /></td>
					<td><c:out value="${u.enabled}" /></td>
				</tr>
			</c:forEach>
		</table>
	</body>
</html>