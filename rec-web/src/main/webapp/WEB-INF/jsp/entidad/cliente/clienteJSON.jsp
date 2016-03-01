<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="id" value="${persona.id}" />
	<json:object name="arquetipoPersona" >
		<json:property name="isNull" value="${arquetipoPersona==null}" />
		<json:property name="isRecuperacion" value="${arquetipoPersona != null && arquetipoPersona.itinerario.dDtipoItinerario.itinerarioRecuperacion == true}" />
		<json:property name="isSeguimiento" value="${arquetipoPersona != null && arquetipoPersona.itinerario.dDtipoItinerario.itinerarioSeguimiento == true}" />
		<json:property name="isArquetipoGestion" value="true" />
	</json:object>
	<json:object name="arquetipoRecuperacion" >
		<json:property name="isNull" value="${arquetipoRecuperacion==null}" />
		<json:property name="isRecuperacion" value="${arquetipoRecuperacion != null && arquetipoRecuperacion.itinerario.dDtipoItinerario.itinerarioRecuperacion == true}" />
		<json:property name="isSeguimiento" value="${arquetipoRecuperacion != null && arquetipoRecuperacion.itinerario.dDtipoItinerario.itinerarioSeguimiento == true}" />
		<json:property name="isArquetipoGestion" value="true" />
	</json:object>
	<json:property name="tieneExpedienteSeguimiento" value="${tieneExpedienteSeguimiento}" />
	<json:property name="tieneExpedienteRecuperacion" value="${tieneExpedienteRecuperacion}" />
	<json:property name="tieneContratosParaCliente" value="${tieneContratos==true}" />
	<json:property name="tieneContratosActivos" value="${tieneContratosActivos}" />
	<json:property name="tieneContratosLibres" value="${tieneContratosLibres}" />
	<json:property name="numContratos" value="${persona.numContratos}" />
	<json:property name="idCliente" value="${persona.clienteActivo.id}" />
	<json:property name="fechaCreacion" >
		<fwk:date value="${persona.fechaCreacion}"/>
	</json:property>
	<json:property name="idTareaPendiente" value="${tareaPendiente.id}" />
	<json:property name="descripcionTareaPendiente" value="${tareaPendiente.descripcionTarea}" />
	<json:property name="descEstado" value="${persona.clienteActivo.estadoItinerario.descripcion}" />
	<json:property name="perfilGestor" value="${persona.clienteActivo.idGestorActual}" />
	<json:property name="perfilSupervisor" value="${persona.clienteActivo.idSupervisorActual}" />
	<json:property name="codigoTipoTarea" value="${subtipoTareaTelecobro}" />
	<json:object name="clienteActivo" >
		<json:property name="isNull" value="${persona.clienteActivo == null}" />
	</json:object>
	<json:object name="expedientePropuesto" >
		<json:property name="isNull" value="${expedientePropuesto==null}" />
		<json:property name="id" value="${expedientePropuesto.id}" />
		<json:property name="seguimiento" value="${expedientePropuesto!=null && expedientePropuesto.seguimiento}" />
	</json:object>
	<json:property name="noHayExpedientes" value="${noHayExpedientes}" />
	<json:property name="clienteExceptuado" value="${clienteExceptuado}" />
	<json:property name="nombreTab" value="${nombreTab}" />
	<json:array name="arquetiposRecup" items="${arquetiposRecup}" var="aRecu">
		<json:object>
			<json:property name="id" value="${aRecu.id}" />
			<json:property name="nombre" value="${aRecu.nombre}" />
		</json:object>
	</json:array>
	<json:array name="arquetiposSeg" items="${arquetiposSeg}" var="aSec">
		<json:object>
			<json:property name="id" value="${aSec.id}" />
			<json:property name="nombre" value="${aSec.nombre}" />
		</json:object>
	</json:array>
	<json:array name="arquetiposGestDeuda" items="${arquetiposGestDeuda}" var="aGestDeu">
		<json:object>
			<json:property name="id" value="${aGestDeu.id}" />
			<json:property name="nombre" value="${aGestDeu.nombre}" />
		</json:object>
	</json:array>
	<json:object name="cabecera">
		<json:property name="codigo" value="${persona.codClienteEntidad}" />
		<json:property name="entidadPropietaria" value="${persona.propietario.descripcion}" />
		<json:property name="nombre" value="${persona.nombre}" />
		<json:property name="apellidos" value="${persona.apellido1} ${persona.apellido2}" />
		<json:property name="tipoDocumento" value="${persona.tipoDocumento}" />
		<json:property name="nif" value="${persona.docId}" />
		<json:property name="fijo1" value="${persona.telefono1}" />
		<json:property name="tipofijo1" value="${persona.tipoTelefono1.descripcion}" />
		<json:property name="fijo2" value="${persona.telefono2}" />
		<json:property name="tipofijo2" value="${persona.tipoTelefono2.descripcion}" />
		<json:property name="email" value="${persona.email}" />
		<json:property name="cartera" value="" />
		<json:property name="colectivoSingular" value="${persona.colectivoSingular.descripcion}" />
		<json:property name="fechaDato" >
			<fwk:date value="${persona.fechaDato}"/>
		</json:property>
		<json:property name="tipoPer" value="${persona.tipoPersona.descripcion}" />
		<json:property name="clienteActivo" value="${persona.clienteActivo}" />
		<json:property name="situacion" value="${persona.situacion}" />
		<json:property name="situacionData" value="${persona.clienteActivo.arquetipo.itinerario.dDtipoItinerario.descripcion}" />
		<json:property name="estadoCliente" value="${persona.estadoCliente}" />
		<json:property name="estadoCicloVida" value="${persona.estadoCicloVida}" />
		<json:property name="fechaEstado" >
			<fwk:date value="${persona.clienteActivo.fechaEstado}"/>
		</json:property>
		<json:property name="numExpedientesActivos" value="${persona.numExpedientesActivos}" />
		<json:property name="numAsuntosActivos" value="${persona.numAsuntosActivosPorPrc}" />
		<json:property name="ratingExterno" value="${persona.ratingExterno}" />
		<json:property name="segmento" value="${persona.segmento}" />
		<json:property name="segmentoEntidad" value="${persona.segmentoEntidad.descripcion}" />		
		<json:property name="nivel" value="${persona.tipoPersonaNivel.descripcion}"/>
		<json:property name="politicaEntidad" value="${persona.politicaEntidad.descripcion}" />
		<json:property name="riesgoDirecto" value="${persona.riesgoDirecto}" />
		<json:property name="riesgoDirectoVencido" value="${persona.riesgoDirectoVencido}" />
		<json:property name="riesgoDirectoNoVencido" value="${persona.riesgoDirectoNoVencido}" />
		<json:property name="riesgoIndirecto" value="${persona.riesgoIndirecto}" />
		<json:property name="riesgoDirectoDanyado" value="${persona.riesgoDirectoDanyado}" />
		<json:property name="riesgoVencidoOtrasEnt" value="${persona.riesgoVencidoOtrasEnt}" />
		<json:property name="riesgoDirectoNoVencidoDanyado" value="${persona.riesgoDirectoNoVencidoDanyado}" />
		<json:property name="riesgoDispuesto" value="${persona.riesgoDispuesto}" />
		<json:property name="riesgoAutorizado" value="${persona.riesgoAutorizado}" />
		<json:property name="dispuestoVencido" value="${persona.dispuestoVencido}" />
		<json:property name="dispuestoNoVencido" value="${persona.dispuestoNoVencido}" />		
		<json:property name="fechaReferenciaRating">
			<fwk:date value="${persona.fechaReferenciaRating}"/>
		</json:property>
		<json:property name="ratingExterno" value="${persona.ratingExterno.descripcion}" />
				
		<json:property name="pasivoVista" value="${persona.pasivoVista}" />
		<json:property name="pasivoPlazo" value="${persona.pasivoPlazo}" />
		<json:property name="puntuacion" value="${persona.puntuacionTotalActiva.puntuacion}" />
		<json:property name="prepolitica" value="${persona.prepolitica.descripcion}" />
		<json:property name="politica" value="${ultimaPolitica.tipoPolitica.descripcion}" />
		<json:property name="isNullGrupo" value="${persona.grupo==null}" />
		<json:property name="nombreGrupo" value="${persona.grupo.grupoCliente.nombre}" />
		<json:property name="ultimaOperacionConcedida" value="${persona.ultimaOperacionConcedida}" />
		<json:array name="direcciones" items="${persona.direcciones}" var="d">
			<json:object>
				<json:property name="tipoVia" value="${d.tipoVia.descripcion}" />
				<json:property name="domicilio" value="${d.domicilio}" />
				<json:property name="numeroDomicilio" value="${d.domicilio_n}"/>
				<json:property name="portal" value="${d.portal}"/>
				<json:property name="piso" value="${d.piso}"/>
				<json:property name="escalera" value="${d.escalera}"/>
				<json:property name="puerta" value="${d.puerta}"/>
				<json:property name="codPostal" value="${d.codigoPostal}" />
				<json:property name="provincia" value="${d.provincia.descripcion}" />
				<json:property name="localidad" value="${d.localidad}" />
				<json:property name="localidad" value="${d.municipio}" />
			</json:object>
		</json:array>
		<json:array name="telefonos" items="${persona.telefonos}" var="telf">
			<json:object>
				<json:property name="telefono" value="${telf.telefono}" />
				<json:property name="origenTelefono" value="${telf.origenTelefono.descripcion}"/>
				<json:property name="tipoTelefono" value="${telf.tipoTelefono.descripcion}"/>
				<json:property name="motivoTelefono" value="${telf.motivoTelefono.descripcion}"/>
				<json:property name="estadoTelefono" value="${telf.estadoTelefono.descripcion}"/>
				<c:if test="${telf.consentimiento==null}">
					<json:property name="consentimiento" value="" />
				</c:if>				
				<c:if test="${telf.consentimiento!=null}">
					<json:property name="consentimiento">
						<c:if test="${telf.consentimiento}">
							<s:message code="mensajes.si"/>
						</c:if>
						<c:if test="${!telf.consentimiento}">
							<s:message code="mensajes.no"/>
						</c:if>
					</json:property>
				</c:if>
				<json:property name="prioridad" value="${telf.prioridad}"/>
			</json:object>
		</json:array>
	</json:object>
	<json:object name="datosCliente">
	
	    <json:property name="colectivoSingular" value="${persona.colectivoSingular.descripcion}" />
	    <json:property name="politicaEntidad" value="${persona.politicaEntidad.descripcion}" />
	    <json:property name="prepolitica" value="${persona.prepolitica.descripcion}" />
		<json:property name="puntuacion" value="${persona.puntuacionTotalActiva.puntuacion}" />
		<json:property name="nombreGrupo" value="${persona.grupo.grupoCliente.nombre}" />
		<json:property name="ultimaOperacionConcedida">
			<fwk:date  value="${persona.ultimaOperacionConcedida}" />
		</json:property>
	    
		<json:property name="fechaConstitucion" >
			<fwk:date value="${persona.fechaConstitucion}"/>
		</json:property>
		<json:property name="fechaNacimiento" >
			<fwk:date value="${persona.fechaNacimiento}"/>
		</json:property>
		<json:property name="esEmpleado">
					<c:if test="${persona.esEmpleado}">
						<s:message code="mensajes.si"/>
					</c:if>
					<c:if test="${!persona.esEmpleado}">
						<s:message code="mensajes.no"/>
					</c:if>
		</json:property>
		<json:property name="tieneIngresosDomiciliados">
					<c:if test="${persona.tieneIngresosDomiciliados}">
						<s:message code="mensajes.si"/>
					</c:if>
					<c:if test="${!persona.tieneIngresosDomiciliados}">
						<s:message code="mensajes.no"/>
					</c:if>
		</json:property>
		<json:property name="volumenFacturacion" value="${persona.volumenFacturacion}" />
		<json:property name="fechaVolumenFacturacion">
			<fwk:date value="${persona.fechaVolumenFacturacion}"/>
		</json:property>
		<json:property name="fechaReferenciaRating">
			<fwk:date value="${persona.fechaReferenciaRating}"/>
		</json:property>
		<json:property name="ratingExterno" value="${persona.ratingExterno.descripcion}" />
		<json:property name="servicioNominaPension" value="${persona.servicioNominaPension}" />
		<json:property name="ultimaActuacion" value="${ultimaPolitica.tipoPolitica.descripcion}" />
		<json:property name="situacionConcursal">
			<c:if test="${persona.situacionConcursal}">
				<s:message code="mensajes.si"/>
			</c:if>
			<c:if test="${!persona.situacionConcursal}">
				<s:message code="mensajes.no"/>
			</c:if>
		</json:property>
		<json:property name="sitConcursal" value="${persona.sitConcursal.descripcion}" />
		<json:property name="fechaSituacionConcursal" value="${persona.fechaSituacionConcursal}"/>
		<json:property name="clienteReestructurado">
			<c:if test="${persona.clienteReestructurado}">
				<s:message code="mensajes.si"/>
			</c:if>
			<c:if test="${!persona.clienteReestructurado}">
				<s:message code="mensajes.no"/>
			</c:if>
		</json:property>		
		<json:property name="tipoPersona" value="${persona.tipoPersona.codigo}" />
		<json:property name="tipoGestorEntidad" value="${persona.tipoGestorEntidad.descripcion}" />
		<json:property name="areaGestion" value="${persona.areaGestion.descripcion}" />
		<json:property name="paisNacimiento" value="${persona.paisNacimiento.descripcion}" />
		<json:property name="sexo" value="${persona.sexo.descripcion}" />
		<json:property name="nroSocios" value="${persona.nroSocios}" />
		<json:property name="oficinaGestora" value="${persona.oficinaGestora.nombre}" />
		<json:property name="centroGestor" value="${persona.centroGestor.descripcion}" />
		<json:property name="perfilGestor" value="${persona.perfilGestor.descripcion}" />
		<json:property name="usuarioGestor" value="${persona.usuarioGestor.apellidoNombre}" />
		<json:property name="grupoGestor" value="1" />
		<json:property name="codClienteEntidad" value="${persona.codClienteEntidad}" />
		<json:property name="nacionalidad" value="${persona.nacionalidad.descripcion}" />
		<json:property name="numEmpleados" value="${persona.numEmpleados}" />
		<json:property name="politicaEntidad" value="${persona.politicaEntidad.descripcion}" />
		<json:property name="ratingAuxiliar" value="${persona.ratingAuxiliar}" />
		<json:property name="extra1" value="${persona.extra1}" />
		<json:property name="extra2" value="${persona.extra2}" />
		<json:property name="extra3" value="${persona.extra3}" />
		<json:property name="extra4" value="${persona.extra4}" />
		<json:property name="extra5" value="${persona.extra5}" />
		<json:property name="extra6" value="${persona.extra6}" />
		<json:property name="movil1" value="${persona.movil1}" />
		<json:property name="movil2" value="${persona.movil2}" />
		<json:property name="telefono5" value="${persona.telefono5}" />
		<json:property name="telefono6" value="${persona.telefono6}" />
		<json:property name="tipoTelefono3" value="${persona.tipoTelefono3}" />
		<json:property name="tipoTelefono4" value="${persona.tipoTelefono4}" />
		<json:property name="tipoTelefono5" value="${persona.tipoTelefono5}" />
		<json:property name="tipoTelefono6" value="${persona.tipoTelefono6}" />
		
		<json:property name="zonaPersona" value="${zonaPersona.descripcion}" />
		<json:property name="zonaTerritorial" value="${zonaTerritorial.descripcion}" />
		
		<json:property name="cnae" value="${persona.descripcionCnae}" />
		<json:property name="accionFSR">
			<c:if test="${accionFSR}">
				<s:message code="mensajes.si"/>
			</c:if>
			<c:if test="${!accionFSR}">
				<s:message code="mensajes.no"/>
			</c:if>
		</json:property>
	    
	</json:object>
	<json:object name="solvencia">
		<json:property name="fechaVerifSolvencia" >
			<fwk:date value="${persona.fechaVerifSolvencia}"/>
		</json:property>
		<json:property name="fechaRevisionSolvencia" >
			<fwk:date value="${persona.fechaRevisionSolvencia}"/>
		</json:property>
		<json:property name="observacionesRevisionSolvencia" value="${persona.observacionesRevisionSolvencia}" />
		<json:property name="observacionesSolvencia" value="${persona.observacionesSolvencia}" />
		<json:property name="gestorSolvencias" value="${gestorProveedor}"/>
		<json:property name="noTieneFincabilidad" value="${persona.noTieneFincabilidad}" />
	</json:object>
	<json:object name="antecedentes">
		<json:property name="fechaVerificacion" >
			<fwk:date value="${antecedente.fechaVerificacion}"/>
		</json:property>
		<json:property name="observaciones" value="${antecedente.observaciones}" />
		<json:property name="numReincidenciasInterno" value="${antecedente.numReincidenciasInterno}" />
	</json:object>
	<json:object name="umbral">
		<json:property name="importeUmbral" value="${persona.importeUmbral}" />
		<json:property name="comentarioUmbral" value="${persona.comentarioUmbral}" />
		<json:property name="fechaUmbral" >
			<fwk:date value="${persona.fechaUmbral}"/>
		</json:property>
	</json:object>
	<json:object name="cirbe">
		<json:property name="fechaInicial1" >
			<fwk:date value="${fechaCirbeActual}"/>
		</json:property>
		<json:property name="fechaInicial2" >
			<fwk:date value="${fechaCirbe30Dias}"/>
		</json:property>
		<json:property name="fechaInicial3" >
			<fwk:date value="${fechaCirbe60Dias}"/>
		</json:property>
	</json:object>
	<json:object name="grupo">
		<json:property name="id" value="${persona.grupo.grupoCliente.id}" />
		<json:property name="isNull" value="${persona.grupo==null}" />
		<json:property name="nombre" value="${persona.grupo.grupoCliente.nombre}" />
		<json:property name="tipo" value="${persona.grupo.grupoCliente.tipoGrupoCliente.descripcion}" />
		<json:property name="numComp" value="${personasMismoGrupoCount}" />
		<json:property name="volRiesgo" value="${persona.grupo.grupoCliente.riesgoDirecto}" />
		<json:property name="riesgoIndirecto" value="${persona.grupo.grupoCliente.riesgoIndirecto}" />
		<json:property name="volRiesgoV" value="${persona.grupo.grupoCliente.riesgoDirectoVencido}" />
		<json:property name="volRiesgoDDG" value="${persona.grupo.grupoCliente.riesgoDirectoDanyado}" />
	</json:object>
	<json:object name="scoring">
		<json:property name="fechasAlertas" value="${fechasAlertas}" />
	</json:object>
	
</fwk:json>