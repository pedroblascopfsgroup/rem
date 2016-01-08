<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"
%>


<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>


<fwk:json>
	<json:array name="estadosItinerario" items="${formEstadosItinerarios.estados}" var="est" >
		<json:object>
			<json:property name="id" value="${est.id}" />
			<json:property name="estadoItinerario" value="${est.estadoItinerario.descripcion}" />
			<json:property name="gestorPerfil" value="${est.gestorPerfil.id}" />
			<json:property name="supervisor" value="${est.supervisor.id}" />
			<json:property name="gestor_nombre" value="${est.gestorPerfil.descripcion}" />
			<json:property name="supervisor_nombre" value="${est.supervisor.descripcion}" />
			<json:property name="plazo" value="${est.plazo / 86400000}" />
			<%-- 
			<json:property name="automatico">
				<c:if test="${est.automatico}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!est.automatico}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="telecobro">
				<c:if test="${est.telecobro}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!est.telecobro}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			--%>
		</json:object>
	</json:array>
</fwk:json>