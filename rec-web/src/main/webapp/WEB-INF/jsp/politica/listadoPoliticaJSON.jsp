<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  
 
<fwk:json>
    <json:array name="politicas" items="${cicloPoliticas}" var="c">
        <json:object>
            <json:property name="id" value="${c.id}" />
            <json:property name="idUltimaPolitica" value="${c.ultimaPolitica.id}" />            
            <json:property name="fecha"><fwk:date value="${c.auditoria.fechaCrear}"/></json:property>
            <json:property name="estado" value="${c.ultimaPolitica.estadoPolitica.descripcion}" />
            <json:property name="tipo" value="${c.ultimaPolitica.tipoPolitica.descripcion}" />
            <json:property name="motivo" value="${c.ultimaPolitica.motivo.descripcion}" />
            <json:property name="objetivos" value="${c.ultimaPolitica.cantidadObjetivos}" />
            <json:property name="objCumplidos" value="${c.ultimaPolitica.cantidadObjetivosCumplidos}" />
            <json:property name="objIncumplidos" value="${c.ultimaPolitica.cantidadObjetivosIncumplidos}" />
            <json:property name="propuesta" value="${c.ultimaPolitica.esPropuesta}" />
            <json:property name="propuestaSuperusuario" value="${c.ultimaPolitica.esPropuestaSuperusuario}" />
			<json:property name="idAnalisis" value="${c.analisisPersonaPolitica.id}"/>
			<json:property name="idExpediente" value="${c.expediente.id}" />
        </json:object>
    </json:array>
</fwk:json>  