<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${comites.totalCount}" />
	<json:array name="comites" items="${comites.results}" var="com">
		<json:object>
			<json:property name="id" value="${com.id}" />
			<json:property name="nombre" value="${com.nombre}" />
			<json:property name="atribucionMinima" value="${com.atribucionMinima}" />
			<json:property name="atribucionMaxima" value="${com.atribucionMaxima}" />
			<json:property name="prioridad" value="${com.prioridad}" />
			<json:property name="miembros" value="${com.miembros}" />
			<json:property name="miembrosRestrict" value="${com.miembrosRestrict}" />
		</json:object>
	</json:array>
</fwk:json>