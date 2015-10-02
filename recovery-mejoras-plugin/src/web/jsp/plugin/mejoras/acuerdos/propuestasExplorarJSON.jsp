<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="actuaciones" items="${actuacionesAExplorar}" var="actuacionAExplorar">	
		<json:object>
			<json:property name="id" value="${actuacionAExplorar.id}" />
			<json:property name="codTipoSolucionAmistosa" value="${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.ddTipoSolucionAmistosa.codigo}" />
			<json:property name="tipoSolucionAmistosa" escapeXml="false">
				<c:if test="${actuacionAExplorar.activo}">
					${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.ddTipoSolucionAmistosa.descripcion}
				</c:if>
				<c:if test="${!actuacionAExplorar.activo}">
					<span style="color: gray;">${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.ddTipoSolucionAmistosa.descripcion}</span>
				</c:if>
			</json:property>
	 		<json:property name="codSubtipoSolucion" value="${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.codigo}" />
	 		<json:property name="subtipoSolucion" escapeXml="false">
				<c:if test="${actuacionAExplorar.activo}">
					${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.descripcion}
				</c:if>
				<c:if test="${!actuacionAExplorar.activo}">
					<span style="color: gray;">${actuacionAExplorar.ddSubtipoSolucionAmistosaAcuerdo.descripcion}</span>
				</c:if>
			</json:property>
	 	 	<json:property name="valoracion" escapeXml="false">
				<c:if test="${actuacionAExplorar.activo}">
					${actuacionAExplorar.ddValoracionActuacionAmistosa.descripcion}
				</c:if>
				<c:if test="${!actuacionAExplorar.activo}">
					<span style="color: gray;">${actuacionAExplorar.ddValoracionActuacionAmistosa.descripcion}</span>
				</c:if>
			</json:property>
	 	 	<json:property name="observaciones" escapeXml="false">
				<c:if test="${actuacionAExplorar.activo}">
					${actuacionAExplorar.observaciones}
				</c:if>
				<c:if test="${!actuacionAExplorar.activo}">
					<span style="color: gray;">${actuacionAExplorar.observaciones}</span>
				</c:if>
			</json:property>
			<json:property name="isActivo" >
				<c:if test="${actuacionAExplorar.activo}">
					true
				</c:if>
				<c:if test="${!actuacionAExplorar.activo}">
					false
				</c:if>
			</json:property>
	 	</json:object>
	</json:array>
</fwk:json>