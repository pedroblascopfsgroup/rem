<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	<json:array name="observaciones" items="${observaciones}" var="obs">
		<json:object>
			<json:property name="id" value="${obs.id}" />
			<json:property name="idProcedimientoPCO" value="${obs.idProcedimientoPCO}" />
			<json:property name="fecha" >
				<fwk:date value="${obs.fechaAnotacion}" />
			</json:property>
			<json:property name="resumen" value="${obs.textoResumen}" />
			<%--<json:property name="secuencia" value="${obs.secuenciaAnotacion}" /> --%>
			<json:property name="texto" value="${obs.textoAnotacion}" />
			<json:property name="idUsuario" value="${obs.idUsuario}" />
			<json:property name="username" value="${obs.username}" />
			<json:property name="idUserLogado" value="${idUserLogado}" />
		</json:object>
	</json:array>
	
</fwk:json>