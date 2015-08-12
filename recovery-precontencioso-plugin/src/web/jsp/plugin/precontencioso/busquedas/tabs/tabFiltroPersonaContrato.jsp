<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>

<%-- NIF / CIF de alguna de las personas relacionadas con el expediente. --%>

var fieldNif = new Ext.form.TextField({
	name: 'nif',
	fieldLabel: '<s:message code="asd" text="** Nro Documento" />'
});

<%-- Nombre y apellidosÁrea de contratos --%>

var fieldNombre = new Ext.form.TextField({
	name: 'nombre',
	fieldLabel: '<s:message code="asd" text="** Nombre" />'
});

var fieldApellidos = new Ext.form.TextField({
	name: 'apellidos',
	fieldLabel: '<s:message code="asd" text="** Apellidos" />'
});

<%-- Código de contrato. --%>

var fieldCodigoContrato = new Ext.form.TextField({
	name: 'codigoContrato',
	fieldLabel: '<s:message code="asd" text="** Codigo Contrato" />'
});

<%-- Tipo de producto. --%>

var diccTiposProducto = <app:dict value="${tipoProducto}" />;

var comboTiposProducto = app.creaDblSelect(
	diccTiposProducto,
	'<s:message code="asd" text="**Tipo de Producto" />',
	{
		id: 'fieldTiposProducto',
		height: 180,
		width: 220
	}
);

<%-- Paneles --%>

var filtrosTabPersonaContratoActive = false;

var filtrosTabPersonaContrato = new Ext.Panel({
	title: '<s:message code="asd" text="** Persona y contratos" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [fieldNif, fieldNombre, fieldApellidos, fieldCodigoContrato]
	}, {
		layout: 'form',
		items: [comboTiposProducto]
	}]
});

filtrosTabPersonaContrato.on('activate',function(){
	filtrosTabPersonaContratoActive = true;
});

<%-- Utils --%>

var getParametrosFiltroPersonaContrato = function() {
	var out = {};

	out.conCodigo = fieldCodigoContrato.getValue();
	out.conTiposProducto = fieldTiposProducto.childNodes[1].value;
	out.conNif = fieldNif.getValue();
	out.conNombre = fieldNombre.getValue();
	out.conApellidos = fieldApellidos.getValue();

	return out;
}
