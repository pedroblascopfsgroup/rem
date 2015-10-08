<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="derivacionesTerminosAcuerdo" items="${derivacionesTerminos}" var="derivacion">
		<json:object>
			<json:property name="id" value="${derivacion.id}" />
	        <json:property name="tipoAcuerdo" value="${derivacion.tipoAcuerdo}" />
	        <json:property name="tipoProcedimiento" value="${derivacion.tipoProcedimiento}" />   
	        <json:property name="restrictivo" value="${derivacion.restrictivo}" />                
	        <json:property name="restrictivoTexto" value="${derivacion.restrictivoTexto}" />	        
		</json:object>
	</json:array>
	
</fwk:json>