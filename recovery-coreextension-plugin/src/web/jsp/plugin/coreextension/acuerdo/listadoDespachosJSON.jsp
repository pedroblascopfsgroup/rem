<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="despachos" items="${despachos.results}" var="des">
		<json:object>
			<json:property name="id" value="${des.id}" />
			<json:property name="despacho" value="${des.despacho}" />
			<json:property name="telefono1" value="${des.telefono1}" />
		</json:object>
	</json:array>
</fwk:json>