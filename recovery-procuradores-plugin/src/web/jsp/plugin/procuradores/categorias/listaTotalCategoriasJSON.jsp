<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="despachoIntegral" value="${despachoIntegral}" />
	<json:property name="idDespacho" value="${idDespacho}" />
	<json:array name="categorias" items="${lista}" var="cat">
		<json:object>			 
			<json:property name="id" value="${cat.id}" />
			<json:property name="idcategorizacion" value="${cat.categorizacion.id}" />
			<json:property name="nombre" value="${cat.nombre}" />
			<json:property name="descripcion" value="${cat.descripcion}" />
		</json:object>
	</json:array>
	<json:array name="vistaCount" items="${vistaCount}" var="vista">
		<json:object>
			<json:property name="id" value="${vista.id}" />
			<json:property name="count" value="${vista.count}" />
		</json:object>
	</json:array>
</fwk:json>