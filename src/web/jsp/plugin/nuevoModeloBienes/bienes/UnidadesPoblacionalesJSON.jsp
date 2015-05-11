<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="unidades" items="${listUnidadesPoblacionales}" var="unid">
		<json:object>
			<json:property name="id" value="${unid.id}"/>
			<json:property name="codigo" value="${unid.codigo}"/>
			<json:property name="descripcion" value="${unid.descripcion}"/>
			<json:property name="descripcionLarga" value="${unid.descripcionLarga}"/>
 		</json:object>
	</json:array>
</fwk:json>
