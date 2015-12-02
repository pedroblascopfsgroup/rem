<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:array name="documentosUG" items="${documentosUG}" var="s">
        <json:object>
            <json:property name="id" value="${s.id}" />
            <json:property name="unidadGestionId" value="${s.unidadGestionId}" />
            <json:property name="contrato" value="${s.contrato}" />    
            <json:property name="descripcionUG" value="${s.descripcionUG}" />
        </json:object>
    </json:array>
</fwk:json> 

