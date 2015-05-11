<%@ page session="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
</head>
	<body>
		<p>Descripcion: = <c:out value="${config.valor}" /></p>
		<p><a href='<c:url value="j_spring_security_logout"/>'>Logout</</p>
	</body>
</html>