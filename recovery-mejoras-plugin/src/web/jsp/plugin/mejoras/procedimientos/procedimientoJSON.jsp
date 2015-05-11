<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:object name="procedimiento">
		<json:property name="id" value="${procedimiento.id}" />
		<json:object name="tipoActuacion">
			<json:property name="codigo"
				value="${procedimiento.tipoActuacion.codigo}" />
		</json:object>
		<json:object name="tipoProcedimiento">
			<json:property name="codigo"
				value="${procedimiento.tipoProcedimiento.codigo}" />
		</json:object>
		<json:object name="tipoReclamacion">
			<json:property name="codigo"
				value="${procedimiento.tipoReclamacion.codigo}" />
		</json:object>
		<json:property name="saldoRecuperacion"
			value="${procedimiento.saldoRecuperacion}" />
		<json:property name="porcentajeRecuperacion"
			value="${procedimiento.porcentajeRecuperacion}" />
		<json:property name="plazoRecuperacion"
			value="${procedimiento.plazoRecuperacion}" />
		
		<json:array name="personasAfectadas" items="${procedimiento.personasAfectadas}" var="per">
			<json:object>
				<json:property name="id" value="${per.id}"/>
			</json:object> 
		</json:array>
	</json:object>
</fwk:json>