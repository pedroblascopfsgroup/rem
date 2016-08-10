<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:array name="contratos" items="${expedienteContratos}" var="ec">
			<json:object>
				<json:property name="idContrato" value="${ec.contrato.id}"/>
				<json:property name="contrato" value="${ec.contrato.codigoContrato}"/>
				<json:property name="tipo" value="${ec.contrato.tipoProductoEntidad.descripcion}"/>
				<json:property name="vencido" value="${ec.contrato.lastMovimiento.posVivaVencidaAbsoluta}"/>
				<json:property name="total" value="${ec.contrato.lastMovimiento.saldoTotalAbsoluto}" />
				<json:property name="incluido" value="${ec.sinActuacion}" />
				<json:property name="incluidoBck" value="${ec.sinActuacion}" />
				<c:if test="${ec.sinActuacion}">
					<json:property name="nProcedimientos">
						<s:message code="decisioncomite.consulta.gridcontratos.sinactuacion" text="**Sin actuación"/>
					</json:property>
				</c:if>
				<c:if test="${!ec.sinActuacion}">
					<json:property name="nProcedimientos" value="${ec.cantidadProcedimientos}" />
				</c:if>
			</json:object> 
		</json:array>
</fwk:json>
