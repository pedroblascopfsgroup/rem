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
		id: 'fieldEstadoLiquidacion',
		height: 100,
		width: 220
	}
);

<%-- Fecha solicitud (Desde / Hasta) --%>

var dateFieldSolicitudLiqDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudLiqDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.solicitud" text="** F. Solicitud" />'
});

var dateFieldSolicitudLiqHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudLiqHasta',
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
		{layout: 'form', items: [dateFieldSolicitudLiqDesde]},
		{layout: 'form', items: [dateFieldSolicitudLiqHasta]}
	]
});

<%-- Fecha Recepción (Desde / Hasta) --%>

var dateFieldRecepcionLiqDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionLiqDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.recepcion" text="** F. Recepción" />'
});

var dateFieldRecepcionLiqHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionLiqHasta',
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
		{layout: 'form', items: [dateFieldRecepcionLiqDesde]},
		{layout: 'form', items: [dateFieldRecepcionLiqHasta]}
	]
});

<%-- Fecha confirmación (Desde / Hasta) --%>

var dateFieldConfirmacionLiqDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldConfirmacionLiqDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.confirmacion" text="** F. Confirmación" />'
});

var dateFieldConfirmacionLiqHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldConfirmacionLiqHasta',
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
		{layout: 'form', items: [dateFieldConfirmacionLiqDesde]},
		{layout: 'form', items: [dateFieldConfirmacionLiqHasta]}
	]
});

<%-- Fecha del cierre (Desde / Hasta) --%>

var dateFieldCierreLiqDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldCierreLiqDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.liquidacion.fecha.cierre" text="** F. Cierre" />'
});

var dateFieldCierreLiqHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldCierreLiqHasta',
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
		{layout: 'form', items: [dateFieldCierreLiqDesde]},
		{layout: 'form', items: [dateFieldCierreLiqHasta]}
	]
});

<%-- Total liquidación (Desde / Hasta) --%>

<pfsforms:numberfield name="fieldTotalLiqDesde" labelKey="plugin.precontencioso.tab.liquidacion.total.desde" label="** Total liquidación desde" 
	value="" 
	obligatory="false" 
	allowDecimals="true" />

<pfsforms:numberfield name="fieldTotalLiqHasta" labelKey="plugin.precontencioso.tab.liquidacion.total.hasta" label="** Total liquidación hasta"
	value=""
	obligatory="false" 
	allowDecimals="true" />

<%-- Días en gestión --%>

<pfsforms:numberfield name="fieldDiasGestionLiq" labelKey="plugin.precontencioso.tab.liquidacion.gestion.dias" label="** Días en gestión" 
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
		items: [comboEstadoLiquidacion, fieldDiasGestionLiq, fieldTotalLiqDesde, fieldTotalLiqHasta]
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

	out.liqEstados = fieldEstadoLiquidacion.childNodes[1].value;
	out.liqFechaSolicitudDesde = dateFieldSolicitudLiqDesde.getValue();
	out.liqFechaSolicitudHasta = dateFieldSolicitudLiqHasta.getValue();
	out.liqFechaRecepcionDesde = dateFieldRecepcionLiqDesde.getValue();
	out.liqFechaRecepcionHasta = dateFieldRecepcionLiqHasta.getValue();
	out.liqFechaConfirmacionDesde = dateFieldConfirmacionLiqDesde.getValue();
	out.liqFechaConfirmacionHasta = dateFieldConfirmacionLiqHasta.getValue();
	out.liqFechaCierreDesde = dateFieldCierreLiqDesde.getValue();
	out.liqFechaCierreHasta = dateFieldCierreLiqHasta.getValue();
	out.liqTotalDesde = fieldTotalLiqDesde.getValue();
	out.liqTotalHasta = fieldTotalLiqHasta.getValue();
	out.liqDiasGestion = fieldDiasGestionLiq.getValue();

	return out;
}
