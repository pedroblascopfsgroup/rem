<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<%-- Estado --%>

var diccEstadoLiquidacion = <app:dict value="${estadoLiquidacion}" />;

var comboEstadoLiquidacion = app.creaDblSelect(
	diccEstadoLiquidacion,
	'<s:message code="plugin.precontencioso.tab.liquidacion.estado" text="** Estado" />',
	{
		id: 'fieldEstadoLiquidacionEle',
		height: 100,
		width: 220
	}
);

<%-- Fecha solicitud (Desde / Hasta) --%>

var dateFieldSolicitudLiqDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudLiqDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.solicitud" text="** F. Solicitud" />'
});

var dateFieldSolicitudLiqHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudLiqHastaEle',
	hideLabel: true,
	width: 95
});

var panelFechaSolicitudLiq = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldSolicitudLiqDesdeEle]},
		{layout: 'form', items: [dateFieldSolicitudLiqHastaEle]}
	]
});

<%-- Fecha Recepción (Desde / Hasta) --%>

var dateFieldRecepcionLiqDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionLiqDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.recepcion" text="** F. Recepción" />'
});

var dateFieldRecepcionLiqHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionLiqHastaEle',
	hideLabel: true,
	width: 95
});

var panelFechaRecepcionLiq = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldRecepcionLiqDesdeEle]},
		{layout: 'form', items: [dateFieldRecepcionLiqHastaEle]}
	]
});

<%-- Fecha confirmación (Desde / Hasta) --%>

var dateFieldConfirmacionLiqDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldConfirmacionLiqDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.confirmacion" text="** F. Confirmación" />'
});

var dateFieldConfirmacionLiqHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldConfirmacionLiqHastaEle',
	hideLabel: true,
	width: 95
});

var panelFechaConfirmacionLiq = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldConfirmacionLiqDesdeEle]},
		{layout: 'form', items: [dateFieldConfirmacionLiqHastaEle]}
	]
});

<%-- Fecha del cierre (Desde / Hasta) --%>

var dateFieldCierreLiqDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldCierreLiqDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.cierre" text="** F. Cierre" />'
});

var dateFieldCierreLiqHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldCierreLiqHastaEle',
	hideLabel: true,
	width: 95
});

var panelFechaCierreLiq = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldCierreLiqDesdeEle]},
		{layout: 'form', items: [dateFieldCierreLiqHastaEle]}
	]
});

<%-- Total liquidación (Desde / Hasta) --%>

<pfsforms:numberfield name="fieldTotalLiqDesdeEle" labelKey="plugin.precontencioso.tab.liquidacion.total.desde" label="** Total liquidación desde" 
	value="" 
	obligatory="false" 
	allowDecimals="true" />

<pfsforms:numberfield name="fieldTotalLiqHastaEle" labelKey="plugin.precontencioso.tab.liquidacion.total.hasta" label="** Total liquidación hasta"
	value=""
	obligatory="false" 
	allowDecimals="true" />

<%-- Días en gestión --%>

<pfsforms:numberfield name="fieldDiasGestionLiqEle" labelKey="plugin.precontencioso.tab.liquidacion.gestion.dias" label="** Días en gestión" 
	value="" 
	obligatory="false" 
	allowDecimals="false" />

<%-- Paneles --%>

var filtrosTabLiquidacionActive = false;

var filtrosTabLiquidacion = new Ext.Panel({
	title: '<s:message code="plugin.precontencioso.tab.liquidacion.titulo" text="** Liquidaciones" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [comboEstadoLiquidacion, fieldDiasGestionLiqEle, fieldTotalLiqDesdeEle, fieldTotalLiqHastaEle]
	}, {
		layout: 'form',
		items: [panelFechaSolicitudLiq, panelFechaRecepcionLiq, panelFechaConfirmacionLiq, panelFechaCierreLiq]
	}]
});

filtrosTabLiquidacion.on('activate',function(){
	filtrosTabLiquidacionActive = true;
});

<%-- Utils --%>

var getParametrosFiltroLiquidaciones = function() {
	var out = {};

	out.liqEstados = fieldEstadoLiquidacionEle.childNodes[1].value;
	out.liqFechaSolicitudDesde = dateFieldSolicitudLiqDesdeEle.getValue();
	out.liqFechaSolicitudHasta = dateFieldSolicitudLiqHastaEle.getValue();
	out.liqFechaRecepcionDesde = dateFieldRecepcionLiqDesdeEle.getValue();
	out.liqFechaRecepcionHasta = dateFieldRecepcionLiqHastaEle.getValue();
	out.liqFechaConfirmacionDesde = dateFieldConfirmacionLiqDesdeEle.getValue();
	out.liqFechaConfirmacionHasta = dateFieldConfirmacionLiqHastaEle.getValue();
	out.liqFechaCierreDesde = dateFieldCierreLiqDesdeEle.getValue();
	out.liqFechaCierreHasta = dateFieldCierreLiqHastaEle.getValue();
	out.liqTotalDesde = fieldTotalLiqDesdeEle.getValue();
	out.liqTotalHasta = fieldTotalLiqHastaEle.getValue();
	out.liqDiasGestion = fieldDiasGestionLiqEle.getValue();

	return out;
}

var limpiaPestanaLiquidaciones = function() {
	app.resetCampos([comboEstadoLiquidacion, dateFieldSolicitudLiqDesdeEle, dateFieldSolicitudLiqHastaEle, 
	dateFieldRecepcionLiqDesdeEle, dateFieldRecepcionLiqHastaEle, dateFieldConfirmacionLiqDesdeEle, dateFieldConfirmacionLiqHastaEle,
	dateFieldCierreLiqDesdeEle, dateFieldCierreLiqHastaEle, fieldTotalLiqDesdeEle, fieldTotalLiqHastaEle, fieldDiasGestionLiqEle]);
}
