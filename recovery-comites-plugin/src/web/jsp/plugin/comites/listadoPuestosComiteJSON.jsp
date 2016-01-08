<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="puestos" items="${puestos}" var="p">
		<json:object>
			<json:property name="id" value="${p.id}"/>
			<json:property name="perfil" value="${p.perfil.descripcion}" />
			<json:property name="zona" value="${p.zona.descripcion}" />
			<json:property name="esRestrictivo" >
				<c:if test="${p.esRestrictivo}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!p.esRestrictivo}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="esSupervisor" >
				<c:if test="${p.esSupervisor}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!p.esSupervisor}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
		</json:object>
	</json:array>
</fwk:json>