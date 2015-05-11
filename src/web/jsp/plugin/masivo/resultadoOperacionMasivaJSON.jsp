<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
		<json:object name="resultado">
			<json:property name="cantidad" value="${resultado.numeroOperacionesRealizadas}" />
			<json:property name="errores" value="${resultado.numeroOperacionesFallidas}" />
			<json:property name="observaciones" value="${resultado.observaciones}" />
		</json:object>
</fwk:json>
	