<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	<json:array name="acuerdos" items="${acuerdos}" var="acuerdo">
		<json:object>
			<json:property name="idAcuerdo" value="${acuerdo.id}" />
			<json:property name="idExpediente" value="${acuerdo.expediente.id}" />
			<json:property name="fechaPropuesta">
				<fwk:date value="${acuerdo.fechaPropuesta}" />
			</json:property>
			<json:property name="tipoPalanca" value="${acuerdo.tipoPalanca.descripcion}" />
			<json:property name="solicitante" value="${acuerdo.solicitante.descripcion}" />
			<json:property name="estado" value="${acuerdo.estadoAcuerdo.descripcion}" />
			<json:property name="codigoEstado" value="${acuerdo.estadoAcuerdo.codigo}" />
			<json:property name="importePago" value="${acuerdo.importePago}" />
			<json:property name="quita" value="${acuerdo.porcentajeQuita}" />
			<%-- 
			<json:property name="codigoContrato" value="${acuerdo.contrato.codigoContrato}" />
			--%>
			<json:property name="observaciones" value="${acuerdo.observaciones}" />
			<json:property name="conclusionTitulo" value="${acuerdo.analisisAcuerdo.ddConclusionTituloAcuerdo.descripcion}"/>
			<json:property name="observacionesTitulos" value="${acuerdo.analisisAcuerdo.observacionesTitulos}"/>
			<json:property name="ddAnalisisCapacidadPago" value="${acuerdo.analisisAcuerdo.ddAnalisisCapacidadPago.descripcion}"/>
			<json:property name="aumento" value="${acuerdo.analisisAcuerdo.importePago}"/>
			<json:property name="observacionesCapacidadDePago" value="${acuerdo.analisisAcuerdo.observacionesPago}"/>
			<json:property name="cambioSolvencia" value="${acuerdo.analisisAcuerdo.ddCambioSolvenciaAcuerdo.descripcion}"/>
			<json:property name="aumentoSolvencia" value="${acuerdo.analisisAcuerdo.importeSolvencia}"/>
			<json:property name="observacionesSolvencia" value="${acuerdo.analisisAcuerdo.observacionesSolvencia}"/>
			<json:property name="contratosString" value="${acuerdo.contratosString}"/>
			<json:property name="despachoString" value="${acuerdo.despacho.despacho}"/>			
		</json:object>
	</json:array>
</fwk:json>