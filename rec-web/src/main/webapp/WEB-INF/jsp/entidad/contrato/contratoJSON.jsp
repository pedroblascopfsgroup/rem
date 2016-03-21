<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:json>
  <json:property name="id" value="${contrato.id}" />
  <json:property name="nombreTab" value="${nombreTab}" />
  <json:object name="cabecera">
    <json:property name="primerTitular" value="${contrato.primerTitular}" />
    <%-- Se cambia el codigo de contrato por el nro. de contrato, ya que ahora esta todo el codigo en el campo CNT_CONTRATO --%>
    <json:property name="codigoContrato" value="${contrato.codigoContrato}" />
    <json:property name="tipoProducto">${contrato.tipoProductoEntidad.descripcion} (${contrato.tipoProductoEntidad.codigo}) </json:property>
    <json:property name="tipoProductoComercial">${contrato.catalogo1.descripcion} </json:property>
    <json:property name="primerTitular" value="${contrato.primerTitular.apellidoNombre}" />
    <json:property name="estadoContrato" value="${contrato.estadoContrato.descripcion}" />
    <json:property name="estadoContratoEntidad" value="${contrato.estadoContratoEntidad}" />
    <json:property name="fechaEstadoContrato" >
	<fwk:date value="${contrato.fechaEstadoContrato}"/>
    </json:property>
    <json:property name="fechaExtraccion" >
	<fwk:date value="${contrato.fechaExtraccion}"/>
    </json:property>
    <json:property name="fechaDato" >
	<fwk:date value="${contrato.fechaDato}"/>
    </json:property>    
    <json:property name="finalidadContrato" value="${contrato.finalidadContrato}" />
    <json:property name="finalidadAcuerdo" value="${contrato.finalidadAcuerdo}" />
    <json:property name="fechaCreacion" >
	<fwk:date value="${contrato.fechaCreacion}"/>
    </json:property>
    <json:property name="moneda" value="${contrato.moneda.descripcionLarga}" />
    <json:property name="posVivaNoVencida" value="${contrato.lastMovimiento.posVivaNoVencida}" />
    <json:property name="posVivaVencida" value="${contrato.lastMovimiento.posVivaVencida}" />
    <json:property name="fechaInicioPVV">
	<fwk:date value="${contrato.lastMovimiento.fechaPosVencida}"/>
    </json:property>
    <json:property name="saldoDudoso" value="${contrato.lastMovimiento.saldoDudoso}"/>
    <json:property name="fechaSaldoDudoso">
	 <fwk:date value="${contrato.lastMovimiento.fechaDudoso}"/>
    </json:property>
    <json:property name="estadoFinanciero">
	${contrato.estadoFinanciero.descripcion} (<fwk:date value="${contrato.fechaEstadoFinanciero}"/>)
    </json:property>
    <json:property name="estadoFinAnterior" >
	${contrato.estadoFinancieroAnterior.descripcion} (<fwk:date value="${contrato.fechaEstadoFinancieroAnterior}"/>)
    </json:property>
    <json:property name="riesgo" value="${contrato.lastMovimiento.riesgo}" />
    <json:property name="dispuesto" value="${contrato.lastMovimiento.dispuesto}" />
    <json:property name="saldoPasivo" value="${contrato.lastMovimiento.saldoPasivo}" />
    <json:property name="limiteInicial" value="${contrato.limiteInicial}" />
    <json:property name="limiteFinal" value="${contrato.limiteFinal}" />
    <json:property name="riesgoGarantizado" value="${contrato.lastMovimiento.riesgoGarantizado}" />
    <json:property name="saldoExcedido" value="${contrato.lastMovimiento.saldoExcedido}" />
    <json:property name="ltvInicial" value="${contrato.lastMovimiento.ltvInicial}" />
    <json:property name="ltvFinal" value="${contrato.lastMovimiento.ltvFinal}" />
    <json:property name="limiteDescubierto" value="${contrato.lastMovimiento.limiteDescubierto}" />
    <json:property name="garantia1" value="${contrato.garantia1.descripcion}" />
    <json:property name="garantia2" value="${contrato.garantia2.descripcion}" />
    <json:property name="fechaVencimiento" >
	<fwk:date value="${contrato.fechaVencimiento}"/>
    </json:property>
    <json:property name="entidadPropietaria" value="${contrato.codEntidadPropietaria}" />
<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
	<json:property name="entidadPropietaria">
		<fmt:formatNumber pattern="#0000">
			${contrato.codigoEntidad}
		</fmt:formatNumber>
	</json:property>
