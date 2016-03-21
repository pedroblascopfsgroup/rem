<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<fwk:json>
	<json:array name="adjuntos" items="${dtos}" var="dto">
		<json:object>
			
			<c:if test="${dto.refCentera != null}">
				<json:property name="id" value="${dto.refCentera}" />
			</c:if>
			<c:if test="${dto.refCentera == null}">
				<json:property name="id" value="${dto.adjunto.id}" />
			</c:if>
			<json:property name="nombre" value="${dto.adjunto.nombre}" />
			<json:property name="contentType" value="${dto.adjunto.contentType}" />
			<json:property name="length" value="${dto.adjunto.length}" />
			<json:property name="descripcion" value="${dto.adjunto.descripcion}"/>
			<json:property name="fechaCrear">
				<fmt:formatDate value="${dto.adjunto.auditoria.fechaCrear}" pattern="dd/MM/yyyy" />
			</json:property>
			<json:property name="puedeBorrar" value="${dto.puedeBorrar}" />
			
			<c:if test="${dto.nombreTipoDoc != null}">
				<json:property name="tipoFichero" value="${dto.nombreTipoDoc}" />
			</c:if>
			<c:if test="${dto.nombreTipoDoc == null}">
				<c:if test="${dto.adjunto.tipoFichero != null}">
					<json:property name="tipoFichero" value="${dto.adjunto.tipoFichero.descripcion}" />
				</c:if>			
				<c:if test="${dto.adjunto.tipoFichero == null}">
					<json:property name="tipoFichero" value="" />
				</c:if>
			</c:if>
		</json:object>
	</json:array>
</fwk:json>
