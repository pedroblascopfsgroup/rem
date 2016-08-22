<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="debug" value="${debug}" />
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="users" items="${pagina.results}" var="u">
		<json:object>
			<json:property name="username" value="${u.username}" />
			<json:property name="password" value="${u.password}" />
			<json:property name="nombre" value="${u.nombre}" />
			<json:property name="apellido1" value="${u.apellido1}" />
			<json:property name="apellido2" value="${u.apellido2}" />
		</json:object>
	</json:array>
</fwk:json>