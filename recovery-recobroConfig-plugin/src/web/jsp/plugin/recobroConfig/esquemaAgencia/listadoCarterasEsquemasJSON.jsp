<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="carteras" items="${carterasEsquema}" var="carteraEsquema">
		<json:object>
			<json:property name="idEsquema" value="${carteraEsquema.esquema.id}"/>
			<json:property name="id" value="${carteraEsquema.cartera.id}"/>
			<json:property name="nombre" value="${carteraEsquema.cartera.nombre}"/>
			<json:property name="tipoCartera" value="${carteraEsquema.tipoCarteraEsquema.descripcion}"/>
			<json:property name="codigoTipoCartera" value="${carteraEsquema.tipoCarteraEsquema.codigo}"/>
			<json:property name="prioridad" value="${carteraEsquema.prioridad}"/>
			<json:property name="tipoGestion" value="${carteraEsquema.tipoGestionCarteraEsquema.descripcion}"/>
			<json:property name="tipoGestionCodigo" value="${carteraEsquema.tipoGestionCarteraEsquema.codigo}"/>
			<json:property name="generacionExpediente" value="${carteraEsquema.ambitoExpedienteRecobro.descripcion}"/>
			<json:property name="idCarteraEsquema" value="${carteraEsquema.id}"/>
		</json:object>
	</json:array>
</fwk:json>		