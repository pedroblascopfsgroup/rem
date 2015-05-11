<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${politicas.totalCount}" />
	
	<json:array name="politicas" items="${politicas.results}" var="politica">
		<json:object>			 
			<json:property name="id" value="${politica.id}" />
			<json:property name="nombre" value="${politica.nombre}" />	
			<json:property name="codigo" value="${politica.codigo}" />
			<json:property name="estado" value="${politica.estado.descripcion}" />
			<json:property name="codigoEstado" value="${politica.estado.codigo}" />
			<json:property name="propietario" value="${politica.propietario.username}" />	
			<json:property name="idPropietario" value="${politica.propietario.id}" />				
		</json:object>
	</json:array>
	
</fwk:json>
