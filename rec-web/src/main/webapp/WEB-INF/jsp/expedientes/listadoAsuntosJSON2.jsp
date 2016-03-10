<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="asuntos" items="${asuntos}" var="asu">
		<json:object>
			<json:property name="id" value="${asu.id}" />
			<json:property name="nombre" value="${asu.nombre}" />
			<json:property name="fcreacion">
				<fwk:date value="${asu.auditoria.fechaCrear}" />
			</json:property>
			<json:property name="gestor" value="${asu.gestor.usuario.username}" />
			<json:property name="estado" value="${asu.codigoDecodificado}" />
			<json:property name="supervisor" value="${asu.supervisor.usuario.username}" />
			<json:property name="despacho" value="${asu.gestor.despachoExterno.despacho}" />
			<json:property name="asuEstado" value="${asu.estadoAsunto.codigo}" />
			<c:if test="${asu.tipoAsunto != null}">
				<json:property name="tipoAsuntoDescripcion" value="${asu.tipoAsunto.descripcion}" />
			</c:if>
		</json:object>
		<c:forEach items="${asu.procedimientos}" var="prc">
			<json:object>
				<json:property name="idProcedimiento" value="${prc.id}" />
				<json:property name="tipoActuacion" value="${prc.tipoActuacion.descripcion}" />
				<json:property name="actuacion" value="${prc.tipoProcedimiento.descripcion}" />
				<json:property name="prcEstado" value="${prc.estadoProcedimiento.codigo}" />			
				<json:property name="principal" value="${prc.saldoRecuperacion}" />			
			</json:object>
		</c:forEach>
	</json:array>
</fwk:json>
