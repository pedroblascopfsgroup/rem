<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>

	<json:array name="eventos" items="${eventos}" var="evento">
        <json:object>
			<json:property name="descripcion" value="${evento.descripcion}"/>
			<json:property name="fechaInicio" ><fwk:date value="${evento.tarea.fechaInicio}"/></json:property>
			<json:property name="fechaFin" ><fwk:date value="${evento.tarea.fechaFin}"/></json:property>
			<json:property name="fechaVenc" ><fwk:date value="${evento.tarea.fechaVenc}"/></json:property>
			<json:property name="alertada" value="${evento.tarea.alerta}"/>
			<json:property name="finalizada" value="${evento.tarea.auditoria.borrado}"/>
			<json:property name="emisor" value="${evento.tarea.emisor}"/>
			<json:property name="codigoSubtipoTarea" value="${evento.tarea.subtipoTarea.codigoSubtarea}" />
			<json:property name="codigotipoTarea" value="${evento.tarea.subtipoTarea.tipoTarea.codigoTarea}" />
			<json:property name="idEntidad" value="${evento.tarea.idEntidad}" />
			<json:property name="codigoEntidadInformacion" value="${evento.tarea.tipoEntidad.codigo}" />
			<json:property name="descripcionTarea" value="${evento.tarea.descripcionTarea}"/>
			<json:property name="descripcionEntidad" value="${evento.tarea.descripcionEntidad}"/>
			<json:property name="tipoSolicitud" value="${evento.tarea.tipoSolicitud}" />
			<c:if test="${evento.tipoEvento == 1}">
				<json:property name="descripcionEntidad" value="Anotacion"/>
				<json:property name="tipoSolicitud" value="${evento.tipoAnotacion}" />
			</c:if>
			<json:property name="fcreacionEntidad" value="${evento.tarea.fechaCreacionEntidadFormateada}" />
			<json:property name="codigoSituacion" value="${evento.tarea.situacionEntidad}" />
			<json:property name="id" value="${evento.tarea.id}" />
			<json:property name="idEntidadPersona" value="${evento.tarea.idEntidadPersona}"/>
			<c:if test="${evento.tarea.prorroga != null}">
				<json:property name="motivoProrroga" value="${evento.tarea.prorroga.causaProrroga.descripcion}"/>
				<json:property name="fechaPropuestaProrroga"><fwk:date value="${evento.tarea.prorroga.fechaPropuesta}"/> </json:property>
			</c:if>
			<c:if test="${evento.class.simpleName == 'MEJEvento'}">
				<json:property name="idTraza" value="${evento.idTraza}"/>
			</c:if>
			<c:if test="${evento.class.simpleName != 'MEJEvento'}">
				<json:property name="idTraza" value=""/>
			</c:if>  
		</json:object>
	</json:array>

</fwk:json>