<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
		<json:object name="resolucion">
			<c:if test="${nombreFichero != null}">
				<json:property name="file" value="${nombreFichero}"/>
			</c:if>
			<c:forEach var="campo" items="${campos}">
				<json:property name="${campo.nombre}" value="${campo.value}" />
			</c:forEach>
		</json:object>
</fwk:json>	