<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:array name="contratosProcedimientos" items="${expedienteContratos}" var="ec">
			<json:object>
				<json:property name="idContrato" value="${ec.contrato.id}"/>
				<c:if test="${ec.cantidadProcedimientos>0}">
					<json:property name="idProcedimiento" value="${ec.procedimientosActivos[0].id}" />
				</c:if>
				<c:if test="${ec.cantidadProcedimientos==0}">
					<json:property name="idProcedimiento" value="0"/>
				</c:if>
				
				<json:property name="contrato" value="${ec.contrato.codigoContrato}"/>
				<json:property name="vencido" value="${ec.contrato.lastMovimiento.posVivaVencida}"/>
				<json:property name="total" value="${ec.contrato.lastMovimiento.saldoTotal}" />
				<c:if test="${ec.cantidadProcedimientos==0}">
					<json:property name="asunto" value="" />
					<json:property name="estado" value="" />
					<c:if test="${ec.sinActuacion==false}">
						<json:property name="actuacion" value="" />
					</c:if>
					<c:if test="${ec.sinActuacion==true}">
						<json:property name="actuacion">
							<s:message code="contrato.sinActuacion" text="**Sin Actuación"/>
						</json:property>
					</c:if>
					<json:property name="procedimiento" value="" />
					<json:property name="reclamacion" value="" />
					<json:property name="saldoRecuperacion" value="" />
					<json:property name="porcRecuperacion" value="" />
					<json:property name="mesesRecuperacion" value="" />
				</c:if>
				<c:if test="${ec.cantidadProcedimientos>0}">
					<json:property name="asunto" value="${ec.procedimientosActivos[0].asunto.nombre}" />
					<json:property name="estado" value="${ec.procedimientosActivos[0].asunto.codigoDecodificado}" />
					<json:property name="actuacion" value="${ec.procedimientosActivos[0].tipoActuacion.descripcion}" />
					<json:property name="procedimiento" value="${ec.procedimientosActivos[0].tipoProcedimiento.descripcion}" />
					<json:property name="reclamacion" value="${ec.procedimientosActivos[0].tipoReclamacion.descripcion}" />
					<json:property name="saldoRecuperacion" value="${ec.procedimientosActivos[0].saldoRecuperacion}" />
					<json:property name="porcRecuperacion" value="${ec.procedimientosActivos[0].porcentajeRecuperacion}" />
					<json:property name="mesesRecuperacion" value="${ec.procedimientosActivos[0].plazoRecuperacion}" />
				</c:if>
			</json:object> 
			<c:forEach items="${ec.procedimientosActivos}" var="proc">
				<c:if test="${ec.procedimientosActivos[0]!=proc}">
					<json:object>
						<json:property name="idContrato" value="${ec.contrato.id}"/>
						<json:property name="idProcedimiento" value="${proc.id}"/>
						<json:property name="contrato" value=""/>
						<json:property name="vencido" value=""/>
						<json:property name="total" value="" />
						<json:property name="asunto" value="${proc.asunto.nombre}" />
						<json:property name="estado" value="${proc.asunto.codigoDecodificado}" />
						<json:property name="actuacion" value="${proc.tipoActuacion.descripcion}" />
						<json:property name="procedimiento" value="${proc.tipoProcedimiento.descripcion}" />
						<json:property name="reclamacion" value="${proc.tipoReclamacion.descripcion}" />
						<json:property name="saldoRecuperacion" value="${proc.saldoRecuperacion}" />
						<json:property name="porcRecuperacion" value="${proc.porcentajeRecuperacion}" />
						<json:property name="mesesRecuperacion" value="${proc.plazoRecuperacion}" />
					</json:object>
				</c:if>
			</c:forEach>
		</json:array>
</fwk:json>
