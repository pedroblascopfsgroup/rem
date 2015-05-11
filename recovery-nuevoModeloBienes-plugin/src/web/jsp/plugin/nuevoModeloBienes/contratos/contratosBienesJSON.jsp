<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="contratosBienes" items="${contratosBienes}" var="cb">
		<json:object>
			<json:property name="id" value="${cb.id}"/>
			<json:property name="importeGarantizado" value="${cb.importeGarantizado}"/>
			<json:property name="idBien" value="${cb.bien.id}"/>
			<json:property name="relacion" value="${cb.tipo.descripcion}"/>
			<json:property name="estado" value="${cb.estado.descripcion}"/>
			<json:property name="tipo" value="${cb.bien.tipoBien}"/>
			<json:property name="detalle" value="${cb.bien.descripcionBien}"/>
			<json:property name="refCatastral" value="${cb.bien.datosRegistralesActivo.referenciaCatastralBien}" />
			<json:property name="poblacion" value="${cb.bien.localizacionActual.poblacion}" />
			<json:property name="importeCargas" value="${cb.bien.importeCargas}" />
			<json:property name="valorActual" value="${cb.bien.valorActual}" />
			<json:property name="superficie" value="${cb.bien.datosRegistralesActivo.superficie}" />
			<json:property name="origen" value="${cb.bien.origen.descripcion}" />
			<json:property name="codInterno" value="${cb.bien.codigoInterno}" />
			<json:property name="fechaTasacion" >
				<fwk:date value="${cb.bien.valoracionActiva.fechaValorTasacion}"/>
			</json:property>
			<json:property name="valorTasacion" value="${cb.bien.valoracionActiva.importeValorTasacion}" />
			<json:property name="participacion" value="${cb.bien.NMBpersonas[0].participacion}" />
			<json:property name="personas" value="${cb.bien.NMBpersonas[0].persona.apellidoNombre}" />
			<json:property name="idPersona" value="${cb.bien.NMBpersonas[0].persona.id}" />
 		</json:object>
 		
 		<c:forEach items="${cb.bien.NMBpersonas}" var="bieper">
			<c:if test="${bieper.id!=cb.bien.NMBpersonas[0].id}">
				<json:object>
					<json:property name="importeGarantizado" value='---' />
					<json:property name="personas" value="${bieper.persona.apellidoNombre}" />
					<json:property name="idPersona" value="${bieper.persona.id}" />
					<json:property name="participacion" value="${bieper.participacion}" />
					<json:property name="valorActual" value='---' />
					<json:property name="importeCargas" value='---' />
					<json:property name="superficie" value='---' />
				</json:object>
			</c:if>
		</c:forEach>
		
	</json:array>
</fwk:json>
