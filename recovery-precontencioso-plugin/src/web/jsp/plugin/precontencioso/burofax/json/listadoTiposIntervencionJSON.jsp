<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
        <json:array name="tiposIntervencion" items="${listaTiposIntervencion}" var="t">    
                <json:object>
 					<json:property name="id" value="${t.id}" />
 					<json:property name="codigo" value="${t.codigo}" />
 					<json:property name="titular" value="${t.titular}" />
 					<json:property name="avalista" value="${t.avalista}" />
 					<json:property name="descripcion" value="${t.descripcion}" />
                </json:object>               
        </json:array>
</fwk:json>