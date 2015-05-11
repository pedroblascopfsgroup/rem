<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${procesosFacturacion.totalCount}" />
	<json:array name="procesosFacturacion" items="${procesosFacturacion.results}" var="proceso">
		<json:object>
			<json:property name="id" value="${proceso.id}"/>
			<json:property name="nombre" value="${proceso.nombre}"/>
			<json:property name="fechaDesde">
				<fwk:date value="${proceso.fechaDesde}"/>
			</json:property>
			<json:property name="fechaHasta">
				<fwk:date value="${proceso.fechaHasta}"/>
			</json:property>
			<c:if test="${proceso.usuarioCreacion != null}">
				<json:property name="usuarioCreacion" value="${proceso.usuarioCreacion.username}"/>
			</c:if>
			<c:if test="${proceso.usuarioLiberacion != null}">
				<json:property name="usuarioLiberacion" value="${proceso.usuarioLiberacion.username}"/>
			</c:if>
			<c:if test="${proceso.usuarioCancelacion != null}">
				<json:property name="usuarioCancelacion" value="${proceso.usuarioCancelacion.username}"/>
			</c:if>
			<json:property name="fechaCreacion">
				<fwk:date value="${proceso.fechaCreacion}"/>
			</json:property>
			<json:property name="fechaLiberacion">
				<fwk:date value="${proceso.fechaLiberacion}"/>
			</json:property>
			<json:property name="fechaCancelacion">
				<fwk:date value="${proceso.fechaCancelacion}"/>
			</json:property>
			<c:if test="${proceso.estadoProcesoFacturable != null}">
				<json:property name="estadoProcesoFacturableCod" value="${proceso.estadoProcesoFacturable.codigo}"/>
				<json:property name="estadoProcesoFacturable" value="${proceso.estadoProcesoFacturable.descripcion}"/>
			</c:if>
			<json:property name="totalImporteFacturable" value="${proceso.totalImporteFacturable}"/>
			<json:property name="totalImporteCobros" value="${proceso.totalImporteCobros}"/>
			<json:property name="errorBatch" value="${proceso.errorBatch}"/>
		</json:object>
	</json:array>
</fwk:json>		