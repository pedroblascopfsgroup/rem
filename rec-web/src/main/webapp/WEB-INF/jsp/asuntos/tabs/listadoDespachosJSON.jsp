<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="despachos" items="${despachos}" var="despacho">
		<json:object>
			<json:property name="id" value="${despacho.id}" />
			<json:property name="tipo" value="${despacho.tipoDespacho.codigo}" />
			<json:property name="codigo" value="${despacho.codigo}" />
			<json:property name="nombre" value="${despacho.despacho}" />
		</json:object>
	</json:array>
</fwk:json>