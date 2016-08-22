<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="contratos" items="${contratos}" var="contrato">
		<json:object>
			<json:property name="id" value="${contrato.id}" />
			<json:property name="contrato" value="${contrato.codigoContrato}" />
			<json:property name="tipo" value="${contrato.tipoProductoEntidad.descripcion}" />
			<json:property name="saldo" value="${contrato.lastMovimiento.posVivaVencida}" />
			<json:property name="dias" value="${contrato.diasIrregular}" />
			<json:property name="riesgo" value="${contrato.lastMovimiento.saldoTotal}" />
			<json:property name="estado" value="${contrato.estadoContrato.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>