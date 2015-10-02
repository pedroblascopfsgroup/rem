<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="id" value="${asunto.id}" />
	<json:property name="nombreTab" value="${nombreTab}" />

<%-- esto sacarlo luego a cabeceraJSON.jsp --%>
	<json:object name="cabecera">
	   <json:object name="procurador">
		  <json:property name="apellidoNombre" value="${asunto.procurador.usuario.apellidoNombre}" />
	   </json:object>
	  <json:property name="fechaConformacion" >
		<fwk:date value="${asunto.auditoria.fechaCrear}"/>
	  </json:property>
	  <json:property name="asunto" value="${asunto.nombre}" />
	  <json:property name="estado" value="${asunto.estadoAsunto.descripcion}" />
	  <json:property name="codigoExterno" value="${asunto.codigoExterno}" />
	  <c:if test="${asunto.propiedadAsunto != null}">
	  	<json:property name="propiedadAsunto" value="${asunto.propiedadAsunto.descripcion}" />
	  </c:if>
	  <c:if test="${asunto.gestionAsunto != null}">
	  	<json:property name="gestionAsunto" value="${asunto.gestionAsunto.descripcion}" />
	  </c:if>
	  <json:property name="despacho" value="${asunto.gestor.despachoExterno.despacho}" />
	  <json:property name="gestor" value="${asunto.gestor.usuario.apellidoNombre}" />
	  <json:property name="supervisor" value="${asunto.supervisor.usuario.apellidoNombre}" />
	  <json:property name="expediente" value="${asunto.expediente.descripcionExpediente}" />
	  <json:property name="expedienteId" value="${asunto.expediente.id}" />
	  <json:property name="comite" value="${asunto.comite.nombre}" />
	  <json:property name="decisionComite" value="${asunto.decisionComite.observaciones}" />
	  <c:if test="${asunto.tipoAsunto != null}">
	  	<json:property name="tipoAsunto" value="${asunto.tipoAsunto.descripcion}" />
	  	<json:property name="tipoAsuntoCodigo" value="${asunto.tipoAsunto.codigo}" />
	  </c:if>
	  <json:property name="cantidadDiasParaVencer" value="${asunto.cantidadDiasParaVencer}" />
	  
	  <json:property name="despachoCEXP" value="${asunto.gestorCEXP.despachoExterno.despacho}" />
	  <json:property name="gestorCEXP" value="${asunto.gestorCEXP.usuario.apellidoNombre}" />
	  <json:property name="supervisorCEXP" value="${asunto.supervisorCEXP.usuario.apellidoNombre}" />
	  <json:property name="titulizada" value="${titulizada}"/>
	  <json:property name="fondo" value="${fondo}"/>
	  <json:property name="msgErrorEnvioCDD" value="${msgErrorEnvioCDD}" />
	</json:object>
	<json:object name="comite">
	  <json:property name="sesion" value="${asunto.comite.ultimaSesion.id}" />
	  <json:property name="fecha" >
		<fwk:date value="${asunto.comite.ultimaSesion.fechaInicio}"/>
	  </json:property>
	  <json:property name="nombre" value="${asunto.comite.nombre}" />
		</json:object>
	<json:object name="aceptacion">
		<c:if test="${asunto.fichaAceptacion.conflicto==true}"><json:property name="conflicto" value="Si" /></c:if>	
		<c:if test="${asunto.fichaAceptacion.conflicto==false}"><json:property name="conflicto" value="No" /></c:if>	
		<c:if test="${asunto.fichaAceptacion.documentacionRecibida==true}"><json:property name="documentacionRecibida" value="Si" /></c:if>	
		<c:if test="${asunto.fichaAceptacion.documentacionRecibida==false}"><json:property name="documentacionRecibida" value="No" /></c:if>	
		<c:if test="${asunto.fichaAceptacion.aceptacion==true}"><json:property name="aceptacion" value="Si" /></c:if>	
		<c:if test="${asunto.fichaAceptacion.aceptacion==false}"><json:property name="aceptacion" value="No" /></c:if>	
		<json:property name="fechaRecepDoc" >
			<fwk:date value="${asunto.fechaRecepDoc}"/>
		</json:property>
		<json:property name="observaciones" value="${asunto.fichaAceptacion.observaciones[0].detalle}" />
		<json:property name="estaConfirmado" value="${asunto.estaConfirmado}" />
		<json:property name="puedoDevolver" value="${puedoDevolver}" />
		<json:property name="gestor" value="${asunto.gestor.usuario.id}" />
		<json:property name="supervisor" value="${asunto.supervisor.usuario.id}" />
		<json:property name="estaAceptado" value="${asunto.estaAceptado}" />
	</json:object>
	<json:object name="cobroPago">
		<json:property name="estadoAsunto" value="${asunto.estadoAsunto.codigo}" />
	</json:object>
	<json:object name="toolbar">
		<json:property name="asuntoId" value="${asunto.id}" />
		<json:property name="fechaCreacionFormateada" value="${asunto.fechaCreacionFormateada}" />
		<json:property name="estadoItinerario" value="${asunto.estadoItinerario.descripcion}" />
		<json:property name="tareaPendiente" value="${tareaPendiente.id}" />
		<json:property name="estaPropuesto" value="${asunto.estaPropuesto}" />
		<json:property name="reasignadoPorVacaciones" value="${asunto.reasignadoPorVacaciones}" />
		<json:property name="esGestor" value="${esGestor}" />
		<json:property name="esSupervisor" value="${esSupervisor}" />
		<json:property name="esSupervisorOriginal" value="${esSupervisorOriginal}" />
		<json:property name="descripcionTarea" value="${tareaPendiente.descripcionTarea}" />
		<json:property name="puedeVerDecisionComite" value="${puedeVerDecisionComite}" />
		<json:property name="puedeVerTabSubasta" value="${puedeVerTabSubasta}" />
		<json:property name="puedeVerTabAdjudicados" value="${puedeVerTabAdjudicados}" />		
	    <json:property name="provision" value="${provision}" />
	    <json:property name="puedeFinalizarAsunto" value="${puedeFinalizarAsunto}" />
	</json:object>
	<json:object name="concursal">
		<json:property name="procedimientosConcursales" value="${procedimientosConcursales}" />
	</json:object>
</fwk:json>
