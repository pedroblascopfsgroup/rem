<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:array name="ingresos" items="${ingresos}" var="i">
		<json:object>
			<json:property name="id" value="${i.id}" />
			<json:property name="tipoIngreso" value="${i.tipoIngreso}" />
			<json:property name="periodicidad" value="${i.periodicidad}" />
			<json:property name="bruto" value="${i.ingNetoBruto}" />
			<json:property name="fechaCrear" value="${i.auditoria.fechaCrear}" />
			<json:property name="fechadisp" value="AGREGAR CAMPO" />
		</json:object>
	</json:array>
</fwk:json>
