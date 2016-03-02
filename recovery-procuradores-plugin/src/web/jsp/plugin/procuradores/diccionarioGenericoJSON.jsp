<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="diccionario" items="${pagina.results}" var="res">
		<json:object>			 
			<json:property name="id" value="${res.id}" />
			<json:property name="codigo" value="${res.codigo}" />
			<json:property name="descripcion" value="${res.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>
