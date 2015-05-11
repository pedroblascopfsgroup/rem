<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="localidades" items="${listLocalidades}" var="loc">
		<json:object>
			<json:property name="id" value="${loc.id}"/>
			<json:property name="codigo" value="${loc.codigo}"/>
			<json:property name="descripcion" value="${loc.descripcion}"/>
			<json:property name="descripcionLarga" value="${loc.descripcionLarga}"/>
 		</json:object>
	</json:array>
</fwk:json>
