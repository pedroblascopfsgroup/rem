<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="bienes" items="${listado}" var="bie">
		<json:object>
			<json:property name="id" value="${bie.id}"/>
			<json:property name="ancId" value="${bie.analisisContrato.id}"/>
			<json:property name="bienId" value="${bie.bien.id}"/>
			<json:property name="codigo" value="${bie.bien.codigoInterno}"/>
			<json:property name="origen" value="${bie.bien.origen.descripcion}"/>
			<json:property name="tipo" value="${bie.bien.tipoBien.descripcion}"/>
			<json:property name="solicitarNoAfeccion" value="${bie.solicitarNoAfeccion}"/>
			<json:property name="fechaSolicitarNoAfeccion">
				<fwk:date value="${bie.fechaSolicitarNoAfeccion}"/>
			</json:property>
			<json:property name="fechaResolucion">
				<fwk:date value="${bie.fechaResolucion}"/>
			</json:property>
			<json:property name="resolucion" value="${bie.resolucion}"/>			
 		</json:object>
	</json:array>
</fwk:json>
