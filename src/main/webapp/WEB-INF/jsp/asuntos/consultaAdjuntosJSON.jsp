<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="adjuntos" items="${asunto.adjuntos}" var="adj">
		<json:object>
			<json:property name="id" value="${adj.id}" />
			<json:property name="nombre" value="${adj.nombre}" />
			<json:property name="contentType" value="${adj.contentType}" />
			<json:property name="length" value="${adj.length}" />
		</json:object>
	</json:array>
</fwk:json>