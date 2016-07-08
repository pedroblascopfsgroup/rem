<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
	<json:object>
		<json:property name="idProcedimiento" value="${rec.procedimiento.id}"/>
		<json:property name="id" value="${rec.id}"/>
		<json:property name="procedimientoPadre" value="${rec.procedimiento.procedimientoPadre.id}"/>
		<json:property name="tipoActuacion" value="${rec.procedimiento.tipoActuacion.codigo}"/>
		<json:property name="descripcion" value="${rec.procedimiento.nombreProcedimiento}"/>
		<json:property name="tipoReclamacion" value="${rec.procedimiento.tipoReclamacion.codigo}"/>
		<json:property name="tipoProcedimiento" value="${rec.procedimiento.tipoProcedimiento.codigo}"/>
		<json:property name="porcentajeRecuperacion" value="${rec.procedimiento.porcentajeRecuperacion}"/>
		<json:property name="plazoRecuperacion" value="${rec.procedimiento.plazoRecuperacion}"/>
		<json:property name="saldoOriginalVencido" value="${rec.procedimiento.saldoOriginalVencido}"/>
		<json:property name="saldoRecuperacion" value="${rec.procedimiento.saldoRecuperacion}"/>
		<json:property name="saldoOriginalNoVencido" value="${rec.procedimiento.saldoOriginalNoVencido}"/>
		<json:property name="fechaRecopilacion" >
			<fwk:date value="${rec.procedimiento.fechaRecopilacion}"/>
		</json:property>
		<json:property name="personas" value="${rec.procedimiento.personasAfectadas[0].id}" />
	</json:object>
	<c:forEach items="${rec.procedimiento.personasAfectadas}" var="per">
		<c:if test="${per.id!=rec.procedimiento.personasAfectadas[0].id}">
			<json:object>
					<json:property name="id" value="${rec.procedimiento.id}"/>
					<json:property name="personas" value="${per.id}" />
			</json:object>
		</c:if>
	</c:forEach>
	</json:array>
</fwk:json>
