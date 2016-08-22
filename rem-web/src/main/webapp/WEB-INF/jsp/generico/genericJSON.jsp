<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<c:set var="blankElement" value="true"/>
	
		<json:array name="diccionario" items="${items}" var="d">	
			 <%--<c:if test="${blankElement}">
		 	 		<json:object>
			 			<json:property name="codigo" value=""/>
				 		<json:property name="descripcion" value="---" />
			 		</json:object>
			 		<c:set var="blankElement" value="false"/>
			 </c:if>--%>
			 <json:object>
			   <json:property name="codigo" value="${d.codigo}" />
			   <json:property name="descripcion" value="${d.descripcion}" />
			 </json:object>
		</json:array>
	
	
</fwk:json>