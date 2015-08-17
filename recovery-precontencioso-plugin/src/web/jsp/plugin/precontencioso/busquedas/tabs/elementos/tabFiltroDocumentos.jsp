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
	'<s:message code="asd" text="** Tipo de documento" />',
	{
		id: 'fieldTipoDocumentoEle',
		height: 150,
		width: 220
	}
);

<%-- Estado de documento --%>

var diccEstadoDocumento = <app:dict value="${estadoDocumento}" />;

var comboEstadoDocumento = app.creaDblSelect(
	diccEstadoDocumento,
	'<s:message code="asd" text="** Estado" />',
	{
		id: 'fieldEstadoDocumentoEle',
		height: 100,
		width: 220
	}
);

<%-- Respuesta ultima solicitud --%>

var diccResultadoSolicitud = <app:dict value="${resultadoSolicitud}" />;

var comboRespuestaSolicitud = app.creaDblSelect(
	diccResultadoSolicitud,
	'<s:message code="asd" text="** Respuesta ultima solicitud" />',
	{
		id: 'fieldRespuestaSolicitudEle',
		height: 60,
		width: 220
	}
);

<%-- Actor última solicitud: Selector múltiple del actor al que se le ha enviado la última solicitud. --%>

<%-- Fecha solicitud (Desde / Hasta) --%>

var dateFieldSolicitudDocDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudDocDesdeEle',
	fieldLabel: '<s:message code="asd" text="** F. Solicitud" />'
});

var dateFieldSolicitudDocHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudDocHastaEle',
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
		{layout: 'form', items: [dateFieldSolicitudDocDesdeEle]},
		{layout: 'form', items: [dateFieldSolicitudDocHastaEle]}
	]
});

<%-- Fecha resultado (Desde / Hasta) --%>

var dateFieldResultadoDocDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldResultadoDocDesdeEle',
	fieldLabel: '<s:message code="asd" text="** F. Resultado" />'
});

var dateFieldResultadoDocHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldResultadoDocHastaEle',
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
		{layout: 'form', items: [dateFieldResultadoDocDesdeEle]},
		{layout: 'form', items: [dateFieldResultadoDocHastaEle]}
	]
});

<%-- Fecha envío (Desde / Hasta) --%>

var dateFieldEnvioDocDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioDocDesdeEle',
	fieldLabel: '<s:message code="asd" text="** F. Envio" />'
});

var dateFieldEnvioDocHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldEnvioDocHastaEle',
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
		{layout: 'form', items: [dateFieldEnvioDocDesdeEle]},
		{layout: 'form', items: [dateFieldEnvioDocHastaEle]}
	]
});

<%-- Fecha Recepción (Desde / Hasta) --%>

var dateFieldRecepcionDocDesdeEle = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionDocDesdeEle',
	fieldLabel: '<s:message code="asd" text="** F. Recepción" />'
});

var dateFieldRecepcionDocHastaEle = new Ext.ux.form.XDateField({
	name: 'dateFieldRecepcionDocHastaEle',
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
		{layout: 'form', items: [dateFieldRecepcionDocDesdeEle]},
		{layout: 'form', items: [dateFieldRecepcionDocHastaEle]}
	]
});

<%-- Adjunto --%>

<pfsforms:ddCombo name="comboAdjuntoDocEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Adjunto" value="" dd="${ddSiNo}" />

<%-- Solicitud previa --%>

<pfsforms:ddCombo name="comboSolicitudPreviaDocEle" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Solicitud previa" value="" dd="${ddSiNo}" />

<%-- Días en gestión --%>

<pfsforms:numberfield name="fieldDiasGestionDocEle" labelKey="asd" label="** Días en gestión" 
	value=""
	obligatory="false"
	allowDecimals="false" />

<%-- Paneles --%>

var filtrosTabDocumentosActive = false;

var filtrosTabDocumentos = new Ext.Panel({
	title: '<s:message code="asd" text="** Documentos" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [comboAdjuntoDocEle, comboSolicitudPreviaDocEle, fieldDiasGestionDocEle, panelFechaSolicitudDoc, panelFechaResultadoDoc, panelFechaEnvioDoc, panelFechaRecepcionDoc, comboRespuestaSolicitud]
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

	out.docTiposDocumento = fieldTipoDocumentoEle.childNodes[1].value;
	out.docEstados = fieldEstadoDocumentoEle.childNodes[1].value;
	out.docUltimaRespuesta = fieldRespuestaSolicitudEle.childNodes[1].value;
	out.docFechaSolicitudDesde = dateFieldSolicitudDocDesdeEle.getValue();
	out.docFechaSolicitudHasta = dateFieldSolicitudDocHastaEle.getValue();
	out.docFechaResultadoDesde = dateFieldResultadoDocDesdeEle.getValue();
	out.docFechaResultadoHasta = dateFieldResultadoDocHastaEle.getValue();
	out.docFechaEnvioDesde = dateFieldEnvioDocDesdeEle.getValue();
	out.docFechaEnvioHasta = dateFieldEnvioDocHastaEle.getValue();
	out.docFechaRecepcionDesde = dateFieldRecepcionDocDesdeEle.getValue();
	out.docFechaRecepcionHasta = dateFieldRecepcionDocHastaEle.getValue();
	out.docAdjunto = comboAdjuntoDocEle.getValue();
	out.docSolicitudPrevia = comboSolicitudPreviaDocEle.getValue();
	out.docDiasGestion = fieldDiasGestionDocEle.getValue();

	//out.ultimoActor = ;

	return out;
}