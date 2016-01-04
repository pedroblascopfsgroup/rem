<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<%-- Fecha solicitud --%>

var dateFieldSolicitudBurDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudBurDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.fecha.solicitud" text="** F. Solicitud" />'
});

var dateFieldSolicitudBurHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudBurHastaEle',
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
		{layout: 'form', items: [dateFieldSolicitudBurDesdeEle]},
		{layout: 'form', items: [dateFieldSolicitudBurHastaEle]}
	]
});

<%-- Fecha envío --%>

var dateFieldEnvioBurDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioBurDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.fecha.envio" text="** F. Envio" />'
});

var dateFieldEnvioBurHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioBurHastaEle',
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
		{layout: 'form', items: [dateFieldEnvioBurDesdeEle]},
		{layout: 'form', items: [dateFieldEnvioBurHastaEle]}
	]
});

<%-- Fecha acuse --%>

var dateFieldAcuseBurDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldAcuseBurDesdeEle',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.fecha.acuse" text="** F. Acuse" />'
});

var dateFieldAcuseBurHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldAcuseBurHastaEle',
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
		{layout: 'form', items: [dateFieldAcuseBurDesdeEle]},
		{layout: 'form', items: [dateFieldAcuseBurHastaEle]}
	]
});

<%-- Reg Manual --%>

<pfsforms:ddCombo name="comboRegManualEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.burofax.regManual" 
label="** Reg. Manual" value="" dd="${ddSiNo}" />

<%-- Ref Externa Envio --%>

var fieldrefExternaEnvioEle = new Ext.form.TextField({
	name: 'refExternaEnvio',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.burofax.refExternaEnvio" text="** Ref Externa Envio" />'
});

<%-- Acuse de recibo --%>

<pfsforms:ddCombo name="comboAcuseReciboEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="plugin.precontencioso.tab.burofax.acuseRecibo" 
label="** Acuse de recibo" value="" dd="${ddSiNo}" />

<%-- Resultado último envío a cliente --%>

var diccResultadoBurofax = <app:dict value="${resultadoBurofax}" />;

var comboResultadoBurofax = app.creaDblSelect(
	diccResultadoBurofax,
	'<s:message code="plugin.precontencioso.tab.burofax.ultimo.envio" text="** Resultado último envío" />',
	{
		id: 'fliedResultadoBurofaxEle',
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
		items: [fieldrefExternaEnvioEle, comboNotificadoEle, comboAcuseReciboEle, comboRegManualEle, comboResultadoBurofax]
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

	out.burResultadoEnvio = fliedResultadoBurofaxEle.childNodes[1].value;
	out.burFechaSolicitudDesde = dateFieldSolicitudBurDesdeEle.getValue();
	out.burFechaSolicitudHasta = dateFieldSolicitudBurHastaEle.getValue();
	out.burFechaAcuseDesde = dateFieldEnvioBurDesdeEle.getValue();
	out.burFechaAcuseHasta = dateFieldEnvioBurHastaEle.getValue();
	out.burFechaEnvioDesde = dateFieldAcuseBurDesdeEle.getValue();
	out.burFechaEnvioHasta = dateFieldAcuseBurHastaEle.getValue();
	out.burRefExternaEnvio = fieldrefExternaEnvioEle.getValue();
	out.burRegManual = comboRegManualEle.getValue();
	out.burAcuseRecibo = comboAcuseReciboEle.getValue();

	return out;
}

var limpiaPestanaBurofaxes = function() {
	app.resetCampos([comboNotificadoEle, comboResultadoBurofax, dateFieldSolicitudBurDesdeEle, dateFieldSolicitudBurHastaEle,
	dateFieldEnvioBurDesdeEle, dateFieldEnvioBurHastaEle, dateFieldAcuseBurDesdeEle, dateFieldAcuseBurHastaEle, fieldrefExternaEnvioEle, comboRegManualEle, comboAcuseReciboEle]);
}
