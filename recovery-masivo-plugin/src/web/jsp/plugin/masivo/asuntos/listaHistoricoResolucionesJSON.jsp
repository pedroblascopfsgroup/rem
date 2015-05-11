<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${resoluciones.totalCount}" />
	<json:array name="historicoResoluciones" items="${resoluciones.results}" var="hr">
		<json:object>
			<json:property name="idResolucion" value="${hr.id}"/>
			<json:property name="juzgado" value="${hr.juzgado}"/>
			<json:property name="plaza" value="${hr.plaza}"/>
			<json:property name="numAuto" value="${hr.numAuto}"/>
			<json:property name="fechaCarga">
				<fwk:date value="${hr.fechaCarga}"/>
			</json:property>
			<json:property name="idTipoResolucion" value="${hr.tipo.id}"/>
			<json:property name="tipo" value="${hr.tipo.descripcion}"/>
			<json:property name="usuario" value="${hr.usuario.nombre} ${hr.usuario.apellido1}"/>
			<json:property name="observaciones" value="${hr.observaciones}"/>
		</json:object>
	</json:array>
</fwk:json>