<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

	<fwk:json>
	    <json:property name="total" value="${data.totalCount}" />
       	<json:array name="listaProcesosResolucion" items="${data.results}" var="resolucion">
               <json:object>               
                       <json:property name="idResolucion" value="${resolucion.id}" />
                       <c:if test="${resolucion.tipoResolucion != null}">
                       		<json:property name="idTipoResolucion" value="${resolucion.tipoResolucion.id}" />
                       		<json:property name="tipoResolucion" value="${resolucion.tipoResolucion.descripcion}" />
                       </c:if>
                       <c:if test="${resolucion.asunto != null}">
					   		<json:property name="asunto" value="${resolucion.asunto.nombre}" />
					   </c:if>
					   <json:property name="fechaEjecucion" value="${resolucion.auditoria.fechaCrear}" />
					   <c:if test="${resolucion.estadoResolucion != null}">
					    	<json:property name="estado" value="${resolucion.estadoResolucion.descripcion}" />
					   </c:if>
					   <json:property name="usuario" value="${resolucion.auditoria.usuarioCrear}" />
					   <json:property name="auto" value="${resolucion.autos}" />
               </json:object>
       </json:array>
</fwk:json>