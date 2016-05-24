<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${tareas.totalCount}" />
	<json:array name="historicoTareas" items="${tareas.results}" var="tp">
		<json:object>
			<json:property name="tipoEntidad" value="${tp.tipoEntidad}"/>
			<json:property name="idEntidad" value="${tp.idEntidad}"/>
			<json:property name="tarea" value="${tp.nombreTarea}"/>
			<json:property name="fechaInicio">
				<fwk:date value="${tp.fechaIni}"/>
			</json:property>
			<json:property name="fechaVencimiento">
				<fwk:date value="${tp.fechaVencimiento}"/>
			</json:property>
			<json:property name="fechaFin">
				<fwk:date value="${tp.fechaFin}"/>
			</json:property>
			<json:property name="nombreUsuario" value="${tp.usuario.nombre} ${tp.usuario.apellido1}"/>
			<json:array name="historicoResoluciones" items="${tp.resoluciones}" var="hr">
				<json:object>
					<json:property name="idResolucion" value="${hr.id}"/>
					<json:property name="juzgado" value="${hr.juzgado}"/>
					<json:property name="plaza" value="${hr.plaza}"/>
					<json:property name="numAuto" value="${hr.numAuto}"/>
					<json:property name="fechaCarga">
						<fwk:date value="${hr.fechaCarga}"/>
					</json:property>
					<json:property name="idTipoResolucion" value="${hr.tipo.id}"/>
					<json:property name="tipo" value="${hr.tipo.descripcion}"/>
					<json:property name="usuario" value="${hr.usuario.nombre} ${hr.usuario.apellido1}"/>
					<json:property name="observaciones" value="${hr.observaciones}"/>
				</json:object>
			</json:array>
			<json:property name="usuarioResponsable" value="${tp.usuarioResponsable}" />
		</json:object>
	</json:array>
</fwk:json>