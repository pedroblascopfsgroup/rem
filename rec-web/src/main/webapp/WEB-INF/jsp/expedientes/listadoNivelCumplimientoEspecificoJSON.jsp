<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	  <json:array name="personasContrato" items="${listadoEntidadRegla}" var="objeto">
			<json:object>
				<json:property name="bCumple" value="${objeto.cumple}" />
				<json:property name="idPersona" value="${objeto.persona.id}" />
				<json:property name="idContrato" value="${objeto.contrato.id}" />
				<json:property name="apellidoNombre" value="${objeto.persona.apellidoNombre}" />
				<json:property name="bCumple" value="${objeto.cumple}" />
				<json:property name="nombre" value="${objeto.nombreEntidad}" />
				<json:property name="tipoObjetoEntidad" value="${objeto.tipoObjetoEntidad}" />
				<json:property name="tipo" value="${objeto.tipoEntidad}" />
					<c:if test="${objeto.pase==true}">
	                	<json:property name="bPase" value="Si" />
                	</c:if>
                	<c:if test="${objeto.pase==false}">
	                	<json:property name="bPase" value="" />
                	</c:if>
			</json:object>
		</json:array>
		
</fwk:json>
