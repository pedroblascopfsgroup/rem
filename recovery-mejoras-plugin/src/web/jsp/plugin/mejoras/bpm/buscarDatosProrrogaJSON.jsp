<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:object name="datos">
		<json:property name="idEntidadInformacion" value="${datos.tarea.procedimiento.id}"/>
		<json:property name="fechaCreacion"><fwk:date value="${datos.tarea.procedimiento.auditoria.fechaCrear}"/></json:property>
		<json:property name="situacion" value="${datos.tarea.procedimiento.asunto.estadoItinerario.descripcion}"/>
		<json:property name="destareaOri" value="${datos.tarea.descripcionTarea}"/>
		<json:property name="idTipoEntidadInformacion"><fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" /></json:property>
		<json:property name="fechaPropuesta"><fwk:date value="${datos.fechaPropuesta}"/></json:property>
		<json:property name="motivo" value="${datos.causaProrroga.descripcion}"/>
		<json:property name="idTareaOriginal" value="${datos.tarea.id}"/>
		<json:property name="descripcion" value="${datos.tarea.tarea}"/>
		<json:property name="descripcionTareaAsociada" value="${datos.tareaAsociada.tarea}"/>
		<json:property name="fechaVencimientoTareaAsociada" value="${datos.tareaAsociada.fechaVenc}"/>
		<json:property name="fechaVencimiento"><fwk:date value="${datos.tarea.fechaVenc}"/></json:property>
		<json:property name="idTareaAsociada" value="${datos.tarea.id}"/>
	</json:object>
</fwk:json>