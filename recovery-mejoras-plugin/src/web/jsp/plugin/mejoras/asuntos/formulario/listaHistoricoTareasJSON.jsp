<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${tareas.totalCount}" />
	<json:array name="historicoAsunto" items="${tareas.results}" var="tp">
		<json:object>
			<json:property name="tipoRegistro" value="${tp.tipoRegistro}" />
			<json:property name="subtipoTarea" value="${tp.subtipoTarea}" />
			<json:property name="tipoEntidad" value="${tp.tipoEntidad}" />
			<json:property name="group">
				<s:message code="${tp.group}" />
			</json:property>
			<json:property name="idEntidad" value="${tp.idEntidad}" />
			<json:property name="tarea" value="${tp.tarea}" />
			<json:property name="descripcionTarea" value="${tp.descripcionTarea}" escapeXml="false"/>
			<json:property name="idTarea" value="${tp.idTarea}"/>
			<json:property name="idTraza" value="${tp.idTraza}"/>
			<json:property name="tipoTraza" value="${tp.tipoTraza}"/>
			<json:property name="tipoActuacion" value="${tp.tipoActuacion}" />
			<json:property name="tipoProcedimiento" value="${tp.tipoProcedimiento}" />

			<json:property name="numeroProcedimiento" value="${tp.numeroProcedimiento}" />
			<json:property name="numeroAutos" value="${tp.numeroAutos}" />
			<json:property name="importe" value="${tp.importe}" />
			<c:if test="${!tp.agenda}">
				<json:property name="fechaInicio">
					<fwk:date value="${tp.fechaInicio}" />
				</json:property>
			</c:if>
			<c:if test="${tp.agenda}">
				<json:property name="fechaInicio" value="${tp.fechaIni}" />
			</c:if>
			
			<json:property name="fechaVencimiento">
				<fwk:date value="${tp.fechaVencimiento}" />
			</json:property>
			<json:property name="fechaFin">
				<fwk:date value="${tp.fechaFin}" />
			</json:property>
			<json:property name="nombreUsuario" value="${tp.nombreUsuario}" />
			<json:property name="descripcionCorta" value="${tp.descripcionCorta}" />
			<json:property name="fechaVencReal">
					<fwk:date value="${tp.fechaVencReal}" />
			</json:property>
			<json:property name="destinatarioTarea" value="${tp.destinatarioTarea}" />
		</json:object>

	</json:array>
</fwk:json>