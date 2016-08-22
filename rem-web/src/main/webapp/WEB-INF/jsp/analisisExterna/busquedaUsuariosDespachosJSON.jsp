<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="diccionario" items="${usuarios}" var="u">
		<json:object>
			<json:property name="codigo" value="${u.id}" />
	
			<c:if test="${u.apellidoNombre == null || u.apellidoNombre == ''}">
				<json:property name="descripcion" value="${u.username}" />
			</c:if>
			<c:if test="${u.apellidoNombre != ''}">
				<json:property name="descripcion" value="${u.apellidoNombre}" />
			</c:if>
		</json:object>
	</json:array>
</fwk:json>