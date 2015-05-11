<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
		<json:object name="usuario">
			<json:property name="id" value="${usuario.id}" />
			<json:property name="username" value="${usuario.username}" />
			<json:property name="nombre" value="${usuario.nombre}" />
			<json:property name="apellido1" value="${usuario.apellido1}" />
			<json:property name="apellido2" value="${usuario.apellido2}" />
			<json:property name="email" value="${usuario.email}" />
			<json:property name="usuarioExterno">
				<c:if test="${usuario.usuarioExterno}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!usuario.usuarioExterno}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="entidad" value="${usuario.entidad.descripcion}" />
		</json:object>
</fwk:json>