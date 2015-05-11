<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="requerimientos" items="${tiposRequerimiento}" var="requerimiento">
        <json:object>
        	<json:property name="codigo" value="${requerimiento.codigo}"/>
            <json:property name="descripcion" value="${requerimiento.descripcion}"/>   
        </json:object>
    </json:array>
</fwk:json>