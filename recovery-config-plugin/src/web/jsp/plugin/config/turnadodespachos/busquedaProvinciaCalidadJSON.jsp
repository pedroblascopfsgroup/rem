<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"
	import="es.capgemini.pfs.direccion.model.DDProvincia"
%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="listaProvincias" items="${provincias}" var="provincias">
		<json:object>
			<json:property name="codigo" value="${provincias.codigo}" />
			<json:property name="nombreProvincia" value="${provincias.descripcion}" />
			<json:property name="calidad" value="${provincias.descripcionLarga}" />
		</json:object>
	</json:array>
</fwk:json>