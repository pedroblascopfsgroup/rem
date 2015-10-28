<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="acuerdos" items="${acuerdos}" var="acuerdo">
		<json:object>
			<json:property name="idAcuerdo" value="${acuerdo.id}" />
			<json:property name="fechaPropuesta">
				<fwk:date value="${acuerdo.fechaPropuesta}" />
			</json:property>
			<json:property name="tipoAcuerdo" value="${acuerdo.tipoAcuerdo.descripcion}" />
			<json:property name="solicitante" value="${acuerdo.solicitante.descripcion}" />
			<json:property name="estado" value="${acuerdo.estadoAcuerdo.descripcion}" />
			<json:property name="codigoEstado" value="${acuerdo.estadoAcuerdo.codigo}" />
			<json:property name="fechaEstado">
				<fwk:date value="${acuerdo.fechaEstado}" />
			</json:property>		
			<c:choose>
			    <c:when test="${acuerdo.motivoRechazo != null}">
				    <c:choose>
					    <c:when test="${acuerdo.motivo != null && acuerdo.motivo != ''}">
					       <json:property name="motivo" value="${acuerdo.motivoRechazo.descripcion} : ${acuerdo.motivo}" />
					    </c:when>
					    <c:otherwise>
					        <json:property name="motivo" value="${acuerdo.motivoRechazo.descripcion}" />
					    </c:otherwise>
					</c:choose>
			    </c:when>
			    <c:otherwise>
			        <json:property name="motivo" value="${acuerdo.motivo}" />
			    </c:otherwise>
			</c:choose>	
			<json:property name="idProponente" value="${acuerdo.proponente.id}" />
			<json:property name="tipoDespachoProponente" value="${acuerdo.gestorDespacho.despachoExterno.tipoDespacho.id}" />
			<json:property name="idTipoAcuerdo" value="${acuerdo.tipoAcuerdo.id}" />
		</json:object>
	</json:array>
</fwk:json>