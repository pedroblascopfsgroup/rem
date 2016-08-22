<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
		<json:array name="listadoRecursos" items="${recursos}" var="r">
			<json:object>
				<json:property name="id" value="${r.id}"/>
				<json:property name="actor" value="${r.actor.descripcion}"/>
				<json:property name="tipo" value="${r.tipoRecurso.descripcion}"/>
				<json:property name="causa" value="${r.causaRecurso.descripcion}"/>
				<json:property name="resultado" value="${r.resultadoResolucion.descripcion}"/>
				<json:property name="fecha" >
					<fwk:date value="${r.fechaRecurso}"/>
				</json:property>
			</json:object>
		</json:array>
</fwk:json>
