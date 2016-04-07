<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:object name="persona">
		<json:property name="nombre" value="${persona.nom50}" />
		<json:property name="docid" value="${persona.docId}" />
	</json:object>
	<json:object name="contrato">
		<json:property name="fechaVencimiento">
		 	<fwk:date value="${contrato.fechaVencimiento}" />
		 </json:property>
		 <json:property name="tipoInteres" value="${contrato.tipoInteres}" />
	</json:object>
	<c:if test="${liquidacion != null}">
		<json:object name="liquidacion">
			<json:property name="capital" value="${liquidacion.capitalVencido + liquidacion.capitalNoVencido}" />
			<json:property name="interesesOrdinarios" value="${liquidacion.interesesOrdinarios}" />
			<json:property name="interesesDemora" value="${liquidacion.interesesDemora}" />
			<json:property name="comisiones" value="${liquidacion.comisiones}" />
			<json:property name="impuestos" value="${liquidacion.impuestos}" />
			<json:property name="gastos" value="${liquidacion.gastos}" />
			<json:property name="fechaCierre">
				<fwk:date value="${liquidacion.fechaCierre}" />
			</json:property>
		</json:object>
	</c:if>
</fwk:json>