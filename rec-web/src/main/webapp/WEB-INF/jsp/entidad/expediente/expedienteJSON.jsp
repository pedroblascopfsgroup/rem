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
		<c:if test="${solicitudCancelacion!=null && solicitudCancelacion.solicitudCancelacion != null}">
			<json:property name="solicitudCancelacion" value="${solicitudCancelacion.solicitudCancelacion.id}" />
		</c:if>
		<json:property name='idGestorActual' value="${expediente.idGestorActual}" />
		<json:property name='isGestorCaracterizado' value="${isGestorCaracterizado}" />
		<json:property name='isSupervisorCaracterizado' value="${isSupervisorCaracterizado}" />
		<json:property name='idSupervisorActual' value="${expediente.idSupervisorActual}" />
		<c:if test="${expediente.estadoItinerario != null}">
			<json:property name='codigoEstado' value="${expediente.estadoItinerario.codigo}" />
		</c:if>
		<c:if test="${expediente.estadoExpediente != null}">
			<json:property name='estadoExpediente' value="${expediente.estadoExpediente.codigo}" />
		</c:if>
		<c:if test="${expediente.tipoExpediente != null}">
			<json:property name='tipoExpediente' value="${expediente.tipoExpediente.codigo}" />
		</c:if>
		<c:if test="${expediente.estadoItinerario != null}">
			<json:property name='situacion' value="${expediente.estadoItinerario.descripcion}" />
		</c:if>
		<json:property name='tieneTareaNotificacion' value="${expediente.fechaVencimiento!=null}" />
		<c:if test="${expediente.comite != null}">
			<json:property name='tieneComiteMixto' value="${expediente.comite.comiteMixto}" />
			<json:property name='tieneComiteSeguimiento' value="${expediente.comite.comiteSeguimiento}" />
		</c:if>
		<json:property name="fechaVencimiento">
		  <fwk:date value="${expediente.fechaVencimiento}"/>
		</json:property>
		<json:property name="descripcion" value="${expediente.descripcionExpediente}" />
		<json:property name="idTareaExpediente" value="${expediente.idTareaExpediente}" />
		<json:property name="fechaCreacionFormateada" value="${expediente.fechaCreacionFormateada}" />
		<c:if test="${prorrogaPendiente != null}">
			<json:property name="prorrogaPendiente" value="${prorrogaPendiente.id}" />
			<json:property name="prorrogaPendienteTarea" value="${prorrogaPendiente.descripcionTarea}" />
			<c:if test="${prorrogaPendiente.prorroga != null}">
				<json:property name="prorrogaFechaPropuesta">
				  <fwk:date value="${prorrogaPendiente.prorroga.fechaPropuesta}"/>
				</json:property>
				<c:if test="${prorrogaPendiente.prorroga.causaProrroga != null}">
					<json:property name="causaProrroga" value="${prorrogaPendiente.prorroga.causaProrroga.descripcion}" />
				</c:if>
			</c:if>
		</c:if>
		<json:property name="descripcionExpediente" value="${expediente.descripcionExpediente}" />
		<json:property name='exclusionNotNull' value="${exclusion!=null}" />
		<json:property name='estaEstadoActivo' value="${expediente.estaEstadoActivo}" />
		<c:if test="${tareaPendiente != null}">
			<json:property name='tareaPendiente' value="${tareaPendiente.id}" />
			<json:property name='tareaPendienteDescripcion' value="${tareaPendiente.descripcionTarea}" escapeXml="false"/>
		</c:if>
		<c:if test="${expediente.arquetipo != null && expediente.arquetipo.itinerario != null && expediente.arquetipo.itinerario.dDtipoItinerario != null}">
			<json:property name='esRecuperacion' value="${expediente.arquetipo.itinerario.dDtipoItinerario.itinerarioRecuperacion == true}"/>
			<json:property name='esSeguimiento' value="${expediente.arquetipo.itinerario.dDtipoItinerario.itinerarioSeguimiento == true}"/>
		</c:if>
		<json:property name='comiteElevarNull' value="${comiteElevar==null}"/>
		<c:if test="${comiteElevar != null}">
			<json:property name='comiteElevar' value="${comiteElevar.id}"/>
		</c:if>
		<json:property name='comitesDelegarNull' value="${comitesDelegarNull==null}"/>
		<c:if test="${comitesDelegar != null}">
			<json:property name='comitesDelegarLen' value="${fn:length(comitesDelegar)==0}"/>
		</c:if>
		<json:property name='puedeMostrarSolapaMarcadoPoliticas' value="${puedeMostrarSolapaMarcadoPoliticas}"/>
		<json:property name='puedeMostrarSolapaDecisionComite' value="${puedeMostrarSolapaDecisionComite}"/>
	</json:object>
	<json:object name="cabecera">
		<json:property name="codExpediente" value="${expediente.id}" />
		<json:property name="fechaCreacion" >
		  <fwk:date value="${expediente.auditoria.fechaCrear}"/>
		</json:property>
		<json:property name="usuModif" value="${expediente.auditoria.usuarioModificar}" />
		<c:if test="${expediente.estadoItinerario != null}">
			<json:property name="situacionData" value="${expediente.estadoItinerario.descripcion}" />
		</c:if>
		<c:if test="${expediente.arquetipo != null && expediente.arquetipo.itinerario != null && expediente.arquetipo.itinerario.dDtipoItinerario != null}">
			<json:property name="situacionTipoItinerario" value="${expediente.arquetipo.itinerario.dDtipoItinerario.descripcion}" />
		</c:if>
		<c:if test="${expediente.estadoExpediente != null}">
			<json:property name="estado" value="${expediente.estadoExpediente.descripcion}" />
		</c:if>
		<json:property name="descripcion" value="${expediente.descripcionExpediente}" />
		<json:property name="diasVencido" value="${expediente.diasVencido}" />
		<json:property name="volRiesgos" value="${expediente.volumenRiesgoAbsoluto}" />
		<json:property name="volRiesgosVenc" value="${expediente.volumenRiesgoVencidoAbsoluto}" />
		<c:if test="${expediente.comite != null}">
			<json:property name="comite" value="${expediente.comite.nombre}" />
		</c:if>
		<json:property name="fechaComite">
		  <fwk:date value="${expediente.fechaVencimiento}"/>
		</json:property>
		<c:if test="${expediente.oficina != null}">
			<json:property name="oficina" value="${expediente.oficina.nombre}" />
		</c:if>
		<json:property name="fechaUltModif">
		  <fwk:date value="${expediente.auditoria.fechaModificar}"/>
		</json:property>
		<json:property name="manual" value="${expediente.manual}" />
		<json:property name="gestor" value="${expediente.gestorActual}" />
		<json:property name="supervisor" value="${expediente.supervisorActual}" />
		<c:if test="${expediente.tipoExpediente != null}">
			<json:property name='tipoExpediente' value="${expediente.tipoExpediente.descripcion}" />
		</c:if>
	</json:object>
	<json:object name="clientes">
		<json:array name="clientes" items="${expediente.personas}" var="expedientePersona">	
			<json:object>
				<json:property name="id" value="${expedientePersona.id}" />
				<json:property name='pase' value="${expedientePersona.pase}" />
				<c:if test="${expedientePersona.persona != null}">
					<json:property name="idPersona" value="${expedientePersona.persona.id}" />
					<json:property name='cliente' value="${expedientePersona.persona.apellidoNombre}" />
					<json:property name='vrDirecto' value="${expedientePersona.persona.riesgoTotal}" />
					<json:property name='vrIndirecto' value="${expedientePersona.persona.riesgoIndirecto}" />
					<json:property name='vrIrregular' value="${expedientePersona.persona.dispuestoVencido}" />
					<json:property name='riesgoDirectoDanyado' value="${expedientePersona.persona.riesgoDirectoDanyado}" />
					<json:property name='contratosActivos' value="${expedientePersona.persona.numContratos}" />
					<c:if test="${expedientePersona.persona.grupo != null && expedientePersona.persona.grupo.grupoCliente != null}">
						<json:property name='vrDirectoNoG' value="${expedientePersona.persona.grupo.grupoCliente.riesgoDirecto}" />
					</c:if>
					<c:if test="${expedientePersona.persona.prepolitica != null}">
						<json:property name='prePolitica' value="${expedientePersona.persona.prepolitica.descripcion}" />
					</c:if>
					<c:if test="${expedientePersona.persona.politicaVigente != null}">
						<json:property name='fechaUltRevision'>
							<fwk:date value="${expedientePersona.persona.politicaVigente.auditoria.fechaCrear}" />
						</json:property>
						<c:if test="${expedientePersona.persona.politicaVigente.tipoPolitica != null}">
							<json:property name='politica' value="${expedientePersona.persona.politicaVigente.tipoPolitica.descripcion}" />
						</c:if>
					</c:if>
					<c:if test="${expedientePersona.persona.puntuacionTotalActiva != null}">
						<json:property name='scoring' value="${expedientePersona.persona.puntuacionTotalActiva.puntuacion}" />
						<json:property name='rating' value="${expedientePersona.persona.puntuacionTotalActiva.intervalo}" />
					</c:if>
					<c:if test="${expedientePersona.pase==0}">
						<json:property name="bPase" value="" />	
					</c:if>	
					<c:if test="${expedientePersona.pase==1}">
						<json:property name="bPase" value="Si" />
					</c:if>
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
		<c:if test="${expediente.aaa != null}">
			<json:property name='gestiones' value="${expediente.aaa.gestiones}" />
			<json:property name='comentariosSituacion' value="${expediente.aaa.comentariosSituacion}" />
			<json:property name='propuestaActuacion' value="${expediente.aaa.propuestaActuacion}" />
			<json:property name='descripcionTipoAyudaActuacion' value="${expediente.aaa.descripcionTipoAyudaActuacion}" />
			<json:property name='revision' value="${expediente.aaa.revision}" />
			<json:property name='aaa' value="${expediente.aaa.id}" />
			<c:if test="${expediente.aaa.tipoAyudaActuacion != null}">
				<json:property name='tipoAyuda' value="${expediente.aaa.tipoAyudaActuacion.descripcion}" />
			</c:if>
			<c:if test="${expediente.aaa.causaImpago != null}">
				<json:property name='causaImpago' value="${expediente.aaa.causaImpago.descripcion}" />
			</c:if>
			<c:if test="${expediente.aaa.tipoPropuestaActuacion != null}">
				<json:property name='tipoPropuestaActuacion' value="${expediente.aaa.tipoPropuestaActuacion.descripcion}" />
			</c:if>
		</c:if>
		<c:if test="${expediente.estadoExpediente != null}">
			<json:property name='estadoExpediente' value="${expediente.estadoExpediente.codigo}" />
		</c:if>
		<c:if test="${expediente.estadoItinerario != null}">
			<json:property name="estadoItinerario" value="${expediente.estadoItinerario.codigo}" />
		</c:if>
		<json:property name='idGestorActual' value="${expediente.idGestorActual}" />
		<json:property name='idSupervisorActual' value="${expediente.idSupervisorActual}" />
	</json:object>
	<json:object name="decision">
		<c:if test="${expediente.comite != null}">
			<json:property name='comite' value="${expediente.comite.nombre}" />
			<c:if test="${expediente.comite.ultimaSesion != null}">
				<json:property name='ultimaSesion' value="${expediente.comite.ultimaSesion.id}" />
				<json:property name='fechaUltimaSesion'>
				  <fwk:date value="${expediente.comite.ultimaSesion.fechaInicio}" />
				</json:property>
			</c:if>
		</c:if>
		<c:if test="${tarea != null}">
			<json:property name='plazoRestante' value="${tarea.plazo}" />
		</c:if>
		<c:if test="${expediente.decisionComite != null}">
			<json:property name='observaciones' value="${expediente.decisionComite.observaciones}" />
		</c:if>
		<json:property name='estaCongelado' value="${expediente.estaCongelado}" />
		<json:property name='descripcionExpediente' value="${expediente.descripcionExpediente}" />
		<json:object name="contratosSinActuacion">
			<c:if test="${exclusion != null}">
				<json:array name="contratosId" items="${exclusion.personas}" var="contrato">
						<json:object>
							<json:property name="id" value="${contrato.id}" />
						</json:object>
				</json:array>
			</c:if>
		</json:object>
	</json:object>
	<json:object name="sancion">
		<c:if test="${expediente.sancion!=null}">
			<json:property name='observaciones' value="${expediente.sancion.observaciones}" />
			<c:if test="${expediente.sancion.decision!=null}">
				<json:property name='codDecision' value="${expediente.sancion.decision.codigo}" />
				<json:property name='descDecision' value="${expediente.sancion.decision.descripcion}" />
			</c:if>
		</c:if>
	</json:object>
</fwk:json>
