<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<fwk:json>
        <c:set var="total" value="0"/>
        <json:array name="contratos" items="${pagina.results}" var="c">
        		<c:set var="total" value="${total + 1}"/>    
                <json:object>
                	<json:property name="id" value="${c[0].id}" />
                    <json:property name="vencido" value="${c[0].vencido}" />
                    <json:property name="cc" value="${c[0].codigoContrato}" />
                    <json:property name="fechaDato">
                        <fwk:date value="${c[0].fechaDato}" />
                    </json:property>
                    <json:property name="tipo" value="${c[0].tipoProductoEntidad.descripcion}" />
                    <json:property name="diasIrregular" value="${c[0].diasIrregular}" />
                    <json:property name="saldoNoVencido" value="${c[0].lastMovimiento.posVivaNoVencidaAbsoluta}" />
                    <json:property name="saldoIrregular" value="${c[0].lastMovimiento.posVivaVencidaAbsoluta}" />
                    <json:property name="saldoPasivo" value="${c[0].lastMovimiento.saldoPasivo}" />                    
                    <json:property name="idPersona" value="${c[0].contratoPersonaOrdenado[0].persona.id}" />
                    <json:property name="tipointerv" value="${c[0].contratoPersonaOrdenado[0].tipoIntervencion.descripcion} ${c[0].contratoPersonaOrdenado[0].orden}" />
                    <json:property name="otrosint" value="${c[0].contratoPersonaOrdenado[0].persona.apellidoNombre}" />
                    <json:property name="apellido1" value="${c[0].contratoPersonaOrdenado[0].persona.apellido1}" />
                    <json:property name="apellido2" value="${c[0].contratoPersonaOrdenado[0].persona.apellido2}" />
                    <json:property name="fechaExtraccion">
                        <fwk:date value="${c[0].fechaExtraccion}" />
                    </json:property>
                    <json:property name="moneda" value="${c[0].moneda.descripcion}" />
                    <json:property name="fechaPosVendida">
                        <fwk:date value="${c[0].lastMovimiento.fechaPosVencida}" />
                    </json:property>
                    <json:property name="saldoDudoso" value="${c[0].lastMovimiento.saldoDudoso}" />
                    <json:property name="fechaDudoso">
                        <fwk:date value="${c[0].lastMovimiento.fechaDudoso}" />
                    </json:property>
                    <json:property name="estadoFinanciero" value="${c[0].estadoFinanciero.descripcion}" />
                    <json:property name="estadoFinancieroAnt" value="${c[0].estadoFinancieroAnterior.descripcion}" />
                    <json:property name="fechaEstadoFinanciero">
                        <fwk:date value="${c[0].fechaEstadoFinanciero}" />
                    </json:property>
                    <json:property name="fechaEstadoFinancieroAnt">
                        <fwk:date value="${c[0].fechaEstadoFinancieroAnterior}" />
                    </json:property>
                    <json:property name="provision" value="${c[0].lastMovimiento.provision}" />
                    <json:property name="estadoContrato" value="${c[0].estadoContrato.descripcion}" />
                    <json:property name="fechaEstadoContrato">
                        <fwk:date value="${c[0].fechaEstadoContrato}" />
                    </json:property>
                    <json:property name="movIntRemuneratorios" value="${c[0].lastMovimiento.movIntRemuneratorios}" />
                    <json:property name="movIntMoratorios" value="${c[0].lastMovimiento.movIntMoratorios}" />
                    <json:property name="comisiones" value="${c[0].lastMovimiento.comisiones}" />
                    <json:property name="gastos" value="${c[0].lastMovimiento.gastos}" />
                    <json:property name="fechaCreacion">
                        <fwk:date value="${c[0].fechaCreacion}" />
                    </json:property>      
                   	<c:if test="${c[1] == 1}">
	                	<json:property name="pase" value="Si" />
                	</c:if>
                	<json:property name="condEspec" value="${c[0].condicionesEspeciales}" />
                	
                                  
                </json:object>
                    <c:forEach items="${c[0].contratoPersonaOrdenado}" var="cp">
                        <c:if test="${cp.persona.id!=c[0].contratoPersonaOrdenado[0].persona.id}">
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