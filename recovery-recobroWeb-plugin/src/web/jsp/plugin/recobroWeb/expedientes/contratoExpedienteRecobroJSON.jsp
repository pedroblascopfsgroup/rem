<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>  

<fwk:json>
	<json:array name="contratos" items="${contratosRecobro}" var="c">
		<json:object>
			<json:property name="id" value="${c.expedienteContrato.contrato.id}"/>
			<json:property name="pase" value="${c.expedienteContrato.pase}"/>
            <json:property name="vencido" value="${c.expedienteContrato.contrato.vencido}" />
            <json:property name="cc" value="${c.expedienteContrato.contrato.codigoContrato}" />

            <json:property name="fechaDato" value="${c.expedienteContrato.contrato.fechaDato}" />

            <json:property name="tipo" value="${c.expedienteContrato.contrato.tipoProductoEntidad.descripcion}" />
            <json:property name="diasIrregular" value="${c.expedienteContrato.contrato.diasIrregular}" />
                        <json:property name="estadoFinanciero" value="${c.expedienteContrato.contrato.estadoFinanciero.descripcion}" />
            
            <json:property name="saldoNoVencido" value="${c.expedienteContrato.contrato.lastMovimiento.posVivaNoVencidaAbsoluta}" />
            <json:property name="saldoIrregular" value="${c.expedienteContrato.contrato.lastMovimiento.posVivaVencidaAbsoluta}" />
            <json:property name="saldoPasivo" value="${c.expedienteContrato.contrato.lastMovimiento.saldoPasivo}" />                    
            <json:property name="idPersona" value="${c.expedienteContrato.contrato.contratoPersonaOrdenado[0].persona.id}" />
            <%--<json:property name="tipointerv" value="${c.expedienteContrato.contrato.contratoPersonaOrdenado[0].tipoIntervencion.descripcion} ${c.contratoPersonaOrdenado[0].orden}" />
            <json:property name="otrosint" value="${c.expedienteContrato.contrato.contratoPersonaOrdenado[0].persona.apellidoNombre}" />
            <json:property name="apellido1" value="${c.expedienteContrato.contrato.contratoPersonaOrdenado[0].persona.apellido1}" />
            <json:property name="apellido2" value="${c.expedienteContrato.contrato.contratoPersonaOrdenado[0].persona.apellido2}" />--%>

            <json:property name="fechaExtraccion" value="${c.expedienteContrato.contrato.fechaExtraccion}" />

            <json:property name="moneda" value="${c.expedienteContrato.contrato.moneda.descripcion}" />

            <json:property name="fechaPosVendida" value="${c.expedienteContrato.contrato.lastMovimiento.fechaPosVencida}" />

            <json:property name="saldoDudoso" value="${c.expedienteContrato.contrato.lastMovimiento.saldoDudoso}" />

            <json:property name="fechaDudoso" value="${c.expedienteContrato.contrato.lastMovimiento.fechaDudoso}" />

            <json:property name="estadoFinancieroAnt" value="${c.expedienteContrato.contrato.estadoFinancieroAnterior.descripcion}" />

            <json:property name="fechaEstadoFinanciero" value="${c.expedienteContrato.contrato.fechaEstadoFinanciero}" />

            <json:property name="fechaEstadoFinancieroAnt" value="${c.expedienteContrato.contrato.fechaEstadoFinancieroAnterior}" />

            <json:property name="provision" value="${c.expedienteContrato.contrato.lastMovimiento.provision}" />
            <json:property name="estadoContrato" value="${c.expedienteContrato.contrato.estadoContrato.descripcion}" />

            <json:property name="fechaEstadoContrato" value="${c.expedienteContrato.contrato.fechaEstadoContrato}" />

            <json:property name="movIntRemuneratorios" value="${c.expedienteContrato.contrato.lastMovimiento.movIntRemuneratorios}" />
                 <json:property name="movIntMoratorios" value="${c.expedienteContrato.contrato.lastMovimiento.movIntMoratorios}" />
            <json:property name="comisiones" value="${c.expedienteContrato.contrato.lastMovimiento.comisiones}" />
            <json:property name="gastos" value="${c.expedienteContrato.contrato.lastMovimiento.gastos}" />

            <json:property name="fechaCreacion" value="${c.expedienteContrato.contrato.fechaCreacion}" />
                  
          	<json:array name="ciclosRecobroContrato" items="${c.ciclosRecobroContrato}" var="ciclo">
				<json:object>         	
					<json:property name="idCiclo" value="${ciclo.id}"/>
					<json:property name="fechaCesion" value= "${ciclo.fechaAlta}" />

					<json:property name="agencia" value="${ciclo.cicloRecobroExpediente.agencia.nombre}"/>
					<json:property name="cartera" value="${ciclo.cicloRecobroExpediente.carteraEsquema.cartera.nombre}"/>
					<json:property name="RDCedido" value="${ciclo.posVivaNoVencida}"/>
					<json:property name="RICedido" value="${ciclo.posVivaVencida}"/>
					<json:property name="fechaFin" value="${ciclo.fechaBaja}" />
					<json:property name="motivoFin" value="${ciclo.motivoBaja.descripcion}"/>
				</json:object>
			</json:array>	
		</json:object>
	</json:array>
</fwk:json>