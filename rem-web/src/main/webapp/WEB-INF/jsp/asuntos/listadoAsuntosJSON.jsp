<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="asuntos" items="${pagina.results}" var="asu">
		<json:object>
			<json:property name="id" value="${asu.id}" />
			<json:property name="codigo" value="${asu.id}" />
			<json:property name="nombre" value="${asu.nombre}" />
			<json:property name="fcreacion">
				<fwk:date value="${asu.auditoria.fechaCrear}" />
			</json:property>
			<json:property name="gestor" value="${asu.gestor.usuario.apellidoNombre}"/>
			<json:property name="despacho" value="${asu.gestor.despachoExterno.despacho}" />
			<json:property name="supervisor" value="${asu.supervisor.usuario.apellidoNombre}" />
			<json:property name="estado" value="${asu.codigoDecodificado}" />
			<json:property name="saldototal" value="${asu.saldoTotal}" />
            <json:property name="confirmado" value="${asu.estaConfirmado}" />      
		</json:object>
	</json:array>
</fwk:json>