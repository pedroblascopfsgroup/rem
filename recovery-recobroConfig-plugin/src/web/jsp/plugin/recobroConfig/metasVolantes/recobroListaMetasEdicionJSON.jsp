<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="metas" items="${formMetasVolantesItinerarios.listaMetas}" var="meta">
		<json:object>			 
			<json:property name="id" value="${meta.id}" />
			<json:property name="orden" value="${meta.orden}" />
			<json:property name="codigo" value="${meta.tipoMeta.codigo}" />
			<json:property name="descripcion" value="${meta.tipoMeta.descripcion}" />
			<json:property name="codigoYDesc" value="${meta.tipoMeta.codigo}: ${meta.tipoMeta.descripcion}" />
			<json:property name="diasDesdeEntrega" value="${meta.diasDesdeEntrega}" />	
			<c:if test="${meta.bloqueo}">
				<json:property name="bloqueo" value="01" />
			</c:if>
			<c:if test="${!meta.bloqueo}">
				<json:property name="bloqueo" value="02" />
			</c:if>
			<json:property name="plazoMaxGestion" value="${meta.itinerario.plazoMaxGestion}" />
			<json:property name="plazoSinGestion" value="${meta.itinerario.plazoSinGestion}" />
			<json:property name="idItinerario" value="${meta.itinerario.id}" />
		</json:object>
	</json:array>
	
</fwk:json>
