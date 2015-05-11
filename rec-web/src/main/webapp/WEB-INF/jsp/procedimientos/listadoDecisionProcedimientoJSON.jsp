<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
	<json:object>
		<json:property name="id" value="${rec.id}"/>
		<json:property name="finalizada" value="${rec.finalizada}"/>
		<json:property name="paralizada" value="${rec.paralizada}"/>
		<json:property name="causaDecision" value="${rec.causaDecision}"/>
		<json:property name="estadoDecision" value="${rec.estadoDecision}"/>
		<json:property name="derivaciones" value="${fn:length(rec.procedimientosDerivados)}"/>
		<json:property name="fechaParalizacion" >
			<fwk:date value="${rec.fechaParalizacion}"/>
		</json:property>
		<json:property name="comentarios" value="${rec.comentarios}"/>
	</json:object>
	</json:array>
</fwk:json>
