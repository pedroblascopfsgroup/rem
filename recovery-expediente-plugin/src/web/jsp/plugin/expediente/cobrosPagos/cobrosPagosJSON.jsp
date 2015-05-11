<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<fwk:json>
	<json:property name="total" value="${listado.totalCount}" /> 
	<json:property name="usuarioLogado" value="${usuario.username}" />
	<json:array name="listado" items="${listado.results}" var="cob">
		<json:object>			
			<json:property name="id" value="${cob.id}" />
			<json:property name="contrato" value="${cob.contrato.descripcion}" /> 
			<json:property name="fechaMovimiento" >
				<fwk:date value="${cob.fechaMovimiento}"/>
			</json:property>
			<json:property name="tipoCobroPago" value="${cob.tipoCobroPago.descripcion}" />
			<json:property name="origenCobro" value="${cob.origenCobro.descripcion}"/>
			<json:property name="importe" value="${cob.importe}"/>
			<json:property name="fechaDato" value="${cob.fechaDato}"/>
		</json:object>
	</json:array>
</fwk:json>