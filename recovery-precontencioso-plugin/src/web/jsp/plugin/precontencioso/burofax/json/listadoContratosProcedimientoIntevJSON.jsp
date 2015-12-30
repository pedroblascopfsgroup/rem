<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
        <json:array name="contratos" items="${procedimiento}" var="ec">    
                <json:object>
                	<c:if test="${ec.contrato != null}">
	                    <json:property name="idContrato" value="${ec.contrato.id}" />
	                    <json:property name="cc" value="${ec.contrato.codigoContrato}" />
	                    <json:property name="tipo" value="${ec.contrato.tipoProducto.descripcion}" />
	                    <json:property name="diasIrregular" value="${ec.contrato.diasIrregular}" />
	                    <json:property name="saldoNoVencido" value="${ec.contrato.lastMovimiento.posVivaNoVencidaAbsoluta}" />
	                    <json:property name="saldoIrregular" value="${ec.contrato.lastMovimiento.posVivaVencidaAbsoluta}" />
                    </c:if>
                    <c:if test="${ec.tipoIntervencion != null}">
                    	<json:property name="tipointerv" value="${ec.tipoIntervencion.descripcion}" />
                    </c:if>
                </json:object>               
        </json:array>
</fwk:json>