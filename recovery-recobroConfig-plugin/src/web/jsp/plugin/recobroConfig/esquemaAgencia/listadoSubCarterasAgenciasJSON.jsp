<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="subCarAgencias" items="${subCarAgencias}" var="subCarAgencias">
		<json:object>
			<json:property name="id" value="${subCarAgencias.id}"/>
			<json:property name="idAgencia" value="${subCarAgencias.agencia.id}"/>
			<json:property name="NomAgencia" value="${subCarAgencias.agencia.nombre}"/>
			<json:property name="coeficiente" value="${subCarAgencias.reparto}"/>
		</json:object>
	</json:array>
</fwk:json>		