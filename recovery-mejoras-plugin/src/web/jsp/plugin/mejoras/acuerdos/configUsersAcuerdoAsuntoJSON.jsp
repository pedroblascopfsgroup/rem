<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<fwk:json>
		<json:object name="tiposDespachosAcuerdoAsunto">
			<json:property name="proponente" value="${map.proponente.id}"/>
			<json:property name="validador" value="${map.validador.id}"/>
			<json:property name="decisor" value="${map.decisor.id}"/>
		</json:object>
		<json:object name="userLogado">
			<json:property name="id" value="${idUsuario}"/>
			<json:property name="idTipoDespacho" value="${idTipoDespacho}"/>
		</json:object>
</fwk:json>			


