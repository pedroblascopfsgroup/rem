<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="palancas" items="${palancas}" var="palanca">
		<json:object>
			<json:property name="id" value="${palanca.id}"/>
			<json:property name="idPolitica" value="${palanca.politicaAcuerdos.id}"/>
			<json:property name="tipoPalanca" value="${palanca.subtipoPalanca.tipoPalanca.descripcion}"/>
			<json:property name="subtipoPalanca" value="${palanca.subtipoPalanca.descripcion}"/>
			<json:property name="delegada" value="${palanca.delegada.descripcion}"/>
			<json:property name="prioridad" value="${palanca.prioridad}"/>
			<json:property name="tiempoInmunidad1" value="${palanca.tiempoInmunidad1}"/>
			<json:property name="tiempoInmunidad2" value="${palanca.tiempoInmunidad2}"/>
		</json:object>
	</json:array>
</fwk:json>		