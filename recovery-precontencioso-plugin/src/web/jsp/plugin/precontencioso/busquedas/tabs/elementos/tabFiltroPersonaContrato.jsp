<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>


<%-- NIF / CIF de alguna de las personas relacionadas con el expediente. --%>

var fieldNifEle = new Ext.form.TextField({
	name: 'nif',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.personacontratos.numdocumento" text="** Nro Documento" />'
});

<%-- Nombre y apellidosÁrea de contratos --%>

var fieldNombreEle = new Ext.form.TextField({
	name: 'nombre',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.personacontratos.nombre" text="** Nombre" />'
});

var fieldApellidosEle = new Ext.form.TextField({
	name: 'apellidos',
	fieldLabel: '<s:message code="plugin.precontencioso.tab.personacontratos.apellidos" text="** Apellidos" />'
});

<%-- Código de contrato. --%>
<pfsforms:numberfield name="fieldCodigoContratoEle" labelKey="plugin.precontencioso.tab.personacontratos.codigo" label="** Codigo Contrato" 
	value="" obligatory="false" allowDecimals="false" />

<%-- Tipo de producto. --%>

var diccTiposProducto = <app:dict value="${tipoProducto}" />;

var comboTiposProductoEle = app.creaDblSelect(
	diccTiposProducto,
	'<s:message code="plugin.precontencioso.tab.personacontratos.tipo.producto" text="**Tipo de Producto" />',
	{
		id: 'fieldTiposProductoEle',
		height: 180,
		width: 220
	}
);

<%-- Paneles --%>

var filtrosTabPersonaContratoActive = false;

var documento =	'<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_DOCUMENTO" />';
var liquidacion = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_LIQUIDACION" />';
var burofax = '<fwk:const value="es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.FiltroBusquedaProcedimientoPcoDTO.BUSQUEDA_BUROFAX" />';
	
var filtrosTabPersonaContrato = new Ext.Panel({
	title: '<s:message code="plugin.precontencioso.tab.personacontratos.titulo" text="** Persona y contratos" />',
	autoHeight: true,
	bodyStyle: 'padding: 10px',
	layout: 'table',
	defaults: {xtype: 'fieldset', border: false, cellCls: 'vtop', layout: 'form', bodyStyle: 'padding :5px; cellspacing: 10px'},
	layoutConfig: {columns: 2},
	items: [{
		layout: 'form',
		items: [fieldNifEle, fieldNombreEle, fieldApellidosEle, fieldCodigoContratoEle]
	}, {
		layout: 'form',
		items: [comboTiposProductoEle]
	}]
});

filtrosTabPersonaContrato.on('activate',function(){
	filtrosTabPersonaContratoActive = true;
});

<%-- Utils --%>

var getParametrosFiltroPersonaContrato = function() {
	var out = {};

	out.conCodigo = fieldCodigoContratoEle.getValue();
	out.conTiposProducto = fieldTiposProductoEle.childNodes[1].value;
	out.conNif = fieldNifEle.getValue();
	out.conNombre = fieldNombreEle.getValue();
	out.conApellidos = fieldApellidosEle.getValue();

	return out;
}

var limpiaPestanaPersonaContrato = function() {
		app.resetCampos([fieldCodigoContratoEle, comboTiposProductoEle, fieldNifEle, 
		fieldNombreEle, fieldApellidosEle]);
	}
