<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${modelosRanking.totalCount}" />
	
	<json:array name="modelos" items="${modelosRanking.results}" var="modelo">
		<json:object>			 
			<json:property name="id" value="${modelo.id}" />
			<json:property name="nombre" value="${modelo.nombre}" />
			<json:property name="estado" value="${modelo.estado.descripcion}" />
			<json:property name="codigoEstado" value="${modelo.estado.codigo}" />
			<json:property name="propietario" value="${modelo.propietario.username}" />	
			<json:property name="idPropietario" value="${modelo.propietario.id}" />				
		</json:object>
	</json:array>
	
</fwk:json>
