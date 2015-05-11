<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
    <json:array name="contratos" items="${contratos}" var="contrato">
        <json:object>
            <json:property name="idContrato" value="${contrato.id}"/>
            <json:property name="codigo" value="${contrato.codigoContrato}" />
            <json:property name="tipo" value="${contrato.tipoProducto.descripcion}" />
            <c:if test="${contrato.cantTitulos > 0}">
                <json:property name="id" value="${contrato.titulos[0].id}"/>
                <json:property name="tipodocumento" value="${contrato.titulos[0].tipoTitulo.descripcion}" />
                <json:property name="incidencias" value="${contrato.titulos[0].situacion.descripcion}" />
                <json:property name="intervencion" value="${contrato.titulos[0].intervenido}" />
                <json:property name="comentario" value="${contrato.titulos[0].comentario}" />
            </c:if>
        </json:object>
        <c:forEach items="${contrato.titulos}" var="tit">
            <c:if test="${contrato.titulos[0].id != tit.id}">
                <json:object>
                    <json:property name="id" value="${tit.id}"/>
                    <json:property name="idContrato" value="${tit.contrato.id}"/>
                    <json:property name="tipodocumento" value="${tit.tipoTitulo.descripcion}" />
                    <json:property name="incidencias" value="${tit.situacion.descripcion}" />
                    <json:property name="intervencion" value="${tit.intervenido}" />
                    <json:property name="comentario" value="${tit.comentario}" />
                </json:object>
            </c:if>
        </c:forEach>
    </json:array>
</fwk:json>