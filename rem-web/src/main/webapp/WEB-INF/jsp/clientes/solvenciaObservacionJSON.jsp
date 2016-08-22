<%@page pageEncoding="iso-8859-1" contentType="application/json; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:object name="data" >
		<json:property name="observacionesSolvencia" value="${personaObservacion.observacionesSolvencia}" escapeXml="false"/>
		<json:property name="fechaVerifSolvencia">
			<fwk:date value="${personaObservacion.fechaVerifSolvencia}" />
		</json:property>
	</json:object>
</fwk:json>
