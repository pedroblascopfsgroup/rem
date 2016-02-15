<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fwk:json>
	<json:array name="adjuntos" items="${entities}" var="entity">
			<json:object>
				<json:property name="descripcionEntidad" value="${entity.descripcion}" />
				<json:property name="idEntidad" value="${entity.id}" />
					<c:if test="${entity.adjuntosAsList != null}">
						<c:if test="${entity.adjuntosAsList[0].refCentera != null}">
							<json:property name="id" value="${entity.adjuntosAsList[0].refCentera}" />
						</c:if>
						<c:if test="${entity.adjuntosAsList[0].refCentera == null}">
							<json:property name="id" value="${entity.adjuntosAsList[0].id}" />
						</c:if>
						<json:property name="nombre" value="${entity.adjuntosAsList[0].nombre}" />
						<json:property name="contentType" value="${entity.adjuntosAsList[0].contentType}" />
						<json:property name="length" value="${entity.adjuntosAsList[0].length}" />
						<json:property name="descripcion" >
							<pfsformat:cut value="${entity.adjuntosAsList[0].descripcion}" max="27"/>
						</json:property>
						<json:property name="fechaCrear">
							<fmt:formatDate value="${entity.adjuntosAsList[0].auditoria.fechaCrear}" pattern="dd/MM/yyyy" />
						</json:property>
						
						<c:if test="${entity.adjuntosAsList[0].nombreTipoDoc != null}">
							<json:property name="tipoFichero" value="${entity.adjuntosAsList[0].nombreTipoDoc}" />
						</c:if>
						<c:if test="${entity.adjuntosAsList[0].nombreTipoDoc == null}">
							<c:if test="${entity.adjuntosAsList[0].tipoAdjuntoEntidad != null}">
								<json:property name="tipoFichero" value="${entity.adjuntosAsList[0].tipoAdjuntoEntidad.descripcion}" />
							</c:if>
						</c:if>
					</c:if>
			</json:object>
			<c:if test="${entity.adjuntos!=null}">
	            <c:forEach items="${entity.adjuntos}" var="adj">
					<c:if test="${adj.id!=entity.adjuntosAsList[0].id}">
			        	<json:object>
			        		<c:if test="${adj.refCentera != null}">		
			        			<json:property name="id" value="${adj.refCentera}" />
			        		</c:if>
			        		<c:if test="${adj.refCentera == null}">
			        			<json:property name="id" value="${adj.id}" />
			        		</c:if>
							<json:property name="nombre" value="${adj.nombre}" />
							<json:property name="contentType" value="${adj.contentType}" />
							<json:property name="length" value="${adj.length}" />
							<json:property name="descripcion" >
								<pfsformat:cut value="${adj.descripcion}" max="27"/>
							</json:property>
							<json:property name="fechaCrear">
								<fmt:formatDate value="${adj.auditoria.fechaCrear}" pattern="dd/MM/yyyy" />
							</json:property>
							<c:if test="${adj.nombreTipoDoc != null}">
								<json:property name="tipoFichero" value="${adj.nombreTipoDoc}" />
							</c:if>
							<c:if test="${adj.nombreTipoDoc == null}">
								<c:if test="${adj.tipoAdjuntoEntidad != null}">
									<json:property name="tipoFichero" value="${adj.tipoAdjuntoEntidad.descripcion}" />
								</c:if>
							</c:if>
			            </json:object>
					</c:if>
	            </c:forEach>
            </c:if>
	</json:array>
</fwk:json>
