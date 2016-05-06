<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="listaGestoresExternos" items="${listaGestoresExternos}" var="ges">
		<json:object>
			<json:property name="id" value="${ges.id}" />
			<json:property name="nombre" value="${ges.nombre}" />
			<json:property name="apellido1" value="${ges.apellido1}" />
			<json:property name="apellido2" value="${ges.apellido2}" />
			<json:property name="username" value="${ges.username}" />
		</json:object>
	</json:array>
</fwk:json>