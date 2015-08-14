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
		id: 'fieldTipoDocumento',
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
		id: 'fieldEstadoDocumento',
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
		id: 'fieldRespuestaSolicitud',
		height: 60,
		width: 220
	}
);

<%-- Actor última solicitud: Selector múltiple del actor al que se le ha enviado la última solicitud. --%>

<%-- Fecha solicitud (Desde / Hasta) --%>

var dateFieldSolicitudDocDesde = new Ext.ux.form.XDateField({
	name: 'dateFieldSolicitudDocDesde',
	fieldLabel: '<s:message code="asd" text="** F. Solicitud" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Resultado" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Envio" />'
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
	fieldLabel: '<s:message code="asd" text="** F. Recepción" />'
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
labelKey="asd" 
label="** Adjunto" value="" dd="${ddSiNo}" />

<%-- Solicitud previa --%>

<pfsforms:ddCombo name="comboSolicitudPreviaDoc" propertyCodigo="codigo" propertyDescripcion="descripcion"
labelKey="asd" 
label="** Solicitud previa" value="" dd="${ddSiNo}" />

<%-- Días en gestión --%>

<pfsforms:numberfield name="fieldDiasGestionDoc" labelKey="asd" label="** Días en gestión" 
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
		items: [comboAdjuntoDoc, comboSolicitudPreviaDoc, fieldDiasGestionDoc, panelFechaSolicitudDoc, panelFechaResultadoDoc, panelFechaEnvioDoc, panelFechaRecepcionDoc, comboRespuestaSolicitud]
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

	//out.ultimoActor = ;

	return out;
}