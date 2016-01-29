<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:property name="total" value="${plazos.totalCount}" />
	<json:array name="plazos" items="${plazos.results}" var="p">
		<json:object prettyPrint="true">
			<json:property name="id" value="${p.id}" />
			<json:property name="tipoProcedimiento" value="${p.nombreProcedimiento}" />
			<json:property name="tareaProcedimiento" value="${p.nombreTareaProcedimiento}" />
			<json:property name="tipoPlaza" value="${p.nombreTipoPlaza}" />
			<json:property name="tipoJuzgado" value="${p.nombreTipoJuzgado}" />
			<json:property name="scriptPlazo" value="${p.scriptPlazo}" />
			<json:property name="absoluto" >
				<c:if test="${p.absoluto}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!p.absoluto}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="observaciones" value="${p.observaciones}" />
		</json:object>
	</json:array>
</fwk:json>