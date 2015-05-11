<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
		<c:set value="true" var="blankElement"/>
		<json:array name="subTiposTarea" items="${subTiposTarea}" var="subTiposTarea">
			<c:if test="${blankElement}">
				<json:object>
					<json:property name="codigo" value=""/>
					<json:property name="descripcion" value="Todos" />
				</json:object>
				<c:set var="blankElement" value="false"/>
			</c:if>
			<json:object>
					<json:property name="codigoSubtarea" value="${subTiposTarea.codigoSubtarea}" />
					<json:property name="descripcion" value="${subTiposTarea.descripcionLarga}" />
			</json:object>
		</json:array>

</fwk:json>