<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="contrato" items="${pagina.results}" var="cnt">
		<json:object>			 
			<json:property name="id" value="${cnt.id}" />
			<json:property name="codigoContrato" value="${cnt.codigoContrato}" />
			<json:property name="diasIrregular" value="${cnt.diasIrregular}" />
			<json:property name="estadoContrato" value="${cnt.estadoContrato.descripcion}" />
			<json:property name="estadoFinanciero" value="${cnt.estadoContrato.descripcion}" />
			<json:property name="riesgo" value="${cnt.riesgo}" />
			<json:property name="saldoVencido" value="${cnt.lastMovimiento.posVivaVencidaAbsoluta}" />
			<json:property name="situacion" value="Panel control" />
			<json:property name="tipoProducto" value="${cnt.tipoProducto.descripcion}" />
			<json:property name="titular" value="${cnt.primerTitular.apellidoNombre}" />
		</json:object>
	</json:array>
</fwk:json>