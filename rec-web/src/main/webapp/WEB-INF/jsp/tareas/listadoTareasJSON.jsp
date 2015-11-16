<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:property name="total" value="${tareas.totalCount}" />
	<json:array name="tareas" items="${tareas.results}" var="tar">
		<json:object>
			<json:property name="descripcionTarea" value="${tar.descripcionTarea}"/>
			<json:property name="descripcion" value="${tar.descripcionEntidad}" />
			<json:property name="subtipo" value="${tar.subtipoTarea.descripcion}" />
			<json:property name="codigoSubtipoTarea" value="${tar.subtipoTarea.codigoSubtarea}" />
			
			<%-- Si es gestion de vencidos, entra en el grupo "esta semana" --%>
			<c:if test='${tar.subtipoTarea.codigoSubtarea == 1 || tar.subtipoTarea.codigoSubtarea == 98 || tar.subtipoTarea.codigoSubtarea == 99}'>
				<json:property name="group" value="2" />
				<json:property name="descripcionTarea" value="${tar.tarea}"/>
				<json:property name="descripcion" value="${tar.descripcionTarea}" />
			</c:if>
			<c:if test='${tar.subtipoTarea.codigoSubtarea != 1 && tar.subtipoTarea.codigoSubtarea != 98 && tar.subtipoTarea.codigoSubtarea != 99}'>
				<json:property name="fechaInicio" >
					<fwk:date value="${tar.fechaInicio}"/>
				</json:property>
				<json:property name="group">
						<app:groupTareas value="${tar}" />
				</json:property>
				<json:property name="id" value="${tar.id}" />
				<json:property name="plazo" value="${tar.plazo}" />
				<json:property name="entidadInformacion" value="${tar.entidadInformacion}"/>
				<json:property name="codigoEntidadInformacion" value="${tar.tipoEntidad.codigo}" />
				<json:property name="codentidad" value="${tar.codigo}" />
				<json:property name="gestor" value="${tar.descGestor}" />
				<json:property name="tipoTarea" value="${tar.subtipoTarea.tipoTarea.codigoTarea}" />
				<json:property name="tipoSolicitud" value="${tar.tipoSolicitud}" />
				<json:property name="idEntidad" value="${tar.idEntidad}" />
				<json:property name="fcreacionEntidad" value="${tar.fechaCreacionEntidadFormateada}" />
				<json:property name="codigoSituacion" value="${tar.situacionEntidad}" />
				<json:property name="fechaVenc"><fwk:date value="${tar.fechaVenc}"/></json:property>
				<json:property name="idTareaAsociada" value="${tar.tareaId.id}"/>
				<json:property name="descripcionTareaAsociada" value="${tar.tareaId.descripcionTarea}"/>
				<json:property name="emisor" value="${tar.emisor}"/>
				<json:property name="supervisor" value="${tar.descSupervisor}"/>
				<json:property name="diasVencido" value="${tar.diasVencido}"/>
				<json:property name="descripcionExpediente">
					<s:message text="${tar.expediente.descripcionExpediente}" javaScriptEscape="true" />
				</json:property>
				<json:property name="gestorId" value="${tar.gestor}"/>
				<json:property name="supervisorId" value="${tar.supervisor}"/>						
				<json:property name="idEntidadPersona" value="${tar.idEntidadPersona}"/>
				<json:property name="volumenRiesgo" value="${tar.volumenRiesgo}"/>
				<json:property name="volumenRiesgoVencido" value="${tar.volumenRiesgoVencido}"/>
				<json:property name="itinerario" value="${tar.tipoItinerarioEntidad}"/>
			</c:if>
			
		</json:object>
	</json:array>
</fwk:json>