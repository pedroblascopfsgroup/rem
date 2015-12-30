<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="data" items="${data}" var="d">
        <json:object>
            <json:property name="idPersona" value="${d.persona.id}"/>
            <json:property name="dniPersona">${d.persona.docId}</json:property>
            <json:property name="nombrePersona">${d.persona.nom50}</json:property>
            <json:property name="personaCompleto">${d.persona.nom50} - DNI: ${d.persona.docId}</json:property>
            <json:property name="nombre">${d.persona.nombre}</json:property>
            <json:property name="apellido1">${d.persona.apellido1}</json:property>
            <json:property name="apellido2">${d.persona.apellido2}</json:property>
            <json:property name="manual">${d.manual}</json:property>
        </json:object>
    </json:array>
</fwk:json>