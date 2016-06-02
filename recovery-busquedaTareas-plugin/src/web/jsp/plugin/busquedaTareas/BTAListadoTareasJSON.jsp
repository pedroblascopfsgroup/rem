<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${tareas.totalCount}" />
	<json:array name="tareas" items="${tareas.results}" var="tar">
		<json:object>
			<json:property name="descripcionTarea" value="${tar.tarea.descripcionTarea}"/>
			<json:property name="descripcion" value="${tar.tarea.descripcionEntidad}" />
			<json:property name="subtipo" value="${tar.tarea.subtipoTarea.descripcion}" />
			<json:property name="codigoSubtipoTarea" value="${tar.tarea.subtipoTarea.codigoSubtarea}" />
			<%-- Si es gestion de vencidos, entra en el grupo "esta semana" --%>
			<c:if test='${tar.tarea.subtipoTarea.codigoSubtarea == "1" || tar.tarea.subtipoTarea.codigoSubtarea == "98" || tar.tarea.subtipoTarea.codigoSubtarea == "99"}'>
				<json:property name="group" value="2" />
				<json:property name="descripcionTarea" value="${tar.tarea.tarea}"/>
				<json:property name="descripcion" value="${tar.tarea.descripcionTarea}" />
			</c:if>
			<c:if test='${tar.tarea.subtipoTarea.codigoSubtarea != "1" && tar.tarea.subtipoTarea.codigoSubtarea != "98" && tar.tarea.subtipoTarea.codigoSubtarea != "99"}'>
				<json:property name="fechaFin" >
					<fwk:date value="${tar.tarea.fechaFin}"/>
				</json:property>
				<json:property name="fechaInicio" >
					<fwk:date value="${tar.tarea.fechaInicio}"/>
				</json:property>
				<json:property name="group">
						<app:groupTareas value="${tar.tarea}" />
				</json:property>
				<json:property name="id" value="${tar.tarea.id}" />
				<json:property name="plazo" value="${tar.tarea.plazo}" />
				<json:property name="entidadInformacion" value="${tar.tarea.entidadInformacion}"/>
				<json:property name="entidadInformacion_id" value="${tar.tarea.idEntidad}"/>
				<json:property name="codigoEntidadInformacion" value="${tar.tarea.tipoEntidad.codigo}" />
				<json:property name="descripcionEntidadInformacion" value="${tar.tarea.tipoEntidad.descripcion}" />
				<json:property name="codentidad" value="${tar.tarea.codigo}" />
				<json:property name="gestor" value="${tar.tarea.descGestor}" />
				<json:property name="tipoTarea" value="${tar.tarea.subtipoTarea.tipoTarea.codigoTarea}" />
				<json:property name="tipoTareaDescripcion" value="${tar.tarea.subtipoTarea.tipoTarea.descripcion}" />
				<json:property name="tipoSolicitud" value="${tar.tarea.tipoSolicitud}" />
				<json:property name="idEntidad" value="${tar.tarea.idEntidad}" />
				<json:property name="fcreacionEntidad" value="${tar.tarea.fechaCreacionEntidadFormateada}" />
				<json:property name="codigoSituacion" value="${tar.tarea.situacionEntidad}" />
				<json:property name="fechaVenc"><fwk:date value="${tar.tarea.fechaVenc}"/></json:property>
				
				<json:property name="idTareaAsociada" value="${tar.tarea.tareaId.id}"/>
				<json:property name="descripcionTareaAsociada" value="${tar.tarea.tareaId.descripcionTarea}"/>
				<json:property name="emisor" value="${tar.tarea.emisor}"/>
				<json:property name="supervisor" value="${tar.tarea.descSupervisor}"/>
				<json:property name="diasVencido" value="${tar.tarea.diasVencido}"/>
				<json:property name="descripcionExpediente" value="${tar.tarea.expediente.descripcionExpediente}"/>
				<json:property name="gestorId" value="${tar.tarea.gestor}"/>
				<json:property name="supervisorId" value="${tar.tarea.supervisor}"/>						
				<json:property name="idEntidadPersona" value="${tar.tarea.idEntidadPersona}"/>
				<json:property name="volumenRiesgo" value="${tar.tarea.volumenRiesgo}"/>
				<json:property name="volumenRiesgoVencido" value="${tar.tarea.volumenRiesgoVencido}"/>
				<json:property name="itinerario" value="${tar.tarea.tipoItinerarioEntidad}"/>
				<json:property name="subTipoTarea" value="${tar.tarea.subtipoTarea.descripcion}" />
				
				<json:property name="zona" value="${tar.tarea.cliente.oficina.zona.descripcion}
												  ${tar.tarea.expediente.oficina.zona.descripcion}
												  ${tar.tarea.asunto.gestor.despachoExterno.zona.descripcion}" />
			</c:if>
		</json:object>
	</json:array>
</fwk:json>