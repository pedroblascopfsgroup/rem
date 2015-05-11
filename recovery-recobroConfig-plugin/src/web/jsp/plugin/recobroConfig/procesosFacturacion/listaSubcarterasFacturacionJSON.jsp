<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="subcarteras" items="${subcarteras}" var="subcartera">
		<json:object>
			<json:property name="id" value="${subcartera.id}"/>
			<json:property name="idSubcarteraFacturacion" value="${subcartera.id}"/>
			<json:property name="idProcesoFacturacion" value="${subcartera.procesoFacturacion.id}"/>
			<json:property name="cartera" value="${subcartera.subCartera.carteraEsquema.cartera.nombre}"/>
			<json:property name="subCartera" value="${subcartera.subCartera.nombre}"/>
			<json:property name="idModeloFacturacionInicial" value="${subcartera.modeloFacturacionInicial.id}"/>
			<json:property name="modeloFacturacionInicial" value="${subcartera.modeloFacturacionInicial.nombre}"/>
			<json:property name="modeloFacturacionActual" value="${subcartera.modeloFacturacionActual.nombre}"/>
			<json:property name="modeloFacturacion_nombre" value="${subcartera.modeloFacturacionActual.nombre}"/>
			<json:property name="modeloFacturacion_id" value="${subcartera.modeloFacturacionActual.id}"/>
			<json:property name="totalImporteCobros" value="${subcartera.totalImporteCobros}"/>
			<json:property name="totalImporteFacturable" value="${subcartera.totalImporteFacturable}"/>
		</json:object>
	</json:array>
</fwk:json>		