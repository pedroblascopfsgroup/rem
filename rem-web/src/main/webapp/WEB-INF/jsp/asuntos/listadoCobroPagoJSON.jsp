<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
	<json:object>
		<json:property name="id" value="${rec.id}"/>
		<json:property name="procedimiento" value="${rec.procedimiento.nombreProcedimiento}"/>
		<json:property name="estado" value="${rec.estado}"/>
		<json:property name="subTipo" value="${rec.subTipo}"/>
		<json:property name="importe" value="${rec.importe}"/>
		<json:property name="fecha" >
			<fwk:date value="${rec.fecha}"/>
		</json:property>
	</json:object>
	</json:array>
</fwk:json>
