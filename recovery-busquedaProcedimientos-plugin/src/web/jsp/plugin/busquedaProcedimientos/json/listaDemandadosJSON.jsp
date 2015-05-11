<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="data" items="${data}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="nombre">${d.nombre} ${d.apellido1} ${d.apellido2}</json:property>
            
            
        </json:object>
    </json:array>
</fwk:json>