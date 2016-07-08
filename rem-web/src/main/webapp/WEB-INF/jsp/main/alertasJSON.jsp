<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
	<json:property name="debug" value="${debug}" />
	<json:property name="total" value="1" />
	<json:array name="alertas" items="${alertas}" var="a">
		<json:object>
			<json:property name="fecha" value="${a.fechaInicio}" />
			<json:property name="hora" value="16:00" />
			<json:property name="mensaje" value="${a.descripcionTarea}" />
			<json:property name="tipo" value="${a.subtipoTarea.id}" />
		</json:object>
	</json:array>
</fwk:json>