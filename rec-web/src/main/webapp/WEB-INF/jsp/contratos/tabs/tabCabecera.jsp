<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

(function(){
		
	var labelStyle = 'width:185px;font-weight:bolder",width:375';

	var nombrePrimerTitular = '';

	<c:if test="${contrato.primerTitular != null}">
		nombrePrimerTitular = "${contrato.primerTitular.apellidoNombre}";
	</c:if>
	// DATOS PRINCIPALES
	var contrato			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.contrato" text="**Contrato"/>','${contrato.codigoContrato}',{labelStyle:labelStyle});
	var tipoProducto		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.tipoProducto" text="**Tipo Producto"/>','${contrato.tipoProducto.descripcion}',{labelStyle:labelStyle});
	var primerTitular		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.primerTitular" text="**1er Titular"/>',nombrePrimerTitular,{labelStyle:labelStyle});
	var estado				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.estado" text="**Estado"/>','${contrato.estadoContrato.descripcion} (<fwk:date value="${contrato.fechaEstadoContrato}"/>)',{labelStyle:labelStyle});
	var fechaExtraccion		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.fechaExtraccion" text="**Fecha Extraccion"/>','<fwk:date value="${contrato.fechaExtraccion}"/>',{labelStyle:labelStyle});
	
	var finalidadContrato    = app.creaLabel('<s:message code="contrato.consulta.tabcabecera.finalidadContrato" text="**finalidadContrato"/>','${contrato.finalidadContrato}',{labelStyle:labelStyle});
	var finalidadAcuerdo	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.finalidadAcuerdo" text="**finalidadAcuerdo"/>','${contrato.finalidadAcuerdo}',{labelStyle:labelStyle});
	var fechaCreacion		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.fechaCreacion" text="**fechaCreación"/>','<fwk:date value="${contrato.fechaCreacion}" />',{labelStyle:labelStyle});
	
	//DATOS FINANCIEROS
	var moneda				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.moneda" text="**Moneda"/>','${contrato.moneda.descripcionLarga}',{labelStyle:labelStyle});
	var posVivaNoVencida	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.pvnv" text="**Posición Viva No Vencida"/>',app.format.moneyRenderer('${contrato.lastMovimiento.posVivaNoVencida}'),{labelStyle:labelStyle});
	var posVivaVencida		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.pvv" text="**Posición Viva Vencida"/>',app.format.moneyRenderer('${contrato.lastMovimiento.posVivaVencida}'),{labelStyle:labelStyle});
	var fechaInicioPVV		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.fechaInicioPVV" text="**Fecha Inicio Pos. Viva Vencida"/>','<fwk:date value='${contrato.lastMovimiento.fechaPosVencida}'/>',{labelStyle:labelStyle});
	var saldoDudoso			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.saldoDudoso" text="**Saldo Dudoso"/>',app.format.moneyRenderer('${contrato.lastMovimiento.saldoDudoso}')+" "+ '(<fwk:date value="${contrato.lastMovimiento.fechaDudoso}"/>)',{labelStyle:labelStyle});
	var estadoFinanciero	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.estadoFinanciero" text="**Estado Financiero"/>','${contrato.estadoFinanciero.descripcion} (<fwk:date value="${contrato.fechaEstadoFinanciero}"/>)',{labelStyle:labelStyle});
	var estadoFinAnterior	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.estadoFinancieroAnterior" text="**Estado Financiero Anterior"/>','${contrato.estadoFinancieroAnterior.descripcion} (<fwk:date value="${contrato.fechaEstadoFinancieroAnterior}"/>)',{labelStyle:labelStyle});

	var riesgo				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.riesgo" text="**Riesgo"/>',app.format.moneyRenderer('${contrato.lastMovimiento.riesgo}'),{labelStyle:labelStyle});
	var dispuesto			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.dispuesto" text="**dispuesto"/>',app.format.moneyRenderer('${contrato.lastMovimiento.dispuesto}'),{labelStyle:labelStyle});
	var saldoPasivo			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.saldoPasivo" text="**saldoPasivo"/>',app.format.moneyRenderer('${contrato.lastMovimiento.saldoPasivo}'),{labelStyle:labelStyle});
	var limiteInicial		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.limiteInicial" text="**limiteInicial"/>',app.format.moneyRenderer('${contrato.limiteInicial}'),{labelStyle:labelStyle});
	var limiteFinal			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.limiteFinal" text="**limiteFinal"/>',app.format.moneyRenderer('${contrato.limiteFinal}'),{labelStyle:labelStyle});
	var riesgoGarantizado	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.riesgoGarantizado" text="**riesgoGarantizado"/>',app.format.moneyRenderer('${contrato.lastMovimiento.riesgoGarantizado}'),{labelStyle:labelStyle});	
	var saldoExcedido		= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.saldoExcedido" text="**saldoExcedido"/>',app.format.moneyRenderer('${contrato.lastMovimiento.saldoExcedido}'),{labelStyle:labelStyle});
	var ltvInicial			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.ltvInicial" text="**ltvInicial"/>','${contrato.lastMovimiento.ltvInicial}',{labelStyle:labelStyle});
	var ltvFinal			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.ltvFinal" text="**ltvFinal"/>','${contrato.lastMovimiento.ltvFinal}',{labelStyle:labelStyle});
	var limiteDescubierto	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.limiteDescubierto" text="**limiteDescubierto"/>',app.format.moneyRenderer('${contrato.lastMovimiento.limiteDescubierto}'),{labelStyle:labelStyle});
	var garantia1			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.garantia1" text="**garantia1"/>','${contrato.garantia1.descripcion}',{labelStyle:labelStyle});
	var garantia2			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.garantia2" text="**garantia2"/>','${contrato.garantia2.descripcion}',{labelStyle:labelStyle});
	var fechaVencimiento	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.fechaVencimiento" text="**fechaVencimiento"/>','<fwk:date value="${contrato.fechaVencimiento}" />',{labelStyle:labelStyle});

	var provision			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.provision" text="**Provisión"/>',app.format.moneyRenderer('${contrato.lastMovimiento.provision}'),{labelStyle:labelStyle});
	var movIntRemun			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.interesesRemun" text="**Intereses Remuneratorios"/>',app.format.moneyRenderer('${contrato.lastMovimiento.movIntRemuneratorios}'),{labelStyle:labelStyle});
	var movIntMoratorios	= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.interesesMoratorios" text="**Intereses Moratorios"/>',app.format.moneyRenderer('${contrato.lastMovimiento.movIntMoratorios}'),{labelStyle:labelStyle});
	var comisiones			= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.comisiones" text="**Comisiones"/>',app.format.moneyRenderer('${contrato.lastMovimiento.comisiones}'),{labelStyle:labelStyle});
	var gastos				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.gastos" text="**Gastos"/>',app.format.moneyRenderer('${contrato.lastMovimiento.gastos}'),{labelStyle:labelStyle});
	
	//OTROS DATOS
	var extra1				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.extra1" text="**Extra1"/>','${contrato.lastMovimiento.extra1}',{labelStyle:labelStyle});
	var extra2				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.extra2" text="**Extra2"/>','${contrato.lastMovimiento.extra2}',{labelStyle:labelStyle});
	var extra3				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.extra3" text="**Extra3"/>','${contrato.lastMovimiento.extra3}',{labelStyle:labelStyle});
	var extra4				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.extra4" text="**Extra4"/>','${contrato.lastMovimiento.extra4}',{labelStyle:labelStyle});
	var extra5				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.extra5" text="**Extra5"/>','<fwk:date value="${contrato.lastMovimiento.extra5}" />',{labelStyle:labelStyle});
	var extra6				= app.creaLabel('<s:message code="contrato.consulta.tabcabecera.extra6" text="**Extra6"/>','<fwk:date value="${contrato.lastMovimiento.extra6}" />',{labelStyle:labelStyle});
	
	

			var datosPrincipalesFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="contrato.consulta.tabcabecera.datosPrincipales" text="**Datos Principales"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[contrato,tipoProducto,primerTitular,estado]},
					  {items:[fechaExtraccion,finalidadContrato,finalidadAcuerdo,fechaCreacion]}
					 ]
		});
		
			var datosFinancierosFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="contrato.consulta.tabcabecera.datosFinancieros" text="**Datos Financieros"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[moneda, posVivaNoVencida, posVivaVencida, fechaInicioPVV, saldoDudoso,estadoFinanciero,estadoFinAnterior,riesgo,dispuesto,saldoPasivo]},
					  {items:[limiteInicial,limiteFinal,riesgoGarantizado,saldoExcedido,ltvInicial,ltvFinal,limiteDescubierto,garantia1,garantia2,fechaVencimiento]}
					 ]
		});
	
	

			var gastosIntComFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="contrato.consulta.tabcabecera.gastosIntCom" text="**Gastos Intereses Comisiones"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[provision,movIntRemun,movIntMoratorios]},
					  {items:[comisiones,gastos]}
					 ]
		});


			var otrosDatosFieldSet = new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
	  	   	,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:'<s:message code="contrato.consulta.tabcabecera.otrosDatos" text="**Otros Datos"/>'
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : [{items:[extra1,extra2,extra3]},
					  {items:[extra4,extra5,extra6]}
					 ]
		});

	

	
	
		
		//Panel propiamente dicho...
		var panel=new Ext.Panel({
			title:'<s:message code="contrato.consulta.tabcabecera.titulo" text="**Cabecera"/>'
			,autoScroll:true
			,width:775
			,autoHeight:true
			//,autoWidth : true
			,layout:'table'
			,bodyStyle:'padding:5px;margin:5px'
			,border : false
		    ,layoutConfig: {
		        columns: 1
		    }
			,defaults : {xtype : 'fieldset', autoHeight : true, border :true ,cellCls : 'vtop'}
			,items:[ datosPrincipalesFieldSet,datosFinancierosFieldSet,gastosIntComFieldSet,otrosDatosFieldSet]
			,nombreTab : 'cabecera'
		});
		
		return panel;
})()