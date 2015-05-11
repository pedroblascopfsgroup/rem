<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${adecuaciones.totalCount}" />
	<json:array name="adecuaciones" items="${adecuaciones.results}" var="ade">
		<json:object>
			<json:property name="id" value="${ade.id}"/>
			<json:property name="contrato" value="${ade.contrato.codigoContrato}"/>
			<json:property name="fechaExtraccion">
				<fwk:date value="${ade.fechaExtraccion}"/>
			</json:property>
			<json:property name="codigoRecomendacion" value="${ade.codigoRecomendacion}"/>			
			<json:property name="importeFinanciar" value="${ade.importeFinanciar}"/>
			<json:property name="gastosIncluidos" value="${ade.gastosIncluidos}"/>
			<json:property name="tipo" value="${ade.tipo}" />
			<json:property name="diferencial" value="${ade.diferencial}"/>
			<json:property name="plazo" value="${ade.plazo}"/>
			<json:property name="cuota" value="${ade.cuota}"/>
			<json:property name="cuotaTrasCarencia" value="${ade.cuotaTrasCarencia}"/>
			<json:property name="sistemaAmortizacion" value="${ade.sistemaAmortizacion}"/>
			<json:property name="razonProgresion" value="${ade.razonProgresion}"/>
			<json:property name="periodicidadRecibos" value="${ade.periodicidadRecibos}"/>
			<json:property name="periodicidadTipo" value="${ade.periodicidadTipo}"/>
			<json:property name="proximaRevision" value="${ade.proximaRevision}"/>
			<json:property name="revisionCuota" value="${ade.revisionCuota}"/>
			<json:property name="fechaDato">
				<fwk:date value="${ade.fechaDato}"/>
			</json:property>
		</json:object>
	</json:array>
</fwk:json>