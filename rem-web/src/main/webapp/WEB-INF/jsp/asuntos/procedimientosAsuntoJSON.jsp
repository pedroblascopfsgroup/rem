<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:array name="contratosProcedimientos" items="${contratos}" var="c">
			<json:object>
				<json:property name="idContrato" value="${c.id}"/>
				<json:property name="contrato" value="${c.codigoContrato}"/>
				<json:property name="tipo" value="${c.tipoProducto.descripcion}"/>
				<json:property name="vencido" value="${c.lastMovimiento.posVivaVencidaAbsoluta}"/>
				<json:property name="total" value="${c.lastMovimiento.saldoTotalAbsoluto}" />
				<json:property name="incluido" value="${c.expedienteContratoActivo.sinActuacion}" />
				<json:property name="incluidoBck" value="${c.expedienteContratoActivo.sinActuacion}" />
				<json:property name="idExpediente" value="${c.expedienteContratoActivo.expediente.id}" />
				<json:property name="idExpedienteContrato" value="${c.expedienteContratoActivo.id}" />
				<c:if test="${c.expedienteContratoActivo.sinActuacion}">
					<json:property name="nProcedimientos">
						<s:message code="decisioncomite.consulta.gridcontratos.sinactuacion" text="**Sin actuación"/>
					</json:property>
				</c:if>
				<c:if test="${!c.expedienteContratoActivo.sinActuacion}">
					<json:property name="nProcedimientos" value="${c.expedienteContratoActivo.cantidadProcedimientos}" />
				</c:if>
			</json:object> 
		</json:array>
</fwk:json>         
