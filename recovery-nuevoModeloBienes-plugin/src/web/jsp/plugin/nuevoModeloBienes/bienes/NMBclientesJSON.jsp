<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${clientes.totalCount}" />
	<json:array name="clientes" items="${clientes.results}" var="cliente">
		<json:object>
			<json:property name="id" value="${cliente.id}" />
			<json:property name="docId" value="${cliente.docId}" />
			<json:property name="nombre" value="${cliente.nombre}" />
			<json:property name="apellido1" value="${cliente.apellido1}" />
			<json:property name="apellido2" value="${cliente.apellido2}" />
			<json:property name="descripcion" value="${cliente.nombre} - ${cliente.apellido1} ${cliente.apellido2}, ${cliente.nombre}" />
		</json:object>
	</json:array>
</fwk:json>