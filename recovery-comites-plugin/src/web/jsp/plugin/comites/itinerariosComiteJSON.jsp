<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="dtoItinerario" items="${formItinerariosComite.dtoItinerario}" var="iti">
		<json:object  prettyPrint="true">
			<json:property name="idComite" value="${iti.idComite}"/>
			<json:property name="idItinerario" value="${iti.idItinerario}" />
			<json:property name="itinerario" value="${iti.itinerario}" />
			<json:property name="tipoItinerario" value="${iti.tipoItinerario}" />
			<json:property name="compatible" value="${iti.compatible}" />
			<%--
			<json:property name="compatible" >
				<c:if test="${iti.compatible}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!iti.compatible}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			 --%>
		</json:object>
	</json:array>
</fwk:json>