<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${ciclosRecPer.totalCount}" />
	<json:array name="ciclosRecPer" items="${ciclosRecPer.results}" var="cicloRecPer">
		<json:object>
			<json:property name="id" value="${cicloRecPer.id}"/>
			<json:property name="idPersona" value="${cicloRecPer.persona.id}"/>
			<json:property name="apellidoNombre" value="${cicloRecPer.persona.apellidoNombre}"/>
			<json:property name="docPersona" value="${cicloRecPer.persona.docId}"/>
			<json:property name="idCicloRecobroExpediente" value="${cicloRecPer.cicloRecobroExpediente.id}"/>
			<json:property name="motivoBaja" value="${cicloRecPer.motivoBaja.descripcion}"/>
			<json:property name="exceptuacion" value="${cicloRecCnt.exceptuacion.motivo}"/>
			<json:property name="fechaAlta">
				<fwk:date value="${cicloRecPer.fechaAlta}"/>
			</json:property>
			<json:property name="fechaBaja">
				<fwk:date value="${cicloRecPer.fechaBaja}"/>
			</json:property>
			<json:property name="posVivaNoVencida" value="${cicloRecPer.posVivaNoVencida}"/>
			<json:property name="posVivaVencida" value="${cicloRecPer.posVivaVencida}"/>
			<json:property name="agencia" value="${cicloRecPer.cicloRecobroExpediente.agencia.nombre}"/>	
			<json:property name="cartera" value="${cicloRecPer.cicloRecobroExpediente.carteraEsquema.cartera.nombre}"/>
		</json:object>
	</json:array>
</fwk:json>