<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

	<fwk:json>
       <json:array name="listaArchivos" items="${listaProcesos}" var="archivo">
               <json:object>
                       <json:property name="id" value="${archivo.id}" />
                       <json:property name="nombre" value="${archivo.descripcion}" />
                       <json:property name="idTipoOperacion" value="${archivo.tipoOperacion.id}" />
                       <json:property name="tipoOperacion" value="${archivo.tipoOperacion.descripcion}" />
                       <json:property name="idEstado" value="${archivo.estadoProceso.id}" />
                       <json:property name="estado" value="${archivo.estadoProceso.descripcion}" />
                       <json:property name="fecha" value="${archivo.auditoria.fechaCrear}" />
                       <json:property name="usuario" value="${archivo.auditoria.usuarioCrear}" />
               </json:object>
       </json:array>
</fwk:json>