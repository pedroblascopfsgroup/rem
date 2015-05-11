<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:property name="total" value="${instrucciones.totalCount}" />
	<json:array name="instrucciones" items="${instrucciones.results}" var="i">
		<json:object prettyPrint="true">
			<json:property name="id" value="${i.id}" />
			<json:property name="tipoProcedimiento" value="${i.tareaProcedimiento.tipoProcedimiento.descripcion}" />
			<json:property name="tareaProcedimiento" value="${i.tareaProcedimiento.descripcion}" />
			<json:property name="label" value="${i.label}" />
			
		</json:object>
	</json:array>
</fwk:json>