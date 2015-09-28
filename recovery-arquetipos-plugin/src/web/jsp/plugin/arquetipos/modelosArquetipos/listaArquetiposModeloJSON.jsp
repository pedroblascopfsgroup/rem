<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"
%>


<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>


<fwk:json>
	<json:array name="arquetiposModelo" items="${formArquetiposModelo.arquetipos}" var="a" >
		<json:object>
			<json:property name="id" value="${a.id}" />
			<json:property name="prioridad" value="${a.prioridad}" />
			<json:property name="arquetipo" value="${a.arquetipo.nombre}" />
			<json:property name="gestion">
				<c:if test="${a.arquetipo.gestion}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!a.arquetipo.gestion}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="itinerario" value="${a.itinerario.id}" />
			<json:property name="itinerario_nombre" value="${a.itinerario.nombre}" />
			<json:property name="nivel" value="${a.nivel}" />
			<json:property name="plazoDisparo" value="${a.plazoDisparo}" /> 
			<json:property name="tipoSaltoNivel" value="${a.arquetipo.tipoSaltoNivel.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>