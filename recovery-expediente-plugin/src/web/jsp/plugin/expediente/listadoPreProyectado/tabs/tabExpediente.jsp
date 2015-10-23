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
	var comboJerarquia = new Ext.form.ComboBox({
	<%-- 		store: '' --%>
	<%-- 		,displayField:'descripcion' --%>
	<%-- 		,valueField:'codigo' --%>
		mode:'local'
		,style:'margin:0px'
		,width:250
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.jerarquia" text="**Jerarquía"/>'
	});
	
	var centros = <app:dict value="${centro}" />;
	var fases = <app:dict value="${fase}" />;
	
	//Doble sel centro
	var dobleSelCentro = app.creaDblSelect(centros
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.centros" text="**Centro" />'
                              ,{<app:test id="dobleSelCentro" />});
                              
	//Doble sel fase
	var dobleSelFase = app.creaDblSelect(fases
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.expediente.fase" text="**Fase" />'
                              ,{<app:test id="dobleSelFase" />});
	
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