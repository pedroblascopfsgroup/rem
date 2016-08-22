<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="personas" items="${dto}" var="dto">	
		<json:object>
			<json:property name="idPersona" value="${dto.persona.id}" />
			<json:property name="cliente" value="${dto.persona.apellidoNombre}" />
			<json:property name="tipoPolitica" value="${dto.politicaUltima.tipoPolitica.descripcion}" />
			<json:property name="numObjetivos" value="${dto.politicaUltima.cantidadObjetivos}" />
			<json:property name="estado" value="${dto.politicaUltima.estadoPolitica.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>