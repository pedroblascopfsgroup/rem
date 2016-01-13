<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="contratosAsunto" items="${listadoContratosAsuntos}" var="contrato">
		<json:object>
			<json:property name="id" value="${contrato.id}"/>
			<json:property name="incluir" value="${false}" />		
            <json:property name="cc" value="${contrato.codigoContrato}" />                 
            <json:property name="tipo" value="${contrato.tipoProducto.descripcion}" />
            <c:if test="${cb.contrato.lastMovimiento != null}">
            	<json:property name="saldoIrregular" value="${contrato.lastMovimiento.posVivaVencidaAbsoluta}" />
            	<json:property name="saldoNoVencido" value="${contrato.lastMovimiento.posVivaNoVencidaAbsoluta}" />
                <json:property name="diasIrregular" value="${contrato.diasIrregular}" />
            </c:if> 
            <json:property name="otrosint" value="${contrato.contratoPersonaOrdenado[0].persona.apellidoNombre}" />
            <json:property name="tipointerv" value="${contrato.contratoPersonaOrdenado[0].tipoIntervencion.descripcion} ${ec.contrato.contratoPersonaOrdenado[0].orden}" />
            <json:property name="estadoFinanciero" value="${contrato.estadoFinanciero.descripcion}" />
		</json:object>
	</json:array>
	
</fwk:json>