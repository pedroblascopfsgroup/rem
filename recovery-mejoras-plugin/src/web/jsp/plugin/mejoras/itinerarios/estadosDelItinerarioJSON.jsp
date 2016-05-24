<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>
	<json:array name="estadosItinerario" items="${estadosItinerario}" var="est" >
		<json:object>
			<json:property name="id" value="${est.id}" />
			<json:property name="codigo" value="${est.codigo}" />
			<json:property name="estadoItinerario" value="${est.estadoItinerario.descripcion}" />
			<json:property name="gestorPerfil" value="${est.gestorPerfil.id}" />
			<json:property name="supervisor" value="${est.supervisor.id}" />
			<json:property name="gestor_nombre" value="${est.gestorPerfil.descripcion}" />
			<json:property name="supervisor_nombre" value="${est.supervisor.descripcion}" />
			<json:property name="plazo" value="${est.plazo / 86400000}" /> 
		</json:object>
	</json:array>
</fwk:json>