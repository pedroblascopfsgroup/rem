<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fwk:json>
	<json:property name="fechaHasta" >
		<fwk:date value="${fechaHasta}"/>
	</json:property>
	<json:property name="idMotivo" value="${idMotivo}" />
	<json:property name="descripcionMotivo" value="${descripcionMotivo}" />
	<json:property name="comentarios" value="${comentarios}" />
	<json:property name="excId" value="${excId}" />
</fwk:json>
