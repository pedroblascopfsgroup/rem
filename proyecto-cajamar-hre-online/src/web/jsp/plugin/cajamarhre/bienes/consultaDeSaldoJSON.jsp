<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
   	<json:property name="isError" value="${resultado.isError()}" />
   	<json:property name="codigoError" value="${resultado.getCodigoError()}" />
   	<json:property name="mensajeError" value="${resultado.getMensajeError()}" />
   	<json:property name="claseApp" value="${resultado.getClaseApp()}" />
   	<json:property name="excedido" value="${resultado.getExcedido()}" />
   	<json:property name="fechaImpago" value="${resultado.getFechaImpago()}" />
   	<json:property name="numCuenta" value="${resultado.getNumCuenta()}" />
   	<json:property name="oficina" value="${resultado.getOficina()}" />
   	<json:property name="riesgoGlobal" value="${resultado.getRiesgoGlobal()}" />
   	<json:property name="saldoAct" value="${resultado.getSaldoAct()}" />
   	<json:property name="saldoGastos" value="${resultado.getSaldoGastos()}" />
   	<json:property name="saldoRetenido" value="${resultado.getSaldoRetenido()}" />
   	<json:property name="estado" value="${resultado.getEstado()}" />
</fwk:json> 

