<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<fwk:json>
    <json:array name="atipicosContratos" items="${atipicosContratos}" var="item">   
        <json:object>
            <json:property name="id" value="${item.id}"/>
        	<json:property name="fechaDato">
        		<fwk:date value="${item.fechaDato}"/>
    		</json:property>    		
            <json:property name="codigo" value="${item.codigo}"/>
        	<json:property name="tipoAtipicoContrato" value="(${item.tipoAtipicoContrato.codigo}) ${item.tipoAtipicoContrato.descripcion}"/>
        	<json:property name="importe" value="${item.importe}"/>
        	<json:property name="fechaValor">
        		<fwk:date value="${item.fechaValor}"/>
    		</json:property>
    		<json:property name="motivoAtipicoContrato" value="(${item.motivoAtipicoContrato.codigo}) ${item.motivoAtipicoContrato.descripcion}"/>
        </json:object>
    </json:array>
</fwk:json>