<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
		<json:property name="total" value="${size}" />
		<json:array name="procuradores" items="${procuradores}" var="rps">
			<json:object>
				<json:property name="id" value="${rps.procurador.id}"/>
				<json:property name="nombre" value="${rps.procurador.nombre}"/>
			</json:object>
		</json:array>
</fwk:json>
