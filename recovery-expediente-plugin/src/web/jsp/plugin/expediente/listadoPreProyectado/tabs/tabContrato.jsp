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
	var comboJerarquiaContrato = new Ext.form.ComboBox({
	<%-- 		store: '' --%>
	<%-- 		,displayField:'descripcion' --%>
	<%-- 		,valueField:'codigo' --%>
		mode:'local'
		,style:'margin:0px'
		,width:250
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.jerarquia" text="**Jerarquía"/>'
	});
	
	var centros = <app:dict value="${centro}" />;
	
	//Doble sel centro
	var dobleSelCentroContrato = app.creaDblSelect(centros
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.contrato.centros" text="**Centro" />'
                              ,{<app:test id="dobleSelCentro" />});
	
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