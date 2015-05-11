<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:array name="localidades" items="${localidades}" var="localidad"> 
        <json:object> 
	        <json:property name="codigo" value="${localidad.codigo}"/>
	        <json:property name="id" value="${localidad.id}"/>
	        <json:property name="descripcion" value="${localidad.descripcion}"/>
 		</json:object>
    </json:array>    
</fwk:json>