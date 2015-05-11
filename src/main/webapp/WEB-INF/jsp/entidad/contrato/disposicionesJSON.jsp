<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${disposiciones.totalCount}" />
	<json:array name="disposiciones" items="${disposiciones.results}" var="disposicion">
		<json:object>
			<json:property name="id" value="${disposicion.id}"/>
			<json:property name="idContrato" value="${disposicion.contrato.id}"/>
			<json:property name="codigoEntidad" value="${disposicion.codigoEntidad}"/>
			<json:property name="codigoDisposicion" value="${disposicion.codigoDisposicion}"/>
			<json:property name="DDtipoDisposicion" value="${disposicion.tipoDisposicion.descripcion}"/>	
			<json:property name="DDsubTipoDisposicion" value="${disposicion.subTipoDisposicion.descripcion}"/>	
			<json:property name="DDsituacionDisposicion" value="${disposicion.situacionDisposicion.descripcion}"/>
			<json:property name="DDmoneda" value="${disposicion.moneda.descripcion}"/>
			<json:property name="importe" value="${disposicion.importe}"/>
			<json:property name="capital" value="${disposicion.capital}"/>
			<json:property name="interesesOrdinarios" value="${disposicion.interesesOrdinarios}"/>
			<json:property name="interesesMoratorios" value="${disposicion.interesesMoratorios}"/>
			<json:property name="comisiones" value="${disposicion.comisiones}"/>
			<json:property name="gastosNoCobrados" value="${disposicion.gastosNoCobrados}"/>
			<json:property name="impuestos" value="${disposicion.impuestos}"/>
			<json:property name="fechaVencimiento">
				<fwk:date value="${disposicion.fechaVencimiento}"/>
			</json:property>
			<json:property name="fechaExtraccion">
				<fwk:date value="${disposicion.fechaExtraccion}"/>
			</json:property>
			<json:property name="fechaDato">
				<fwk:date value="${disposicion.fechaDato}"/>
			</json:property>
			<json:property name="charExtra1" value="${disposicion.charExtra1}"/>
			<json:property name="charExtra2" value="${disposicion.charExtra2}"/>
			<json:property name="flagExtra1" value="${disposicion.flagExtra1}"/>
			<json:property name="flagExtra2" value="${disposicion.flagExtra2}"/>
			<json:property name="dateExtra1" value="${disposicion.dateExtra1}"/>
			<json:property name="dateExtra2" value="${disposicion.dateExtra2}"/>
			<json:property name="numExtra1" value="${disposicion.numExtra1}"/>
			<json:property name="numExtra2" value="${disposicion.numExtra2}"/>		
		</json:object>
	</json:array>
</fwk:json>