<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
	<json:array name="personasSolvencias" items="${personasSolvencias}" var="ps">
		<json:object>
			<json:property name="idPersona" value="${ps.id}"/>
			<json:property name="apellidoNombre" value="${ps.nombreApellidos}"/>
			<json:property name="idPersonaBien" value="${ps.solvencias[0].id}" />
			<json:property name="idBien" value="${ps.solvencias[0].bien.id}" />
			<json:property name="propiedad" value="${ps.solvencias[0].participacion}" />
			<json:property name="tipo" value="${ps.solvencias[0].bien.tipoBien}" />
			<json:property name="detalle" value="${ps.solvencias[0].bien.descripcionBien}" />
			<json:property name="poblacion" value="${ps.solvencias[0].bien.localizacionActual.poblacion}" />
			<json:property name="superficie" value="${ps.solvencias[0].bien.datosRegistralesActivo.superficie}" />
			<json:property name="importeCargas" value="${ps.solvencias[0].bien.importeCargas}" />
			<json:property name="valorActual" value="${ps.solvencias[0].bien.valorActual}" />
			<json:property name="origen" value="${ps.solvencias[0].bien.origen.descripcion}" />
			<json:property name="contrato" value="${ps.solvencias[0].bien.contratos[0].contrato.codigoContrato}" />
			<json:property name="tipoGarantia" value="${ps.solvencias[0].bien.contratos[0].tipo.descripcion}" />
			<json:property name="importeGarantizado" value="${ps.solvencias[0].bien.contratos[0].importeGarantizado}" />
 		</json:object>
 		
 		<c:forEach items="${ps.solvencias}" var="sol">
			<c:if test="${ps.solvencias[0].id!=sol.id}">
				<json:object>
					<json:property name="idPersona" value="${ps.id}"/>
					<json:property name="apellidoNombre" value='' />
					<json:property name="idPersonaBien" value="${sol.id}" />
					<json:property name="idBien" value="${sol.bien.id}" />
					<json:property name="propiedad" value="${sol.participacion}" />
					<json:property name="tipo" value="${sol.bien.tipoBien}" />
					<json:property name="detalle" value="${sol.bien.descripcionBien}" />
					<json:property name="poblacion" value="${sol.bien.localizacionActual.poblacion}" />
					<json:property name="superficie" value="${sol.bien.datosRegistralesActivo.superficie}" />
					<json:property name="importeCargas" value="${sol.bien.importeCargas}" />
					<json:property name="valorActual" value="${sol.bien.valorActual}" />
					<json:property name="origen" value="${sol.bien.origen.descripcion}" />
					<json:property name="contrato" value="${sol.bien.contratos[0].contrato.codigoContrato}" />
					<json:property name="tipoGarantia" value="${sol.bien.contratos[0].bien.contratos[0].tipo.descripcion}" />
					<json:property name="importeGarantizado" value="${sol.bien.contratos[0].importeGarantizado}" />
				</json:object>
				
				<c:forEach items="${sol.bien.contratos}" var="cnt">
					<c:if test="${sol.bien.contratos[0].contrato.id!=cnt.contrato.id}">
						<json:object>
							<json:property name="propiedad" value="---" />
							<json:property name="valorActual" value="---" />
							<json:property name="contrato" value="${cnt.contrato.codigoContrato}" />
							<json:property name="tipoGarantia" value="${cnt.tipo.descripcion}" />
							<json:property name="importeGarantizado" value="${cnt.importeGarantizado}" />
						</json:object>
					</c:if>
				</c:forEach> 	
				
			</c:if>
		</c:forEach> 		
		
	</json:array>
</fwk:json>