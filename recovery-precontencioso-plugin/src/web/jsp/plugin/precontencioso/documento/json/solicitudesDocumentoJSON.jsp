<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="pfsformat" tagdir="/WEB-INF/tags/pfs/format"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<fwk:json>
    <json:array name="solicitudesDocumento" items="${solicitudesDocumento}" var="s">
        <json:object>
            <json:property name="id" value="${s.id}" />
            <json:property name="idDoc" value="${s.idDoc}" />
            <json:property name="contrato" value="${s.contrato}" />    
            <json:property name="descripcionUG" value="${s.descripcionUG}" />
     		<json:property name="tipoDocumento" value="${s.tipoDocumento}" />            
            <json:property name="estado" value="${s.estado}" />
            <json:property name="adjunto" value="${s.adjunto}" />
            <json:property name="actor" value="${s.actor}" />
            <json:property name="fechaSolicitud" >
            	<fwk:date value="${s.fechaSolicitud}" />
            </json:property>
            <json:property name="fechaResultado" >
            	<fwk:date value="${s.fechaResultado}" />
            </json:property>                                    
            <json:property name="fechaEnvio" >
            	<fwk:date value="${s.fechaEnvio}" />
            </json:property>                                    
            <json:property name="fechaRecepcion" >
            	<fwk:date value="${s.fechaRecepcion}" />
            </json:property>                                    
            <json:property name="resultado" value="${s.resultado}" />
            <json:property name="comentario" value="${s.comentario}" />
        </json:object>
    </json:array>
</fwk:json> 

