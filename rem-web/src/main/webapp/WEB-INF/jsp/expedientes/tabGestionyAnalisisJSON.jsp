<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<fwk:json>
		<json:object name="data">
			<json:property name="gestiones" value="${expediente.aaa.gestiones}" escapeXml="false"/>
			<json:property name="tipoPropuestaActuacion" value="${expediente.aaa.tipoPropuestaActuacion.descripcion}"/>
			<json:property name="descripcion" value="${expediente.aaa.causaImpago.descripcion}"/>
			<json:property name="comentariosSituacion" value="${expediente.aaa.comentariosSituacion}" escapeXml="false"/>
			<json:property name="causasImpago" value="${expediente.aaa.causaImpago.descripcion}"/>
			<json:property name="propuestaActuacion" value="${expediente.aaa.propuestaActuacion}" escapeXml="false"/>
			<json:property name="tipoAyudaDescripcion" value="${expediente.aaa.tipoAyudaActuacion.descripcion}"/>
			<json:property name="descripcionTipoAyudaActuacion" value="${expediente.aaa.descripcionTipoAyudaActuacion}" escapeXml="false"/>
			<json:property name="revision" value="${expediente.aaa.revision}"/>
		</json:object>
</fwk:json>
