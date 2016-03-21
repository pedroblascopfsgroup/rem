<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:array name="tareasProcedimiento" items="${tareas}" var="tp">
			<json:object>
				<json:property name="id" value="${tp.id}"/>
				<json:property name="idTareaProcedimiento" value="${tp.tareaProcedimiento.id}"/>
				<json:property name="descTareaProcedimiento" value="${tp.tareaProcedimiento.descripcion}"/>
				<json:property name="tarea" value="${tp.tareaPadre.tarea}"/>
				<json:property name="permiteProrrogas" value="${flagPermiteProrrogas}"/>
				<json:property name="fechaInicio" >
					<fwk:date value="${tp.tareaPadre.fechaInicio}"/>
				</json:property>
				<json:property name="fechaVenc">
					<fwk:date  value="${tp.tareaPadre.fechaVenc}"/>
				</json:property>
				<json:property name="fechaFin">
					<fwk:date   value="${tp.tareaPadre.fechaFin}"/>
				</json:property>
				<json:property name="usuario" value="${tp.tareaPadre.auditoria.usuarioCrear}"/>
				<json:property name="prorrogaAsociada" value="${tp.tareaPadre.prorrogaAsociada.tarea.id}"/>
				<json:property name="motivo" value="${tp.tareaPadre.prorrogaAsociada.causaProrroga.descripcion}"/>
				<json:property name="descPropuesta" value="${tp.tareaPadre.prorrogaAsociada.tarea.descripcionTarea}"/>
				<json:property name="fechaPropuesta" >
					<fwk:date  value="${tp.tareaPadre.prorrogaAsociada.fechaPropuesta}"/>
				</json:property>
				<json:property name="subtipoTarea" value="${tp.tareaPadre.subtipoTarea.codigoSubtarea}"/>
				<json:property name="vueltaAtras" value="${tp.vueltaAtras}"/>
				<json:property name="autoprorroga" value="${tp.tareaProcedimiento.autoprorroga}" />
				<json:property name="maximoAutoprorrogas" value="${tp.tareaProcedimiento.maximoAutoprorrogas}" />
				<c:if test="${tp.class.simpleName != 'TareaExterna'}">
					<json:property name="numeroAutoprorrogas" value="${tp.numeroAutoprorrogas}" />
				</c:if>
				<c:if test="${tp.class.simpleName == 'TareaExterna'}">
					<json:property name="numeroAutoprorrogas" value="0" />
				</c:if>	
			</json:object>
		</json:array>
</fwk:json>