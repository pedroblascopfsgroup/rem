<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:property name="total" value="${pagina.totalCount}" />
    <json:array name="plazas" items="${pagina.results}" var="pl">
        <json:object>
        	<json:property name="id" value="${pl.id}" />
            <json:property name="codigo" value="${pl.codigo}" />
            <json:property name="descripcion" value="${pl.descripcion}" />
        </json:object>
    </json:array>
</fwk:json> 

