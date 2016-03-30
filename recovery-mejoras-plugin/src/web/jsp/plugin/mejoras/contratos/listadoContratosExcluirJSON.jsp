<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
        <json:array name="contratos" items="${procedimiento.expedienteContratos}" var="ec">    
                <json:object>
                    <json:property name="id" value="${ec.contrato.id}" />
                    <json:property name="excluir" value="${false}" />
                    <json:property name="codigoContrato" value="${ec.contrato.codigoContrato}" />
                    <json:property name="tipoProducto" value="${ec.contrato.tipoProducto.descripcion}" />
<c:if test="${ec.contrato.lastMovimiento != null}">                    
                    <json:property name="saldoIrregular" value="${ec.contrato.lastMovimiento.posVivaVencidaAbsoluta}" />
                    <json:property name="diasIrregular" value="${ec.contrato.diasIrregular}" />
                    <json:property name="riesgo" value="${ec.contrato.lastMovimiento.riesgo}" />
</c:if>                    
					<json:property name="estadoContrato" value="${ec.contrato.estadoContrato.descripcion}"/>
					<json:property name="titular" value="${ec.contrato.primerTitular.apellidoNombre}"/>
					<json:property name="estadoFinanciero" value="${ec.contrato.estadoFinanciero.descripcion}"/>
					<c:if test="${ec.pase != null && ec.pase == 1}">
						<json:property name="pase" value="Sí" />
					</c:if>
					<c:if test="${ec.pase == null || ec.pase == 0}">
						<json:property name="pase" value="No" />
					</c:if>
					<json:property name="cex" value="${ec.id}"/>
                </json:object>
        </json:array>
</fwk:json>