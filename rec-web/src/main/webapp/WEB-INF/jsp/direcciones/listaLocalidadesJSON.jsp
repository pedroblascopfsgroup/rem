<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:array name="listaLocalidades" items="${listaData}" var="d"> 
        <json:object> 
	        <json:property name="id" value="${d.id}"/>
	        <json:property name="descripcion" value="${d.descripcion}"/>
 		</json:object>
    </json:array>    
</fwk:json>