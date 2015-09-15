<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>
	<json:array name="reglasElevacion" items="${reglasElevacion}" var="re" >
		<json:object>
			<json:property name="id" value="${re.id}" />
			<json:property name="ddTipoReglasElevacion" value="${re.ddTipoReglasElevacion.descripcion}" />
			<json:property name="ambitoExpediente" value="${re.ambitoExpediente.descripcion}" /> 
		</json:object>
	</json:array>
</fwk:json>