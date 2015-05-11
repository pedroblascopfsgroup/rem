<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="funciones" items="${pagina.results}" var="f">
		<json:object>
			<json:property name="id" value="${f.id}" />
			<json:property name="descripcionLarga" value="${f.descripcionLarga}" />
			<json:property name="descripcion" value="${f.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>