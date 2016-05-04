<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="acuerdos" items="${pagina.results}" var="acu">
		<json:object>
			<json:property name="id" value="${acu.id}"/>
			<json:property name="nroContrato" value="${acu.nroContrato}"/>
			<json:property name="nroCliente" value="${acu.nroCliente}"/>
			<json:property name="solicitante" value="${acu.solicitante}"/>
			<json:property name="tipoSolicitante" value="${acu.tipoSolicitante}"/>
			<json:property name="tipoAcuerdo" value="${acu.tipoAcuerdo}"/>
			<json:property name="estado" value="${acu.estado}"/>
			<json:property name="fechaAlta" value="${acu.fechaAlta}"/>
			<json:property name="fechaEstado" value="${acu.fechaEstado}"/>
			<json:property name="fechaVigencia" value="${acu.fechaVigencia}"/>
		</json:object>
	</json:array>
</fwk:json>	 		 