<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
		<json:array name="listadoAnalisis" items="${listadoAnalisis}" var="app">
			<json:object>
				<json:property name="id" value="${app.id}"/>
				<c:if test="${(tipoIteracion==null) || (tipoIteracion != app.parcela.tipoAnalisis.id)}">
					<json:property name="tipo" value="${app.parcela.tipoAnalisis.descripcion}"/>
				</c:if>
				<c:if test="${(tipoIteracion!=null) && (tipoIteracion == app.parcela.tipoAnalisis.id)}">
					<json:property name="tipo" value=""/>
				</c:if>
				<json:property name="parcela" value="${app.parcela.descripcion}"/>
				<json:property name="idParcela" value="${app.parcela.id}"/>
				<c:if test="${app.valoracion!=null}">
						<json:property name="valoracion" value="${app.valoracion.descripcion}"/>
						<json:property name="codValoracion" value="${app.valoracion.codigo}"/>
				</c:if>
				<c:if test="${app.valoracion==null}">
						<json:property name="valoracion" value=""/>
						<json:property name="codValoracion" value=""/>
				</c:if>
				<c:if test="${app.impacto!=null}">
						<json:property name="impacto" value="${app.impacto.descripcion}"/>
						<json:property name="codImpacto" value="${app.impacto.codigo}"/>
				</c:if>
				<c:if test="${app.valoracion==null}">
						<json:property name="impacto" value=""/>
						<json:property name="codImpacto" value=""/>
				</c:if>
				<c:if test="${app.comentario!=null}">
						<json:property name="comentario" value="${app.comentario}"/>
				</c:if>
				<c:if test="${app.comentario==null}">
						<json:property name="comentario" value=""/>
				</c:if>
				<c:set var="tipoIteracion" value="${app.parcela.tipoAnalisis.id}"/>
			</json:object>
		</json:array>
</fwk:json>
