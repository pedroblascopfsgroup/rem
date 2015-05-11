<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:array name="cumplimiento" items="${cumplimientos}" var="cumplimiento">
		<json:object>
			<json:property name="id" value="${cumplimiento.id}" />
			<json:property name="usuario" value="${cumplimiento.usuario.apellidoNombre}" /> 
			<json:property name="fechaPago" value="${cumplimiento.infoRegistro[0].valor}" />
			<c:if test="${cumplimiento.infoRegistro[3].valor=='null'}">
				<json:property name="cantidadPagada" value="---" />	
			</c:if>
			<c:if test="${cumplimiento.infoRegistro[3].valor!='null'}">
				<json:property name="cantidadPagada" value="${cumplimiento.infoRegistro[3].valor}" />	
			</c:if>
			<json:property name="cumplido">
				<c:if test="${cumplimiento.infoRegistro[2].valor==true}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${cumplimiento.infoRegistro[2].valor==false}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
			<json:property name="cerrado" >
				<c:if test="${cumplimiento.infoRegistro[4].valor==true}">
					<s:message code="mensajes.si"/>
				</c:if>
				<c:if test="${cumplimiento.infoRegistro[4].valor==false}">
					<s:message code="mensajes.no"/>
				</c:if>
			</json:property>
		</json:object>
	</json:array>
	
</fwk:json>