<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="gestor" items="${listaGestoresAdicionales}" var="gah">
		<json:object>
			<json:property name="id" value="${gah.id}" />
			<json:property name="idGestor" value="${gah.gestor.id}" />
			<json:property name="usuarioId" value="${gah.usuario.id}" />
			<json:property name="tipoGestor" value="${gah.tipoGestor.codigo}" />
			<json:property name="tipoGestorDescripcion" value="${gah.tipoGestor.descripcion}" />
			<json:property name="fechaDesde">
				 <fwk:date value="${gah.fechaDesde}" />
			</json:property>
			<json:property name="fechaHasta">
				<fwk:date  value="${gah.fechaHasta}" />
			</json:property>
			<json:property name="tipoVia" value="${gah.gestor.despachoExterno.tipoVia}" />
			<json:property name="domicilio" value="${gah.gestor.despachoExterno.domicilio}" />
			<json:property name="domicilioPlaza" value="${gah.gestor.despachoExterno.domicilioPlaza}" />
			<json:property name="telefono1" value="${gah.gestor.despachoExterno.telefono1}" />
			<json:property name="email" value="${gah.gestor.usuario.email}" />
		</json:object>
	</json:array>
</fwk:json>