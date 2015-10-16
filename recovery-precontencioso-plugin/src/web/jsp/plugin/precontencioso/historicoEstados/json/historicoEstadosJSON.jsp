<%@ page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	<json:array name="historicoEstados" items="${historicoEstados}" var="he">
		<json:object>
			<json:property name="id" value="${he.id}" />
 			<json:property name="estado" value="${he.estado}" />
			<json:property name="fechaInicio">
				<fwk:date value="${he.fechaInicio}" />
			</json:property>
			<json:property name="fechaFin">
				<fwk:date value="${he.fechaFin}" />
			</json:property>
		</json:object>
	</json:array>
</fwk:json>
