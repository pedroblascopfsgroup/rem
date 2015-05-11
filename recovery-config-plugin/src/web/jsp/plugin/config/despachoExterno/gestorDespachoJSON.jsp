<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
		<json:object name="gestorDespacho">
			<json:property name="id" value="${gestorDespacho.id}" />
			<json:property name="idusuario" value="${gestorDespacho.usuario.id}" />
			<json:property name="username" value="${gestorDespacho.usuario.username}" />
			<json:property name="nombre" value="${gestorDespacho.usuario.nombre}" />
			<json:property name="apellido1" value="${gestorDespacho.usuario.apellido1}" />
			<json:property name="apellido2" value="${gestorDespacho.usuario.apellido2}" />
			<json:property name="nombrecompleto" value="${gestorDespacho.usuario.nombre!=null?gestorDespacho.usuario.apellidoNombre:gestorDespacho.usuario.username}" />
			<json:property name="email" value="${gestorDespacho.usuario.email}" />
			<json:property name="telefono" value="${gestorDespacho.usuario.telefono}" />
		</json:object>
</fwk:json>