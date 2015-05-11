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
			<json:property name="userName" value="${panel.userName}" />
			<json:property name="totalExpedientes" value="${panel.totalExpedientes}" />
			<json:property name="importe" value="${panel.importe}" />
			<json:property name="tareasVencidas" value="${panel.tareasVencidas}" />
			<json:property name="tareasPendientesHoy" value="${panel.tareasPendientesHoy}" />
			<json:property name="tareasPendientesSemana" value="${panel.tareasPendientesSemana}" />
			<json:property name="tareasPendientesMes" value="${panel.tareasPendientesMes}" />
			<json:property name="tareasPendientesMasMes" value="${panel.tareasPendientesMasMes}" />
			<json:property name="tareasPendientesMasAnyo" value="${panel.tareasPendientesMasAnyo}" />
			<json:property name="tareasFinalizadasAyer" value="${panel.tareasFinalizadasAyer}" />
		    <json:property name="tareasFinalizadasSemana" value="${panel.tareasFinalizadasSemana}" />
			<json:property name="tareasFinalizadasMes" value="${panel.tareasFinalizadasMes}" />
			<json:property name="tareasFinalizadasAnyo" value="${panel.tareasFinalizadasAnyo}" />
			<json:property name="tareasFinalizadas" value="${panel.tareasFinalizadas}" />
		</json:object>
	</json:array>
</fwk:json>