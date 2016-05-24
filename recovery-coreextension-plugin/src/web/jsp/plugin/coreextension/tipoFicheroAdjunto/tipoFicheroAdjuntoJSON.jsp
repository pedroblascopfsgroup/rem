<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="tipoFicherosAdjunto" items="${tipoFicherosAdjunto}" var="tfa">
		<json:object>
			<json:property name="id" value="${tfa.id}" />
			<json:property name="codigo" value="${tfa.codigo}" />
			<json:property name="descripcion" value="${tfa.descripcion}" />
			<json:property name="descripcionLarga" value="${tfa.descripcionLarga}" />
		</json:object>
	</json:array>
</fwk:json>