<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>

<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>


<fwk:json>
	<json:array name="tiposEstadosItinerarios" items="${tiposEstadosItinerarios}" var="est" >
		<json:object>
			<json:property name="id" value="${est.id}" />
			<json:property name="codigo" value="${est.codigo}" />
			<json:property name="descripcion" value="${est.descripcion}" />
			<json:property name="orden" value="${est.orden}" />
			<c:if test="${est.tipoEntidad!=null}">
				<json:property name="tipoEntidad" value="${est.tipoEntidad.codigo}" />
			</c:if>
		</json:object>
	</json:array>
</fwk:json>