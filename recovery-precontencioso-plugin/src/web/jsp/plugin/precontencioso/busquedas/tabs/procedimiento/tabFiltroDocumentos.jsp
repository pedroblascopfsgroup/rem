<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<%-- Tipo de documento --%>

var diccTipoDocumento = <app:dict value="${tipoDocumento}" />;

var comboTipoDocumento = app.creaDblSelect(
	diccTipoDocumento,
	'<s:message code="plugin.precontencioso.tab.documento.tipo.documento" text="** Tipo de documento" />',
	{
		id: 'fieldTipoDocumento',
		height: 150,
		width: 220
	}
);

<%-- Estado de documento --%>

var diccEstadoDocumento = <app:dict value="${estadoDocumento}" />;

var comboEstadoDocumento = app.creaDblSelect(
	diccEstadoDocumento,
	'<s:message code="plugin.precontencioso.tab.documento.estado" text="** Estado" />',
	{
		id: 'fieldEstadoDocumento',
		height: 100,
		width: 220
	}
);

<%-- Respuesta ultima solicitud --%>

var diccResultadoSolicitud = <app:dict value="${resultadoSolicitud}" />;

var comboRespuestaSolicitud = app.creaDblSelect(
	diccResultadoSolicitud,
	'<s:message code="plugin.precontencioso.tab.documento.respuesta.solicitud" text="** Respuesta ultima solicitud" />',
	{
		id: 'fieldRespuestaSolicitud',
		height: 60,
		width: 220
	}
);

<%-- Actor última solicitud: Selector múltiple del actor al que se le ha enviado la última solicitud. --%>

<%-- Fecha solicitud (Desde / Hasta) --%>

var dateFieldSolicitudDocDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudDocDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.documento.fecha.solicitud" text="** F. Solicitud" />'
});

var dateFieldSolicitudDocHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudDocHasta',
	hideLabel: true,
	width: 95
});

var panelFechaSolicitudDoc = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldSolicitudDocDesde]},
		{layout: 'form', items: [dateFieldSolicitudDocHasta]}
	]
});

<%-- Fecha resultado (Desde / Hasta) --%>

var dateFieldResultadoDocDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldResultadoDocDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.documento.fecha.resultado" text="** F. Resultado" />'
});

var dateFieldResultadoDocHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldResultadoDocHasta',
	hideLabel: true,
	width: 95
});

var panelFechaResultadoDoc = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldResultadoDocDesde]},
		{layout: 'form', items: [dateFieldResultadoDocHasta]}
	]
});

<%-- Fecha envío (Desde / Hasta) --%>

var dateFieldEnvioDocDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioDocDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.documento.fecha.envio" text="** F. Envio" />'
});

var dateFieldEnvioDocHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioDocHasta',
	hideLabel: true,
	width: 95
});

var panelFechaEnvioDoc = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldEnvioDocDesde]},
		{layout: 'form', items: [dateFieldEnvioDocHasta]}
	]
});

<%-- Fecha Recepción (Desde / Hasta) --%>

var dateFieldRecepcionDocDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionDocDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.documento.fecha.recepcion" text="** F. Recepción" />'
});

var dateFieldRecepcionDocHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionDocHasta',
	hideLabel: true,
	width: 95
});

var panelFechaRecepcionDoc = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldRecepcionDocDesde]},
		{layout: 'form', items: [dateFieldRecepcionDocHasta]}
	]
});

<%-- Adjunto --%>

<pfsforms:ddCombo name="comboAdjuntoDoc" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.documento.adjunto" 
label="** Adjunto" value="" dd="${ddSiNo}" />

<%-- Solicitud previa --%>

<pfsforms:ddCombo name="comboSolicitudPreviaDoc" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.documento.solicitud.previa" 
label="** Solicitud previa" value="" dd="${ddSiNo}" />

<%-- Días en gestión --%>

<pfsforms:numberfield name="fieldDiasGestionDoc" labelKey="plugin.precontencioso.tab.documento.gestion.dias" label="** Días en gestión" 
	value=""
	obligatory="false"
	allowDecimals="false" />
	
	
<%-- Actores asignados: Permitirá buscar por los distintos actores que estén asignados a los expedientes. (Rol, Despacho y usuario) --%>

<pfsforms:ddCombo name="comboTiposGestorDoc" propertyCodigo="id" propertyDescripcion="descripcion"
labelKey="ext.asuntos.busqueda.filtro.tipoGestor" label="**Tipo de gestor" value="" dd="${ddListadoGestores}" />

comboTiposGestorDoc.on('select', function(){
	comboDespachosDoc.reset();
	optionsDespachoStoreDoc.webflow({'idTipoGestor': comboTiposGestorDoc.getValue(), 'incluirBorrados': true}); 
	comboGestorDoc.reset();
	comboDespachosDoc.setDisabled(false);
});
 
