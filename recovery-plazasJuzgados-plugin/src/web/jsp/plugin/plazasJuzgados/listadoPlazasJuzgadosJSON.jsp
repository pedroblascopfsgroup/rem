<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
	<json:property name="total" value="${juzgados.totalCount}" />
	<json:array name="juzgados" items="${juzgados.results}" var="j">
		<json:object >
			<json:property name="id" value="${j.juzgado.id}" />
			<json:property name="codigo" value="${j.juzgado.codigo}" />
			<json:property name="descripcion" value="${j.juzgado.descripcion}" />
			<json:property name="plaza" value="${j.juzgado.plaza.descripcion}" />
			<json:property name="esUltimo" value="${j.esUltimo}" />
		</json:object>
	</json:array>
</fwk:json>