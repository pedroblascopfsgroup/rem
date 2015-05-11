<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="gestor" items="${listaGestores}" var="gestor">
		<json:object>
			<json:property name="id" value="${gestor.id}" />
			<json:property name="usuario" value="${gestor.usuario.id}" />
			<json:property name="tipoGestor" value="${gestor.tipoGestor.codigo}" />
			<json:property name="tipoGestorDescripcion" value="${gestor.tipoGestor.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>