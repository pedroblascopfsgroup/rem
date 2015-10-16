<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"
	import="es.pfsgroup.recovery.ext.turnadodespachos.EsquemaTurnadoConfig"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
    <json:property name="total" value="${page.totalCount}" />
    <json:array name="esquemas" items="${page.results}" var="esquema">
        <json:object>
        	<json:property name="id" value="${esquema.id}" />
			<json:property name="descripcion" value="${esquema.descripcion}" />
			<json:property name="estado_cod" value="${esquema.estado.codigo}"/>
			<json:property name="estado_des" value="${esquema.estado.descripcion}"/>
			<json:property name="usuario" value="${esquema.auditoria.usuariocrear}" />
			<json:property name="fechaalta" value="${esquema.auditoria.fechacrear}" />
			<json:property name="fechainivig" value="${esquema.fechaInicioVigencia}" />
			<json:property name="fechafinvig" value="${esquema.fechaFinVigencia}" />
        </json:object>
    </json:array>
</fwk:json>