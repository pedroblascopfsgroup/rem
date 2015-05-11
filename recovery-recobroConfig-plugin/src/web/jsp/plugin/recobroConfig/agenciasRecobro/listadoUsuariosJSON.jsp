<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:array name="usuarios" items="${usuarios}" var="usuario"> 
        <json:object> 
	        <json:property name="id" value="${usuario.id}"/>
	        <json:property name="nombre" value="${usuario.nombre}"/>
 		</json:object>
    </json:array>    
</fwk:json>