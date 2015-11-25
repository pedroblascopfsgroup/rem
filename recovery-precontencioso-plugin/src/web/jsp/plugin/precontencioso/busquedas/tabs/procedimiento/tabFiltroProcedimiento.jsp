<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


<%-- Codigo --%>
<pfsforms:numberfield name="fieldCodigo" labelKey="plugin.precontencioso.tab.expjudicial.codigo" label="** Código" 
	value="" obligatory="false" allowDecimals="false" />

<%-- Nombre Expediente Judicial --%>

var fieldNombreExpedienteJudicial = new Ext.form.TextField({
	name: 'nombreExpedienteJudicial',
	fieldLabel : '<s:message code="plugin.precontencioso.tab.expjudicial.nombre" text="** Nom. Exp Judicial" />'
});

<%-- Días en gestión: Número de días transcurridos en el estado actual del expediente, o en caso de seleccionar algún estado en particular, el plazoen gestión de dicho estado. --%>

<pfsforms:numberfield name="fieldDiasGestion" labelKey="plugin.precontencioso.tab.expjudicial.dias.gestion" label="** Días en gestión" 
	value="" 
	obligatory="false" 
	allowDecimals="false" />

<%-- Fecha inicio de la preparación (Desde / Hasta) --%>

var dateFieldInicioPreparacionDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldInicioPreparacionDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.preparacion" text="** F. Inicio Preparacion" />'
});

var dateFieldInicioPreparacionHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldInicioPreparacionHasta',
	hideLabel: true,
	width: 95
});

var panelFechaInicioPreparacion = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldInicioPreparacionDesde]},
		{layout: 'form', items: [dateFieldInicioPreparacionHasta]}
	]
});

<%-- Fecha preparado (Desde / Hasta) --%>

var dateFieldPreparadoDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldPreparadoDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.preparado" text="** F. Preparado" />'
});

var dateFieldPreparadoHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldPreparadoHasta',
	hideLabel: true,
	width: 95
});

var panelFechaPreparado = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldPreparadoDesde]},
		{layout: 'form', items: [dateFieldPreparadoHasta]}
	]
});

<%-- Fecha enviado a letrado (Desde / Hasta) --%>

var dateFieldEnviadoLetradoDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldEnviadoLetradoDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.envioLetrado" text="** F. enviado a letrado " />'
});

var dateFieldEnviadoLetradoHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldEnviadoLetradoHasta',
	hideLabel: true,
	width: 95
});

var panelFechaEnviadoLetrado = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldEnviadoLetradoDesde]},
		{layout: 'form', items: [dateFieldEnviadoLetradoHasta]}
	]
});

<%-- Fecha finalizado (Desde / Hasta) --%>

var dateFieldFinalizadoDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldFinalizadoDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.finalizado" text="** F. Finalizado" />'
});

var dateFieldFinalizadoHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldFinalizadoHasta',
	hideLabel: true,
	width: 95
});

var panelFechaFinalizado = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldFinalizadoDesde]},
		{layout: 'form', items: [dateFieldFinalizadoHasta]}
	]
});

<%-- Fecha última subsanación (Desde / Hasta) --%>

var dateFieldUltimaSubsanacionDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldUltimaSubsanacionDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.subsanacion" text="** F. última subsanación" />'
});

var dateFieldUltimaSubsanacionHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldUltimaSubsanacionHasta',
	hideLabel: true,
	width: 95
});

var panelFechaUltimaSubsanacion = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldUltimaSubsanacionDesde]},
		{layout: 'form', items: [dateFieldUltimaSubsanacionHasta]}
	]
});

<%-- Fecha cancelado (Desde / Hasta) --%>

var dateFieldCanceladoDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldCanceladoDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.cancelado" text="** F. Cancelado" />'
});

var dateFieldCanceladoHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldCanceladoHasta',
	hideLabel: true,
	width: 95
});

var panelFechaCancelado = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldCanceladoDesde]},
		{layout: 'form', items: [dateFieldCanceladoHasta]}
	]
});

<%-- Fecha paralización (Desde / Hasta) --%>

var dateFieldParalizacionDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldParalizacionDesde',
	fieldLabel: '<s:message code="asd" text="** F. Paralización" />'
});

var dateFieldParalizacionHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldParalizacionHasta',
	hideLabel: true,
	width: 95
});

var panelFechaParalizacion = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldParalizacionDesde]},
		{layout: 'form', items: [dateFieldParalizacionHasta]}
	]
});

