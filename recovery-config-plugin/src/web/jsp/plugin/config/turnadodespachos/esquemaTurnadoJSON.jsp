<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"
	import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig"
%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="id" value="${data.id}" />
	<json:property name="descripcion" value="${data.descripcion}" />
	<json:object name="estadoEsquema">
		<json:property name="id" value="${data.estado.id}" />
		<json:property name="codigo" value="${data.estado.codigo}" />
		<json:property name="descripcion" value="${data.estado.descripcion}" />
	</json:object>
	<json:property name="limiteStockAnualConcursos" value="${data.limiteStockAnualConcursos}" />
	<json:property name="limiteStockAnualLitigios" value="${data.limiteStockAnualLitigios}" />
	<json:property name="fechaInicioVigencia" value="${data.fechaInicioVigencia}" />
	<json:property name="fechaFinVigencia" value="${data.fechaFinVigencia}" />
	<json:array name="configuracion" items="${data.configuracion}" var="config">
		<json:object>
			<json:property name="tipo" value="${config.tipo}" />
			<json:property name="codigo" value="${config.codigo}" />
			<json:property name="descripcion" value="${config.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>