<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<fwk:json>
	<json:property name="total" value="${listado.totalCount}" /> 
	<json:property name="usuarioLogado" value="${usuario.username}" />
	<json:property name="esProveedor" value="${esProveedor}" />
	<json:array name="incidencias" items="${listado.results}" var="inc">
		<json:object>			 
			<json:property name="idIncidencia" value="${inc.incidencia.id}" />
			<json:property name="fechaCrear" ><fwk:date value="${inc.incidencia.auditoria.fechaCrear}"/></json:property>
			<json:property name="persona" value="${inc.incidencia.persona.nombre}"/>
			<json:property name="contrato" value="${inc.incidencia.contrato.codigoContrato}" />
			<json:property name="usuario" value="${inc.agencia}" />
			<json:property name="tipoIncidencia" value="${inc.incidencia.tipoIncidencia.descripcion}"/>
			<json:property name="idSituacionIncidencia" value="${inc.incidencia.situacionIncidencia.id}"/>
			<json:property name="observaciones" value="${inc.incidencia.observaciones}" />
		</json:object>
	</json:array>
</fwk:json>