<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<fwk:json>
	<json:property name="total" value="${hitos.totalCount}" />
	<json:array name="hitos" items="${hitos.results}" var="h">
		<json:object>
			<json:property name="fechaExtraccion" >
				<fwk:date value="${h.fechaExtraccion}"/>
			</json:property>
			<json:property name="contrato" value="${h.contrato.codigoContrato}"/>
			<json:property name="iter" value="${h.iterJudicial.id}"/>
			<c:if test="${h.persona== null}">
				<json:property name="codigoPersona" value="${h.codigoPersona}"/>
			</c:if>
			<c:if test="${h.persona== null}">
				<json:property name="codigoPersona" value="${h.persona.apellidoNombre}"/>
			</c:if>
			<json:property name="tipoHito" value="${h.tipoHitoIter.descripcion}"/>	
			<json:property name="fechaInicio" >
				<fwk:date value="${h.fechaInicio}"/>
			</json:property>
			<json:property name="fechaCumplimiento" >
				<fwk:date value="${h.fechaCumplimiento}"/>
			</json:property>
			<json:property name="observaciones" value="${h.observaciones}"/>
			<c:if test="${h.usuario.apellidoNombre== null}">
				<json:property name="gestor" value="${h.gestor}"/>
			</c:if>
			<c:if test="${h.usuario.apellidoNombre!= null}">
				<json:property name="gestor" value="${h.usuario.apellidoNombre}"/>
			</c:if>
			<json:property name="codigoInterfaz" value="${h.tipoHitoIter.codigoInterfaz}"/>
			<json:property name="idHito" value="${h.idHito}"/>
			<%-- 
			<json:property name="tipoPersona" value="${h.tipoPersona.descripcion}"/>
			--%>
			<%-- 
			<json:property name="tipoInteraccion" value="${h.interaccion.subTipoInteraccion.tipoInteraccion.descripcion}"/>
			<json:property name="subTipoInteraccion" value="${h.interaccion.subTipoInteraccion.descripcion}"/>
			--%>
			<%--
			--%>
		</json:object>	
	</json:array>
</fwk:json>