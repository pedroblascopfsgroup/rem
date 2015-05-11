<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
		<json:array name="permisoUsuario" items="${permisos}" var="p">
			<json:object>
				<json:property name="esGestorObjetivos" value="${p.esGestorObjetivos}"/>
				<json:property name="esSupervisorObjetivos" value="${p.esSupervisorObjetivos}"/>
				<json:property name="esVigente" value="${p.esVigente}"/>
				<json:property name="esPropuesta" value="${p.esPropuesta}"/>
				<json:property name="esPropuestaSuperusuario" value="${p.esPropuestaSuperusuario}"/>
				<json:property name="esGestorExpediente" value="${p.esGestorExpediente}"/>
				<json:property name="esSupervisorExpediente" value="${p.esSupervisorExpediente}"/>
			</json:object>
		</json:array>
</fwk:json>
