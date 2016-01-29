<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="reglasVigenciaItinerario" items="${reglasVigencia}" var="rvp" >
		<json:object>
			<json:property name="id" value="${rvp.id}" />
			<json:property name="tipoReglaVigenciaPolitica" value="${rvp.tipoReglaVigenciaPolitica.descripcion}" />
			<json:property name="estado" value="${rvp.estadoItinerario.estadoItinerario.descripcion}" /> 
		</json:object>
	</json:array>
</fwk:json>