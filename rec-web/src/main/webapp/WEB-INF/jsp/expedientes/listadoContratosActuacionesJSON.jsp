<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:array name="contratosActuaciones" items="${contratosActuaciones}" var="ec">
			<json:object>
				<json:property name="idContrato" value="${ec.contrato.id}"/>
				<json:property name="contrato" value="${ec.contrato.codigoContrato}" />
				<json:property name="tipo" value="${ec.contrato.tipoProducto.descripcion}" />
				<c:if test="${ec.sinActuacion}">
					<json:property name="procedimiento">
						<s:message code="decisioncomite.consulta.gridcontratos.sinactuacion" text="**Sin Actuacion" />
					</json:property>
				</c:if>
				<c:if test="${!ec.sinActuacion}">
					<json:property name="procedimiento" value="" />
				</c:if>
				<json:property name="tipoActuacion" value="" />
				<json:property name="fechaCreacionProcedimiento" value="" />
			</json:object>
			<c:forEach items="${ec.procedimientosActivos}" var="prc">
				<json:object>
					<json:property name="contrato" value="" />
					<json:property name="tipo" value="" />
					<json:property name="procedimiento" value="${prc.id}" />
					<json:property name="tipoActuacion" value="${prc.tipoActuacion.descripcion}" />
					<json:property name="actuacion" value="${prc.tipoProcedimiento.descripcion}" />
					<json:property name="fechaCreacionProcedimiento">
						<fwk:date value="${prc.auditoria.fechaCrear}" />
					</json:property>
				</json:object>
			</c:forEach>
		</json:array>
</fwk:json>
