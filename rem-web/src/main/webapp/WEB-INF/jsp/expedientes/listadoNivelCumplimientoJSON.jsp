<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	  <json:array name="nivelCumplimiento" items="${reglasElevacion}" var="regla">
			<json:object>
				<json:property name="idNivelCumplimiento" value="${regla.id}"/>
				<json:property name="bCumple" value="${regla.cumple}" />
				<json:property name="descripcionRegla" value="${regla.tipoReglaElevacion.descripcion}" />
				<json:property name="descripcionAmbito" value="${regla.ambitoExpediente.descripcion}" />
				<c:if test="${regla.ambitoExpediente == null}">
					<json:property name="descripcionAmbito" value="Expediente" />
				</c:if>
			</json:object>
		</json:array>
		
</fwk:json>
