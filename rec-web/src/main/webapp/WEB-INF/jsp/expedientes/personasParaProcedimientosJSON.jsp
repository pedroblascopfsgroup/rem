<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
         <json:array name="clientes" items="${procedimientoPersonas}" var="pp">
                <json:object>
                    <json:property name="id" value="${pp.persona.id}" />
                    <json:property name="nombre" value="${pp.persona.nombre}" />
                    <json:property name="apellido1" value="${pp.persona.apellido1}" />
                    <json:property name="apellido2" value="${pp.persona.apellido2}" />
                    <json:property name="deudaIrregular" value="${pp.persona.riesgoTotal}" />
                    <json:property name="totalSaldo" value="${pp.persona.totalSaldo}" />
                    <json:property name="asiste" value="${pp.asiste}" />
                    <json:property name="cntId" value="${pp.cntId}" />
     			</json:object>
        </json:array>
</fwk:json>
