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
					<json:property name="idGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.id}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.id}</span>
						</c:if>
					</json:property>
					<json:property name="codigo" value="${rec.id}" />
					<json:property name="nombre" value="${rec.nombreProcedimiento}" />
					<json:property name="nombreGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.nombreProcedimiento}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.nombreProcedimiento}</span>
						</c:if>
					</json:property>
					<json:property name="tipoProcedimiento" value="${rec.tipoProcedimiento.descripcion}" />
					<json:property name="tipoProcedimientoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.tipoProcedimiento.descripcion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.tipoProcedimiento.descripcion}</span>
						</c:if>
					</json:property>
			 	 	<json:property name="saldoARecuperar" value="${rec.saldoRecuperacion}" />
			 	 	<json:property name="saldoARecuperarGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							<pfsformat:money value="${rec.saldoRecuperacion}"/>
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<pfsformat:money value="${rec.saldoRecuperacion}"/>
							</span>
						</c:if>
					</json:property>
			 	 	<json:property name="tipoReclamacion" value="${rec.tipoReclamacion.descripcion}" />
			 	 	<json:property name="tipoReclamacionGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.tipoReclamacion.descripcion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.tipoReclamacion.descripcion}</span>
						</c:if>
					</json:property>
					<json:property name="pVencido" value="${rec.saldoOriginalVencido}" />
			 	 	<json:property name="pVencidoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							<pfsformat:money value="${rec.saldoOriginalVencido}"/>
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<pfsformat:money value="${rec.saldoOriginalVencido}"/>
							</span>
						</c:if>
					</json:property>
					<json:property name="pNoVencido" value="${rec.saldoOriginalNoVencido}" />
			 	 	<json:property name="pNoVencidoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.saldoOriginalNoVencido}"
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<pfsformat:money value="${rec.saldoOriginalNoVencido}"/>
							</span>
						</c:if>
					</json:property>
					<json:property name="porcRecup" value="${rec.porcentajeRecuperacion}" />
			 	 	<json:property name="porcRecupGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.porcentajeRecuperacion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.porcentajeRecuperacion}</span>
						</c:if>
					</json:property>
					<json:property name="meses" value="${rec.plazoRecuperacion}" />
					<json:property name="mesesGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.plazoRecuperacion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.plazoRecuperacion}</span>
						</c:if>
					</json:property>
					<json:property name="estado" value="${rec.estadoProcedimiento.descripcion}" />
					<json:property name="estadoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.estadoProcedimiento.descripcion}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.estadoProcedimiento.descripcion}</span>
						</c:if>
					</json:property>
			 	 	<json:property name="codProcEnJuzgado" value="${rec.codigoProcedimientoEnJuzgado}" />
			 	 	<json:property name="codProcEnJuzgadoGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.codigoProcedimientoEnJuzgado}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.codigoProcedimientoEnJuzgado}</span>
						</c:if>
					</json:property>
					<json:property name="fechaInicio" > 
						<fwk:date value="${rec.auditoria.fechaCrear}" />
					</json:property>	
					<json:property name="fechaInicioGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							<fwk:date value="${rec.auditoria.fechaCrear}" />
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">
								<fwk:date value="${rec.auditoria.fechaCrear}" /></span>
						</c:if>
					</json:property>										
			 	 	<json:property name="procedimientoPadre" value="${rec.procedimientoPadre.id}" />
			 	 	<json:property name="procedimientoPadreGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.procedimientoPadre.id}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.procedimientoPadre.id}</span>
						</c:if>
					</json:property>
			 	 	<json:property name="demandados" value="${rec.personasAfectadas[0].apellidoNombre}" />
			 	 	<json:property name="demandadosGrid" escapeXml="false">
						<c:if test="${!rec.activo}">
							${rec.personasAfectadas[0].apellidoNombre}
						</c:if>
						<c:if test="${rec.activo}">
							<span style="color: #4169E1; font-weight: bold;">${rec.personasAfectadas[0].apellidoNombre}</span>
						</c:if>
					</json:property>
					<json:property name="descripcionProcedimiento">
	 	 				<s:message text="${procedimiento.asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
	 	 			</json:property>							
			 	 	
				</json:object>
				<c:forEach items="${rec.personasAfectadas}" var="pa">
					<c:if test="${pa.id!=rec.personasAfectadas[0].id}">
						<json:object>
							<json:property name="demandadosGrid" escapeXml="false">
								<c:if test="${!rec.activo}">${pa.apellidoNombre}</c:if>
								<c:if test="${rec.activo}">
									<span style="color: #4169E1; font-weight: bold;">${pa.apellidoNombre}</span>
								</c:if>
							</json:property>
							<json:property name="descripcionProcedimientoGrid">
			 	 				<s:message text="${procedimiento.asunto.nombre}" javaScriptEscape="true" />-<s:message text="${rec.tipoProcedimiento.descripcion}" javaScriptEscape="true" />
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
