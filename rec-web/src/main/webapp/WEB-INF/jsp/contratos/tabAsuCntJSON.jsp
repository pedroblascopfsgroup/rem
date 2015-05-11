<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
    <json:array name="asuntos" items="${asuntos}" var="asunto">   
        <json:object>
            <json:property name="id" value="${asunto.id}"/>
            <json:property name="descripcion">
				<s:message text="${asunto.nombre}" javaScriptEscape="true" />
			</json:property>
            <json:property name="fechaCrear">
            	<fwk:date value="${asunto.auditoria.fechaCrear}"/>
            </json:property>
            <json:property name="gestor" value="${asunto.gestor.usuario.apellidoNombre}" />
            <json:property name="supervisor" value="${asunto.supervisor.usuario.apellidoNombre}" />
            <json:property name="despacho" value="${asunto.gestor.despachoExterno.despacho}" />
        </json:object>
    </json:array>
</fwk:json>