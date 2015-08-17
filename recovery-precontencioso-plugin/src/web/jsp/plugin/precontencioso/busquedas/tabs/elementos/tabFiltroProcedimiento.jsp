<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


<%-- Codigo --%>

var fieldCodigoEle = new Ext.form.TextField({
	name: 'codigo',
	fieldLabel : '<s:message code="asd" text="** Código" />'
});

<%-- Nombre Expediente Judicial --%>

var fieldNombreExpedienteJudicialEle = new Ext.form.TextField({
	name: 'nombreExpedienteJudicial',
	fieldLabel : '<s:message code="asd" text="** Nom. Exp Judicial" />'
});

<%-- Días en gestión: Número de días transcurridos en el estado actual del expediente, o en caso de seleccionar algún estado en particular, el plazoen gestión de dicho estado. --%>

<pfsforms:numberfield name="fieldDiasGestionEle" labelKey="asd" label="** Días en gestión" 
	value="" 
	obligatory="false" 
	allowDecimals="false" />

<%-- Fecha inicio de la preparación (Desde / Hasta) --%>

var dateFieldInicioPreparacionDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldInicioPreparacionDesdeEle',
	fieldLabel: '<s:message code="asd" text="** F. Inicio Preparacion" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Preparado" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Preparado" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Finalizado" />'
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
	fieldLabel: '<s:message code="asd" text="** F. última subsanación" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Cancelado" />'
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
	
	var ocultarTipoBusqueda = ${ocultarTipoBusqueda};
	
	var comboTipoBusqueda = new Ext.form.ComboBox({
	    fieldLabel: '<s:message text="**Tipo de busqueda"/>',
	    hidden:ocultarTipoBusqueda,
	    disable:ocultarTipoBusqueda,
	    allowBlank: true,
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
	    valueField: 'myId',
	    displayField: 'displayText'
	});
	
	comboTipoBusqueda.on('select', function(combo, record, index) {
	    if(comboTipoBusqueda.getValue() == documento) {
            filtrosTabDocumentos.enable();
            filtrosTabLiquidacion.disable();	            	
			filtrosTabBurofax.disable();
			gridDocumentoPco.show();
            gridLiquidacionPco.hide();
            gridBurofaxPco.hide();
		}else if(comboTipoBusqueda.getValue() == liquidacion) {
           	filtrosTabDocumentos.disable();
            filtrosTabLiquidacion.enable();
           	filtrosTabBurofax.disable();
           	gridDocumentoPco.hide();
            gridLiquidacionPco.show();
            gridBurofaxPco.hide();
        }else if(comboTipoBusqueda.getValue() == burofax) {
          	filtrosTabDocumentos.disable();
          	filtrosTabLiquidacion.disable();
			filtrosTabBurofax.enable();
			gridDocumentoPco.hide();
            gridLiquidacionPco.hide();
            gridBurofaxPco.show();
        }
	});

<pfsforms:ddCombo name="comboTipoProcPropuestoEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Tipo de procedimiento propuesto" value="" dd="${tipoProcedimientoProcpuesto}" />

<%-- Tipo de preparación --%>

<pfsforms:ddCombo name="comboTipoPreparacionEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Tipo de preparación" value="" dd="${tipoPreparacion}" />

<%-- Disponible todos los documentos SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleDocumentosEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Disponible todos los documentos" value="" dd="${ddSiNo}" />

<%-- Disponible todas las liquidaciones SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleLiquidacionesEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Disponible todas las liquidaciones" value="" dd="${ddSiNo}" />

<%-- Disponible todos los burofaxes SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleBurofaxesEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Disponible todos los burofaxes" value="" dd="${ddSiNo}" />

<%-- Actores asignados: Permitirá buscar por los distintos actores que estén asignados a los expedientes. (Rol, Despacho y usuario) --%>

<%-- Selector múltiple del estado en que se encuentran los expedientes. --%>

var estadoPreparacion = <app:dict value="${estadoPreparacion}" />;

var estadoPreparacionStore = new Ext.data.JsonStore({
		data: estadoPreparacion,
		root: 'diccionario',
		fields: ['codigo', 'descripcion']
});

var filtroEstadoPreparacion = app.creaDblSelect(
	estadoPreparacion,
	'<s:message code="asd" text="** Estado Expediente" />',
	{
		store: estadoPreparacionStore,
		id: 'fieldEstadoPreparacionEle'
	}
);

<%-- Jerarquía y Centros: Donde el filtro aplicará sobre el centro al que pertenece alguno de los contratos en preparación. --%>

<%-- Paneles --%>

var filtrosTabDatosProcedimientoActive = false;

var filtrosTabDatosProcedimiento = new Ext.Panel({
	title: '<s:message code="asd" text="** Expediente judicial" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [comboTipoBusqueda, fieldCodigoEle, fieldNombreExpedienteJudicialEle, fieldDiasGestionEle, comboTipoProcPropuestoEle, comboTipoPreparacionEle, comboDisponibleDocumentosEle, comboDisponibleLiquidacionesEle, comboDisponibleBurofaxesEle]
	}, {
		layout: 'form',
		items: [panelFechaInicioPreparacion, panelFechaPreparado, panelFechaEnviadoLetrado, panelFechaFinalizado, panelFechaUltimaSubsanacion, panelFechaCancelado, filtroEstadoPreparacion]
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

	out.proDisponibleDocumentos = comboDisponibleDocumentosEle.getValue();
	out.proDisponibleLiquidaciones = comboDisponibleLiquidacionesEle.getValue();
	out.proDisponibleBurofaxes = comboDisponibleBurofaxesEle.getValue();
	out.proDiasGestion = fieldDiasGestionEle.getValue();

	return out;
}
