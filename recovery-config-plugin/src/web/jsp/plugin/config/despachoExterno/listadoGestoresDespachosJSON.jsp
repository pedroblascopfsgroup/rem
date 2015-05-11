<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="gestoresDespacho" items="${gestores}" var="g">
		<json:object>
			<json:property name="id" value="${g.id}" />
			<json:property name="idusuario" value="${g.usuario.id}" />
			<json:property name="username" value="${g.usuario.username}" />
			<json:property name="nombre" value="${g.usuario.nombre}" />
			<json:property name="apellido1" value="${g.usuario.apellido1}" />
			<json:property name="apellido2" value="${g.usuario.apellido2}" />
			<json:property name="email" value="${g.usuario.email}" />
			<json:property name="telefono" value="${g.usuario.telefono}" />
		</json:object>
	</json:array>
</fwk:json>