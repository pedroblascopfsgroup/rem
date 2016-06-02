<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
			<json:object name="resolucion">
			<json:property name="idResolucion" value="${resolucion.id}" />
			<c:if test="${resolucion.estadoResolucion != null}">
            	<json:property name="estado" value="${resolucion.estadoResolucion.descripcion}" />
            	<json:property name="idEstado" value="${resolucion.estadoResolucion.id}" />
            </c:if>			
			<c:if test="${resolucion.tipoJuicio != null}">
            	<json:property name="comboTipoJuicioNew" value="${resolucion.tipoJuicio.id}" />
            </c:if>		
			<c:if test="${resolucion.tipoResolucion != null}">
            	<json:property name="comboTipoResolucionNew" value="${resolucion.tipoResolucion.id}" />
            </c:if>	
            <c:if test="${resolucion.tipoResolucion != null}">
            	<json:property name="codigoTipoAccion" value="${resolucion.tipoResolucion.tipoAccion.codigo}" />
            </c:if>		
			<json:property name="auto" value="${resolucion.autos}" />
			<json:property name="juzgado" value="${resolucion.juzgado}" />
			<json:property name="plaza" value="${resolucion.plaza}" />
			<json:property name="principal" value="${resolucion.principal}"/>
			<c:if test="${(resolucion.nombreFichero != null)}">
				<json:property name="file" value="${resolucion.nombreTipoAdjunto}"/>
				<json:property name="fileId" value="${resolucion.adjuntoFinal.id}"/>
			</c:if>
			<c:if test="${(resolucion.adjuntosResolucion != null)}">
				<json:array name="adjuntosResolucion" items="${resolucion.adjuntosResolucion}" var="obs">
					 <json:object>
						<json:property name="nombreFichero">${obs.nombre}</json:property>
						<json:property name="tipoFicheroCodigo">${obs.tipoFichero.codigo}</json:property>
						<json:property name="file">${obs.nombre} - ${obs.tipoFichero.descripcion}</json:property>
						<json:property name="id" value="${obs.id}" />
					 </json:object>
				</json:array>
			</c:if>
			<c:if test="${resolucion.asunto != null}">
				<json:property name="asunto" value="${resolucion.asunto.nombre}" />
				<json:property name="idAsunto" value="${resolucion.asunto.id}" />
			</c:if>		
			<c:if test="${resolucion.tarea != null}">
				<json:property name="idTarea" value="${resolucion.tarea.id}" />
			</c:if>
			<c:if test="${resolucion.procedimiento != null}">			
				<json:property name="idProcedimiento" value="${resolucion.procedimiento.id}" />
				<json:property name="tipoPrc" value="${resolucion.procedimiento.tipoProcedimiento.descripcion}" />
				<json:property name="desEstadoPrc" value="${resolucion.procedimiento.estadoProcedimiento.descripcion}" />				 
				<json:property name="codEstadoPrc" value="${resolucion.procedimiento.estadoProcedimiento.codigo}" />
			</c:if>
			<c:forEach var="campo" items="${resolucion.camposDinamicos}">
				<json:property name="${campo.nombreCampo}" value="${campo.valorCampo}" />
			</c:forEach>
		</json:object>
		<json:object name="resultadoDatosvalidacion">
			<json:property name="validacion" value="${validacion}" />
		</json:object>
</fwk:json>			