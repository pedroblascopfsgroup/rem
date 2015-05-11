<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="cliente" items="${pagina.results}" var="cl">
		<json:object>			 
			<json:property name="id" value="${cl.id}" />
			<json:property name="nombre" value="${cl.persona.nombre}" />
			<json:property name="apellido1" value="${cl.persona.apellido1}" />
			<json:property name="apellido2" value="${cl.persona.apellido2}" />
			<json:property name="gestion" value="" />
			<json:property name="segmento" value="${cl.persona.segmento.descripcion}" />
			<json:property name="saldoVencido" value="${cl.persona.deudaIrregular}" />
			<json:property name="riesgoTotal" value="${cl.persona.riesgoTotal}" />
			<json:property name="riesgoDirecto" value="${cl.persona.riesgoDirecto}" />
			<json:property name="contratos" value="${cl.persona.numContratos}" />
			<json:property name="diasVencido" value="${cl.persona.diasVencido}" />
			<json:property name="situacion" value="${cl.persona.situacion}" />
			<json:property name="situacionFinanciera" value="${cl.persona.situacionFinanciera.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>