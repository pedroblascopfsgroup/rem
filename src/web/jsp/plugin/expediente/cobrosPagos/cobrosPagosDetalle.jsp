<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>
		
	var labelStyle='font-weight:bolder;width:150px'	

	var booleanRenderer = function(value){
		if(value=='true'){
			return "Sí";
		}
		else if(value=='false'){
			return "No";
		}
	};

	var fechaDato = new Ext.form.DateField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.tab.fechaDato" text="**Fecha dato" />'
		,value:app.format.dateRenderer('${cop.fechaDato}'.substring(0, 10))
		,id:'fechaDato'
		,name:'cobroPago.fechaDato'
		,labelStyle:labelStyle
		,readOnly: true
	});	

	var fecha = new Ext.form.DateField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.fecha" text="**Fecha" />'
		,value:app.format.dateRenderer('${cop.fecha}'.substring(0, 10))
		,id:'fecha'
		,name:'cobroPago.fecha'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var importe = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.importe" text="**Importe" />'
		,value:'${cop.importe}'
		,id:'importe'
		,name:'cobroPago.importe'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var tipoCobro = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.tipoCobro" text="**Tipo cobro" />'
		,value:'${cop.tipoCobroPago.descripcion}'
		,id:'tipoCobro'
		,name:'cobroPago.tipoCovro'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var contrato = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.contrato" text="**Contrato" />'
		,value:'${cop.contrato.descripcion}'
		,id:'contrato'
		,name:'cobroPago.contrato'
		,labelStyle:labelStyle
		,readOnly: true
	});   
	
	<%-- var periodoCarga = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.periodoCarga" text="**Periodo carga" />'
		,value:'${cop.periodoCarga}'
		,name:'cobroPago.periodoCarga'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	 --%>
	var observaciones = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.observaciones" text="**Observaciones" />'
		,value:'${cop.observaciones}'
		,id:'observaciones'
		,name:'cobroPago.observaciones'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var origenCobro = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.origenCobro" text="**Origen cobro" />'
		,value:'${cop.origenCobro.descripcion}'
		,id:'origenCobro'
		,name:'cobroPago.origenCobro'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var codigoPropietario = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.codigoPropietario" text="**Código propietario" />'
		,value:'${cop.codigoPropietario}'
		,id:'codigoPropietario'
		,name:'cobroPago.codigoPropietario'
		,labelStyle:labelStyle
		,readOnly: true
	});
	
	var numeroEspec = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.numeroEspec" text="**Número espec" />'
		,value:'${cop.numeroEspec}'
		,name:'cobroPago.numeroEsPec'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var fechaValor = new Ext.form.DateField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.fechaValor" text="**Fecha valor" />'
		,value:app.format.dateRenderer('${cop.fechaValor}'.substring(0, 10))
		,name:'cobroPago.fechaValor'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	
	var fechaMovimiento = new Ext.form.DateField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.fechaMovimiento" text="**Fecha movimiento" />'
		,value:app.format.dateRenderer('${cop.fechaMovimiento}'.substring(0, 10))
		,name:'cobroPago.fechaMovimiento'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	
	var cobroFacturable = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.cobroFacturable" text="**Cobro facturable" />'
		,value:booleanRenderer('${cop.cobroFacturable}')
		,name:'cobroPago.cobroFacturable'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var capital = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.capital" text="**Capital" />'
		,value:'${cop.capital}'
		,name:'cobroPago.capital'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	
	var interesesOrdinarios = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.interesesOrdinarios" text="**Intereses ordinarios" />'
		,value:'${cop.interesesOrdinarios}'
		,name:'cobroPago.interesesOrdinarios'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	
	var interesesMoratorios = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.interesesMoratorios" text="**Intereses moratorios" />'
		,value:'${cop.interesesMoratorios}'
		,name:'cobroPago.interesesMoratorios'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	
	var comisiones = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.comisiones" text="**Comisiones" />'
		,value:'${cop.comisiones}'
		,name:'cobroPago.comisiones'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var gastos = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.gastos" text="**Gastos" />'
		,value:'${cop.gastos}'
		,name:'cobroPago.gastos'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	
	var impuestos = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.expediente.cobrosPagos.detalle.impuestos" text="**Impuestos" />'
		,value:'${cop.impuestos}'
		,name:'cobroPago.impuestos'
		,labelStyle:labelStyle
		,readOnly: true
	});	
	
	var btnGuardar = new Ext.Button({
		text : '<s:message code="plugin.expediente.cobrosPagos.detalle.cerrar" text="**Cerrar" />'
		<app:test id="btnGuardarAntecedenteExterno" addComa="true" />
		,iconCls : 'icon_cancel'
		,handler : function(){			
			 page.fireEvent(app.event.DONE); 			
		}
	});
	
	function fieldSet(title,items){
		return new Ext.form.FieldSet({
			autoHeight:true
			,width:770
			,style:'padding:0px'
			,border:true
			,layout : 'table'
			,border : true
			,layoutConfig:{
				columns:2
			}
			,title:title
			,defaults : {xtype : 'fieldset', autoHeight : true, border : false ,cellCls : 'vtop',width:375}
		    ,items : items
		});
	}
	
	var datosPrincipalesFieldSet = fieldSet( '<s:message code="plugin.expediente.cobrosPagos.detalle.datosPrincipales" text="**Datos Principales"/>'
                 ,[{items:[fecha, importe,tipoCobro, contrato,  observaciones, origenCobro, codigoPropietario, numeroEspec,fechaValor]} 
                 , {items:[fechaDato, fechaMovimiento, cobroFacturable, capital, interesesOrdinarios, interesesMoratorios, comisiones, gastos, impuestos]} ]);
	
	
	var panelEdicion = new Ext.form.FormPanel({
		autoHeight : true
		,width:500
		,bodyStyle : 'padding:10px'
		,border : false
		,items : [
		
			 { xtype : 'errorList', id:'errL' }
			,{
				autoHeight:true
				,layout:'table'
				,layoutConfig:{columns:2}
				,border:false
				,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false,width:1000}
				,items:[{
						layout:'form'
						,bodyStyle:'padding:5px;cellspacing:10px'
						,items:[datosPrincipalesFieldSet]
					}
				]
			}
		]
		,bbar : [
			'->',btnGuardar
		]
	});
	

	page.add(panelEdicion);
	
</fwk:page>