<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
	
				<json:object>
					<json:property name="id" value="${rec.procedimiento.id}" />
					<json:property name="codigo" value="${rec.procedimiento.id}" />
					<json:property name="nivel" value="${rec.nivel}" />
					<json:property name="nombre" value="${rec.procedimiento.nombreProcedimiento}" />
					<json:property name="tipoProcedimiento" value="${rec.procedimiento.tipoProcedimiento.descripcion}" />
			 	 	<json:property name="saldoARecuperar" value="${rec.procedimiento.saldoRecuperacion}" />
			 	 	<json:property name="tipoReclamacion" value="${rec.procedimiento.tipoReclamacion.descripcion}" />
			 	 	<json:property name="pVencido" value="${rec.procedimiento.saldoOriginalVencido}" />
			 	 	<json:property name="pNoVencido" value="${rec.procedimiento.saldoOriginalNoVencido}" />
			 	 	<json:property name="porcRecup" value="${rec.procedimiento.porcentajeRecuperacion}" />
			 	 	<json:property name="meses" value="${rec.procedimiento.plazoRecuperacion}" />
			 	 	<json:property name="estado" value="${rec.procedimiento.estadoProcedimiento.descripcion}" />
			 	 	<json:property name="codProcEnJuzgado" value="${rec.procedimiento.codigoProcedimientoEnJuzgado}" />
					<json:property name="fechaInicio" > 
						<fwk:date value="${rec.procedimiento.auditoria.fechaCrear}" />
					</json:property>						
			 	 	<json:property name="procedimientoPadre" value="${rec.procedimiento.procedimientoPadre.id}" />
			 	 	<json:property name="demandados" value="${rec.procedimiento.personasAfectadas[0].apellidoNombre}" />
			 	 	<json:property name="descripcionProcedimiento">
			 	 		<s:message text="${asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.procedimiento.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
			 	 	</json:property>
				</json:object>
				<c:forEach items="${rec.procedimiento.personasAfectadas}" var="pa">
					<c:if test="${pa.id!=rec.procedimiento.personasAfectadas[0].id}">
						<json:object>
							<json:property name="demandados" value="${pa.apellidoNombre}" />
							<json:property name="descripcionProcedimiento">
			 	 				<s:message text="${asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.procedimiento.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
			 	 			</json:property>							
							<json:property name="saldoARecuperar" value="---" />
							<json:property name="pVencido" value="---" />
							<json:property name="pNoVencido" value="---" />
						</json:object>
					</c:if>
				</c:forEach>
		
	</json:array>
</fwk:json>
