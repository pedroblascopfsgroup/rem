<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="camposTerminoAcuerdo" items="${operacionesPorTipo}" var="campo">
		<json:object>
			<json:property name="id" value="${campo.id}" />
	        <json:property name="tipoAcuerdo" value="${campo.tipoAcuerdo}" />   
	        <json:property name="nombreCampo" value="${campo.nombreCampo}" /> 
		</json:object>
	</json:array>
</fwk:json>