<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="resultados" items="${resultados}" var="r">
		<json:object>
			<json:property name="codigoResultado" value="${r.codigoResultado}"/>
			<json:property name="mensajeError" value="${r.mensajeError}" />
			<json:property name="nResultados" value="${r.resultados}"/>
		</json:object>
	</json:array>
</fwk:json>	 		 