<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="zonas" items="${zonas}" var="zona">
		<json:object>
			<json:property name="codigo" value="${zona.codigo}" />
			<json:property name="descripcion" value="${zona.descripcion}" />
			<json:property name="oficina" value="${zona.oficina.id}" />
		</json:object>
	</json:array>
</fwk:json>