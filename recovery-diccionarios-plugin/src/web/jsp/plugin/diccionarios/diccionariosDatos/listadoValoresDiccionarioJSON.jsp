<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="valoresDiccionario" items="${diccionarioDatos}" var="vd">
		<json:object>
			<json:property name="idDiccionarioEditable" value="${vd.idDiccionarioEditable}" />
			<json:property name="idLineaEnDiccionario" value="${vd.idLineaEnDiccionario}" />
			<json:property name="codigo" value="${vd.codigo}" />
			<json:property name="descripcion" value="${vd.descripcion}" />
			<json:property name="descripcionLarga" value="${vd.descripcionLarga}" />
		</json:object>
	</json:array>
</fwk:json>