<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:property name="permitirBorrar" value="${permitirBorrar}" />
	<json:array name="categorizaciones" items="${pagina.results}" var="ctg">
		<json:object>			 
			<json:property name="id" value="${ctg.id}" />
			<json:property name="nombre" value="${ctg.nombre}" />
			<json:property name="codigo" value="${ctg.codigo}" />
			<json:property name="iddespacho" value="${ctg.despachoExterno.id}" />
			<json:property name="despacho" value="${ctg.despachoExterno.despacho}" />
		</json:object>
	</json:array>
</fwk:json>