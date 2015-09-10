<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:array name="solicitudesDocumento" items="${solicitudesDocumento}" var="s">
        <json:object>
        	<json:property name="idIdentificativo" value="${s.idIdentificativo}" />
            <json:property name="id" value="${s.id}" />
            <json:property name="idDoc" value="${s.idDoc}" />
            <json:property name="esDocumento" value="${s.esDocumento}" />
            <json:property name="tieneSolicitud" value="${s.tieneSolicitud}" />
            <json:property name="codigoEstadoDocumento" value="${s.codigoEstadoDocumento}" />            
            <json:property name="contrato" value="${s.contrato}" />    
            <json:property name="descripcionUG" value="${s.descripcionUG}" />
     		<json:property name="tipoDocumento" value="${s.tipoDocumento}" />            
            <json:property name="estado" value="${s.estado}" />
            <json:property name="adjunto" value="${s.adjunto}" />
            <json:property name="ejecutivo" value="${s.ejecutivo}" />
            <json:property name="tipoActor" value="${s.tipoActor}" />
            <json:property name="actor" value="${s.actor}" />
            <json:property name="fechaSolicitud" value="${s.fechaSolicitud}" />
            <json:property name="fechaResultado" value="${s.fechaResultado}" />
            <json:property name="fechaEnvio" value="${s.fechaEnvio}" />
            <json:property name="fechaRecepcion" value="${s.fechaRecepcion}" />
            <json:property name="resultado" value="${s.resultado}" />
            <json:property name="comentario" value="${s.comentario}" />
            <json:property name="solicitante" value="${s.solicitante}" />
        </json:object>
    </json:array>
</fwk:json> 

