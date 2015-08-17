<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>


<%-- Codigo --%>

var fieldCodigo = new Ext.form.TextField({
	name: 'codigo',
	fieldLabel : '<s:message code="asd" text="** Código" />'
});

<%-- Nombre Expediente Judicial --%>

var fieldNombreExpedienteJudicial = new Ext.form.TextField({
	name: 'nombreExpedienteJudicial',
	fieldLabel : '<s:message code="asd" text="** Nom. Exp Judicial" />'
});

<%-- Días en gestión: Número de días transcurridos en el estado actual del expediente, o en caso de seleccionar algún estado en particular, el plazoen gestión de dicho estado. --%>

<pfsforms:numberfield name="fieldDiasGestion" labelKey="asd" label="** Días en gestión" 
	value="" 
	obligatory="false" 
	allowDecimals="false" />

<%-- Fecha inicio de la preparación (Desde / Hasta) --%>

var dateFieldInicioPreparacionDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldInicioPreparacionDesde',
	fieldLabel: '<s:message code="asd" text="** F. Inicio Preparacion" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Preparado" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Preparado" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Finalizado" />'
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
	fieldLabel: '<s:message code="asd" text="** F. última subsanación" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Cancelado" />'
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

<pfsforms:ddCombo name="comboTipoProcPropuesto" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Tipo de procedimiento propuesto" value="" dd="${tipoProcedimientoProcpuesto}" />

<%-- Tipo de preparación --%>

<pfsforms:ddCombo name="comboTipoPreparacion" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Tipo de preparación" value="" dd="${tipoPreparacion}" />

<%-- Disponible todos los documentos SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleDocumentos" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Disponible todos los documentos" value="" dd="${ddSiNo}" />

<%-- Disponible todas las liquidaciones SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleLiquidaciones" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Disponible todas las liquidaciones" value="" dd="${ddSiNo}" />

<%-- Disponible todos los burofaxes SI/NO --%>

<pfsforms:ddCombo name="comboDisponibleBurofaxes" propertyCodigo="codigo" propertyDescripcion="descripcion"
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
		id: 'fieldEstadoPreparacion'
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
		items: [comboTipoBusqueda, fieldCodigo, fieldNombreExpedienteJudicial, fieldDiasGestion, comboTipoProcPropuesto, comboTipoPreparacion, comboDisponibleDocumentos, comboDisponibleLiquidaciones, comboDisponibleBurofaxes]
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

	out.proDisponibleDocumentos = comboDisponibleDocumentos.getValue();
	out.proDisponibleLiquidaciones = comboDisponibleLiquidaciones.getValue();
	out.proDisponibleBurofaxes = comboDisponibleBurofaxes.getValue();
	out.proDiasGestion = fieldDiasGestion.getValue();

	return out;
}
