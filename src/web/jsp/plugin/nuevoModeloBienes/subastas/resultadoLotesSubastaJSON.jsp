<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
	<json:property name="total" value="${lotes.totalCount}" />
    <json:array name="lotes" items="${lotes.results}" var="lote">
        <json:object>
            <json:property name="idLote" value="${lote.loteSubasta.id}" />
            <json:property name="idSubasta" value="${lote.loteSubasta.subasta.id}" />
            <json:property name="idAsunto" value="${lote.loteSubasta.subasta.asunto.id}" />
            <json:property name="nombreAsunto" value="${lote.loteSubasta.subasta.asunto.nombre}" />
            <json:property name="operacion" value="${lote.loteSubasta.subasta.contratoGeneral.descripcion} (${fn:length(lote.loteSubasta.subasta.procedimiento.procedimientosContratosExpedientes)})" /> 
            <json:property name="fechaSubasta">
            	<fwk:date value="${lote.loteSubasta.subasta.fechaSenyalamiento}"/>
            </json:property>
            <json:property name="oficina" value="${lote.loteSubasta.subasta.contratoGeneral.oficina.codigoOficina}" />
           	<json:property name="centro" value="${lote.centroGestorString}" />
            <json:property name="tipoSubasta" value="${lote.loteSubasta.subasta.tipoSubasta.descripcion}" />
            <json:property name="deudaJudicial" value="${lote.loteSubasta.deudaJudicial}" />
            <json:property name="pujaSin" value="${lote.loteSubasta.insPujaSinPostores}" />
            <json:property name="pujaConDesde" value="${lote.loteSubasta.insPujaPostoresDesde}" />
            <json:property name="pujaConHasta" value="${lote.loteSubasta.insPujaPostoresHasta}" />
            <json:property name="valorSubasta" value="${lote.loteSubasta.valorBienes}" />
            <json:property name="numActivos" value="${fn:length(lote.loteSubasta.bienes)}" />
            <json:property name="tasacionActiva" value="${lote.loteSubasta.tasacionActiva}" />
            <json:property name="riesgoConsignacion" value="${lote.loteSubasta.riesgoConsignacion}" />
            <json:property name="cargas" value="${lote.loteSubasta.tieneCargasAnteriores}" />
            <json:property name="estado" value="${lote.loteSubasta.estado.descripcion}" />
            <json:property name="estadoCodigo" value="${lote.loteSubasta.estado.codigo}" />
        </json:object>
    </json:array>
</fwk:json> 