<pfsforms:ddCombo name="comboTipoProcPropuesto" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.tipo.procedimiento" 
label="** Tipo de procedimiento propuesto" value="" dd="${tipoProcedimientoProcpuesto}" />

<%-- Tipo de preparación --%>

<pfsforms:ddCombo name="comboTipoPreparacion" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.tipo.preparacion" 
label="** Tipo de preparación" value="" dd="${tipoPreparacion}" />

<%-- Disponible todos los documentos SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleDocumentos" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.disponible.todos.documentos" 
label="** Disponible todos los documentos" value="" dd="${ddSiNo}" />

<%-- Disponible todas las liquidaciones SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleLiquidaciones" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.disponible.todos.liquidaciones" 
label="** Disponible todas las liquidaciones" value="" dd="${ddSiNo}" />

<%-- Disponible todos los burofaxes SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleBurofaxes" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.disponible.todos.burofaxes" 
label="** Disponible todos los burofaxes" value="" dd="${ddSiNo}" />

<%-- Selector múltiple del estado en que se encuentran los expedientes. --%>

var estadoPreparacion = <app:dict value="${estadoPreparacion}" />;

var estadoPreparacionStore = new Ext.data.JsonStore({
		data: estadoPreparacion,
		root: 'diccionario',
		fields: ['codigo', 'descripcion']
});

var filtroEstadoPreparacion = app.creaDblSelect(
	estadoPreparacion,
	'<s:message code="plugin.precontencioso.tab.expjudicial.disponible.estado" text="** Estado Expediente" />',
	{
		store: estadoPreparacionStore,
		id: 'fieldEstadoPreparacion'
	}
);

<%-- Actores asignados: Permitirá buscar por los distintos actores que estén asignados a los expedientes. (Rol, Despacho y usuario) --%>

<pfsforms:ddCombo name="comboTiposGestor" propertyCodigo="id" propertyDescripcion="descripcion"
labelKey="ext.asuntos.busqueda.filtro.tipoGestor" label="**Tipo de gestor" value="" dd="${ddListadoGestores}" />

comboTiposGestor.on('select', function(){
	comboDespachos.reset();
	optionsDespachoStore.webflow({'idTipoGestor': comboTiposGestor.getValue(), 'incluirBorrados': true}); 
	comboGestor.reset();
	comboDespachos.setDisabled(false);
});
 
//store generico de combo diccionario
var optionsDespachosRecord = Ext.data.Record.create([
	 {name:'cod'}
	,{name:'descripcion'}
]);

var optionsDespachoStore = page.getStore({
       flow: 'expedientejudicial/getListTipoDespachoData'
       ,reader: new Ext.data.JsonReader({
    	 root : 'listadoDespachos'
    }, optionsDespachosRecord)	       
});

//Campo Combo Despacho
var comboDespachos = new Ext.form.ComboBox({
	store:optionsDespachoStore
	,displayField:'descripcion'
	,valueField:'cod'
	,mode: 'remote'
	,emptyText:'---'
	,editable: false
	,triggerAction: 'all'
	,disabled:true
	,resizable:true
	,fieldLabel : '<s:message code="asuntos.busqueda.filtro.despacho" text="**Despacho"/>'
	<app:test id="comboDespachos" addComa="true"/>
});

comboDespachos.on('select', function(){
	comboGestor.reset();
	optionsGestoresStore.webflow({'idTipoDespacho': comboDespachos.getValue(), 'incluirBorrados': true}); 
	comboGestor.setDisabled(false);
});

var Gestor = Ext.data.Record.create([
	 {name:'id'}
	,{name:'username'}
]);

var optionsGestoresStore =  page.getStore({
       flow: 'expedientejudicial/getListUsuariosData'
       ,reader: new Ext.data.JsonReader({
    	 root : 'listadoUsuarios'
    }, Gestor)	       
});

