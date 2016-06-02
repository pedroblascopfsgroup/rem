<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="delegaciones" items="${pagina.results}" var="del">
		<json:object>
			<json:property name="id" value="${del.id}" />
			<json:property name="usuarioOrigenName" value="${del.usuarioOrigen.apellidoNombre}" />
			<json:property name="usuarioOrigenId" value="${del.usuarioOrigen.id}" />
			<json:property name="usuarioDestinoName" value="${del.usuarioDestino.apellidoNombre}" />
			<json:property name="usuarioDestinoId" value="${del.usuarioDestino.id}" />
			<json:property name="fechaIniVigencia">
			  <fwk:date value="${del.fechaIniVigencia}"/>
			</json:property>
			<json:property name="fechaFinVigencia">
			  <fwk:date value="${del.fechaFinVigencia}"/>
			</json:property>
			<json:property name="usuarioCrear" value="${del.usuarioCrear}" />
			<json:property name="fechaCrear">
			  <fwk:date value="${del.fechaCrear}"/>
			</json:property>
			<json:property name="estadoDesc" value="${del.estado.descripcion}" />
			<json:property name="estadoCod" value="${del.estado.codigo}" />
		</json:object>
	</json:array>
</fwk:json>
