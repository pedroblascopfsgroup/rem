<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="cambiosGestoresPendientes" items="${cambiosGestoresPendiente}" var="cambioGestorPendiente">
		<json:object>
			<json:property name="id" value="${cambioGestorPendiente.id}" />
			<json:property name="tipoGestor" value="${cambioGestorPendiente.tipoGestor.descripcion}" />					
			<json:property name="usuarioActual" value="${cambioGestorPendiente.gestorActual.usuario.nombre} ${cambioGestorPendiente.gestorActual.usuario.apellido1} ${cambioGestorPendiente.gestorActual.usuario.apellido2}" />					
			<json:property name="usuarioFuturo" value="${cambioGestorPendiente.nuevoGestor.usuario.nombre} ${cambioGestorPendiente.nuevoGestor.usuario.apellido1} ${cambioGestorPendiente.nuevoGestor.usuario.apellido2}" />					
			<json:property name="fechaInicio" >
				<fwk:date value="${cambioGestorPendiente.fechaInicio}"/>
			</json:property>
			<json:property name="fechaFin" >
				<fwk:date value="${cambioGestorPendiente.fechaFin}"/>
			</json:property>
			<json:property name="usuarioModifica" value="${cambioGestorPendiente.solicitante.nombre} ${cambioGestorPendiente.solicitante.apellido1} ${cambioGestorPendiente.solicitante.apellido2}" />
		</json:object>
	</json:array>
</fwk:json>