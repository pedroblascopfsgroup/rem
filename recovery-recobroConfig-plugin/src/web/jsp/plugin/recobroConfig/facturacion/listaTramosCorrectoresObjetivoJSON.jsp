<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="correctores" items="${tramosCorrectores}" var="tramosCorrectores">
		<json:object>
			<json:property name="id" value="${tramosCorrectores.id}"/>
			<json:property name="posicion" value="${tramosCorrectores.objetivoInicio}% - ${tramosCorrectores.objetivoFin}%"  />
			<json:property name="coeficiente" value="${tramosCorrectores.coeficiente}%"/>
		</json:object>
	</json:array>
</fwk:json>		

