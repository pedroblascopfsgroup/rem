<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="subCarteras" items="${subCarteras}" var="subCartera">
		<json:object>
			<json:property name="id" value="${subCartera.id}"/>
			<json:property name="idCarteraEsquema" value="${subCartera.carteraEsquema.id}"/>
			<json:property name="esquema" value="${subCartera.carteraEsquema.esquema.nombre}"/>
			<json:property name="versionEsquema" value="${subCartera.carteraEsquema.version}"/>
			<json:property name="cartera" value="${subCartera.carteraEsquema.cartera.nombre}"/>
			<json:property name="nombre" value="${subCartera.nombre}"/>
			<json:property name="particion" value="${subCartera.particion}"/>
			<json:property name="tipoReparto" value="${subCartera.tipoRepartoSubcartera.descripcion}"/>
			<json:property name="modeloFacturacion" value="${subCartera.modeloFacturacion.nombre}"/>
			<json:property name="itinerarioMetasVolantes" value="${subCartera.itinerarioMetasVolantes.nombre}"/>	
			<json:property name="politicaAcuerdos" value="${subCartera.politicaAcuerdos.nombre}"/>
			<json:property name="modelosDeRanking" value="${subCartera.modeloDeRanking.nombre}"/>
			<c:if test="${subCartera.modeloFacturacion!=null}">
				<json:property name="fechaAltaModeloFacturacion">
					<fwk:date value="${subCartera.modeloFacturacion.auditoria.fechaCrear}" />
				</json:property>
			</c:if>
		</json:object>
	</json:array>
</fwk:json>		