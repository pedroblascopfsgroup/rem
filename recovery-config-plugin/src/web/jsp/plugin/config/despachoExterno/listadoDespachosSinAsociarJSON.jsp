<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="listaDespachos" items="${listaDespachos}" var="des">
		<json:object>
			<json:property name="id" value="${des.id}" />
			<json:property name="despacho" value="${des.despacho}" />
		</json:object>
	</json:array>
</fwk:json>