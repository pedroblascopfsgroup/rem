<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="data" items="${data}" var="d">
        <json:object>
        	<json:property name="id" value="${d.id}"/>
            <json:property name="idAsunto" value="${d.idAsunto}"/>
            <json:property name="idProcedimiento" value="${d.idProcedimiento}"/>
            <json:property name="nombre">${d.nombre}</json:property>
            <json:property name="plaza" value="${d.plaza}"/>
            <json:property name="juzgado" value="${d.juzgado}"/>
            <json:property name="auto" value="${d.auto}"/>
            <json:property name="principal" value="${d.principal}"/>
            <json:property name="tipoPrc" value="${d.tipoPrc}"/>
            <json:property name="desEstadoPrc" value="${d.desEstadoPrc}"/>
            <json:property name="codEstadoPrc" value="${d.codEstadoPrc }"/>      
            <json:property name="idTarea" value="${d.idTarea}"/>
            <json:property name="tarTarea" value="${d.tarTarea}"/>    
        </json:object>
    </json:array>
</fwk:json>