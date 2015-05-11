<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${ciclosRecExp.totalCount}" />
	<json:array name="ciclosRecExp" items="${ciclosRecExp.results}" var="cicloRecExp">
		<json:object>
			<json:property name="id" value="${cicloRecExp.id}"/>
			<json:property name="idExpediente" value="${cicloRecExp.expediente.id}"/>
			<json:property name="fechaAlta">
				<fwk:date value="${cicloRecExp.fechaAlta}"/>
			</json:property>
			<json:property name="fechaBaja">
				<fwk:date value="${cicloRecExp.fechaBaja}"/>
			</json:property>
			<json:property name="posVivaNoVencida" value="${cicloRecExp.posVivaNoVencida}"/>
			<json:property name="posVivaVencida" value="${cicloRecExp.posVivaVencida}"/>	
			<json:property name="interesesOrdDeven" value="${cicloRecExp.interesesOrdDeven}"/>
			<json:property name="interesesMorDeven" value="${cicloRecExp.interesesMorDeven}"/>
			<json:property name="comisiones" value="${cicloRecExp.comisiones}"/>
			<json:property name="gastos" value="${cicloRecExp.gastos}"/>
			<json:property name="impuestos" value="${cicloRecExp.impuestos}"/>
			<json:property name="esquema" value="${cicloRecExp.esquema.nombre}"/>
			<json:property name="cartera" value="${cicloRecExp.carteraEsquema.cartera.nombre}"/>
			<json:property name="subcartera" value="${cicloRecExp.subcartera.nombre}"/>
			<json:property name="modeloFacturacion" value="${cicloRecExp.modeloFacturacion.nombre}"/>
			<json:property name="agencia" value="${cicloRecExp.agencia.nombre}"/>
			<json:property name="motivoBaja" value="${cicloRecExp.motivoBaja.descripcion}"/>
		</json:object>
	</json:array>
</fwk:json>