<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>

	<json:array name="data" items="${data}" var="metrica">    
		<json:object>
			<json:property name="codSegmento" value="${metrica.segmento.codigo}" />
			<json:property name="segmento" value="${metrica.segmento.descripcion}" />
			<json:property name="configVigente" value="${metrica.metricaDefault.nombreFichero}" />
			<json:property name="fechaConfigVigente">
				<fwk:date value="${metrica.metricaDefault.fechaActivacion}" />
			</json:property>
			<json:property name="configNueva" value="${metrica.metricaNueva.nombreFichero}" />
		</json:object>
	</json:array>

</fwk:json>
