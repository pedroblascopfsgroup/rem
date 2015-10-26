<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var createContratoTab=function(){

	// codigo contrato
	var txtCodContrato = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.codContrato" text="**Codigo Contrato" />'
		,enableKeyEvents: true
		,allowDecimals: false
		,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
		//,vtype:'numeric'
		
		});
		
	// Field fecha prevista regularizacion
	<pfsforms:datefield name="filtroFechaDesde"
		labelKey="plugin.mejoras.listadoPreProyectado.contrato.fechaPrevista" 
		label="**Fecha prevista refularizacion" width="140"/>
		
	filtroFechaDesde.id='filtroFechaDesdeRecobroListaCarteras';		
	
 	var filtroFechaHasta = new Ext.ux.form.XDateField({ 
 		name : 'filtroFechaAltaHasta' 
 		,hideLabel:true 
 		,width:100 
 	}); 
	
	var panelFechasPrevistaRegul = new Ext.Panel({
		layout:'table'
		,title : ''
		,id : 'panelFechasPrevistaRegul'
		,collapsible : false
		,titleCollapse : false
		,layoutConfig : {
			columns:2
		}
		,style:'margin-right:0px;margin-left:0px'
		,border:false
		,autoWidth:true
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop'}
		,items:[
			
			{layout:'form', items:[filtroFechaDesde]}
			,{layout:'form',items:[filtroFechaHasta]}
		]
	}); 
	
	//Combo jerarquia
	
	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />; 
	
	var comboJerarquiaContrato = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name: 'jerarquia',fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.jerarquia" text="**Jerarquía"/>' })
	
	var centro = <app:dict value="${centro}" />;
	
	//Doble sel centro
	
	 var centrosRecord  = Ext.data.Record.create([
		{name:'codigo'}
	   ,{name:'descripcion'}
		
	]);
	
	var optionsCentrosStore = page.getStore({
	       flow: 'clientes/buscarZonas'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'zonas'
	    }, centrosRecord)
	       
	}); 
	
	var dobleSelCentroContrato = app.creaDblSelect(centro
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.centros" text="**Centro" />'
                              ,{store:optionsCentrosStore, funcionReset:recargarComboCentros, width:300});	
    
    var recargarComboCentros = function(){
		if (comboJerarquiaContrato.getValue()!=null && comboJerarquiaContrato.getValue()!=''){
			optionsCentrosStore.webflow({id:comboJerarquiaContrato.getValue()});
		}else{
			optionsCentrosStore.webflow({id:0});
			dobleSelCentroContrato.setValue('');
			optionsCentrosStore.removeAll();
		}
	}
    
    var limpiarYRecargar = function(){
		app.resetCampos([dobleSelCentroContrato]);
		recargarComboCentros();
	}
	comboJerarquiaContrato.on('select',limpiarYRecargar);
	
	recargarComboCentros();
	
	//Filtro Contrato

	var filtrosTabContrato = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato" text="**Contrato" />'
		,autoWidth:true
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items:[txtCodContrato, panelFechasPrevistaRegul]
					,autoWidth:true
				}
				,{
					layout:'form'
					,items:[comboJerarquiaContrato,dobleSelCentroContrato]
				}]
	});
	
	return filtrosTabContrato;
};