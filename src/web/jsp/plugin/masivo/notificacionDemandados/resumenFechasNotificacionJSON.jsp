<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="data" items="${data}" var="d">
        <json:object>
            <json:property name="idProcedimiento" value="${d.idProcedimiento}"/>
            <json:property name="idDemandado">${d.idDemandado}</json:property>
            <json:property name="nombreDemandado" value="${d.nombreDemandado}"/>
            <json:property name="excluido" value="${d.excluido}"/>
            <json:property name="fechaReqPago">
            	<fwk:date  value="${d.fechaReqPago}"/>
            </json:property>
            <json:property name="resultadoReqPago" value="${d.resultadoReqPago}"/>
            <json:property name="fechaSolicitudAvDomiciliaria">
            	<fwk:date value="${d.fechaSolicitudAvDomiciliaria}"/>
            </json:property>
            <json:property name="resultadoAvDomiciliaria" value="${d.resultadoAvDomiciliaria}"/>
            <json:property name="fechaSolicitudReqEdicto">
            	<fwk:date value="${d.fechaSolicitudReqEdicto}"/>
            </json:property>
            <json:property name="resultadoReqEdicto" value="${d.resultadoReqEdicto}"/>
        </json:object>
    </json:array>
</fwk:json>