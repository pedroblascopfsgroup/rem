<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="arquetipos" items="${pagina.results}" var="p">
		<json:object>
			<json:property name="id" value="${p.id}" />
			<json:property name="nombre" value="${p.nombre}" />
			<json:property name="rule" value="${p.rule.name}" />
			<json:property name="gestion">
				<c:if test="${p.gestion}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!p.gestion}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="plazoDisparo" value="${p.plazoDisparo}" />
			<json:property name="tipoSaltoNivel" value="${p.tipoSaltoNivel.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>