//store generico de combo diccionario
var optionsDespachosRecordDoc = Ext.data.Record.create([
	 {name:'cod'}
	,{name:'descripcion'}
]);

var optionsDespachoStoreDoc = page.getStore({
       flow: 'expedientejudicial/getListTipoDespachoData'
       ,reader: new Ext.data.JsonReader({
    	 root : 'listadoDespachos'
    }, optionsDespachosRecordDoc)	       
});

//Campo Combo Despacho
var comboDespachosDoc = new Ext.form.ComboBox({
	store:optionsDespachoStoreDoc
	,displayField:'descripcion'
	,valueField:'cod'
	,mode: 'remote'
	,emptyText:'---'
	,editable: false
	,triggerAction: 'all'
	,disabled:true
	,resizable:true
	,fieldLabel : '<s:message code="asuntos.busqueda.filtro.despacho" text="**Despacho"/>'
	<app:test id="comboDespachosDoc" addComa="true"/>
});

comboDespachosDoc.on('select', function(){
	comboGestorDoc.reset();
	optionsGestoresStoreDoc.webflow({'idTipoDespacho': comboDespachosDoc.getValue(), 'incluirBorrados': true}); 
	comboGestorDoc.setDisabled(false);
});

var GestorDoc = Ext.data.Record.create([
	 {name:'id'}
	,{name:'username'}
]);

var optionsGestoresStoreDoc =  page.getStore({
       flow: 'expedientejudicial/getListUsuariosData'
       ,reader: new Ext.data.JsonReader({
    	 root : 'listadoUsuarios'
    }, GestorDoc)	       
});

//Campo Gestores, double select 
var creaDblSelectMioDoc = function(label, config){

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

var comboGestorDoc = creaDblSelectMioDoc('<s:message code="asuntos.busqueda.filtro.gestor" text="**Gestor" />',{store:optionsGestoresStoreDoc, funcionReset:recargarComboGestoresDoc});

var recargarComboGestoresDoc = function(){
	optionsGestoresStoreDoc.webflow({id:0});
}

var validarEmptyForm = function(){
	return (comboDespachosDoc.getValue() != '' || comboGestorDoc.getValue() != '' || comboTiposGestorDoc.getValue() != '');
}
		
var validaMinMax = function(){
	return true;
}

<%-- Paneles --%>

var filtrosTabDocumentosActive = false;

var filtrosTabDocumentos = new Ext.Panel({
	title: '<s:message code="plugin.precontencioso.tab.documento.titulo" text="** Documentos" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [comboAdjuntoDoc, comboSolicitudPreviaDoc, fieldDiasGestionDoc, panelFechaSolicitudDoc, panelFechaResultadoDoc, panelFechaEnvioDoc, panelFechaRecepcionDoc, comboRespuestaSolicitud, comboTiposGestorDoc, comboDespachosDoc, comboGestorDoc]
	}, {
		layout: 'form',
		items: [comboTipoDocumento, comboEstadoDocumento]
	}]
});

filtrosTabDocumentos.on('activate',function(){
	filtrosTabDocumentosActive = true;
});

<%-- Utils --%>

var getParametrosFiltroDocumentos = function() {
	var out = {};

	out.docTiposDocumento = fieldTipoDocumento.childNodes[1].value;
	out.docEstados = fieldEstadoDocumento.childNodes[1].value;
	out.docUltimaRespuesta = fieldRespuestaSolicitud.childNodes[1].value;
	out.docFechaSolicitudDesde = dateFieldSolicitudDocDesde.getValue();
	out.docFechaSolicitudHasta = dateFieldSolicitudDocHasta.getValue();
	out.docFechaResultadoDesde = dateFieldResultadoDocDesde.getValue();
	out.docFechaResultadoHasta = dateFieldResultadoDocHasta.getValue();
	out.docFechaEnvioDesde = dateFieldEnvioDocDesde.getValue();
	out.docFechaEnvioHasta = dateFieldEnvioDocHasta.getValue();
	out.docFechaRecepcionDesde = dateFieldRecepcionDocDesde.getValue();
	out.docFechaRecepcionHasta = dateFieldRecepcionDocHasta.getValue();
	out.docAdjunto = comboAdjuntoDoc.getValue();
	out.docSolicitudPrevia = comboSolicitudPreviaDoc.getValue();
	out.docDiasGestion = fieldDiasGestionDoc.getValue();
	out.docTipoGestor = comboTiposGestorDoc.getValue();
	out.docDespacho = comboDespachosDoc.getValue();
	out.docGestor = comboGestorDoc.getValue();
	
	//out.ultimoActor = ;

	return out;
}