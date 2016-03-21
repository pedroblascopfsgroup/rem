<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
        <json:array name="contratos" items="${procedimiento.expedienteContratos}" var="ec">    
                <json:object>
                    <json:property name="idContrato" value="${ec.contrato.id}" />
                    <json:property name="vencido" value="${ec.contrato.vencido}" />
                    <json:property name="cc" value="${ec.contrato.codigoContrato}" />
                    <json:property name="tipo" value="${ec.contrato.tipoProducto.descripcion}" />
                    <json:property name="diasIrregular" value="${ec.contrato.diasIrregular}" />
                    <json:property name="saldoNoVencido" value="${ec.contrato.lastMovimiento.posVivaNoVencidaAbsoluta}" />
                    <json:property name="saldoIrregular" value="${ec.contrato.lastMovimiento.posVivaVencidaAbsoluta}" />
                    <json:property name="idPersona" value="${ec.contrato.contratoPersonaOrdenado[0].persona.id}" />
                    <json:property name="tipointerv" value="${ec.contrato.contratoPersonaOrdenado[0].tipoIntervencion.descripcion} ${ec.contrato.contratoPersonaOrdenado[0].orden}" />
                    <json:property name="otrosint" value="${ec.contrato.contratoPersonaOrdenado[0].persona.apellidoNombre}" />
                    <json:property name="apellido1" value="${ec.contrato.contratoPersonaOrdenado[0].persona.apellido1}" />
                    <json:property name="apellido2" value="${ec.contrato.contratoPersonaOrdenado[0].persona.apellido2}" />
                    <json:property name="fechaExtraccion">
                        <fwk:date value="${ec.contrato.fechaExtraccion}" />
                    </json:property>
                    <json:property name="moneda" value="${ec.contrato.moneda.descripcion}" />
                    <json:property name="fechaPosVendida">
                        <fwk:date value="${ec.contrato.lastMovimiento.fechaPosVencida}" />
                    </json:property>
                    <json:property name="saldoDudoso" value="${ec.contrato.lastMovimiento.saldoDudoso}" />
                    <json:property name="fechaDudoso">
                        <fwk:date value="${ec.contrato.lastMovimiento.fechaDudoso}" />
                    </json:property>
                    <json:property name="estadoFinanciero" value="${ec.contrato.estadoFinanciero.descripcion}" />
                    <json:property name="estadoFinancieroAnt" value="${ec.contrato.estadoFinancieroAnterior.descripcion}" />
                    <json:property name="fechaEstadoFinanciero">
                        <fwk:date value="${ec.contrato.fechaEstadoFinanciero}" />
                    </json:property>
                    <json:property name="fechaEstadoFinancieroAnt">
                        <fwk:date value="${ec.contrato.fechaEstadoFinancieroAnterior}" />
                    </json:property>
                    <json:property name="provision" value="${ec.contrato.lastMovimiento.provision}" />
                    <json:property name="estadoContrato" value="${ec.contrato.estadoContrato.descripcion}" />
                    <json:property name="fechaEstadoContrato">
                        <fwk:date value="${ec.contrato.fechaEstadoContrato}" />
                    </json:property>
                    <json:property name="movIntRemuneratorios" value="${ec.contrato.lastMovimiento.movIntRemuneratorios}" />
                    <json:property name="movIntMoratorios" value="${ec.contrato.lastMovimiento.movIntMoratorios}" />
                    <json:property name="comisiones" value="${ec.contrato.lastMovimiento.comisiones}" />
                    <json:property name="gastos" value="${ec.contrato.lastMovimiento.gastos}" />
                    <json:property name="fechaCreacion">
                        <fwk:date value="${ec.contrato.fechaCreacion}" />
                    </json:property> 
                    <json:property name="titulizado" value="${ec.contrato.titulizado}" />
                    <c:if test="${ec.contrato.titulizado==1}">
                    	<json:property name="fondo" value="${ec.contrato.fondo}" />
                    </c:if>                               
                </json:object>               
        </json:array>
</fwk:json>