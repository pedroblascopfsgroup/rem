<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="asuntos" items="${pagina.results}" var="asu">
		<json:object>
			<json:property name="codigo" value="${asu.id}" />
			<json:property name="fcreacion" value="${asu.fechaCreacionFormateada}" />
			<json:property name="descripcion" value="${asu.nombre}" />
			<json:property name="situacion" value="${asu.estadoItinerario.codigo}" />
			<json:property name="gestor" value="${asu.gestor.usuario.apellidoNombre}" />
			<json:property name="supervisor" value="${asu.supervisor.usuario.apellidoNombre}" />
			<json:property name="despacho" value="${asu.gestor.despachoExterno.despacho}" />
			<json:property name="comite" value="${asu.comite.nombre}" />
			<json:property name="estado" value="${asu.estadoAsunto.descripcion}" />
		</json:object>
	</json:array>
</fwk:json>
