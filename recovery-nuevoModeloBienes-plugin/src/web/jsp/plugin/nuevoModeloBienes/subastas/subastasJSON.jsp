<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:array name="subastas" items="${subastas}" var="s">
        <json:object>
            <json:property name="id" value="${s.id}" />
            <json:property name="numAutos" value="${s.procedimiento.codigoProcedimientoEnJuzgado}" />
            <json:property name="idProcedimiento" value="${s.procedimiento.id}" />
            <json:property name="prcDescripcion" value="${s.procedimiento.nombreProcedimiento}" />
            <json:property name="tipo" value="${s.tipoSubasta.descripcion}" />
            <json:property name="fechaSolicitud" >
            	<fwk:date value="${s.fechaSolicitud}" />
            </json:property>
            <json:property name="fechaAnuncio" >
            	<fwk:date value="${s.fechaAnuncio}" />
            </json:property>
            <json:property name="fechaSenyalamiento" >
            	<fwk:date value="${s.fechaSenyalamiento}" />
            </json:property>
            <json:property name="codEstadoSubasta" value="${s.estadoSubasta.codigo}" />
            <json:property name="estadoSubasta" value="${s.estadoSubasta.descripcion}" />
            <json:property name="resultadoComite" value="${s.resultadoComite.descripcion}" />
            <json:property name="motivoSuspension" value="${s.motivoSuspension.descripcion}" />
            
            <json:property name="tasacion" value="${s.tasacion}" />
            <json:property name="infoLetrado" value="${s.infoLetrado}" />
            <json:property name="instrucciones" value="${s.instrucciones}" />
            <json:property name="subastaRevisada" value="${s.subastaRevisada}" />
        </json:object>
    </json:array>
</fwk:json> 

