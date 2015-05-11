<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
		<json:object name="resultadoNuevoProceso">
		<json:property name="idProceso" value="${idProceso}" />
		<json:property name="idTipoOperacion" value="${idTipoOperacion}" />
		<json:property name="descripcion" value="${descripcion}" />
		</json:object>
</fwk:json>
	