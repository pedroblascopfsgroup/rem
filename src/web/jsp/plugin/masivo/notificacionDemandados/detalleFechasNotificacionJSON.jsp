<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="data" items="${data}" var="d">
        <json:object>
            <json:property name="idPersona">${d.idDemandado}</json:property>
            <json:property name="idProcedimiento" value="${d.idProcedimiento}"/>
            <json:property name="idDireccion" value="${d.idDireccion}"/>
            <json:property name="direccion" value="${d.direccion}"/>
            <json:property name="fechaRequerimiento">
            	<fwk:date value="${d.fechaRequerimiento}"/>
            </json:property>
            <json:property name="resultadoRequerimiento" value="${d.resultadoRequerimiento}"/>
            <json:property name="fechaHorarioNocturno">
            	<fwk:date value="${d.fechaHorarioNocturno}"/>
           	</json:property>
            <json:property name="resultadoHorarioNocturno" value="${d.resultadoHorarioNocturno}"/>            
        </json:object>
    </json:array>
</fwk:json>