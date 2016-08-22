<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="gestores" items="${gestores}" var="gestor">
		<json:object>
			<json:property name="codigo" value="${gestor.id}" />
			<c:if test="${gestor.usuario.apellidoNombre == ''}">
				<json:property name="descripcion" value="${gestor.usuario.username}" />
			</c:if>
			<c:if test="${gestor.usuario.apellidoNombre != ''}">
				<json:property name="descripcion" value="${gestor.usuario.apellidoNombre}" />
			</c:if>


		</json:object>
	</json:array>
</fwk:json>