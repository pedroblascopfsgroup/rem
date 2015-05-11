<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="gestor" items="${listaGestoresAdicionales}" var="gah">
		<json:object>
			<json:property name="id" value="${gah.id}" />
			<json:property name="idGestor" value="${gah.gestor.id}" />
			<json:property name="usuario" value="${gah.gestor.usuario.apellidoNombre}" />
			<json:property name="tipoGestor" value="${gah.tipoGestor.codigo}" />
			<json:property name="tipoGestorDescripcion" value="${gah.tipoGestor.descripcion}" />
			<json:property name="fechaDesde">
				 <fwk:date value="${gah.fechaDesde}" />
			</json:property>
			<json:property name="fechaHasta">
				<fwk:date  value="${gah.fechaHasta}" />
			</json:property>
		</json:object>
	</json:array>
</fwk:json>