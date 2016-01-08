<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="juzgado" items="${juzgados}" var="j">
		<json:object>
			<json:property name="id" value="${j.id}" />
			<json:property name="codigo" value="${j.codigo}" />
			<json:property name="descripcion" value="${j.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>