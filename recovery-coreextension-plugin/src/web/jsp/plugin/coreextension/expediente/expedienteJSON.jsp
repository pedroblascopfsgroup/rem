<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="id" value="${expediente.id}" />
	<json:property name="nombreTab" value="${nombreTab}" />
	<json:object name="toolbar">
		<json:property name="solicitudCancelacion" value="${solicitudCancelacion.solicitudCancelacion.id}" />
		<json:property name='idGestorActual' value="${expediente.idGestorActual}" />
		<json:property name='isGestorCaracterizado' value="${isGestorCaracterizado}" />
		<json:property name='isSupervisorCaracterizado' value="${isSupervisorCaracterizado}" />
		<json:property name='idSupervisorActual' value="${expediente.idSupervisorActual}" />
		<json:property name='codigoEstado' value="${expediente.estadoItinerario.codigo}" />
		<json:property name='estadoExpediente' value="${expediente.estadoExpediente.codigo}" />
		<json:property name='tipoExpediente' value="${expediente.tipoExpediente.codigo}" />
		<json:property name='situacion' value="${expediente.estadoItinerario.descripcion}" />
		<json:property name='tieneTareaNotificacion' value="${expediente.fechaVencimiento!=null}" />
		<json:property name='tieneComiteMixto' value="${expediente.comite.comiteMixto}" />
		<json:property name='tieneComiteSeguimiento' value="${expediente.comite.comiteSeguimiento}" />
		<json:property name="fechaVencimiento">
		  <fwk:date value="${expediente.fechaVencimiento}"/>
		</json:property>
		<json:property name="descripcion" value="${expediente.descripcionExpediente}" />
		<json:property name="idTareaExpediente" value="${expediente.idTareaExpediente}" />
		<json:property name="fechaCreacionFormateada" value="${expediente.fechaCreacionFormateada}" />
		<json:property name="prorrogaPendiente" value="${prorrogaPendiente.id}" />
		<json:property name="prorrogaPendienteTarea" value="${prorrogaPendiente.descripcionTarea}" />
		<json:property name="prorrogaFechaPropuesta">
		  <fwk:date value="${prorrogaPendiente.prorroga.fechaPropuesta}"/>
		</json:property>
		<json:property name="causaProrroga" value="${prorrogaPendiente.prorroga.causaProrroga.descripcion}" />
		<json:property name="descripcionExpediente" value="${expediente.descripcionExpediente}" />
		<json:property name='exclusionNotNull' value="${exclusion!=null}" />
		<json:property name='estaEstadoActivo' value="${expediente.estaEstadoActivo}" />
		<json:property name='tareaPendiente' value="${tareaPendiente.id}" />
		<json:property name='tareaPendienteDescripcion' value="${tareaPendiente.descripcionTarea}" escapeXml="false"/>
		<json:property name='esRecuperacion' value="${expediente.arquetipo.itinerario.dDtipoItinerario.itinerarioRecuperacion == true}"/>
		<json:property name='esSeguimiento' value="${expediente.arquetipo.itinerario.dDtipoItinerario.itinerarioSeguimiento == true}"/>
		<json:property name='comiteElevarNull' value="${comiteElevar==null}"/>
		<json:property name='comiteElevar' value="${comiteElevar.id}"/>
		<json:property name='comitesDelegarNull' value="${comitesDelegarNull==null}"/>
		<json:property name='comitesDelegarLen' value="${fn:length(comitesDelegar)==0}"/>
		<json:property name='puedeMostrarSolapaMarcadoPoliticas' value="${puedeMostrarSolapaMarcadoPoliticas}"/>
		<json:property name='puedeMostrarSolapaDecisionComite' value="${puedeMostrarSolapaDecisionComite}"/>
	</json:object>
	<json:object name="cabecera">
		<json:property name="codExpediente" value="${expediente.id}" />
		<json:property name="fechaCreacion" >
		  <fwk:date value="${expediente.auditoria.fechaCrear}"/>
		</json:property>
		<json:property name="usuModif" value="${expediente.auditoria.usuarioModificar}" />
		<json:property name="situacionData" value="${expediente.estadoItinerario.descripcion}" />
		<json:property name="situacionTipoItinerario" value="${expediente.arquetipo.itinerario.dDtipoItinerario.descripcion}" />
		<json:property name="estado" value="${expediente.estadoExpediente.descripcion}" />
		<json:property name="descripcion" value="${expediente.descripcionExpediente}" />
		<json:property name="diasVencido" value="${expediente.diasVencido}" />
		<json:property name="volRiesgos" value="${expediente.volumenRiesgoAbsoluto}" />
		<json:property name="volRiesgosVenc" value="${expediente.volumenRiesgoVencidoAbsoluto}" />
		<json:property name="comite" value="${expediente.comite.nombre}" />
		<json:property name="fechaComite">
		  <fwk:date value="${expediente.fechaVencimiento}"/>
		</json:property>
		<json:property name="oficina" value="${expediente.oficina.nombre}" />
		<json:property name="fechaUltModif">
		  <fwk:date value="${expediente.auditoria.fechaModificar}"/>
		</json:property>
		<json:property name="manual" value="${expediente.manual}" />
		<json:property name="gestor" value="${expediente.gestorActual}" />
		<json:property name="supervisor" value="${expediente.supervisorActual}" />
		<json:property name='tipoExpediente' value="${expediente.tipoExpediente.descripcion}" />
	</json:object>
	<json:object name="clientes">
		<json:array name="clientes" items="${expediente.personas}" var="expedientePersona">	
			<json:object>
				<json:property name="id" value="${expedientePersona.id}" />
				<json:property name="idPersona" value="${expedientePersona.persona.id}" />
				<json:property name='pase' value="${expedientePersona.pase}" />
				<json:property name='cliente' value="${expedientePersona.persona.apellidoNombre}" />
				<json:property name='vrDirecto' value="${expedientePersona.persona.riesgoDirecto}" />
				<json:property name='vrIndirecto' value="${expedientePersona.persona.montoTotalRiesgosIndirectos}" />
				<json:property name='vrIrregular' value="${expedientePersona.persona.riesgoDirectoVencido}" />
				<json:property name='riesgoDirectoDanyado' value="${expedientePersona.persona.riesgoDirectoDanyado}" />
				<json:property name='vrDirectoNoG' value="${expedientePersona.persona.grupo.grupoCliente.riesgoDirecto}" />
				<json:property name='contratosActivos' value="${expedientePersona.persona.numContratos}" />
				<json:property name='prePolitica' value="${expedientePersona.persona.prepolitica.descripcion}" />
				<json:property name='politica' value="${expedientePersona.persona.politicaVigente.tipoPolitica.descripcion}" />
				<json:property name='fechaUltRevision'>
					<fwk:date value="${expedientePersona.persona.politicaVigente.auditoria.fechaCrear}" />
				</json:property>
				<json:property name='scoring' value="${expedientePersona.persona.puntuacionTotalActiva.puntuacion}" />
				<json:property name='rating' value="${expedientePersona.persona.puntuacionTotalActiva.intervalo}" />
				<c:if test="${expedientePersona.pase==0}">
					<json:property name="bPase" value="" />	
				</c:if>	
				<c:if test="${expedientePersona.pase==1}">
					<json:property name="bPase" value="Si" />
				</c:if>
			</json:object>
		</json:array>
	</json:object>
	<json:object name="contratos">
		<json:property name='estaDecidido' value="${expediente.estaDecidido}" />
	</json:object>
	<json:object name="titulos">
		<json:property name='idGestorActual' value="${expediente.idGestorActual}" />
		<json:property name='idSupervisorActual' value="${expediente.idSupervisorActual}" />
		<json:property name='estadoExpediente' value="${expediente.estadoExpediente.codigo}" />
	</json:object>
	<json:object name="gestion">
		<json:property name='gestiones' value="${expediente.aaa.gestiones}" />
		<json:property name='causaImpago' value="${expediente.aaa.causaImpago.descripcion}" />
		<json:property name='comentariosSituacion' value="${expediente.aaa.comentariosSituacion}" />
		<json:property name='propuestaActuacion' value="${expediente.aaa.propuestaActuacion}" />
		<json:property name='tipoAyuda' value="${expediente.aaa.tipoAyudaActuacion.descripcion}" />
		<json:property name='descripcionTipoAyudaActuacion' value="${expediente.aaa.descripcionTipoAyudaActuacion}" />
		<json:property name='tipoPropuestaActuacion' value="${expediente.aaa.tipoPropuestaActuacion.descripcion}" />
		<json:property name='revision' value="${expediente.aaa.revision}" />
		<json:property name='aaa' value="${expediente.aaa.id}" />
		<json:property name='estadoExpediente' value="${expediente.estadoExpediente.codigo}" />
		<json:property name="estadoItinerario" value="${expediente.estadoItinerario.codigo}" />
		<json:property name='idGestorActual' value="${expediente.idGestorActual}" />
		<json:property name='idSupervisorActual' value="${expediente.idSupervisorActual}" />
	</json:object>
		<json:object name="decision">
		<json:property name='ultimaSesion' value="${expediente.comite.ultimaSesion.id}" />
		<json:property name='comite' value="${expediente.comite.nombre}" />
		<json:property name='fechaUltimaSesion'>
		  <fwk:date value="${expediente.comite.ultimaSesion.fechaInicio}" />
		</json:property>
		<json:property name='plazoRestante' value="${tarea.plazo}" />
		<json:property name='observaciones' value="${expediente.decisionComite.observaciones}" />
		<json:property name='estaCongelado' value="${expediente.estaCongelado}" />
		<json:property name='descripcionExpediente' value="${expediente.descripcionExpediente}" />
		<json:object name="contratosSinActuacion">
			<json:array name="contratosId" items="${exclusion.personas}" var="contrato">
					<json:object>
						<json:property name="id" value="${contrato.id}" />
					</json:object>
			</json:array>
		</json:object>

	</json:object>
	<json:object name="sancion">
		<c:if test="${expediente.sancion!=null}">
			<json:property name='observaciones' value="${expediente.sancion.observaciones}" />
			<json:property name='codDecision' value="${expediente.sancion.decision.codigo}" />
			<json:property name='descDecision' value="${expediente.sancion.decision.descripcion}" />
		</c:if>
	</json:object>

</fwk:json>
