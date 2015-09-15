<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<c:set var="blankElement" value="true" />

<fwk:json>
	<json:array name="ambitoExpedienteIti" items="${ambitoExpedienteIti}" var="ddAmbitoExpediente">
	
		<c:if test="${blankElement}">
			<json:object>
					<json:property name="id" value="" />
					<json:property name="codigo" value="" />
					<json:property name="descripcion" value="--" />
			</json:object>
			<c:set var="blankElement" value="false" />
		</c:if>
	
		<json:object>
			<json:property name="id" value="${ddAmbitoExpediente.id}" />
			<json:property name="codigo" value="${ddAmbitoExpediente.id}" />
			<json:property name="descripcion" value="${ddAmbitoExpediente.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>