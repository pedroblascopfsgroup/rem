<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="panelControl" items="${listado}" var="panel">
		<json:object>			 
			<json:property name="idNivel" value="${panel.id}" />
			<json:property name="nivel" value="${panel.nivel}" />
			<json:property name="cod" value="${panel.cod}" />
			<json:property name="ofiCodigo" value="${panel.ofiCodigo}" />
			<json:property name="clientes" value="${panel.clientes}" />
			<json:property name="contratosTotal" value="${panel.contratosTotal}" />
			<json:property name="contratosIrregulares" value="${panel.contratosIrregulares}" />
			<json:property name="saldoVencido" value="${panel.saldoVencido}" />
			<json:property name="saldoNoVencido" value="${panel.saldoNoVencido}" />
			<json:property name="saldoNoVencidoDanyado" value="${panel.saldoNoVencidoDanyado}" />
			<json:property name="tareasPendientesVencidas" value="${panel.tareasPendientesVencidas}" />
			<json:property name="tareasPendientesHoy" value="${panel.tareasPendientesHoy}" />
			<json:property name="tareasPendientesSemana" value="${panel.tareasPendientesSemana}" />
			<json:property name="tareasPendientesMes" value="${panel.tareasPendientesMes}" />
		</json:object>
	</json:array>
</fwk:json>