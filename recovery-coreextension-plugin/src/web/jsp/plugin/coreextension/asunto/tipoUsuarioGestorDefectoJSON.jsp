<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="listadoUsuarios" items="${pagina.results}" var="rec">
		<json:object>
			<json:property name="id" value="${rec.usuario.id}"/>
			<json:property name="username" value="${rec.usuario.apellidoNombre}"/>
			<json:property name="defecto" value="${rec.gestorPorDefecto}"/>
		</json:object>
	</json:array>
</fwk:json>			