</sec:authorize>        
    <c:if test="${contrato.condicionesEspeciales=='000000000000000'}">
    	<json:property name="condEspec" value="" />
    </c:if>
    <c:if test="${contrato.condicionesEspeciales!='000000000000000'}">
    	<json:property name="condEspec" value="${contrato.condicionesEspeciales}" />
    </c:if>
    <json:property name="segmentoCartera" value="${contrato.segmentoCartera}" />    	
    <json:property name="ofiConta" value="${contrato.oficinaContable.nombre}" />
    <json:property name="ofiAdmin" value="${contrato.oficinaAdministrativa.nombre}" />
    <json:property name="cartera" value="**Pendiente de confirmar dato" />
    <json:property name="gestionEspecial" value="${contrato.gestionEspecial.descripcion}" />
    <json:property name="apliOrigen" value="${contrato.aplicativoOrigen.descripcion}" />
    <json:property name="iban" value="${contrato.iban}" />
    <json:property name="cccDomiciliacion" value="${contrato.cccDomiciliacion}" />
    <json:property name="contratoParaguas" value="${contrato.codigoContratoParaguas}" />
    <json:property name="remunEsp" value="${contrato.remuneracionEspecial.descripcion}" />
    
    <json:property name="fechaIniEpiIrregular">
    	<fwk:date value="${contrato.lastMovimiento.fechaIniEpiIrregular}" />
    </json:property>
    
    <json:property name="entregasCuenta" value="${contrato.lastMovimiento.entregasACuenta}" />
    <json:property name="interesesEntregasCuenta" value="${contrato.lastMovimiento.interesesEntregas}" />
    <json:property name="pendienteDesembolso" value="${contrato.lastMovimiento.pendienteDesembolso}" />
    <json:property name="sistemaAmort" value="${contrato.sistemaAmortizacion.descripcion}" />
    <json:property name="tipoInteres" value="${contrato.tipoInteres}" />
    <json:property name="importeCuota" value="${contrato.cuotaImporte}" />
    <json:property name="periodicidadCuota" value="${contrato.cuotaPeriodicidad}" />
    <json:property name="numCuotasVencidas" value="${contrato.lastMovimiento.cuotasVencidasImpagadas}" />
    <json:property name="interesFijoVariable" value="${contrato.interesFijoVariable.descripcion}" />
    <json:property name="deudaExigible" value="${contrato.lastMovimiento.deudaExigible}" />
    <json:property name="deudaIrregular" value="${contrato.lastMovimiento.deudaIrregular}" />
    
    
    <json:property name="provision" value="${contrato.lastMovimiento.provision}" />
    <json:property name="movIntRemun" value="${contrato.lastMovimiento.movIntRemuneratorios}" />
    <json:property name="movIntMoratorios" value="${contrato.lastMovimiento.movIntMoratorios}" />
    <json:property name="comisiones" value="${contrato.lastMovimiento.comisiones}" />
    <json:property name="gastos" value="${contrato.lastMovimiento.gastos}" />
    <json:property name="extra1" value="${contrato.lastMovimiento.extra1}" />
    <json:property name="extra2" value="${contrato.lastMovimiento.extra2}" />
    <json:property name="extra3" value="${contrato.lastMovimiento.extra3}" />
    <json:property name="extra4" value="${contrato.lastMovimiento.extra4}" />
	<json:property name="extra5" >
		<fwk:date value="${contrato.lastMovimiento.extra5}"/>
    </json:property>
    <json:property name="extra6" value="${contrato.lastMovimiento.extra6}" />
    <json:property name="provisionPorcentaje" value="${contrato.lastMovimiento.provisionPorcentaje}" />
  	<json:property name="impuestos" value="${contrato.lastMovimiento.impuestos}" />

    <json:property name="domiciExt" >
		<c:if test="${contrato.domiciliacionExterna}">
			<s:message code="mensajes.si"/>
		</c:if>
		<c:if test="${!contrato.domiciliacionExterna}">
			<s:message code="mensajes.no"/>
		</c:if>
	</json:property>
	
    <json:property name="domiciExtFecha">
    	<fwk:date value="${contrato.lastMovimiento.fechaReciboDev}"/>
    </json:property>
    <json:property name="domiciExtTotal" value="${contrato.lastMovimiento.totalRecibosDev}" />
    <json:property name="contratoAnt" value="${contrato.contratoAnterior}" />
    <json:property name="motivoRenum" value="${contrato.motivoRenumeracion.descripcion}" />
    <json:property name="contratoExceptuado" value="${contratoExceptuado}" />
    <json:property name="numextra1" value="${contrato.numextra1}" />
    <json:property name="numextra2" value="${contrato.numextra2}" />
    <json:property name="numextra3" value="${contrato.numextra3}" />
    <json:property name="dateextra1" value="${contrato.dateextra1}" />
    <json:property name="flagextra1" value="${contrato.flagextra1}" />
    <json:property name="flagextra2" value="${contrato.flagextra2}" />
    <json:property name="flagextra3" value="${contrato.flagextra3}" />
    <json:property name="charextra1" value="${contrato.charextra1}" />
    <json:property name="charextra2" value="${contrato.charextra2}" />
    <json:property name="charextra3" value="${contrato.charextra3}" />
    <json:property name="charextra4" value="${contrato.charextra4}" />
    <json:property name="charextra5" value="${contrato.charextra5}" />
    <json:property name="charextra6" value="${contrato.charextra6}" />
    <json:property name="charextra7" value="${contrato.charextra7}" />
    <json:property name="charextra8" value="${contrato.charextra8}" />
    <json:property name="marca" value="${contrato.marcaOperacion}" />
    <json:property name="motivoMarca" value="${contrato.motivoMarca}" />
    <json:property name="indicador" value="${contrato.indicadorNominaPension}" />
    <json:property name="contadorReincidencia" value="${contadorReincidencia}" />
  </json:object>
  
  
  <json:object name="intervinientes">
	<json:array name="intervinientes" items="${contrato.contratoPersonaOrdenado}" var="obs">
		 <json:object>
			<json:property name="nombre">${obs.persona.nombre}</json:property>
			<json:property name="apellidos">${obs.persona.apellido1} ${obs.persona.apellido2}</json:property>
			<json:property name="apellido1">${obs.persona.apellido1}</json:property>
			<json:property name="apellido2">${obs.persona.apellido2}</json:property>
			<json:property name="codClienteEntidad">${obs.persona.codClienteEntidad}</json:property>
			<json:property name="nif">${obs.persona.docId}</json:property>
			<json:property name="saldoVencido">${obs.persona.dispuestoVencido}</json:property>
			<json:property name="totalRiesgo">${obs.persona.riesgoTotal}</json:property>
			<json:property name="numContratos">${obs.persona.numContratos}</json:property>
			<json:property name="situacion">${obs.persona.situacion}</json:property>
			<json:property name="tipoIntervencion">${obs.tipoIntervencion.descripcion} ${obs.orden}</json:property>
			<<json:property name="id" value="${obs.persona.id}" />
			<json:property name="apellidoNombre" value="${obs.persona.apellidoNombre}"/>
		 </json:object>
	</json:array>
  </json:object>
  
	<json:object name="otrosDatos">
    	<json:property name="contratoPadreNivel2" value="${contrato.contratoPadreNivel2}" />
    	<json:property name="charextra7" value="${contrato.charextra7}" />
    	<json:property name="charextra9" value="${contrato.charextra9}" />
    	<json:property name="charextra10" value="${contrato.charextra10}" />
    	<sec:authorize ifAllGranted="TAB_CONTRATO_OTROS,PERSONALIZACION-BCC">
    		<json:property name="charextra10" value="${contrato.estadoEntidad}" />
    	</sec:authorize>
    	<json:property name="flagextra4" value="${contrato.flagextra4}" />
    	<json:property name="flagextra5" value="${contrato.flagextra5}" />
    	<json:property name="flagextra6" value="${contrato.flagextra6}" />
    	<json:property name="dateextra2" value="${contrato.dateextra2}" />
    	<json:property name="dateextra3" value="${contrato.dateextra3}" />
    	<json:property name="dateextra4" value="${contrato.dateextra4}" />
    	<json:property name="dateextra5" value="${contrato.dateextra5}" />
    	<json:property name="dateextra6" value="${contrato.dateextra6}" />
    	<json:property name="dateextra7" value="${contrato.dateextra7}" />
    	<json:property name="dateextra9" value="${contrato.dateextra9}" />
    	<json:property name="numextra4" value="${contrato.numextra4}" />
    	<json:property name="numextra5" value="${contrato.numextra5}" />
    	<json:property name="numextra6" value="${contrato.numextra6}" />
    	<json:property name="numextra7" value="${contrato.numextra7}" />
    	<json:property name="numextra8" value="${contrato.numextra8}" />
    	<sec:authorize ifAllGranted="TAB_CONTRATO_OTROS,PERSONALIZACION-BCC">
    		<c:if test="${not empty riesgo}">
    			<json:property name="descripcionRiesgo" value="${riesgo.descripcion}"/>
    		</c:if>
    		<c:if test="${not empty vencido}">
    			<c:if test="${not empty vencido.tipoVencido}">
    				<json:property name="tipoVencido" value="${vencido.tipoVencido.descripcion}"/>
    			</c:if>
	    		<c:if test="${not empty vencido.tipoVencidoAnterior}">
	    			<json:property name="tramoPrevio" value="${vencido.tipoVencidoAnterior.descripcion}"/>
	    		 </c:if>
    		</c:if>    		
    	</sec:authorize>
	</json:object>
  
</fwk:json>
