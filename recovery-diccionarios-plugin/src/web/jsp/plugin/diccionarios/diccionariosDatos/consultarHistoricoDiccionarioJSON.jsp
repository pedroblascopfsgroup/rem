<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="historico" items="${historicoDiccionario}" var="hist">
		<json:object>
			<json:property name="usuario" value="${hist.usuario}" />
			<json:property name="accion" value="${hist.accion}" />
			<json:property name="fecha"><fwk:date value="${hist.fecha}" /></json:property>
			<json:property name="valorAnterior" value="${hist.valorAnterior}" />
			<json:property name="valorNuevo" value="${hist.valorNuevo}" />
			
		</json:object>
	</json:array>
</fwk:json>