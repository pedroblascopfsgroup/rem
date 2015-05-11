<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="tareasBankia" items="${pagina.results}" var="tarea">
		<json:object>		
			<json:property name="id" value="${tarea.id}"/>
			
			<json:property name="codigo" value="${tarea.codigo}"/>

 		</json:object>
	</json:array>
</fwk:json>