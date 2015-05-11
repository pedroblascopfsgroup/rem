<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
		<json:object name="despacho">
			<json:property name="id" value="${despacho.id}" />
			<json:property name="despacho" value="${despacho.despacho}" />
			<json:property name="tipoVia" value="${despacho.tipoVia}" />
			<json:property name="domicilio" value="${despacho.domicilio}" />
			<json:property name="domicilioPlaza" value="${despacho.domicilioPlaza}" />
			<json:property name="codigoPostal" value="${despacho.codigoPostal}" />
			<json:property name="personaContacto" value="${despacho.personaContacto}" />
			<json:property name="telefono1" value="${despacho.telefono1}" />
			<json:property name="telefono2" value="${despacho.telefono2}" />
			<json:property name="tipoDespacho" value="${despacho.tipoDespacho.descripcion}" />
		</json:object>
</fwk:json>