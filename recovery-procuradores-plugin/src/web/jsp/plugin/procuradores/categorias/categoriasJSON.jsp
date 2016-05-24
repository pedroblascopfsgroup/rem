<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:property name="permitirBorrar" value="${permitirBorrar}" />
	<json:array name="categorias" items="${pagina.results}" var="cat">
		<json:object>			 
			<json:property name="id" value="${cat.id}" />
			<json:property name="nombre" value="${cat.nombre}" />
			<json:property name="descripcion" value="${cat.descripcion}" />
			<json:property name="idcategorizacion" value="${cat.categorizacion.id}" />
			<json:property name="orden" value="${cat.orden}" />
		</json:object>
	</json:array>
</fwk:json>