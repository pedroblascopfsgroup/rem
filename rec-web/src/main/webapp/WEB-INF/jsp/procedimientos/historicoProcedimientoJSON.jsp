<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:array name="historicoProcedimiento" items="${tareas}" var="tp">
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
			<json:property name="nombreUsuario" value="${tp.nombreUsuario}"/>
			<json:property name="usuarioResponsable" value="${tp.usuarioResponsable}"/>
		</json:object>
	</json:array>
</fwk:json>