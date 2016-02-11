<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:property name="total" value="1" />
	<json:array name="tareas" items="${tareas}" var="tar">
		<json:object>
			<json:property name="descripcionTarea"
				value="${tar.descripcionTarea}" escapeXml="false" />
			<json:property name="descripcion" value="${tar.descripcion}" />
			<json:property name="subtipo" value="${tar.subtipo}" />
			<json:property name="codigoSubtipoTarea"
				value="${tar.codigoSubtipoTarea}" />
			<json:property name="dtype" value="${tar.dtype}" />
			<json:property name="categoriaTarea" value="${tar.categoriaTarea}" />
			<json:property name="group" value="2" />

		</json:object>
	</json:array>
</fwk:json>