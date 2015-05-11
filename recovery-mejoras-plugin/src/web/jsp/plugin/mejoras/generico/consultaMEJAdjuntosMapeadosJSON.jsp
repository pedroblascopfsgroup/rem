<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>

<fwk:json>
	<json:array name="adjuntos" items="${dtos}" var="dto">
		<json:object>
			<json:property name="id" value="${dto.adjunto.id}" />
			<json:property name="nombre" value="${dto.adjunto.nombre}" />
			<json:property name="contentType" value="${dto.adjunto.contentType}" />
			<json:property name="length" value="${dto.adjunto.length}" />
			<json:property name="descripcion" value="${dto.adjunto.descripcion}"/>
			<json:property name="fechaCrear">
				<fwk:date value="${dto.adjunto.auditoria.fechaCrear}"/>
			</json:property>
			<json:property name="puedeBorrar" value="${dto.puedeBorrar}" />
			
			<c:if test="${dto.adjunto.tipoFichero != null}">
				<json:property name="tipoFichero" value="${dto.adjunto.tipoFichero.descripcion}" />
			</c:if>
			<json:property name="prcId" value="${dto.adjunto.procedimiento.id}" />
			
				
		</json:object>
	</json:array>
</fwk:json>
