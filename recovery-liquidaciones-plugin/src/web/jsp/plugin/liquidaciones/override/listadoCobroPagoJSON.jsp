<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
	<json:object>
		<json:property name="id" value="${rec.id}"/>
		<json:property name="procedimiento" value="${rec.procedimiento.nombreProcedimiento}"/>
		<json:property name="estado" value="${rec.estado.descripcion}"/>
		<json:property name="tipoGenerico" value="Genérico"/>
		<json:property name="subTipo" value="${rec.subTipo.descripcion}"/>
		<json:property name="importe" value="${rec.importe}"/>
		<json:property name="fecha" >
			<fwk:date value="${rec.fecha}"/>
		</json:property>
		<json:property name="origenCobro" value="${rec.origenCobro.descripcion}"/>
		<json:property name="modalidadCobro" value="${rec.modalidadCobro.descripcion}"/>
		<json:property name="observaciones" value="${rec.observaciones}"/>
		<json:property name="revisado" value="${rec.revisado}"/>
		<json:property name="tipoImputacion" value="${rec.tipoImputacion.codigo}"/>
	</json:object>
	</json:array>
</fwk:json>
