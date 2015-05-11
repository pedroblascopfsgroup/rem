<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${modelosFacturacion.totalCount}" />
	<json:array name="modelosFacturacion" items="${modelosFacturacion.results}" var="modelo">
		<json:object>
			<json:property name="id" value="${modelo.id}"/>
			<json:property name="nombre" value="${modelo.nombre}"/>
			<json:property name="enEsquemaVigente">
				<c:if test="${modelo.enEsquemaVigente}">
						<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!modelo.enEsquemaVigente}">
						<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="tipoCorrector" value="${modelo.tipoCorrector.descripcion}"/>
			<json:property name="numeroTramos" value="${modelo.numeroTramos}"/>
			<json:property name="estado" value="${modelo.estado.descripcion}" />
			<json:property name="codigoEstado" value="${modelo.estado.codigo}" />
			<json:property name="propietario" value="${modelo.propietario.username}" />	
			<json:property name="idPropietario" value="${modelo.propietario.id}" />
		</json:object>
	</json:array>
</fwk:json>		