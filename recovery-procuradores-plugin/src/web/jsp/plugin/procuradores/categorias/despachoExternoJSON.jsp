<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${total}" />
	<json:array name="listaDespachos" items="${listado}" var="des">
		<json:object>
			<json:property name="idDespExt" value="${des.id}" />
			<json:property name="despacho" value="${des.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>