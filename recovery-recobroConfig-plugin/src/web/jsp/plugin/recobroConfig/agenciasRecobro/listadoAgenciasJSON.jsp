<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${listaAgencias.totalCount}" />
	<json:array name="agencias" items="${listaAgencias.results}" var="agencia">
		<json:object>
			<json:property name="id" value="${agencia.id}"/>
			<json:property name="nombre" value="${agencia.nombre}"/>
			<json:property name="nif" value="${agencia.nif}"/>
			<json:property name="denominacionFiscal" value="${agencia.denominacionFiscal}"/>
			<json:property name="contactoNombreApellido" value="${agencia.contactoNombreApellido}"/>
		</json:object>
	</json:array>
</fwk:json>		