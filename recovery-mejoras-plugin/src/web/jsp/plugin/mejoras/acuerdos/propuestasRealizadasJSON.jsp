<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="actuaciones" items="${propuestas}" var="actuacion">	
		<json:object>
			<json:property name="id" value="${actuacion.id}" />
			<json:property name="tipoActuacion" value="${actuacion.ddTipoActuacionAcuerdo.descripcion}" />
			<json:property name="fecha">
				<fwk:date value="${actuacion.fechaActuacion}" />
			</json:property>
	 		<json:property name="resultado" value="${actuacion.ddResultadoAcuerdoActuacion.descripcion}" />
	 	 	<json:property name="actitud" value="${actuacion.tipoAyudaActuacion.descripcion}" />
	 	 	<json:property name="observaciones" value="${actuacion.observaciones}"/>
	 	</json:object>
	</json:array>
</fwk:json>