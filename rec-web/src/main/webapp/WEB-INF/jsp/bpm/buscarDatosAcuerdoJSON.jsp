<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:object name="datos">
		<json:property name="idAcuerdo" value="${datos.id}"/>
		<json:property name="idAsunto" value="${datos.asunto.id}"/>
	</json:object>
</fwk:json>