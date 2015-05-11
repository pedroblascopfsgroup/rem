<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="listadoComites" items="${comites}" var="comites">
		<json:object>
	  		<json:property name="id" value="${comites.id}" /> 
			<json:property name="nombre" value="${comites.nombre}" />
		</json:object>
	</json:array>
</fwk:json>
