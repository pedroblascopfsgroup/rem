<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="gestor" items="${listaGestoresAdicionales}" var="gaa">
		<json:object>
			<json:property name="id" value="${gaa.id}" />
			<json:property name="idGestor" value="${gaa.gestor.id}" />
			<json:property name="usuarioId" value="${gaa.gestor.usuario.id}" />
			<json:property name="usuario" value="${gaa.gestor.usuario.apellidoNombre}" />
			<json:property name="tipoGestor" value="${gaa.tipoGestor.codigo}" />
			<json:property name="tipoGestorId" value="${gaa.tipoGestor.id}" />
			<json:property name="tipoGestorDescripcion" value="${gaa.tipoGestor.descripcion}" />
			<json:property name="tipoDespachoId" value="${gaa.gestor.despachoExterno.id}" />
			<json:property name="fechaDesde" value="" />
			<json:property name="fechaHasta" value="" />
			<json:property name="tipoVia" value="${gaa.gestor.despachoExterno.tipoVia}" />
			<json:property name="domicilio" value="${gaa.gestor.despachoExterno.domicilio}" />
			<json:property name="domicilioPlaza" value="${gaa.gestor.despachoExterno.domicilioPlaza}" />
			<json:property name="telefono1" value="${gaa.gestor.despachoExterno.telefono1}" />
			<json:property name="email" value="${gaa.gestor.usuario.email}" />
		</json:object>
	</json:array>
</fwk:json>