<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="itinerarios" items="${pagina.results}" var="i" >
		<json:object>
			<json:property name="id" value="${i.id}" />
			<json:property name="nombre" value="${i.nombre}" />
			<json:property name="dDtipoItinerario" value="${i.dDtipoItinerario.descripcion}" /> 
			<json:property name="ambitoExpediente" value="${i.ambitoExpediente.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>