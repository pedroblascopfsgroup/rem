<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
    <json:array name="titulos" items="${pagina.results}" var="titulo">   
        <json:object>
            <json:property name="id" value="${titulo.id}"/>
            <json:property name="tipoDocumentoGeneral" value="${titulo.tipoTitulo.tipoTituloGeneral.descripcion}"/>
            <json:property name="tipodocumento" value="${titulo.tipoTitulo.descripcion}" />
            <json:property name="incidencias" value="${titulo.situacion.descripcion}" />
            <json:property name="intervencion" value="${titulo.intervenido}" />
            <json:property name="comentario" value="${titulo.comentario}" />
        </json:object>
    </json:array>
</fwk:json>