//Campo Gestores, double select 
var creaDblSelectMio = function(label, config){

	var store = config.store ;
	var cfg = {
	   	fieldLabel: label || ''
	   	,displayField:'username'
	   	,valueField: 'id'
	   	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
	   	,dataFields : ['id', 'username']
	   	,fromStore:store
	   	,toData : []
	       ,msHeight : config.height || 60
		,labelStyle:config.labelStyle || ''
	       ,msWidth : config.width || 140
	       ,drawTopIcon:false
	       ,drawBotIcon:false
	       ,drawUpIcon:false
		,drawDownIcon:false
		,disabled:true
		,toSortField : 'codigo'
	    };
	if(config.id) {
		cfg.id = config.id;
	}
	
	var itemSelector = new Ext.ux.ItemSelector(cfg);
	if (config.funcionReset){
		itemSelector.funcionReset = config.funcionReset;
	}
	
	//modificaciï¿½n al itemSelector porque no tiene un mï¿½todo setValue. Si se cambia de versiï¿½n se tendrï¿½ que revisar la validez de este mï¿½todo
	itemSelector.setValue =  function(val) {
	       if(!val) {
	           return;
	       }
	       val = val instanceof Array ? val : val.split(',');
	       var rec, i, id;
	       for(i = 0; i < val.length; i++) {
	           id = val[i];
	           if(this.toStore.find('id',id)>=0) {
	               continue;
	           }
	           rec = this.fromStore.find('id',id);
	           if(rec>=0) {
	           	rec = this.fromStore.getAt(rec);
	               this.toStore.add(rec);
	               this.fromStore.remove(rec);
	           }
	       }
	   };
	
	itemSelector.getStore =  function() {
		return this.toStore;
	};
	
	return itemSelector;
};

var comboGestor = creaDblSelectMio('<s:message code="asuntos.busqueda.filtro.gestor" text="**Gestor" />',{store:optionsGestoresStore, funcionReset:recargarComboGestores});

var recargarComboGestores = function(){
	optionsGestoresStore.webflow({id:0});
}

var validarEmptyForm = function(){
	return (comboDespachos.getValue() != '' || comboGestor.getValue() != '' || comboTiposGestor.getValue() != '');
}
		
var validaMinMax = function(){
	return true;
}

<%-- Jerarquía y Centros: Donde el filtro aplicará sobre el centro al que pertenece alguno de los contratos en preparación. --%>

var jerarquia = <app:dict value="${ddJerarquia}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
var comboJerarquia = app.creaCombo({
	triggerAction: 'all', 
	data:jerarquia, 
	value:jerarquia.diccionario[0].codigo, 
	name : 'jerarquia', 
	fieldLabel : '<s:message code="menu.clientes.listado.filtro.jerarquia" text="**Jerarquia" />'
});

<%-- Total importe (Desde / Hasta) --%>

<pfsforms:numberfield name="fieldImporteDesde" labelKey="plugin.precontencioso.tab.expjudicial.importe.desde" label="** Importe desde" 
	value="" 
	obligatory="false" 
	allowDecimals="true" />

<pfsforms:numberfield name="fieldImporteHasta" labelKey="plugin.precontencioso.tab.expjudicial.importe.hasta" label="** Importe hasta"
	value=""
	obligatory="false" 
	allowDecimals="true" />


//Campo Zonas, double select 
var creaDblSelectZonas = function(label, config){

	var store = config.store ;
	var cfg = {
	   	fieldLabel: label || ''
	   	,displayField:'descripcion'
	   	,valueField: 'codigo'
	   	,imagePath:"/${appProperties.appName}/js/fwk/ext.ux/Multiselect/images/"
	   	,dataFields : ['codigo', 'descripcion']
	   	,fromStore:store
	   	,toData : []
	       ,msHeight : config.height || 60
		,labelStyle:config.labelStyle || ''
	       ,msWidth : config.width || 140
	       ,drawTopIcon:false
	       ,drawBotIcon:false
	       ,drawUpIcon:false
		,drawDownIcon:false
		,disabled:true
		,toSortField : 'codigo'
	    };
	if(config.id) {
		cfg.id = config.id;
	}
	
	var itemSelector = new Ext.ux.ItemSelector(cfg);
	if (config.funcionReset){
		itemSelector.funcionReset = config.funcionReset;
	}
	
	//modificaciï¿½n al itemSelector porque no tiene un mï¿½todo setValue. Si se cambia de versiï¿½n se tendrï¿½ que revisar la validez de este mï¿½todo
	itemSelector.setValue =  function(val) {
	       if(!val) {
	           return;
	       }
	       val = val instanceof Array ? val : val.split(',');
	       var rec, i, id;
	       for(i = 0; i < val.length; i++) {
	           id = val[i];
	           if(this.toStore.find('id',id)>=0) {
	               continue;
	           }
	           rec = this.fromStore.find('id',id);
	           if(rec>=0) {
	           	rec = this.fromStore.getAt(rec);
	               this.toStore.add(rec);
	               this.fromStore.remove(rec);
	           }
	       }
	   };
	
	itemSelector.getStore =  function() {
		return this.toStore;
	};
	
	return itemSelector;
};
	
var zonasRecord = Ext.data.Record.create([
	 {name:'codigo'}
	,{name:'descripcion'}
]);
    
