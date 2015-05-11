<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" 
	import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"
%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="usuarios" items="${pagina.results}" var="u">
		<json:object>
			<json:property name="id" value="${u.id}" />
			<json:property name="username" value="${u.username}" />
			<json:property name="nombre" value="${u.nombre}" />
			<json:property name="apellido1" value="${u.apellido1}" />
			<json:property name="apellido2" value="${u.apellido2}" />
			<json:property name="email" value="${u.email}" />
			<json:property name="usuarioExterno">
				<c:if test="${u.usuarioExterno}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!u.usuarioExterno}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="entidad" value="${u.entidad.descripcion}" />
			
		</json:object>
	</json:array>
</fwk:json>