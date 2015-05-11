<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
		<json:object name="perfil">
			<json:property name="id" value="${perfil.id}" />
			<json:property name="descripcionLarga" value="${perfil.descripcionLarga}" />
			<json:property name="descripcion" value="${perfil.descripcion}" />
		</json:object>
</fwk:json>