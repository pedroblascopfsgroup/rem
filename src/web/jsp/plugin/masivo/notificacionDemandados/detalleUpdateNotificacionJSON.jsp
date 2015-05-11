<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
        <json:object name="data">
            <json:property name="id">${data.id}</json:property>
            <json:property name="idPersona">${data.persona.id}</json:property>
            <json:property name="idProcedimiento">${data.procedimiento.id}</json:property>
            <json:property name="idDireccion">${data.direccion.codDireccion}</json:property>
            <json:property name="direccion">${data.direccion}</json:property>
			<json:property name="tipoFecha">${data.tipoFecha}</json:property>
			<json:property name="fechaSolicitud">${data.fechaSolicitud}</json:property>
			<json:property name="fechaResultado">${data.fechaResultado}</json:property>
			<json:property name="resultado">${data.resultado}</json:property>
        </json:object>
</fwk:json>