<%@page pageEncoding="iso-8859-1" contentType="application/json; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:array name="diccionario" items="${lista}" var="tipo">	
		 <json:object>
		   <json:property name="codigo" value="${tipo.codigo}" />
		   <json:property name="descripcion" value="${tipo.descripcion}" />
		 </json:object>
	</json:array>
</fwk:json>
