<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${cobros.totalCount}" />
	<json:array name="cobros" items="${cobros.results}" var="cobro">
		<json:object>
			<json:property name="id" value="${cobro.id}"/>
			<json:property name="codigo" value="${cobro.codigo}"/>
			<json:property name="descripcion" value="${cobro.descripcion}"/>
		</json:object>
	</json:array>
</fwk:json>		