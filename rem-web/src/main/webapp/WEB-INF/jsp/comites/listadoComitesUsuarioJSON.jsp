<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="comitesJSON" items="${comites}" var="dto">
        <json:object>
            <json:property name="id" value="${dto.comite.id}" />
            <json:property name="nombre" value="${dto.comite.nombre}" />
            <json:property name="estado" value="${dto.comite.estado}" />
            <json:property name="atrmin" value="${dto.comite.atribucionMinima}" />
            <json:property name="atrmax" value="${dto.comite.atribucionMaxima}" />
            <json:property name="pendientes" value="${dto.cantidadDePuntosParaTratar}" />
            <json:property name="prioridad" value="${dto.comite.prioridad}" />
            <json:property name="fechaVencimiento">
                <fwk:date value="${dto.comite.fechaVencimiento}" />
            </json:property>
            <json:property name="zona" value="${dto.comite.zona.descripcionLarga}" />
        </json:object>
    </json:array>
</fwk:json>