<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="zonas" items="${pagina}" var="z">
		<json:object>
			<json:property name="id" value="${z.id}" />
			<json:property name="codigo" value="${z.codigo}" />
			<json:property name="centro" value="${z.centro}" />
			<json:property name="descripcion" value="${z.descripcion}" />
			<json:property name="descripcionLarga" value="${z.descripcionLarga}" />
			<json:property name="zonaPadre" value="${z.zonaPadre}" />
			<json:property name="nivel" value="${z.nivel}" />
			<json:property name="oficina" value="${z.oficina}" />
		</json:object>
	</json:array>
</fwk:json>