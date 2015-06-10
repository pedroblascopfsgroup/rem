<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="comitesItinerario" items="${comites}" var="c" >
		<json:object>
			<json:property name="id" value="${c.id}" />
			<json:property name="nombre" value="${c.nombre}" />
			<json:property name="atribucionMinima" value="${c.atribucionMinima}" />
			<json:property name="atribucionMaxima" value="${c.atribucionMaxima}" />
			<json:property name="miembros" value="${c.miembros}" />
			<json:property name="miembrosRestrict" value="${c.miembrosRestrict}" /> 
		</json:object>
	</json:array>
</fwk:json>