<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${totalTerminos}" />
	<json:array name="terminos" items="${results}" var="ter">
		<json:object>
			<json:property name="idTermino" value="${ter.idTermino}"/>
			<json:property name="idAcuerdo" value="${ter.idAcuerdo}"/>
			<json:property name="idAsunto" value="${ter.idAsunto}"/>
			<json:property name="nombreAsunto" value="${ter.nombreAsunto}"/>
			<json:property name="idExpediente" value="${ter.idExpediente}"/>
			<json:property name="descripcionExpediente" value="${ter.descripcionExpediente}"/>
			<json:property name="tipoExpediente" value="${ter.tipoExpediente}"/>
			<json:property name="idContrato" value="${ter.idContrato}"/>
			<json:property name="cliente" value="${ter.nroCliente}"/>
			<json:property name="tipoAcuerdo" value="${ter.tipoAcuerdo}"/>
			<json:property name="solicitante" value="${ter.solicitante}"/>
			<json:property name="tipoSolicitante" value="${ter.tipoSolicitante}"/>
			<json:property name="estado" value="${ter.estado}"/>
			<json:property name="fechaAlta" value="${ter.fechaAlta}"/>
			<json:property name="fechaEstado" value="${ter.fechaEstado}"/>
			<json:property name="fechaVigencia" value="${ter.fechaVigencia}"/>						
		</json:object>
	</json:array>
</fwk:json>		