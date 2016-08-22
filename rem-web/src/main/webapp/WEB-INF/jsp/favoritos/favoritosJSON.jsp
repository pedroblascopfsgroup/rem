<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:array name="favoritos" items="${favoritos}" var="fav">
		<json:object>
			<json:property name="codigo" value="${fav.entidadId}" />
			<json:property name="nombre" value="${fav.nombre}" />
			<json:property name="tipo" value="${fav.entidadInformacion.codigo}" />
		</json:object>
	</json:array>
</fwk:json>