<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
         <json:array name="contratos" items="${expedienteContratos}" var="cex">
                <json:object>
					<json:property name="idCex" value="${cex.expedienteContrato.id}" />
                    <json:property name="id" value="${cex.expedienteContrato.contrato.id}" />
                    <json:property name="vencido" value="${cex.expedienteContrato.contrato.vencido}" />
                    <json:property name="cc" value="${cex.expedienteContrato.contrato.codigoContrato}" />
                    <json:property name="tipo" value="${cex.expedienteContrato.contrato.tipoProductoEntidad.descripcion}" />
                    <json:property name="saldoIrregular" value="${cex.expedienteContrato.contrato.lastMovimiento.posVivaVencidaAbsoluta}" />
					<json:property name="saldoNoVencido" value="${cex.expedienteContrato.contrato.lastMovimiento.posVivaNoVencidaAbsoluta}" />
                    <json:property name="saldoTotal" value="${cex.expedienteContrato.contrato.lastMovimiento.saldoTotalAbsoluto}" />
                    <json:property name="tipointerv" value="${cex.expedienteContrato.contrato.contratoPersonaOrdenado[0].tipoIntervencion.descripcion} ${cex.expedienteContrato.contrato.contratoPersonaOrdenado[0].orden}" />
					<json:property name="seleccionado" value="${cex.seleccionado}" />
                </json:object>
        </json:array>
</fwk:json>
