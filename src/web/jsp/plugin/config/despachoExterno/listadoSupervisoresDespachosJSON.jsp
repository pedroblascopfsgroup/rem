<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="supervisoresDespacho" items="${supervisores}" var="s">
		<json:object>
			<json:property name="id" value="${s.id}" />
			<json:property name="idusuario" value="${s.usuario.id}" />
			<json:property name="username" value="${s.usuario.username}" />
			<json:property name="nombre" value="${s.usuario.nombre}" />
			<json:property name="apellido1" value="${s.usuario.apellido1}" />
			<json:property name="apellido2" value="${s.usuario.apellido2}" />
			<json:property name="email" value="${s.usuario.email}" />
			<json:property name="telefono" value="${s.usuario.telefono}" />
		</json:object>
	</json:array>
</fwk:json>