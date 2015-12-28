<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
        <c:set var="total" value="0"/>
        <json:array name="contratos" items="${pagina.results}" var="c">
        		<c:set var="total" value="${total + 1}"/>    
                <json:object>
                	<json:property name="id" value="${c.id}" />
                    <json:property name="vencido" value="${c.vencido}" />
                    <json:property name="cc" value="${c.codigoContrato}" />
                    <json:property name="fechaDato">
                        <fwk:date value="${c.fechaDato}" />
                    </json:property>
                    <json:property name="tipo" value="${c.tipoProductoEntidad.descripcion}" />
                    <json:property name="diasIrregular" value="${c.diasIrregular}" />
                    <json:property name="saldoNoVencido" value="${c.lastMovimiento.posVivaNoVencidaAbsoluta}" />
                    <json:property name="saldoIrregular" value="${c.lastMovimiento.posVivaVencidaAbsoluta}" />
                    <json:property name="saldoPasivo" value="${c.lastMovimiento.saldoPasivo}" />                    
                    <json:property name="idPersona" value="${c.contratoPersonaOrdenado[0].persona.id}" />
                    <json:property name="tipointerv" value="${c.contratoPersonaOrdenado[0].tipoIntervencion.descripcion} ${c.contratoPersonaOrdenado[0].orden}" />
                    <json:property name="otrosint" value="${c.contratoPersonaOrdenado[0].persona.apellidoNombre}" />
                    <json:property name="apellido1" value="${c.contratoPersonaOrdenado[0].persona.apellido1}" />
                    <json:property name="apellido2" value="${c.contratoPersonaOrdenado[0].persona.apellido2}" />
                    <json:property name="fechaExtraccion">
                        <fwk:date value="${c.fechaExtraccion}" />
                    </json:property>
                    <json:property name="moneda" value="${c.moneda.descripcion}" />
                    <json:property name="fechaPosVendida">
                        <fwk:date value="${c.lastMovimiento.fechaPosVencida}" />
                    </json:property>
                    <json:property name="saldoDudoso" value="${c.lastMovimiento.saldoDudoso}" />
                    <json:property name="fechaDudoso">
                        <fwk:date value="${c.lastMovimiento.fechaDudoso}" />
                    </json:property>
                    <json:property name="estadoFinanciero" value="${c.estadoFinanciero.descripcion}" />
                    <json:property name="estadoFinancieroAnt" value="${c.estadoFinancieroAnterior.descripcion}" />
                    <json:property name="fechaEstadoFinanciero">
                        <fwk:date value="${c.fechaEstadoFinanciero}" />
                    </json:property>
                    <json:property name="fechaEstadoFinancieroAnt">
                        <fwk:date value="${c.fechaEstadoFinancieroAnterior}" />
                    </json:property>
                    <json:property name="provision" value="${c.lastMovimiento.provision}" />
                    <json:property name="estadoContrato" value="${c.estadoContrato.descripcion}" />
                    <json:property name="fechaEstadoContrato">
                        <fwk:date value="${c.fechaEstadoContrato}" />
                    </json:property>
                    <json:property name="movIntRemuneratorios" value="${c.lastMovimiento.movIntRemuneratorios}" />
                    <json:property name="movIntMoratorios" value="${c.lastMovimiento.movIntMoratorios}" />
                    <json:property name="comisiones" value="${c.lastMovimiento.comisiones}" />
                    <json:property name="gastos" value="${c.lastMovimiento.gastos}" />
                    <json:property name="fechaCreacion">
                        <fwk:date value="${c.fechaCreacion}" />
                    </json:property>      
                   	<c:if test="${pagina.results[0].id==c.id}">
	                	<json:property name="pase" value="Si" />
                	</c:if>
                	<c:if test="${pagina.results[0].id!=c.id}">
	                	<json:property name="pase" value="" />
                	</c:if>
                	<json:property name="condEspec" value="${c.condicionesEspeciales}" />
                	
                                  
                </json:object>
                    <c:forEach items="${c.contratoPersonaOrdenado}" var="cp">
                        <c:if test="${cp.persona.id!=c.contratoPersonaOrdenado[0].persona.id}">
                        	<c:set var="total" value="${total + 1}"/>
                            <json:object>
                                <json:property name="idPersona" value="${cp.persona.id}" />
                                <json:property name="tipointerv" value="${cp.tipoIntervencion.descripcion} ${cp.orden}" />
                                <json:property name="otrosint" value="${cp.persona.apellidoNombre}" />
                                <json:property name="apellido1" value="${cp.persona.apellido1}" />
                                <json:property name="apellido2" value="${cp.persona.apellido2}" />
                                <json:property name="saldoNoVencido" value="---" />
                                <json:property name="saldoIrregular" value="---" />
                                <json:property name="saldoDudoso" value="---" />
                                <json:property name="provision" value="---" />
                                <json:property name="movIntRemuneratorios" value="---" />
                                <json:property name="movIntMoratorios" value="---" />
                                <json:property name="comisiones" value="---" />
                                <json:property name="gastos" value="---" />
                            </json:object>
                       </c:if>
                    </c:forEach>
                
        </json:array>
        <json:property name="total" value="${total}" />
</fwk:json>