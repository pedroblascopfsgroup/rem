<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="listadoTareas" items="${pagina.results}" var="tar">
		<json:object>			 
			<json:property name="usuario" value="${tar.usuarioPendiente}" />
			<json:property name="tarea" value="${tar.id}" />
			<json:property name="asunto" value="${tar.asunto}" />
			<json:property name="nombreTarea" value="${tar.nombreTarea}" />
			<json:property name="descripcionTarea" value="${tar.descripcionTarea}" />
			<json:property name="procedimiento" value="${tar.procedimiento}" />
			<json:property name="fechaVenc" value="${tar.fechaVenc}" />
			<json:property name="resolucion" value="${tar.resolucion}" />
			<json:property name="idResolucion" value="${tar.idResolucion}" />
			<json:property name="idTipoResolucion" value="${tar.idTipoResolucion}" />
			<json:property name="codigoSubtipoTarea" value="${tar.subtipoTareaCodigoSubtarea}" />
			<json:property name="tipoAccionCodigo" value="${tar.tipoAccionCodigo}" />
			<json:property name="descripcionProcedimiento" value="${tar.descripcionProcedimiento}" />
		</json:object>
	</json:array>
</fwk:json>