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
					<json:property name="id" value="${rec.procedimiento.id}" />
					<json:property name="idGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.id}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.id}</span>
						</c:if>
					</json:property>
					<json:property name="codigo" value="${rec.procedimiento.id}" />
					<json:property name="nombre" value="${rec.procedimiento.nombreProcedimiento}" />
					<json:property name="nombreGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.nombreProcedimiento}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.nombreProcedimiento}</span>
						</c:if>
					</json:property>
					<json:property name="tipoProcedimiento" value="${rec.procedimiento.tipoProcedimiento.descripcion}" />
					<json:property name="tipoProcedimientoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.tipoProcedimiento.descripcion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.tipoProcedimiento.descripcion}</span>
						</c:if>
					</json:property>
			 	 	<json:property name="saldoARecuperar" value="${rec.procedimiento.saldoRecuperacion}" />
			 	 	<json:property name="saldoARecuperarGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							<pfsformat:money value="${rec.procedimiento.saldoRecuperacion}"/>
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<pfsformat:money value="${rec.procedimiento.saldoRecuperacion}"/>
							</span>
						</c:if>
					</json:property>
			 	 	<json:property name="tipoReclamacion" value="${rec.procedimiento.tipoReclamacion.descripcion}" />
			 	 	<json:property name="tipoReclamacionGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.tipoReclamacion.descripcion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.tipoReclamacion.descripcion}</span>
						</c:if>
					</json:property>
					<json:property name="pVencido" value="${rec.procedimiento.saldoOriginalVencido}" />
			 	 	<json:property name="pVencidoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							<pfsformat:money value="${rec.procedimiento.saldoOriginalVencido}"/>
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<pfsformat:money value="${rec.procedimiento.saldoOriginalVencido}"/>
							</span>
						</c:if>
					</json:property>
					<json:property name="pNoVencido" value="${rec.procedimiento.saldoOriginalNoVencido}" />
			 	 	<json:property name="pNoVencidoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.saldoOriginalNoVencido}"
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<pfsformat:money value="${rec.procedimiento.saldoOriginalNoVencido}"/>
							</span>
						</c:if>
					</json:property>
					<json:property name="porcRecup" value="${rec.procedimiento.porcentajeRecuperacion}" />
			 	 	<json:property name="porcRecupGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.porcentajeRecuperacion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.porcentajeRecuperacion}</span>
						</c:if>
					</json:property>
					<json:property name="meses" value="${rec.procedimiento.plazoRecuperacion}" />
					<json:property name="mesesGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.plazoRecuperacion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.plazoRecuperacion}</span>
						</c:if>
					</json:property>
					<json:property name="estado" value="${rec.procedimiento.estadoProcedimiento.descripcion}" />
					<json:property name="estadoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.estadoProcedimiento.descripcion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.estadoProcedimiento.descripcion}</span>
						</c:if>
					</json:property>
			 	 	<json:property name="codProcEnJuzgado" value="${rec.procedimiento.codigoProcedimientoEnJuzgado}" />
			 	 	<json:property name="codProcEnJuzgadoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.codigoProcedimientoEnJuzgado}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.codigoProcedimientoEnJuzgado}</span>
						</c:if>
					</json:property>
					<json:property name="fechaInicio" > 
						<fwk:date value="${rec.procedimiento.auditoria.fechaCrear}" />
					</json:property>	
					<json:property name="fechaInicioGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							<fwk:date value="${rec.procedimiento.auditoria.fechaCrear}" />
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<fwk:date value="${rec.procedimiento.auditoria.fechaCrear}" /></span>
						</c:if>
					</json:property>										
			 	 	<json:property name="procedimientoPadre" value="${rec.procedimiento.procedimientoPadre.id}" />
			 	 	<json:property name="procedimientoPadreGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.procedimientoPadre.id}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.procedimientoPadre.id}</span>
						</c:if>
					</json:property>
			 	 	<json:property name="demandados" value="${rec.procedimiento.personasAfectadas[0].apellidoNombre}" />
			 	 	<json:property name="demandadosGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimiento.personasAfectadas[0].apellidoNombre}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimiento.personasAfectadas[0].apellidoNombre}</span>
						</c:if>
					</json:property>
					<json:property name="descripcionProcedimiento">
	 	 				<s:message text="${procedimiento.asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.procedimiento.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
	 	 			</json:property>							
			 	 	
				</json:object>
				<c:forEach items="${rec.procedimiento.personasAfectadas}" var="pa">
					<c:if test="${pa.id!=rec.procedimiento.personasAfectadas[0].id}">
						<json:object>
							<json:property name="demandadosGrid" escapeXml="false">
								<c:if test="${!rec.activo}">${pa.apellidoNombre}</c:if>
								<c:if test="${rec.activo}">
									<span style="color: #4169E1; font-weight: bold;">${pa.apellidoNombre}</span>
								</c:if>
							</json:property>
							<json:property name="descripcionProcedimientoGrid">
			 	 				<s:message text="${procedimiento.asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.procedimiento.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
			 	 			</json:property>							
							<json:property name="saldoARecuperarGrid" value="" />
							<json:property name="pVencidoGrid" value="" />
							<json:property name="pNoVencidoGrid" value="" />
							<json:property name="capitalGrid" escapeXml="false">
								<c:if test="${!rec.activo}">
									<pfsformat:money value="0.00"/>
								</c:if>
								<c:if test="${rec.activo}">
									<span style="color: #4169E1; font-weight: bold;">
										<pfsformat:money value="0.00"/></span>
								</c:if>
					</json:property>
						 </json:object>
					</c:if>
				</c:forEach>
		
	</json:array>
</fwk:json>
