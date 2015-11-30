<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


<%-- Codigo --%>
<pfsforms:numberfield name="fieldCodigoEle" labelKey="plugin.precontencioso.tab.expjudicial.codigo" label="** Código" 
	value="" obligatory="false" allowDecimals="false" />

<%-- Nombre Expediente Judicial --%>

var fieldNombreExpedienteJudicialEle = new Ext.form.TextField({
	name: 'nombreExpedienteJudicial',
	fieldLabel : '<s:message code="plugin.precontencioso.tab.expjudicial.nombre" text="** Nom. Exp Judicial" />'
});

<%-- Días en gestión: Número de días transcurridos en el estado actual del expediente, o en caso de seleccionar algún estado en particular, el plazoen gestión de dicho estado. --%>

<pfsforms:numberfield name="fieldDiasGestionEle" labelKey="plugin.precontencioso.tab.expjudicial.dias.gestion" label="** Días en gestión" 
	value="" 
	obligatory="false" 
	allowDecimals="false" />

<%-- Fecha inicio de la preparación (Desde / Hasta) --%>

var dateFieldInicioPreparacionDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldInicioPreparacionDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.preparacion" text="** F. Inicio Preparacion" />'
});

var dateFieldInicioPreparacionHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldInicioPreparacionHastaEle',
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
		{layout: 'form', items: [dateFieldInicioPreparacionDesdeEle]},
		{layout: 'form', items: [dateFieldInicioPreparacionHastaEle]}
	]
});

<%-- Fecha preparado (Desde / Hasta) --%>

var dateFieldPreparadoDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldPreparadoDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.preparado" text="** F. Preparado" />'
});

var dateFieldPreparadoHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldPreparadoHastaEle',
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
		{layout: 'form', items: [dateFieldPreparadoDesdeEle]},
		{layout: 'form', items: [dateFieldPreparadoHastaEle]}
	]
});

<%-- Fecha enviado a letrado (Desde / Hasta) --%>

var dateFieldEnviadoLetradoDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldEnviadoLetradoDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.envioLetrado" text="** F. enviado a letrado " />'
});

var dateFieldEnviadoLetradoHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldEnviadoLetradoHastaEle',
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
		{layout: 'form', items: [dateFieldEnviadoLetradoDesdeEle]},
		{layout: 'form', items: [dateFieldEnviadoLetradoHastaEle]}
	]
});

<%-- Fecha finalizado (Desde / Hasta) --%>

var dateFieldFinalizadoDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldFinalizadoDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.finalizado" text="** F. Finalizado" />'
});

var dateFieldFinalizadoHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldFinalizadoHastaEle',
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
		{layout: 'form', items: [dateFieldFinalizadoDesdeEle]},
		{layout: 'form', items: [dateFieldFinalizadoHastaEle]}
	]
});

<%-- Fecha última subsanación (Desde / Hasta) --%>

var dateFieldUltimaSubsanacionDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldUltimaSubsanacionDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.subsanacion" text="** F. última subsanación" />'
});

var dateFieldUltimaSubsanacionHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldUltimaSubsanacionHastaEle',
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
		{layout: 'form', items: [dateFieldUltimaSubsanacionDesdeEle]},
		{layout: 'form', items: [dateFieldUltimaSubsanacionHastaEle]}
	]
});

<%-- Fecha cancelado (Desde / Hasta) --%>

var dateFieldCanceladoDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldCanceladoDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.cancelado" text="** F. Cancelado" />'
});

var dateFieldCanceladoHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldCanceladoHastaEle',
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
		{layout: 'form', items: [dateFieldCanceladoDesdeEle]},
		{layout: 'form', items: [dateFieldCanceladoHastaEle]}
	]
});

<%-- Fecha paralización (Desde / Hasta) --%>

var dateFieldParalizacionDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldParalizacionDesdeEle',
	fieldLabel: '<s:message code="asd" text="** F. Paralización" />'
});

var dateFieldParalizacionHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldParalizacionHastaEle',
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
		{layout: 'form', items: [dateFieldParalizacionDesdeEle]},
		{layout: 'form', items: [dateFieldParalizacionHastaEle]}
	]
});

	var documento =	'<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO" />';
	var liquidacion = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION" />';
	var burofax = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX" />';
	
	var comboTipoBusqueda = new Ext.form.ComboBox({
	    fieldLabel: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.busqueda" text="**Tipo de busqueda"/>',
	    triggerAction: 'all',
	    mode: 'local',
	    store: new Ext.data.ArrayStore({
	        id: 0,
	        fields: [
	            'myId',
	            'displayText'
	        ],
	        data: [[documento, documento], [liquidacion, liquidacion], [burofax, burofax]]
	    }),
	    value: documento,
	    valueField: 'myId',
	    displayField: 'displayText'
	});
	
	comboTipoBusqueda.on('select', function(combo, record, index) {
		documentoPcoStore.removeAll();
		liquidacionPcoStore.removeAll();
		burofaxPcoStore.removeAll();
		pagingBarDoc.hide();
		pagingBarLiq.hide();
		pagingBarBur.hide();
	
		if(comboTipoBusqueda.getValue() == documento) {
            filtrosTabDocumentos.enable();
            filtrosTabLiquidacion.disable();	            	
			filtrosTabBurofax.disable();
			gridDocumentoPco.show();
            gridLiquidacionPco.hide();
            gridBurofaxPco.hide();
            limpiaPestanaLiquidaciones();
            limpiaPestanaBurofaxes();
		}else if(comboTipoBusqueda.getValue() == liquidacion) {
           	filtrosTabDocumentos.disable();
            filtrosTabLiquidacion.enable();
           	filtrosTabBurofax.disable();
           	gridDocumentoPco.hide();
            gridLiquidacionPco.show();
            gridBurofaxPco.hide();
            limpiaPestanaDocumentos();
            limpiaPestanaBurofaxes();
        }else if(comboTipoBusqueda.getValue() == burofax) {
          	filtrosTabDocumentos.disable();
          	filtrosTabLiquidacion.disable();
			filtrosTabBurofax.enable();
			gridDocumentoPco.hide();
            gridLiquidacionPco.hide();
            gridBurofaxPco.show();
            limpiaPestanaDocumentos();
            limpiaPestanaLiquidaciones();
		}
	});

<pfsforms:ddCombo name="comboTipoProcPropuestoEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.tipo.procedimiento" 
label="** Tipo de procedimiento propuesto" value="" dd="${tipoProcedimientoProcpuesto}" />

<%-- Tipo de preparación --%>

<pfsforms:ddCombo name="comboTipoPreparacionEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.tipo.preparacion" 
label="** Tipo de preparación" value="" dd="${tipoPreparacion}" />

<%-- Disponible todos los documentos SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleDocumentosEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.disponible.todos.documentos" 
label="** Disponible todos los documentos" value="" dd="${ddSiNo}" />

<%-- Disponible todas las liquidaciones SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleLiquidacionesEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.expjudicial.disponible.todos.liquidaciones" 
label="** Disponible todas las liquidaciones" value="" dd="${ddSiNo}" />

<%-- Disponible todos los burofaxes SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleBurofaxesEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
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
		id: 'fieldEstadoPreparacionEle'
	}
);

<%-- Actores asignados: Permitirá buscar por los distintos actores que estén asignados a los expedientes. (Rol, Despacho y usuario) --%>

<pfsforms:ddCombo name="comboTiposGestorEle" propertyCodigo="id" propertyDescripcion="descripcion"
labelKey="ext.asuntos.busqueda.filtro.tipoGestor" label="**Tipo de gestor" value="" dd="${ddListadoGestores}" />

