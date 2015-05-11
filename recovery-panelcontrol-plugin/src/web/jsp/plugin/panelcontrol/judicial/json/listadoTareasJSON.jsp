<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="tarea" items="${pagina.results}" var="tar">
		<json:object>			 
			<json:property name="id" value="${tar.id}" />
			<json:property name="tarea" value="${tar.tarea}" />
			<json:property name="unidadGestion" value="" />
			<json:property name="descripcion" value="${tar.descripcionTarea}" />
			<json:property name="gestion" value="${tar.descGestor}" />
			<json:property name="fechaVencimiento"><fwk:date value="${tar.fechaVenc}"/></json:property>
			<json:property name="fechaVencimientoOriginal"><fwk:date value="${tar.fechaVencReal}"/></json:property>
			<json:property name="tipoSolicitud" value="${tar.tipoSolicitud}" />
			<json:property name="diasVencida" value="${tar.diasVencido}" />
			<json:property name="gestor" value="${tar.descGestor}" />
			<json:property name="supervisor" value="${tar.descSupervisor}" />
			<json:property name="vre" value="${tar.volumenRiesgo}" />
			<json:property name="vreVencidos" value="${tar.volumenRiesgoVencido}" />
			<json:property name="fechaRevisionTarea"><fwk:date value="${tar.fechaRevisionAlerta}"/></json:property>
		</json:object>
	</json:array>
</fwk:json>
