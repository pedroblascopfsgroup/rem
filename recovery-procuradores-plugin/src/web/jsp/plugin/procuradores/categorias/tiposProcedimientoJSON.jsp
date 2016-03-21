<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="tiposProcedimiento" items="${listado}" var="tp">
		<json:object>
			<json:property name="id" value="${tp.id}" />
			<json:property name="codigo" value="${tp.codigo}" />
			<json:property name="descripcion" value="${tp.descripcion}" />
			<json:property name="saldoMinimo" value="${tp.saldoMinimo}" />
			<json:property name="saldoMaximo" value="${tp.saldoMaximo}" />
		</json:object>
	</json:array>
</fwk:json>