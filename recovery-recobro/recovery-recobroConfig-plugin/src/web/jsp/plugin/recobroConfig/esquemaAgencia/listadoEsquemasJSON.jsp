<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:property name="total" value="${esquemas.totalCount}" />
	<json:array name="esquemas" items="${esquemas.results}" var="esquema">
		<json:object>
			<json:property name="id" value="${esquema.id}"/>
			<json:property name="nombre" value="${esquema.nombreVersion}"/>
			<json:property name="version" value="${esquema.versionrelease}.${esquema.majorRelease}.${esquema.minorRelease}"/>
			<json:property name="estadoEsquema" value="${esquema.estadoEsquema.descripcion}"/>
			<json:property name="codigoEstado" value="${esquema.estadoEsquema.codigo}"/>
			<json:property name="fechaAlta">
				<fwk:date value="${esquema.fechaAlta}" />
			</json:property>	
			<json:property name="fechaLiberacion">
				<fwk:date value="${esquema.fechaLiberacion}" />
			</json:property>
			<json:property name="fechaFinTransicion">
				<fwk:date value="${esquema.fechaFinTransicion}" />
			</json:property>
			<json:property name="fechaDesactivacion">
				<fwk:date value="${esquema.fechaDesactivacion}" />
			</json:property>
			<json:property name="idPropietario" value="${esquema.propietario.id}"/>
			<json:property name="esquemaAnterior" value="${esquema.esquemaAnterior.nombre}"/>
			<json:property name="usuarioCrear" value="${esquema.propietario.username}"/>
		</json:object>
	</json:array>
</fwk:json>		