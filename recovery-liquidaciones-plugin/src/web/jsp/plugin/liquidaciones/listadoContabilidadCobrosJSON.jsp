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
		<json:property name="fechaEntrega" value="${rec.fechaEntrega}"/>
		<json:property name="fechaValor" value="${rec.fechaValor}"/>
		<json:property name="tipoEntrega" value="${rec.tipoEntrega.descripcion}"/>
		<json:property name="conceptoEntrega" value="${rec.conceptoEntrega.descripcion}"/>
		<json:property name="nominal" value="${rec.nominal}"/>
		<json:property name="intereses" value="${rec.intereses}"/>
		<json:property name="demoras" value="${rec.demoras}"/>
		<json:property name="impuestos" value="${rec.impuestos}"/>
		<json:property name="gastosProcurador" value="${rec.gastosProcurador}"/>
		<json:property name="gastosLetrado" value="${rec.gastosLetrado}"/>
		<json:property name="otrosGastos" value="${rec.otrosGastos}"/>
		<json:property name="quitaNominal" value="${rec.quitaNominal}"/>
		<json:property name="quitaIntereses" value="${rec.quitaIntereses}"/>
		<json:property name="quitaDemoras" value="${rec.quitaDemoras}"/>
		<json:property name="quitaImpuestos" value="${rec.quitaImpuestos}"/>
		<json:property name="quitaGastosProcurador" value="${rec.quitaGastosProcurador}"/>
		<json:property name="quitaGastosLetrado" value="${rec.quitaGastosLetrado}"/>
		<json:property name="quitaOtrosGastos" value="${rec.quitaOtrosGastos}"/>
		<json:property name="totalEntrega" value="${rec.totalEntrega}"/>
		<json:property name="numEnlace" value="${rec.numEnlace}"/>
		<json:property name="numMandamiento" value="${rec.numMandamiento}"/>
		<json:property name="numCheque" value="${rec.numCheque}"/>
		<json:property name="observaciones" value="${rec.observaciones}"/>
		<json:property name="asunto" value="${rec.asunto}"/>
		<json:property name="operacionesTramite" value="${rec.operacionesTramite}"/>
		<json:property name="usuarioCrear" value="${rec.auditoria.usuarioCrear}"/>
		<json:property name="totalQuita" value="${rec.totalQuita}"/>
		<json:property name="quitaOperacionesEnTramite" value="${rec.quitaOperacionesEnTramite}"/>
		<json:property name="operacionesEnTramite" value="${rec.operacionesEnTramite}"/>
		
	</json:object>
	</json:array>
</fwk:json>
