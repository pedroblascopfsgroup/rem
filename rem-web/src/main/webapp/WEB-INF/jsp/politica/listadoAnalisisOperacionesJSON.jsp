<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
		<json:array name="listadoAnalisisOperaciones" items="${listadoAnalisisOperaciones}" var="app">
			<json:object>
				<json:property name="id" value="${app.id}"/>
				<json:property name="idContrato" value="${app.contrato.id}"/>
				<json:property name="contrato" value="${app.contrato.nroContrato}"/>
				<json:property name="tipoContrato" value="${app.contrato.tipoProducto.descripcion}"/>
				<c:if test="${app.valoracion!=null}">
					<json:property name="valoracion" value="${app.valoracion.descripcion}"/>
					<json:property name="codigoValoracion" value="${app.valoracion.codigo}"/>
				</c:if>
				<c:if test="${app.valoracion==null}">
					<json:property name="valoracion" value=""/>
					<json:property name="codigoValoracion" value=""/>
				</c:if>
				<c:if test="${app.impacto!=null}">
					<json:property name="impacto" value="${app.impacto.descripcion}"/>
					<json:property name="codigoImpacto" value="${app.impacto.codigo}"/>
				</c:if>
				<c:if test="${app.valoracion==null}">
					<json:property name="impacto" value=""/>
					<json:property name="codigoImpacto" value=""/>
				</c:if>
				<c:if test="${app.comentario!=null}">
					<json:property name="comentario" value="${app.comentario}"/>
				</c:if>
				<c:if test="${app.comentario==null}">
					<json:property name="comentario" value=""/>
				</c:if>
			</json:object>
		</json:array>
</fwk:json>
