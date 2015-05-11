<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	  <json:array name="contratos" items="${procedimientos}" var="proc">
			<json:object>
				<json:property name="idContrato" value="${proc.expedienteContrato.contrato.id}"/>
				<json:property name="contrato" value="${proc.expedienteContrato.contrato.codigoContrato}" />
				<json:property name="vencido" value="${proc.expedienteContrato.contrato.lastMovimiento.posVivaVencida}" />
				<json:property name="total" value="${proc.expedienteContrato.contrato.lastMovimiento.totalDeuda}" />
				<json:property name="asunto" value="${proc.asunto.id}" />
				<json:property name="estado" value="${proc.asunto.codigoDecodificado}" />
				<json:property name="actuacion" value="${proc.tipoActuacion.descripcion}" />
				<json:property name="procedimiento" value="${proc.tipoProcedimiento.descripcion}" />
				<json:property name="gestor" value="${proc.asunto.gestor.usuario.username}" />
			</json:object>
		</json:array>
		
</fwk:json>
