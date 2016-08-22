<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="asistentesJSON" items="${dtoSesionComite.asistentes}" var="a">
		<json:object>
			<json:property name="id" value="${a.usuario.id}" />
			<json:property name="nombre" value="${a.usuario.nombre}" />
			<json:property name="apellidos" value="${a.usuario.apellidos}" />
			<json:property name="restrictivo" value="${a.esRestrictivoToString}" />
			<json:property name="supervisor" value="${a.esSupervisorToString}" />
			<json:property name="asiste" value="${a.asiste}" />
		</json:object>
	</json:array>
</fwk:json>