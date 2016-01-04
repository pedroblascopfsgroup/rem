<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<%-- Fecha solicitud --%>

var dateFieldSolicitudBurDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudBurDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.fecha.solicitud" text="** F. Solicitud" />'
});

var dateFieldSolicitudBurHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudBurHasta',
	hideLabel: true,
	width: 95
});

var panelFechaSolicitudBur = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldSolicitudBurDesde]},
		{layout: 'form', items: [dateFieldSolicitudBurHasta]}
	]
});

<%-- Fecha envío --%>

var dateFieldEnvioBurDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioBurDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.fecha.envio" text="** F. Envio" />'
});

var dateFieldEnvioBurHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioBurHasta',
	hideLabel: true,
	width: 95
});

var panelFechaEnvioBur = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldEnvioBurDesde]},
		{layout: 'form', items: [dateFieldEnvioBurHasta]}
	]
});

<%-- Fecha acuse --%>

var dateFieldAcuseBurDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldAcuseBurDesde',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.fecha.acuse" text="** F. Acuse" />'
});

var dateFieldAcuseBurHasta = new Ext.ux.form.XDateField({
	name: 'dateFieldAcuseBurHasta',
	hideLabel: true,
	width: 95
});

var panelFechaAcuseBur = new Ext.Panel({
	layout: 'table',
	title: '',
	collapsible: false,
	titleCollapse: false,
	layoutConfig: {columns: 2},
	style: 'margin-right: 0px; margin-left: 0px',
	border: false,
	defaults: {xtype: 'panel', border: false, cellCls: 'vtop'},
	items: [
		{layout: 'form', items: [dateFieldAcuseBurDesde]},
		{layout: 'form', items: [dateFieldAcuseBurHasta]}
	]
});

<%-- Reg Manual --%>

<pfsforms:ddCombo name="comboRegManual" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.burofax.regManual" 
label="** Reg. Manual" value="" dd="${ddSiNo}" />

<%-- Ref Externa Envio --%>

var fieldrefExternaEnvio = new Ext.form.TextField({
	name: 'refExternaEnvio',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.refExternaEnvio" text="** Ref Externa Envio" />'
});

<%-- Acuse de recibo --%>

<pfsforms:ddCombo name="comboAcuseRecibo" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.burofax.acuseRecibo" 
label="** Acuse de recibo" value="" dd="${ddSiNo}" />

<%-- Resultado último envío a cliente --%>

var diccResultadoBurofax = <app:dict value="${resultadoBurofax}" />;

var comboResultadoBurofax = app.creaDblSelect(
	diccResultadoBurofax,
	'<s:message code="plugin.precontencioso.tab.burofax.ultimo.envio" text="** Resultado último envío" />',
	{
		id: 'fliedResultadoBurofax',
		height: 100,
		width: 200
	}
);

<%-- Paneles --%>
var filtrosTabBurofaxActive = false;

var filtrosTabBurofax = new Ext.Panel({
	title: '<s:message code="plugin.precontencioso.tab.burofax.titulo" text="** Burofax" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [fieldrefExternaEnvio, comboNotificado, comboAcuseRecibo, comboRegManual, comboResultadoBurofax]
	}, {
		layout: 'form',
		items: [panelFechaSolicitudBur, panelFechaEnvioBur, panelFechaAcuseBur]
	}]
});

filtrosTabBurofax.on('activate',function(){
	filtrosTabBurofaxActive = true;
});

<%-- Utils --%>

var getParametrosFiltroBurofax = function() {
	var out = {};

	out.burResultadoEnvio = fliedResultadoBurofax.childNodes[1].value;
	out.burFechaSolicitudDesde = dateFieldSolicitudBurDesde.getValue();
	out.burFechaSolicitudHasta = dateFieldSolicitudBurHasta.getValue();
	out.burFechaAcuseDesde = dateFieldEnvioBurDesde.getValue();
	out.burFechaAcuseHasta = dateFieldEnvioBurHasta.getValue();
	out.burFechaEnvioDesde = dateFieldAcuseBurDesde.getValue();
	out.burFechaEnvioHasta = dateFieldAcuseBurHasta.getValue();
	out.burRefExternaEnvio = fieldrefExternaEnvio.getValue();
	out.burRegManual = comboRegManual.getValue();
	out.burAcuseRecibo = comboAcuseRecibo.getValue();

	return out;
}