comboTiposGestorEle.on('select', function(){
	comboDespachosEle.reset();
	optionsDespachoStore.webflow({'idTipoGestor': comboTiposGestorEle.getValue(), 'incluirBorrados': true}); 
	comboGestorEle.reset();
	comboDespachosEle.setDisabled(false);
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
var comboDespachosEle = new Ext.form.ComboBox({
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
	<app:test id="comboDespachosEle" addComa="true"/>
});

comboDespachosEle.on('select', function(){
	comboGestorEle.reset();
	optionsGestoresStore.webflow({'idTipoDespacho': comboDespachosEle.getValue(), 'incluirBorrados': true}); 
	comboGestorEle.setDisabled(false);
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

var comboGestorEle = creaDblSelectMio('<s:message code="asuntos.busqueda.filtro.gestor" text="**Gestor" />',{store:optionsGestoresStore, funcionReset:recargarComboGestores});

var recargarComboGestores = function(){
	optionsGestoresStore.webflow({id:0});
}

var validarEmptyForm = function(){
	return (comboDespachosEle.getValue() != '' || comboGestorEle.getValue() != '' || comboTiposGestorEle.getValue() != '');
}
		
var validaMinMax = function(){
	return true;
}

<%-- Jerarquía y Centros: Donde el filtro aplicará sobre el centro al que pertenece alguno de los contratos en preparación. --%>

var jerarquia = <app:dict value="${ddJerarquia}" blankElement="true" blankElementValue="" blankElementText="---" />;
	
var comboJerarquiaEle = app.creaCombo({
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

var comboZonasEle = creaDblSelectZonas('<s:message code="menu.clientes.listado.filtro.centro" text="**Centro" />',
	{store:optionsZonasStore, funcionReset:recargarComboZonas}
);
	
var recargarComboZonas = function(){
	if (comboJerarquiaEle.getValue()!=null && comboJerarquiaEle.getValue()!=''){
		optionsZonasStore.webflow({idJerarquia:comboJerarquiaEle.getValue()});
	}else{
		optionsZonasStore.webflow({idJerarquia:0});
		comboZonasEle.setValue('');
		optionsZonasStore.removeAll();
	}
}
	
var limpiarYRecargar = function(){
	comboZonasEle.reset();
	recargarComboZonas();
	comboZonasEle.setDisabled(false);
}
	
comboJerarquiaEle.on('select',limpiarYRecargar);

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
		items: [comboTipoBusqueda, fieldCodigoEle, fieldNombreExpedienteJudicialEle, fieldDiasGestionEle, comboTipoProcPropuestoEle, comboTipoPreparacionEle, comboDisponibleDocumentosEle, comboDisponibleLiquidacionesEle, comboDisponibleBurofaxesEle, comboJerarquiaEle, comboZonasEle, fieldImporteDesde, fieldImporteHasta]
	}, {
		layout: 'form',
		items: [panelFechaInicioPreparacion, panelFechaPreparado, panelFechaEnviadoLetrado, panelFechaFinalizado, panelFechaUltimaSubsanacion, panelFechaCancelado, comboTiposGestorEle, comboDespachosEle, comboGestorEle, filtroEstadoPreparacion]
	}]
});

filtrosTabDatosProcedimiento.on('activate',function(){
	filtrosTabDatosProcedimientoActive = true;
});

<%-- Utils --%>

var getParametrosFiltroProcedimiento = function() {
	var out = {};

	out.tipoBusqueda = comboTipoBusqueda.getValue();
	out.proCodigo = fieldCodigoEle.getValue();
	out.proNombre = fieldNombreExpedienteJudicialEle.getValue();
	out.proFechaInicioPreparacionDesde = dateFieldInicioPreparacionDesdeEle.getValue();
	out.proFechaInicioPreparacionHasta = dateFieldInicioPreparacionHastaEle.getValue();
	out.proFechaPreparadoDesde = dateFieldPreparadoDesdeEle.getValue();
	out.proFechaPreparadoHasta = dateFieldPreparadoHastaEle.getValue();
	out.proFechaEnviadoLetradoDesde = dateFieldEnviadoLetradoDesdeEle.getValue();
	out.proFechaEnviadoLetradoHasta = dateFieldEnviadoLetradoHastaEle.getValue();
	out.proFechaFinalizadoDesde = dateFieldFinalizadoDesdeEle.getValue();
	out.proFechaFinalizadoHasta = dateFieldFinalizadoHastaEle.getValue();
	out.proFechaUltimaSubsanacionDesde = dateFieldUltimaSubsanacionDesdeEle.getValue();
	out.proFechaUltimaSubsanacionHasta = dateFieldUltimaSubsanacionHastaEle.getValue();
	out.proFechaCanceladoDesde = dateFieldCanceladoDesdeEle.getValue();
	out.proFechaCanceladoHasta = dateFieldCanceladoHastaEle.getValue();
	out.proFechaParalizacionDesde = dateFieldParalizacionDesdeEle.getValue();
	out.proFechaParalizacionHasta = dateFieldParalizacionHastaEle.getValue();
	out.proTipoProcedimiento = comboTipoProcPropuestoEle.getValue();
	out.proTipoPreparacion = comboTipoPreparacionEle.getValue();
	out.proCodigosEstado = fieldEstadoPreparacionEle.childNodes[1].value;
	out.proTipoGestor = comboTiposGestorEle.getValue();
	out.proDespacho = comboDespachosEle.getValue();
	out.proGestor = comboGestorEle.getValue();
	out.proJerarquiaContable = comboJerarquiaEle.getValue();
	out.proCentroContable = comboZonasEle.getValue();
	
	out.proDisponibleDocumentos = comboDisponibleDocumentosEle.getValue();
	out.proDisponibleLiquidaciones = comboDisponibleLiquidacionesEle.getValue();
	out.proDisponibleBurofaxes = comboDisponibleBurofaxesEle.getValue();
	out.proDiasGestion = fieldDiasGestionEle.getValue();
	out.importeDesde = fieldImporteDesde.getValue();
	out.importeHasta = fieldImporteHasta.getValue();
	
	return out;
}

var limpiaPestanaProcedimiento = function() {
	app.resetCampos([comboTipoBusqueda, fieldCodigoEle, fieldNombreExpedienteJudicialEle, 
	dateFieldInicioPreparacionDesdeEle, dateFieldInicioPreparacionHastaEle,
	dateFieldPreparadoDesdeEle, dateFieldPreparadoHastaEle, dateFieldEnviadoLetradoDesdeEle, dateFieldEnviadoLetradoHastaEle,
	dateFieldFinalizadoDesdeEle, dateFieldFinalizadoHastaEle, dateFieldUltimaSubsanacionDesdeEle, dateFieldUltimaSubsanacionHastaEle,
	dateFieldCanceladoDesdeEle, dateFieldCanceladoHastaEle, dateFieldParalizacionDesdeEle, dateFieldParalizacionHastaEle,
	comboTipoProcPropuestoEle, comboTipoPreparacionEle, filtroEstadoPreparacion, comboTiposGestorEle,
	comboDespachosEle, comboGestorEle, comboJerarquiaEle, comboZonasEle, comboDisponibleDocumentosEle, comboDisponibleLiquidacionesEle,
	comboDisponibleBurofaxesEle, fieldDiasGestionEle, fieldImporteDesde, fieldImporteHasta]);
}