<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
	
				<json:object>
					<json:property name="id" value="${rec.id}" />
					<json:property name="activo" value="${rec.activo}" />
					<json:property name="codigo" value="${rec.id}" />
					<json:property name="nombre" value="${rec.nombreProcedimiento}" />
					<json:property name="tipoProcedimiento" value="${rec.tipoProcedimiento.descripcion}" />
					<json:property name="saldoARecuperar" value="${rec.saldoRecuperacion}" />
			 	 	<json:property name="tipoReclamacion" value="${rec.tipoReclamacion.descripcion}" />
			 	 	<json:property name="pVencido" value="${rec.saldoOriginalVencido}" />
			 	 	<json:property name="pNoVencido" value="${rec.saldoOriginalNoVencido}" />
			 	 	<json:property name="porcRecup" value="${rec.porcentajeRecuperacion}" />
			 	 	<json:property name="meses" value="${rec.plazoRecuperacion}" />
					<json:property name="estado" value="${rec.estadoProcedimiento.descripcion}" />
					<json:property name="codProcEnJuzgado" value="${rec.codigoProcedimientoEnJuzgado}" />
			 	 	<json:property name="fechaInicio" > 
						<fwk:date value="${rec.auditoria.fechaCrear}" />
					</json:property>	
					<json:property name="procedimientoPadre" value="${rec.procedimientoPadre.id}" />
			 	 	<json:property name="demandados" value="${rec.personasAfectadas[0].apellidoNombre}" />
			 	 	<json:property name="descripcionProcedimiento">
	 	 				<s:message text="${procedimiento.asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
	 	 			</json:property>							
			 	 	
				</json:object>
				<c:forEach items="${rec.personasAfectadas}" var="pa">
					<c:if test="${pa.id!=rec.personasAfectadas[0].id}">
						<json:object>
							<json:property name="demandados" value="${pa.apellidoNombre}"/>
								
							<json:property name="descripcionProcedimiento">
			 	 				<s:message text="${procedimiento.asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
			 	 			</json:property>							
							<json:property name="saldoARecuperar" value="" />
							<json:property name="pVencido" value="" />
							<json:property name="pNoVencido" value="" />
							<json:property name="capital" escapeXml="false">							
									<pfsformat:money value="0.00"/>
						</json:property>
					 </json:object>
					</c:if>
				</c:forEach>
		
	</json:array>
</fwk:json>
