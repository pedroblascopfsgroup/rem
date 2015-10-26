<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var createExpedienteTab = function(){

	// codigo expediente
	var txtCodExpediente = new Ext.form.NumberField({
		fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.codExpediente" text="**Codigo Expediente" />'
		,enableKeyEvents: true
		,allowDecimals: false
		,allowNegative: false
		,style : 'margin:0px'
		,autoCreate : {tag: "input", type: "text",maxLength:"16", autocomplete: "off"}
		//,vtype:'numeric'
		
		});
		
	//Combo jerarquia
	
 	var jerarquia = <app:dict value="${niveles}" blankElement="true" blankElementValue="" blankElementText="---" />; 
	
	var comboJerarquia = app.creaCombo({triggerAction: 'all', data:jerarquia, value:jerarquia.diccionario[0].codigo, name: 'jerarquia',fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.jerarquia" text="**Jerarquía"/>' })
	
	
	
	var fases = <app:dict value="${fase}" />;
	
	//Doble sel centro
	
	
	var centro = <app:dict value="${centro}" />;
	
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
	
	
	var dobleSelCentro = app.creaDblSelect(centro
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.centros" text="**Centro" />'
                              ,{store:optionsCentrosStore, funcionReset:recargarComboCentros, width:300});	
           	
    var recargarComboCentros = function(){
		if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
			optionsCentrosStore.webflow({id:comboJerarquia.getValue()});
		}else{
			optionsCentrosStore.webflow({id:0});
			dobleSelCentro.setValue('');
			optionsCentrosStore.removeAll();
		}
	}
	
	var limpiarYRecargar = function(){
		app.resetCampos([dobleSelCentro]);
		recargarComboCentros();
	}
	comboJerarquia.on('select',limpiarYRecargar);
	
	recargarComboCentros();
           	                              
	//Doble sel fase
	var dobleSelFase = app.creaDblSelect(fases
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.fase" text="**Fase" />'
						,{
               				width:200
           					});	
	
	//filtro Expediente
	var filtrosTabExpediente = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente" text="**Expediente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items:[txtCodExpediente,comboJerarquia,dobleSelCentro]
				},{
					layout:'form'
					,items:[dobleSelFase]
				}
				]
	});
	
	return filtrosTabExpediente;
};