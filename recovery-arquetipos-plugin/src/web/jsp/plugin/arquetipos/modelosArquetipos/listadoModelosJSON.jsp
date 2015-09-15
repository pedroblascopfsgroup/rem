<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="modelos" items="${pagina.results}" var="m" >
		<json:object>
			<json:property name="id" value="${m.id}" />
			<json:property name="nombre" value="${m.nombre}" />
			<json:property name="descripcion" value="${m.descripcion}" />
			<json:property name="estado" value="${m.estado.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>