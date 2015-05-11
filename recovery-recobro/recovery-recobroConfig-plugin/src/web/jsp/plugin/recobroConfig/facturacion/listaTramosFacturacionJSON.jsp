<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="tramos" items="${tramos}" var="tramo">
		<json:object>
			<json:property name="id" value="${tramo.id}"/>
			<json:property name="idModFact" value="${tramo.modeloFacturacion.id}"/>
			<json:property name="nombre" value="< ${tramo.tramoDias} dias"/>
		</json:object>
	</json:array>
</fwk:json>	