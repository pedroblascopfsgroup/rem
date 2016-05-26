<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:json>
	<json:array name="listado" items="${listado}" var="rec">
	<json:object>
		<json:property name="id" value="${rec.id}"/>
		<c:if test="${rec.procedimiento != null}">
			<json:property name="procedimiento" value="${rec.procedimiento.nombreProcedimiento}"/>
		</c:if>
		<c:if test="${rec.estado != null}">
			<json:property name="estado" value="${rec.estado.descripcion}"/>
		</c:if>
		<json:property name="tipoGenerico" value="Genérico"/>
		<c:if test="${rec.tipoCobroPago != null}">
			<json:property name="tipoCobro" value="${rec.tipoCobroPago.descripcion}"/>
		</c:if>
		<c:if test="${rec.subTipo != null}">
			<json:property name="subTipo" value="${rec.subTipo.descripcion}"/>
		</c:if>
		<json:property name="importe" value="${rec.importe}"/>
		<json:property name="fecha" >
			<fwk:date value="${rec.fecha}"/>
		</json:property>
		<json:property name="fechaValor" >
			<fwk:date value="${rec.fechaValor}"/>
		</json:property>
		<c:if test="${rec.origenCobro != null}">
			<json:property name="origenCobro" value="${rec.origenCobro.descripcion}"/>
		</c:if>
		<c:if test="${rec.modalidadCobro != null}">
			<json:property name="modalidadCobro" value="${rec.modalidadCobro.descripcion}"/>
		</c:if>
		<json:property name="observaciones" value="${rec.observaciones}"/>
		<json:property name="revisado" value="${rec.revisado}"/>
		<c:if test="${rec.tipoImputacion != null}">
			<json:property name="tipoImputacion" value="${rec.tipoImputacion.codigo}"/>
		</c:if>
		<json:property name="codigoCobro" value="${rec.codigoCobro}"/>
		<json:property name="impuestos" value="${rec.impuestos}"/>
		<json:property name="interesesOrdinarios" value="${rec.interesesOrdinarios}"/>
		<json:property name="interesesMoratorios" value="${rec.interesesMoratorios}"/>
		<json:property name="capital" value="${rec.capital}"/>
		<json:property name="capitalNoVencido" value="${rec.capitalNoVencido}"/>
		<json:property name="comisiones" value="${rec.comisiones}"/>
		<json:property name="nominal" value="${rec.capital + rec.capitalNoVencido}"/>
		<json:property name="totalEntrega" value="${rec.capital + rec.capitalNoVencido + rec.interesesOrdinarios + rec.interesesMoratorios + rec.impuestos}"/>
		<json:property name="gastosProcurador" value="${rec.gastosProcurador}"/>
		<json:property name="gastosAbogado" value="${rec.gastosAbogado}"/>
		<json:property name="gastosOtros" value="${rec.gastosOtros}"/>
		<json:property name="gastos" value="${rec.gastos}"/>
		<c:if test="${rec.tipoEntrega != null}">
			<json:property name="tipoEntrega" value="${rec.tipoEntrega.descripcion}"/>
		</c:if>
		<json:property name="conceptoEntrega" value="${rec.conceptoEntrega}"/>
		
	</json:object>
	</json:array>
</fwk:json>
