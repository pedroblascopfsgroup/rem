<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="perfiles" items="${pagina.results}" var="p">
		<json:object>
			<json:property name="id" value="${p.id}" />
			<json:property name="descripcionLarga" value="${p.descripcionLarga}" />
			<json:property name="descripcion" value="${p.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>