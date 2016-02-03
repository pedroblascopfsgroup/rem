<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" import="es.capgemini.pfs.procesosJudiciales.model.DDSiNo"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="diccionario" items="${pagina}" var="dd">
		<json:object>
			<json:property name="id" value="${dd.id}" />
			<json:property name="nombre" value="${dd.nombreTabla}" />
			<json:property name="descripcion" value="${dd.descripcion}" />
			<json:property name="editable">
				<c:if test="${dd.editable}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!dd.editable}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="insertable">
				<c:if test="${dd.insertable}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!dd.insertable}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="borrable">
				<c:if test="${(dd.editable && dd.insertable)}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${!(dd.editable && dd.insertable)}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
		</json:object>
	</json:array>
</fwk:json>