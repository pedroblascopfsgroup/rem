<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="despachosExternos" items="${pagina.results}" var="d">
		<json:object>
			<json:property name="id" value="${d.id}" />
			<json:property name="despacho" value="${d.despacho}" />
			<json:property name="tipoVia" value="${d.tipoVia}" />
			<json:property name="domicilio" value="${d.domicilio}" />
			<json:property name="domicilioPlaza" value="${d.domicilioPlaza}" />
			<json:property name="codigoPostal" value="${d.codigoPostal}" />
			<json:property name="personaContacto" value="${d.personaContacto}" />
			<json:property name="telefono1" value="${d.telefono1}" />
			<json:property name="telefono2" value="${d.telefono2}" />
			<json:property name="tipoDespacho" value="${d.tipoDespacho.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>