<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<c:set value="true" var="blankElement"/>
	<json:array name="idTareaProc" items="${tareasProc}" var="tarea">
		<c:set var="_current" value="${l}" scope="page" />
		 	 <c:if test="${blankElement}">
			 	 <json:object>
			 	 	<json:property name="id" value=""/>
				 	<json:property name="codigo" value=""/>
					<json:property name="descripcion" value="---" />
				 </json:object>
				 <c:set value="false" var="blankElement"/>
			 </c:if>
		<json:object>
			<json:property name="id" value="${tarea.id}" />
			<json:property name="codigo" value="${tarea.id}" />
			<json:property name="descripcion" value="${tarea.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>