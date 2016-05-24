<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
		<json:object name="resultadoDatosvalidacion">
			<json:property name="validacion" value="${validacion}" />
		</json:object>
</fwk:json>
	