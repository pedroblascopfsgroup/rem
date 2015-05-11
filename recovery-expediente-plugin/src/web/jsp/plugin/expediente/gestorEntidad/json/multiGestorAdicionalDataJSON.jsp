<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="listaGestoresAdicionales" items="${listaGestoresAdicionales}" var="gah">
		<json:object>
			<json:property name="id" value="${gah.id}" />
			<json:property name="idGestor" value="${gah.usuario.id}" />
			<json:property name="usuario" value="${gah.usuario.apellidoNombre}" />
			<json:property name="tipoGestor" value="${gah.tipoGestor.codigo}" />
			<json:property name="tipoGestorDescripcion" value="${gah.tipoGestor.descripcion}" />
			<json:property name="fechaDesde" value="${gah.fechaDesde}" />
			<json:property name="fechaHasta" value="${gah.fechaHasta}" />
			<json:property name="editableWeb" value="${gah.tipoGestor.editableWeb}" />
		</json:object>
	</json:array>
</fwk:json>