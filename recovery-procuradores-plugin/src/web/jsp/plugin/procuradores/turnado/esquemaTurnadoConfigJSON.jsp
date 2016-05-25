<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<fwk:json>
	 <json:array name="rangosEsquema" items="${rangosEsquema}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="plaza" value="${d.esquemaPlazasTpo.tipoPlaza.descripcion}"/>
            <json:property name="tipoProcedimiento" value="${d.esquemaPlazasTpo.tipoProcedimiento.descripcion}"/>
            <json:property name="importeDesde" value="${d.importeDesde}"/>
            <json:property name="importeHasta" value="${d.importeHasta}"/>
            <json:property name="despacho" value="${d.usuario.username}"/>
            <json:property name="porcentaje" value="${d.porcentaje}"/>
        </json:object>
    </json:array>
    <json:array name="plazasEsquema" items="${plazasEsquema}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="codigo" value="${d.codigo}"/>
            <json:property name="descripcion" value="${d.descripcion}"/>
        </json:object>
    </json:array>
    <json:array name="tipoProcedimientos" items="${tipoProcedimientos}" var="d">
        <json:object>
            <json:property name="id" value="${d.id}"/>
            <json:property name="codigo" value="${d.codigo}"/>
            <json:property name="descripcion" value="${d.descripcion}"/>
        </json:object>
    </json:array>
    <json:array name="idTuplas" items="${idTuplas}" var="d">
        <json:object>
            <json:property name="idTupla" value="${d}"/>
        </json:object>
    </json:array>
    <json:property name="resultado" value="${resultado}"/>
</fwk:json>