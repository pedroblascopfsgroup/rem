<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

var createDatosGeneralesTab=function(){
	
	//Combo Estado Gestión
	var estadosGestion = <app:dict value="${estadosGestion}" blankElement="true" blankElementValue="" blankElementText="---" />;
	var optionsEstadoGestionStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : estadosGestion
	});
	
	var comboEstadoGestion = new Ext.form.ComboBox({
		store: optionsEstadoGestionStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,style:'margin:0px'
		,width:170
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.estadoGestion" text="**Estado gestión"/>'
	});
	
	//Combo Tipo persona
	var tipoPersonas = <app:dict value="${tipoPersonas}" blankElement="false" />;
	
	var optionsTipoPersonaStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : tipoPersonas
	});
	
	var comboTipoPersona = new Ext.form.ComboBox({
		store: optionsTipoPersonaStore
		,displayField:'descripcion'
		,valueField:'codigo'
		,mode:'local'
		,style:'margin:0px'
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.tipoPersona" text="**Tipo Persona"/>'
	});
	
	// Field riesgo total
	var mmRiesgoTotal = app.creaMinMaxMoneda('<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.riesgoTotal" text="**Riesgo Total" />', 'riesgo',{width : 80, labelWidth:105});
	
	// Field deuda irregular
	var mmDeudaIrregular = app.creaMinMaxMoneda('<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.deudaIrregular" text="**Deuda Irregular" />', 'deuda',{width : 80, labelWidth:105});
	
	//Combo Agrupar por
<%-- 	var agruparPor = <app:dict value="${agruparPor}" blankElement="false" />; --%>
	
 	var optionsAgruparPorStore = new Ext.data.JsonStore({
		fields: ['codigo', 'descripcion']
 	       ,data : [
 	       			{"codigo":"EXP", "descripcion":"Expediente"}
 	       			,{"codigo":"CTO", "descripcion":"Contrato"}
 	       	
 	       ]
 	}); 
	
	var comboAgruparPor = new Ext.form.ComboBox({
 		store: optionsAgruparPorStore 
		,displayField:'descripcion' 
		,valueField:'codigo' 
		,mode:'local'
		,style:'margin:0px'
		,triggerAction:'all'
		,fieldLabel:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.agruparPor" text="**Agrupar por"/>'
	});
	
	var tramos = <app:dict value="${tramo}" />;
	var propuestas = <app:dict value="${propuesta}" />;
	
	//Doble sel tramo
	var dobleSelTramo = app.creaDblSelect(tramos
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.tramo" text="**Tramo" />'
                              ,{<app:test id="dobleSelTramo" />});
                              
    //Doble sel propuesta
	var dobleSelPropuesta = app.creaDblSelect(propuestas
                              ,'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales.propuesta" text="**Propuesta" />'
                              ,{
               						width:250
           						});	
                              
     //filtro Datos Generales
	var filtrosTabDatosGenerales = new Ext.Panel({
		title:'<s:message code="plugin.mejoras.listadoPreProyectado.datosGenerales" text="**Datos del expediente" />'
		,autoHeight:true
		,bodyStyle:'padding: 10px'
		,layout:'table'
		,layoutConfig:{columns:2}
		,defaults : {xtype:'fieldset', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px'}
		,items:[{
					layout:'form'
					,items: [comboEstadoGestion,comboTipoPersona,mmRiesgoTotal.panel,mmDeudaIrregular.panel,comboAgruparPor]	
		
				},
				{
					layout:'form'
					,items: [dobleSelTramo,dobleSelPropuesta]
				}]
		
	});
	
	return filtrosTabDatosGenerales;
};