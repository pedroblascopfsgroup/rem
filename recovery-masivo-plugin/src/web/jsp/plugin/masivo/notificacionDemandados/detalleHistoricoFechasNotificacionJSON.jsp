<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="data" items="${data}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="idPersona">${d.persona.id}</json:property>
            <json:property name="idProcedimiento" value="${d.procedimiento.id}"/>
            <json:property name="idDireccion" value="${d.direccion.codDireccion}"/>
            <json:property name="direccion" value="${d.direccion}"/>
            <json:property name="tipoFecha" value="${d.tipoFecha}"/>
            <json:property name="fechaSolicitud">
            	<fwk:date value="${d.fechaSolicitud}"/>
            </json:property>
            <json:property name="fechaResultado">
            	<fwk:date value="${d.fechaResultado}"/>
            </json:property>
            <json:property name="resultado" value="${d.resultado}"/>    
        </json:object>
    </json:array>
</fwk:json>