var optionsZonasStore =  page.getStore({
       flow: 'expedientejudicial/getZonasPorNivel'
       ,reader: new Ext.data.JsonReader({
    	 root : 'ddZonas'
    }, zonasRecord)	       
});

var comboZonas = creaDblSelectZonas('<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',
	{store:optionsZonasStore, funcionReset:recargarComboZonas}
);
	
var recargarComboZonas = function(){
	if (comboJerarquia.getValue()!=null && comboJerarquia.getValue()!=''){
		optionsZonasStore.webflow({idJerarquia:comboJerarquia.getValue()});
	}else{
		optionsZonasStore.webflow({idJerarquia:0});
		comboZonas.setValue('');
		optionsZonasStore.removeAll();
	}
}
	
var limpiarYRecargar = function(){
	comboZonas.reset();
	recargarComboZonas();
	comboZonas.setDisabled(false);
}
	
comboJerarquia.on('select',limpiarYRecargar);

recargarComboZonas();


<%-- Paneles --%>

var filtrosTabDatosProcedimientoActive = false;

var filtrosTabDatosProcedimiento = new Ext.Panel({
	title: '<s:message code="plugin.precontencioso.tab.expjudicial.titulo" text="** Expediente judicial" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [fieldCodigo, fieldNombreExpedienteJudicial, fieldDiasGestion, comboTipoProcPropuesto, comboTipoPreparacion, comboDisponibleDocumentos, comboDisponibleLiquidaciones, comboDisponibleBurofaxes, comboJerarquia, comboZonas, fieldImporteDesde]
	}, {
		layout: 'form',
		items: [panelFechaInicioPreparacion, panelFechaPreparado, panelFechaEnviadoLetrado, panelFechaFinalizado, panelFechaUltimaSubsanacion, panelFechaCancelado, comboTiposGestor, comboDespachos, comboGestor, filtroEstadoPreparacion, fieldImporteHasta]
	}]
});

filtrosTabDatosProcedimiento.on('activate',function(){
	filtrosTabDatosProcedimientoActive = true;
});

<%-- Utils --%>

var getParametrosFiltroProcedimiento = function() {
	var out = {};
	out.proCodigo = fieldCodigo.getValue();
	out.proNombre = fieldNombreExpedienteJudicial.getValue();
	out.proFechaInicioPreparacionDesde = dateFieldInicioPreparacionDesde.getValue();
	out.proFechaInicioPreparacionHasta = dateFieldInicioPreparacionHasta.getValue();
	out.proFechaPreparadoDesde = dateFieldPreparadoDesde.getValue();
	out.proFechaPreparadoHasta = dateFieldPreparadoHasta.getValue();
	out.proFechaEnviadoLetradoDesde = dateFieldEnviadoLetradoDesde.getValue();
	out.proFechaEnviadoLetradoHasta = dateFieldEnviadoLetradoHasta.getValue();
	out.proFechaFinalizadoDesde = dateFieldFinalizadoDesde.getValue();
	out.proFechaFinalizadoHasta = dateFieldFinalizadoHasta.getValue();
	out.proFechaUltimaSubsanacionDesde = dateFieldUltimaSubsanacionDesde.getValue();
	out.proFechaUltimaSubsanacionHasta = dateFieldUltimaSubsanacionHasta.getValue();
	out.proFechaCanceladoDesde = dateFieldCanceladoDesde.getValue();
	out.proFechaCanceladoHasta = dateFieldCanceladoHasta.getValue();
	out.proFechaParalizacionDesde = dateFieldParalizacionDesde.getValue();
	out.proFechaParalizacionHasta = dateFieldParalizacionHasta.getValue();
	out.proTipoProcedimiento = comboTipoProcPropuesto.getValue();
	out.proTipoPreparacion = comboTipoPreparacion.getValue();
	out.proCodigosEstado = fieldEstadoPreparacion.childNodes[1].value;
	out.proTipoGestor = comboTiposGestor.getValue();
	out.proDespacho = comboDespachos.getValue();
	out.proGestor = comboGestor.getValue();
	out.proJerarquiaContable = comboJerarquia.getValue();
	out.proCentroContable = comboZonas.getValue();

	out.proDisponibleDocumentos = comboDisponibleDocumentos.getValue();
	out.proDisponibleLiquidaciones = comboDisponibleLiquidaciones.getValue();
	out.proDisponibleBurofaxes = comboDisponibleBurofaxes.getValue();
	out.proDiasGestion = fieldDiasGestion.getValue();
	out.importeDesde = fieldImporteDesde.getValue();
	out.importeHasta = fieldImporteHasta.getValue();

	return out;
}
