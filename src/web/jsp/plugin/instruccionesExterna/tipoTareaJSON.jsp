<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:json>
	<json:array name="listadoTareas" items="${lista}" var="rec">
		<json:object>
			<json:property name="id" value="${rec.id}"/>
			<json:property name="descripcion" value="${rec.descripcion}"/>
		</json:object>
	</json:array>
</fwk:json>			


