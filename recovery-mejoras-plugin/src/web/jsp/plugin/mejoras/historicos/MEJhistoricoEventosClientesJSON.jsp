<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>

	<json:array name="eventos" items="${eventos}" var="evento">
        <json:object>
			<json:property name="descripcion" value="${evento.descripcion}"/>
			<json:property name="fechaInicio" ><fwk:date value="${evento.fechaInicio}"/></json:property>
			<json:property name="fechaFin" ><fwk:date value="${evento.fechaFin}"/></json:property>
			<json:property name="tipoSolicitud" value="${evento.tipoSolicitud}" />
			<json:property name="fechaVenc" ><fwk:date value="${evento.fechaVenc}"/></json:property>
			<json:property name="alertada" value="${evento.alertada}"/>
			<json:property name="finalizada" value="${evento.finalizada}"/>
			<json:property name="emisor" value="${evento.emisor}"/>
			<json:property name="codigoSubtipoTarea" value="${evento.codigoSubtipoTarea}" />
			<json:property name="codigotipoTarea" value="${evento.codigoTipoTarea}" />
			<json:property name="idEntidad" value="${evento.idEntidad}" />
			<json:property name="codigoEntidadInformacion" value="${evento.codigoEntidadInformacion}" />
			<json:property name="descripcionTarea" value="${evento.descripcionTarea}"/>
			<json:property name="descripcionEntidad" value="${evento.descripcionEntidad}"/>
			<json:property name="fcreacionEntidad" value="${evento.fcreacionEntidad}" />
			<json:property name="codigoSituacion" value="${evento.codigoSituacion}" />
			<json:property name="id" value="${evento.id}" />
			<json:property name="idEntidadPersona" value="${evento.idEntidadPersona}"/>
			<json:property name="motivoProrroga" value="${evento.motivoProrroga}"/>
			<json:property name="fechaPropuestaProrroga"><fwk:date value="${evento.fechaPropuestaProrroga}"/></json:property>
			<json:property name="idTraza" value="${evento.idTraza}"/>
			<json:property name="isRegistro" value="${evento.isRegistro}"/>
		</json:object>
	</json:array>

</fwk:json>