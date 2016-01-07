<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
  <json:property name="id" value="${procedimiento.id}" />
  <json:property name="nombreTab" value="${nombreTab}" />
<!--  <json:property name="fechaVenc" value="${fechaVenc}" /> -->
<!--  <json:property name="tarea" value="${tarea}" /> -->
  <json:property name="paralizado" value="${paralizado}" />
  <json:property name="esGestor" value="${esGestor}" />
  <json:property name="esSupervisor" value="${esSupervisor}" />
  <json:property name="esGestorDecision" value="${esGestorDecision}" />  
  <json:property name="procedimientoAceptado" value="${procedimiento.estaAceptado}" />
  <json:property name="puedeCrearRecurso" value="${puedeCrearRecurso}" />
  <json:property name="derivacionAceptada" value="${procedimiento.derivacionAceptada}" />
  <json:property name="nombreProcedimiento" value="${procedimiento.nombreProcedimiento}" />
  <json:property name="hayPrecontencioso" value="${precontencioso.id != null}" />
  <json:property name="estadoPrecontencioso" value="${precontencioso.estadoActualCodigo}" />
  <json:object name="toolbar">
	  <json:property name="fechaCreacionFormateada" value="${procedimiento.asunto.fechaCreacionFormateada}" />
	  <json:property name="estadoItinerario" value="${procedimiento.asunto.estadoItinerario.descripcion}" />
  	  <json:property name="tareaPendiente" value="${tareaPendiente!=null}" />
  	  <json:property name="descripcionTarea" value="${tareaPendiente.descripcionTarea}" />
	  <json:property name="tareaPendienteId" value="${tareaPendiente.id}" />
  </json:object>
  <json:object name="cabecera">
	  <json:property name="asunto" value="${procedimiento.asunto.nombre}" />
	  <json:property name="asuntoId" value="${procedimiento.asunto.id}" />
	  <json:property name="despacho" value="${procedimiento.asunto.gestor.despachoExterno.despacho}" />
	  <json:property name="gestor" value="${procedimiento.asunto.gestor.usuario.apellidoNombre}" />
	  <json:property name="supervisor" value="${procedimiento.asunto.supervisor.usuario.apellidoNombre}" />
	  <json:property name="procurador" value="${procedimiento.asunto.procurador.usuario.apellidoNombre}" />
	  <json:property name="fechaInicio">
		<fwk:date value="${procedimiento.auditoria.fechaCrear}" />
	  </json:property>
	  <json:property name="procedimiento" value="${procedimiento.tipoProcedimiento.descripcion}" />
	  <json:property name="procedimientoCodigo" value="${procedimiento.tipoProcedimiento.codigo}" />
	  <json:property name="procedimientoInterno" value="${procedimiento.id}" />
	  <json:property name="procedimientoJuzgado" value="${procedimiento.codigoProcedimientoEnJuzgado}" />
	  <json:property name="juzgado" value="${procedimiento.juzgado.descripcion}" />
	  <json:property name="plazaJuzgado" value="${procedimiento.juzgado.plaza.descripcion}" />
	  <json:property name="reclamacion" value="${procedimiento.tipoReclamacion.descripcion}" />
	  <json:property name="estado" value="${procedimiento.estadoProcedimiento.descripcion}" />
	  <json:property name="saldoVencido" value="${procedimiento.saldoVencidoActual}" />
	  <json:property name="saldoNoVencido" value="${procedimiento.saldoNoVencidoActual}" />
	  <json:property name="saldoOriginalVencido" value="${procedimiento.saldoOriginalVencido}" />
	  <json:property name="saldoOriginalNoVencido" value="${procedimiento.saldoOriginalNoVencido}" />
	  <json:property name="saldoRecuperar" value="${procedimiento.saldoRecuperacion}" />
	  <json:property name="recuperacion" value="${procedimiento.porcentajeRecuperacion}" />
	  <json:property name="meses" value="${procedimiento.plazoRecuperacion}" />
	  <json:object name="clientes">
	      <json:array name="clientes" items="${procedimiento.personasAfectadas}" var="per">  
		<json:object>
		  <json:property name="id" value="${per.id}"/>
		  <json:property name="apellidoNombre" value="${per.apellidoNombre}"/>
		  <json:property name="nombre" value="${per.nombre}"/>
		  <json:property name="apellido1" value="${per.apellido1}"/>
		  <json:property name="apellido2" value="${per.apellido2}"/>
		   <json:property name="deudaIrregular" value="${per.deudaIrregular}"/>
		    <json:property name="totalSaldo" value="${per.totalSaldo}"/>            
		    <json:property name="asiste" value="true" />
		 </json:object>
	      </json:array>
	    </json:object>
  </json:object>
  <json:object name="tareas">
    <json:property name="estadoItinerario" value="${procedimiento.asunto.estadoItinerario.descripcion}" />
    <json:property name="fechaCreacion">
		<fwk:date value="${procedimiento.auditoria.fechaCrear}" />
    </json:property>
  </json:object>
  <json:object name="documentacion">
    <json:property name="tipoProcedimiento" value="${procedimiento.tipoProcedimiento.html}" />
    <json:property name="observacionesRecopilacion" value="${procedimiento.observacionesRecopilacion}" />
    <json:property name="fechaRecopilacion">
	<fwk:date value="${procedimiento.fechaRecopilacion}" />
    </json:property>
    <json:property name="fechaRecepcionDocumentacion">
	<fwk:date value="${procedimiento.asunto.fechaRecepDoc}" />
    </json:property>
  </json:object>
  <json:object name="historico">
    <json:property name="tipoProcedimiento" value="${procedimiento.tipoProcedimiento.html}" escapeXml="false"/>
	<json:property name="nombreProcedimiento" value="${procedimiento.tipoProcedimiento.descripcion}"/>
  </json:object>
  <json:object name="contratoPrincipal">
    <json:property name="codigoContrato" value="${contratoPrincipal.codigoContrato}" escapeXml="false"/>
  </json:object>
  <json:object name="precontencioso">
  	<json:property name="id" value="${precontencioso.id}" />
  	<json:property name="estadoActual" value="${precontencioso.estadoActual}" />
  	<json:property name="estadoActualCodigo" value="${precontencioso.estadoActualCodigo}" />
	<json:property name="tipoPreparacionDesc" value="${precontencioso.tipoPreparacionDesc}" />
	<json:property name="tipoProcPropuestoDesc" value="${precontencioso.tipoProcPropuestoDesc}" />
	<json:property name="tipoProcIniciadoDesc" value="${precontencioso.tipoProcIniciadoDesc}" />
	<json:property name="preturnado" value="${precontencioso.preturnado}" />
	<json:property name="nombreExpJudicial" value="${precontencioso.nombreExpJudicial}" />
	<json:property name="numExpInterno" value="${precontencioso.numExpInterno}" />
	<json:property name="numExpExterno" value="${precontencioso.numExpExterno}" />
	<json:property name="cntPrincipal" value="${precontencioso.cntPrincipal}" />
  </json:object>
</fwk:json>
