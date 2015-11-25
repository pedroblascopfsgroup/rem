<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	<json:array name="liquidaciones" items="${liquidaciones}" var="l">
		<json:object>
			<json:property name="id" value="${l.id}" />
 			<json:property name="contrato" value="${l.idContrato}" />
 			<json:property name="nroContrato" value="${l.nroContrato}" />
 			<json:property name="solicitante" value="${l.solicitante}" />
			<json:property name="producto" value="${l.producto}" />
			<json:property name="estadoLiquidacion" value="${l.estadoLiquidacion}" />
			<json:property name="estadoCodigo" value="${l.estadoCod}" />
			<json:property name="fechaSolicitud">
				<fwk:date value="${l.fechaSolicitud}" />
			</json:property>
			<json:property name="fechaRecepcion">
				<fwk:date value="${l.fechaRecepcion}" />
			</json:property>
			<json:property name="fechaConfirmacion">
				<fwk:date value="${l.fechaConfirmacion}" />
			</json:property>
			<json:property name="fechaCierre">
				<fwk:date value="${l.fechaCierre}" />
			</json:property>
			<json:property name="capitalVencido" value="${l.capitalVencido}" />
			<json:property name="capitalNoVencido" value="${l.capitalNoVencido}" />
			<json:property name="interesesOrdinarios" value="${l.interesesOrdinarios}" />
			<json:property name="interesesDemora" value="${l.interesesDemora}" />
			<json:property name="total" value="${l.total}" />
			<json:property name="apoderado" value="${l.apoderadoNombre}" />
			<json:property name="comisiones" value="${l.comisiones}" />
			<json:property name="gastos" value="${l.gastos}" />
			<json:property name="impuestos" value="${l.impuestos}" />
		</json:object>
	</json:array>
</fwk:json>
