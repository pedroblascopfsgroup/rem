<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:object name="datos">
		<json:property name="id" value="${datos.id}"/>
		<json:property name="idTareaExterna" value="${datos.tareaExterna.id}"/>
		<json:property name="codigoTipoEntidad" value="${datos.tipoEntidad.codigo}"/>
		<json:property name="descripcion" value="${datos.descripcionTarea}"/>
		<json:property name="fecha"><fwk:date value="${datos.fechaInicio}"/></json:property>
		<json:property name="situacion" value="${datos.situacionEntidad}"/>
		<json:property name="idTareaAsociada" value="${datos.tareaId.id}"/>
		<json:property name="idEntidad" value="${datos.tipoEntidad.codigo}"/>
		<json:property name="descripcionTareaAsociada" value="${datos.tareaId.descripcionTarea}"/>
		<json:property name="tipoTarea" value="${datos.subtipoTarea.tipoTarea.codigoTarea}"/>
		<json:property name="idProrroga" value="${datos.prorroga.id}"/>

   </json:object>
</fwk:json>
