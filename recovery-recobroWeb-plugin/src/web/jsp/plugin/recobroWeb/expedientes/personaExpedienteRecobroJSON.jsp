<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:array name="clientes" items="${clientes}" var="c">
		<json:object>
			<json:property name="id" value="${c.expedientePersona.persona.id}"/>
			<json:property name="apellidoNombre" value="${c.expedientePersona.persona.apellidoNombre}"/>
			<json:property name="vrDirecto" value="${c.expedientePersona.persona.riesgoDirecto}"/>	
			<json:property name="vrIndirecto" value="${c.expedientePersona.persona.riesgoIndirecto}"/>
			<json:property name="vrIrregular" value="${c.expedientePersona.persona.riesgoDirectoVencido}"/>
			<json:property name="riesgoDirectoDanyado" value="${c.expedientePersona.persona.riesgoDirectoNoVencidoDanyado}"/>
			<json:property name="contratosActivos" value="${c.expedientePersona.persona.numContratos}"/>
			<json:array name="ciclosRecobroPersona" items="${c.ciclosRecobro}" var="ciclo">
				<json:object>
					<json:property name="idCiclo" value="${ciclo.id}"/>
					<json:property name="fechaCesion" value="${ciclo.fechaAlta}" />
					<json:property name="agencia" value="${ciclo.cicloRecobroExpediente.agencia.nombre}"/>
					<json:property name="cartera" value="${ciclo.cicloRecobroExpediente.carteraEsquema.cartera.nombre}"/>
					<json:property name="RDCedido" value="${ciclo.posVivaNoVencida}"/>
					<json:property name="RICedido" value="${ciclo.posVivaVencida}"/>
					<json:property name="fechaFin" value="${ciclo.fechaBaja}" />
					<json:property name="motivoFin" value="${ciclo.motivoBaja.descripcion}"/>
				</json:object>
			</json:array>	
		</json:object>
	</json:array>
</fwk:json>