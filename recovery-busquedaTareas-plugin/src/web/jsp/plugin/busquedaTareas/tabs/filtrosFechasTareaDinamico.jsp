<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

(function(){

	<%-- FILTROS DE FECHA --%>
	 
	// Filtros fecha vencimiento -------------
	 
	var comboFechaDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,value:'${fechaVencDesdeOp}'
	})
	
	comboFechaDesdeOp.on('select',function(){
		var val = comboFechaDesdeOp.getValue();
		if(val == "=" || val == "<>"){
			comboFechaHastaOp.disable();
			fechaVencHasta.disable();
			fechaVencHasta.reset();
			comboFechaHastaOp.reset();
		}else{
			comboFechaHastaOp.enable();
			fechaVencHasta.enable();
		}	
	});
		
	var fechaVencDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaVencDesde'
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaVencimiento" text="**F. Vencimiento" />'
		,value:'${fechaVencDesde}'
	});
	
	var comboFechaHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorHasta" text="**Venc hasta" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,value:'${fechaVencHastaOp}'
	})
	
	var fechaVencHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaVencHasta'
		,height:20
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaVencimiento" text="**F. Vencimiento" />'
		,value:'${fechaVencHasta}'
	});

	// Filtros fecha incio -------------

	var comboFechaInicioDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,value:'${fechaInicioDesdeOp}'
	})
	
	comboFechaInicioDesdeOp.on('select',function(){
		var val = comboFechaInicioDesdeOp.getValue();
		if(val == "=" || val == "<>"){
			comboFechaInicioHastaOp.disable();
			fechaInicioHasta.disable();
			fechaInicioHasta.reset();
			comboFechaInicioHastaOp.reset();
		}else{
			comboFechaInicioHastaOp.enable();
			fechaInicioHasta.enable();
		}	
	});
		
	var fechaInicioDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaInicioDesde'
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaInicio" text="**F. Inicio" />'
		,value:'${fechaInicioDesde}'
	});
	
	var comboFechaInicioHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorHasta" text="**Inicio hasta" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,value:'${fechaInicioHastaOp}'
	})
	
	var fechaInicioHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaInicioHasta'
		,height:20
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaInicio" text="**F. Inicio" />'
		,value:'${fechaInicioHasta}'
	});

	// Filtros fecha Fin -------------

	var comboFechaFinDesdeOp=new Ext.form.ComboBox({
		store:[">=",">","=","<>"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorDesde" text="**Desde" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,value:'${fechaFinDesdeOp}'
	})
	
	comboFechaFinDesdeOp.on('select',function(){
		var val = comboFechaFinDesdeOp.getValue();
		if(val == "=" || val == "<>"){
			comboFechaFinHastaOp.disable();
			fechaFinHasta.disable();
			fechaFinHasta.reset();
			comboFechaFinHastaOp.reset();
		}else{
			comboFechaFinHastaOp.enable();
			fechaFinHasta.enable();
		}	
	});
		
	var fechaFinDesde = new Ext.ux.form.XDateField({
		width:100
		,height:20
		,name:'fechaFinDesde'
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaFin" text="**F. fin" />'
		,value:'${fechaFinDesde}'
	});
	
	var comboFechaFinHastaOp=new Ext.form.ComboBox({
		store:["<=","<"]
		,triggerAction : 'all'
		,mode:'local'
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaOperadorHasta" text="**Fin hasta" />'
		,width:40
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,value:'${fechaFinHastaOp}'
	})
	
	var fechaFinHasta = new Ext.ux.form.XDateField({
		width:100
		,name:'fechaFinHasta'
		,height:20
		,listeners:{
			specialkey: function(f,e){
				if(e.getKey()==e.ENTER){ 
					buscarFunc(); 
				}
			}
		}
		,fieldLabel:'<s:message code="plugin.busquedaTareas.filtroFechaFin" text="**F. fin" />'
		,value:'${fechaFinHasta}'
	});
	
	var tabFechas=false;	
	
	var filtrosDeFechaTabBuscaTareas = new Ext.Panel({
		title:'<s:message code="plugin.busquedaTareas.tituloPestanaFiltros2" text="**Filtros de fecha" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboFechaDesdeOp, comboFechaInicioDesdeOp, comboFechaFinDesdeOp]
				},{
					layout:'form'
					,items: [fechaVencDesde, fechaInicioDesde, fechaFinDesde]
				},{
					layout:'form'
					,items: [comboFechaHastaOp, comboFechaInicioHastaOp, comboFechaFinHastaOp]
				},{
					layout:'form'
					,items: [fechaVencHasta, fechaInicioHasta, fechaFinHasta]
				}]
		,listeners:{
			getParametros: function(anadirParametros, hayError) {
		        if (validaFechas()){
    	                anadirParametros(getParametros());
    	        }
			}
			,limpiar: function() {
    		   app.resetCampos([      
    		           	comboFechaDesdeOp, comboFechaInicioDesdeOp,	comboFechaFinDesdeOp, fechaVencDesde, fechaInicioDesde,
						fechaFinDesde, comboFechaHastaOp, comboFechaInicioHastaOp, comboFechaFinHastaOp,
						fechaVencHasta, fechaInicioHasta, fechaFinHasta
	           ]); 
    		}
    	}
	});
	
	filtrosDeFechaTabBuscaTareas.on('activate',function(){
		tabFechas=true;
	});
	
	// VALIDACIONES 
	
	var validaFechas=function(){
		var valid=true;
		if (tabFechas){
			if(fechaVencDesde.getValue()!='' && fechaVencHasta.getValue()!=''){
				valid = (fechaVencDesde.getValue()< fechaVencHasta.getValue())
			}

			if(fechaVencDesde.getValue()!='' && comboFechaDesdeOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaVencHasta.getValue()!='' && comboFechaHastaOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaInicioDesde.getValue()!='' && comboFechaInicioDesdeOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaInicioHasta.getValue()!='' && comboFechaInicioHastaOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaFinDesde.getValue()!='' && comboFechaFinDesdeOp.getValue()==''){
				valid = valid && false;
			}
			if(fechaFinHasta.getValue()!='' && comboFechaFinHastaOp.getValue()==''){
				valid = valid && false;
			}
								
			if(comboFechaDesdeOp.getValue()=='>=' || comboFechaDesdeOp.getValue()=='>'){
				if (fechaVencHasta.getValue()!='' && comboFechaHastaOp.getValue()!='') 
					if(fechaVencDesde.getValue()=='')
						valid = valid && false;
					else
						valid = valid && true;
			}
			if(fechaInicioDesde.getValue()!='' && fechaInicioHasta.getValue()!=''){
				valid = (fechaInicioDesde.getValue()< fechaInicioHasta.getValue())
			}
			if(comboFechaInicioDesdeOp.getValue()=='>=' || comboFechaInicioDesdeOp.getValue()=='>'){
				if (fechaInicioHasta.getValue()!='' && comboFechaInicioHastaOp.getValue()!='') 
					if(fechaInicioDesde.getValue()=='')
						valid = valid && false;
					else
						valid = valid && true;
			}
			if(fechaFinDesde.getValue()!='' && fechaFinHasta.getValue()!=''){
				valid = (fechaFinDesde.getValue()< fechaFinHasta.getValue())
			}
			if(comboFechaFinDesdeOp.getValue()=='>=' || comboFechaFinDesdeOp.getValue()=='>'){
				if (fechaFinHasta.getValue()!='' && comboFechaFinHastaOp.getValue()!='') 
					if(fechaFinDesde.getValue()=='')
						valid = valid && false;
					else
						valid = valid && true;
			}
		}
		return valid;
	}
	
	var getParametros = function() {
		
		return {fechaVencDesdeOperador: comboFechaDesdeOp.getValue()
			,fechaInicioDesdeOperador: comboFechaInicioDesdeOp.getValue()
			,fechaFinDesdeOperador: comboFechaFinDesdeOp.getValue()
			,fechaVencimientoDesde: app.format.dateRenderer(fechaVencDesde.getValue())
			,fechaInicioDesde: app.format.dateRenderer(fechaInicioDesde.getValue())
			,fechaFinDesde: app.format.dateRenderer(fechaFinDesde.getValue())
			,fechaVencimientoHastaOperador: comboFechaHastaOp.getValue()
			,fechaInicioHastaOperador: comboFechaInicioHastaOp.getValue()
			,fechaFinHastaOperador: comboFechaFinHastaOp.getValue()
			,fechaVencimientoHasta: app.format.dateRenderer(fechaVencHasta.getValue())
			,fechaInicioHasta: app.format.dateRenderer(fechaInicioHasta.getValue())
			,fechaFinHasta: app.format.dateRenderer(fechaFinHasta.getValue())
			
		};
	};

    return filtrosDeFechaTabBuscaTareas;
    
})()