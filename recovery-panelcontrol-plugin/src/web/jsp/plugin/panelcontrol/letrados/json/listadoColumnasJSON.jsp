<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="columna" items="${listado}" var="col">
		<json:object>			 
			<json:property name="header" value="${col.header}" />
			<json:property name="align" value="${col.align}" />
			<json:property name="dataindex" value="${col.dataindex}" />
			<json:property name="sortable" value="${col.sortable}" />
			<json:property name="width" value="${col.width}" />
			<json:property name="hidden" value="${col.hidden}" />
			<json:property name="type" value="${col.type}" />
			<json:property name="flow_click" value="${col.flowClick}" />
			<json:property name="panelTareas" value="${col.panelTareas}" />
			<json:property name="etiqueta" value="${col.etiqueta}" />
		</json:object>
	</json:array>
</fwk:json>