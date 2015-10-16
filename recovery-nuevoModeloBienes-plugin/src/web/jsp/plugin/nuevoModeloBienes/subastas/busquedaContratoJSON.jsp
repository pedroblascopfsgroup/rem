<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:object name="contrato">
		<json:property name="idContrato" value="${contrato.idContrato}"/>
		<json:property name="numContrato" value="${contrato.numContrato}"/>
		<json:property name="garantia" value="${contrato.garantia}"/>
		<json:property name="garantiaApp" value="${contrato.garantiaApp}"/>
		<json:property name="tipoProducto" value="${contrato.tipoProducto}"/>
	</json:object>
</fwk:json>
