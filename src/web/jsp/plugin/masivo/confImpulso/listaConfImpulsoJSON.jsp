<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${impulsos.totalCount}" />
    <json:array name="impulsos" items="${impulsos.results}" var="d">
        <json:object>
        	<json:property name="id" value="${d.id}"/>
            <json:property name="tipoJuicio" value="${d.tipoJuicio.descripcion}"/>
            <json:property name="tareaProcedimiento" value="${d.tareaProcedimiento.descripcion}"/>
            <c:if test='${d.conProcurador == true}'>
            	<json:property name="conProcurador" value="SI"/>
            </c:if>	
           	<c:if test='${d.conProcurador != true}'>
            	<json:property name="conProcurador" value="NO"/>
           	</c:if>
            <json:property name="despacho" value="${d.despacho.descripcion}"/>
            <json:property name="cartera" value="${d.cartera}"/>
        </json:object>
    </json:array>
</fwk:json>
