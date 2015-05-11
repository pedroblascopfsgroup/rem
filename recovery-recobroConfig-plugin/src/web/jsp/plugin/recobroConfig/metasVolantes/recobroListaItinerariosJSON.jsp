<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${listaItinerarios.totalCount}" />
	
	<json:array name="itinerarios" items="${listaItinerarios.results}" var="itinerario">
		<json:object>			 
			<json:property name="id" value="${itinerario.id}" />
			<json:property name="nombre" value="${itinerario.nombre}" />
			<json:property name="plazoMaxGestion" value="${itinerario.plazoMaxGestion}" />
			<json:property name="plazoSinGestion" value="${itinerario.plazoSinGestion}" />
			<json:property name="fechaAlta" >
				<fwk:date value="${itinerario.fechaAlta}"/>
	  		</json:property>	
  			<json:property name="estado" value="${itinerario.estado.descripcion}" />
			<json:property name="codigoEstado" value="${itinerario.estado.codigo}" />
			<json:property name="propietario" value="${itinerario.propietario.username}" />	
			<json:property name="idPropietario" value="${itinerario.propietario.id}" />	
		</json:object>
	</json:array>
	
</fwk:json>
