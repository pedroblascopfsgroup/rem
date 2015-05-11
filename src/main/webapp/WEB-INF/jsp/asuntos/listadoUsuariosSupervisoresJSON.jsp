<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="gestores" items="${supervisores}" var="gestor">
		<json:object>
			<json:property name="codigo" value="${gestor.id}" />
	
			<c:if test="${gestor.apellidoNombre == null || gestor.apellidoNombre == ''}">
				<json:property name="descripcion" value="${gestor.username}" />
			</c:if>
			<c:if test="${gestor.apellidoNombre != ''}">
				<json:property name="descripcion" value="${gestor.apellidoNombre}" />
			</c:if>
		</json:object>
	</json:array>
</fwk:json>