<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
    <json:array name="juzgados" items="${juzgados}" var="juzgado">
        <json:object>
        	<json:property name="id" value="${juzgado.id}"/>
            <json:property name="codigo" value="${juzgado.codigo}"/>
            <json:property name="descripcion" value="${juzgado.descripcion}"/>
        </json:object>
    </json:array>
</fwk:json>