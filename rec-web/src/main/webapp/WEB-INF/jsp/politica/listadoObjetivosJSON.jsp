<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
    <json:array name="objetivos" items="${objetivos}" var="o">
        <json:object>
            <json:property name="id" value="${o.id}" />
            <json:property name="idPolitica" value="${o.politica.id}" />
            <%--<json:property name="padreId" value="${o.objetivoPadre.id}" />--%>            
            <json:property name="resumen" value="${o.resumen}" />
            <json:property name="observacion" value="${o.observacion}" />
            <json:property name="tipo" value="${o.tipoObjetivo.descripcion}" />
			<json:property name="tipoAutomatico" value="${o.tipoObjetivo.automatico}" />
            <json:property name="estadoObjetivo" value="${o.estadoObjetivo.descripcion}" />
            <json:property name="estadoCumplimiento" value="${o.estadoCumplimiento.descripcion}" />
            <json:property name="justificacion" value="${o.justificacion}" />
            <json:property name="fechaLimite">
				<fwk:date value="${o.fechaLimite}" />
			</json:property>
<%--             <json:property name="fechaLimite" value="${o.fechaLimite}" /> --%>
			<json:property name="estadoObjetivo" value="${o.estadoObjetivo.descripcion}" />
            <json:property name="estaPendiente" value="${o.estaPendiente}" />
            <json:property name="esRechazable" value="${o.definidoEstadoAnterior}" />
			<json:property name="estaIncumplido" value="${o.estaIncumplido}" />
			<json:property name="estaPropuesto" value="${o.estaPropuesto}" />
			<json:property name="estaConfirmado" value="${o.estaConfirmado}" />
			<json:property name="estaPoliticaVigente" value="${o.politica.esVigente}" />
			<json:property name="estaPoliticaPropuesta" value="${o.politica.esPropuesta}" />
			<json:property name="estaPoliticaPropuestaSuperusuario" value="${o.politica.esPropuestaSuperusuario}" />
        </json:object>
    </json:array>
</fwk:json>  
