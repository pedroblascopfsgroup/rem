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
			<c:if test="${(adjuntosResolucion != null)}">
				<json:array name="adjuntosResolucion" items="${adjuntosResolucion}" var="obs">
					 <json:object>
						<json:property name="nombreFichero">${obs.nombre}</json:property>
						<json:property name="tipoFicheroCodigo">${obs.tipoFichero.codigo}</json:property>
						<json:property name="file">${obs.nombre} - ${obs.tipoFichero.descripcion}</json:property>
						<json:property name="id" value="${obs.id}" />
						<json:property name="idResolucion" value="${obs.idResolucion}" />
					 </json:object>
				</json:array>
			</c:if>
		</json:object>
</fwk:json>	