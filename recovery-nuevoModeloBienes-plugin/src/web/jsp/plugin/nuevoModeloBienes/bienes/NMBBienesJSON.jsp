<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:property name="total" value="${pagina.totalCount}" />
	<json:array name="bienes" items="${pagina.results}" var="bie">
		<json:object>
			<json:property name="id" value="${bie.id}"/>
			<json:property name="numFinca" value="${bie.datosRegistralesActivo.numFinca}"/>
			<json:property name="codigoInterno" value="${bie.codigoInterno}"/>
			<json:property name="tipo" value="${bie.tipoBien.descripcion}"/>
			<json:property name="descripcionBien" value="${bie.descripcionBien}"/>
			<json:property name="refCatastral" value="${bie.datosRegistralesActivo.referenciaCatastralBien}" />
			<json:property name="poblacion" value="${bie.localizacionActual.localidad.descripcion}" />
			<json:property name="valorActual" value="${bie.valorActual}" />
			<json:property name="superficie" value="${bie.datosRegistralesActivo.superficie}" />
			<json:property name="origen" value="${bie.origen.descripcion}" />
			<json:property name="importeCargas" value="${bie.importeTotalCargas}" />
			<json:property name="solvenciaNoEncontrada" value="${bie.solvenciaNoEncontrada}" />
			<json:property name="numActivo" value="${bie.numeroActivo}" />
			<json:property name="numRegistro" value="${bie.codigoInterno}" />
			<json:property name="referenciaCatastral" value="${bie.datosRegistralesActivo.referenciaCatastralBien}" />			
			<json:property name="direccion" value="${bie.localizacionActual.direccion}" />
			<json:property name="provincia" value="${bie.localizacionActual.provincia.descripcion}" />
			<json:property name="localidad" value="${bie.localizacionActual.poblacion}" />
			<json:property name="codigoPostal" value="${bie.localizacionActual.codPostal}" />
			<json:property name="tipoVia" value="${bie.localizacionActual.tipoVia}" />
			<json:property name="nombreVia" value="${bie.localizacionActual.nombreVia}" />
			<json:property name="numeroDomicilio" value="${bie.localizacionActual.numeroDomicilio}" />
			<json:property name="portal" value="${bie.localizacionActual.portal}" />
			<json:property name="bloque" value="${bie.localizacionActual.bloque}" />
			<json:property name="escalera" value="${bie.localizacionActual.escalera}" />
			<json:property name="piso" value="${bie.localizacionActual.piso}" />
			<json:property name="puerta" value="${bie.localizacionActual.puerta}" />
			<json:property name="barrio" value="${bie.localizacionActual.barrio}" />
			<json:property name="pais" value="${bie.localizacionActual.pais}" />
 		</json:object>
	</json:array>
</fwk:json>
