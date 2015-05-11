<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:property name="total" value="${recibos.totalCount}" />
	<json:array name="recibos" items="${recibos.results}" var="recibo">
		<json:object>
			<json:property name="id" value="${recibo.id}"/>
			<json:property name="idContrato" value="${recibo.contrato.id}"/>
			<json:property name="codigoEntidad" value="${recibo.codigoEntidad}"/>
			<json:property name="codigoRecibo" value="${recibo.codigoRecibo}"/>
			<json:property name="fechaVencimiento">
				<fwk:date value="${recibo.fechaVencimiento}"/>
			</json:property>
			<json:property name="fechaFacturacion">
				<fwk:date value="${recibo.fechaFacturacion}"/>
			</json:property>
			<json:property name="ccDomiciliacion" value="${recibo.ccDomiciliacion}"/>
			<json:property name="DDtipoRecibo" value="${recibo.tipoRecibo.descripcion}"/>	
			<json:property name="tipoInteres" value="${recibo.tipoInteres}"/>
			<json:property name="importeRecibo" value="${recibo.importeRecibo}"/>
			<json:property name="importeImpagado" value="${recibo.importeImpagado}"/>
			<json:property name="capital" value="${recibo.capital}"/>
			<json:property name="interesesOrdinarios" value="${recibo.interesesOrdinarios}"/>
			<json:property name="interesesMoratorios" value="${recibo.interesesMoratorios}"/>
			<json:property name="comisiones" value="${recibo.comisiones}"/>
			<json:property name="gastosNoCobrados" value="${recibo.gastosNoCobrados}"/>
			<json:property name="impuestos" value="${recibo.impuestos}"/>
			<json:property name="DDsituacionRecibo" value="${recibo.situacionRecibo.descripcion}"/>
			<json:property name="DDmotivoDevolucion" value="${recibo.motivoDevolucion.descripcion}"/>
			<json:property name="DDmotivoRechazo" value="${recibo.motivoRechazo.descripcion}"/>
			<json:property name="fechaExtraccion">
				<fwk:date value="${recibo.fechaExtraccion}"/>
			</json:property>
			<json:property name="fechaDato">
				<fwk:date value="${recibo.fechaDato}"/>
			</json:property>
			<json:property name="charExtra1" value="${recibo.charExtra1}"/>
			<json:property name="charExtra2" value="${recibo.charExtra2}"/>
			<json:property name="flagExtra1" value="${recibo.flagExtra1}"/>
			<json:property name="flagExtra2" value="${recibo.flagExtra2}"/>
			<json:property name="dateExtra1" value="${recibo.dateExtra1}"/>
			<json:property name="dateExtra2" value="${recibo.dateExtra2}"/>
			<json:property name="floatExtra1" value="${recibo.floatExtra1}"/>
			<json:property name="floatExtra2" value="${recibo.floatExtra2}"/>		
		</json:object>
	</json:array>
</fwk:json>