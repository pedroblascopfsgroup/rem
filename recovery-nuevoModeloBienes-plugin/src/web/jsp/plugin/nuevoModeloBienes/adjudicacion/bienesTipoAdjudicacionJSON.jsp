<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="bienes" items="${bienes}" var="bie">
		<json:object>
			<json:property name="id" value="${bie.bien.id}" />
			<json:property name="idBien" value="${bie.bien.id}" />
			<json:property name="codigo" value="${bie.bien.codigoInterno}" />
			<json:property name="numeroActivo" value="${bie.bien.numeroActivo}" />
			<json:property name="origen" value="${bie.bien.origen.descripcion}" />
			<json:property name="descripcion" value="${bie.bien.descripcionBien}" />
			<json:property name="habitual" value="${bie.bien.viviendaHabitual}" />
			<json:property name="idAdjudicacion" value="${bie.bien.adjudicacion.idAdjudicacion}" />
			
			<json:property name="tareaId" value="${bie.tareaNotificacion.id}" />
			<json:property name="tareaCodigo" value="${bie.tareaNotificacion.tareaExterna.tareaProcedimiento.codigo}" />
			<json:property name="tareaDescripcion" value="${bie.tareaNotificacion.tareaExterna.tareaProcedimiento.descripcion}" />
			
			
			<json:property name="ocupado" value="${bie.bien.adjudicacion.ocupado}" />
			<json:property name="posiblePosesion"
				value="${bie.bien.adjudicacion.posiblePosesion}" />
			<json:property name="ocupantesDiligencia"
				value="${bie.bien.adjudicacion.ocupantesDiligencia}" />
			<json:property name="lanzamientoNecesario"
				value="${bie.bien.adjudicacion.lanzamientoNecesario}" />
			<json:property name="entregaVoluntaria"
				value="${bie.bien.adjudicacion.entregaVoluntaria}" />
			<json:property name="necesariaFuerzaPublica"
				value="${bie.bien.adjudicacion.necesariaFuerzaPublica}" />
			<json:property name="existeInquilino"
				value="${bie.bien.adjudicacion.existeInquilino}" />
			<json:property name="llavesNecesarias"
				value="${bie.bien.adjudicacion.llavesNecesarias}" />
			<c:if test="${bie.bien.adjudicacion.gestoriaAdjudicataria != null}">
				<json:property name="gestoriaAdjudicataria"
					value="${bie.bien.adjudicacion.gestoriaAdjudicataria.id}" />
			</c:if>	
			<json:property name="nombreArrendatario"
				value="${bie.bien.adjudicacion.nombreArrendatario}" />
			<json:property name="nombreDepositario"
				value="${bie.bien.adjudicacion.nombreDepositario}" />
			<json:property name="nombreDepositarioFinal"
				value="${bie.bien.adjudicacion.nombreDepositarioFinal}" />
			<c:if test="${bie.bien.adjudicacion.fondo != null}">
				<json:property name="fondo"
					value="${bie.bien.adjudicacion.fondo.descripcion}" />
			</c:if>
			<c:if test="${bie.bien.adjudicacion.entidadAdjudicataria != null}">
				<json:property name="entidadAdjudicataria"
					value="${bie.bien.adjudicacion.entidadAdjudicataria.descripcion}" />
			</c:if>
			<c:if test="${bie.bien.adjudicacion.situacionTitulo != null}">
				<json:property name="situacionTitulo"
					value="${bie.bien.adjudicacion.situacionTitulo.descripcion}" />
			</c:if>
			<c:if test="${bie.bien.adjudicacion.resolucionMoratoria != null}">
				<json:property name="resolucionMoratoria"
					value="${bie.bien.adjudicacion.resolucionMoratoria.descripcion}" />
			</c:if>
			<json:property name="numFinca" value="${bie.numFinca}" />
		</json:object>
	</json:array>
</fwk:json>



