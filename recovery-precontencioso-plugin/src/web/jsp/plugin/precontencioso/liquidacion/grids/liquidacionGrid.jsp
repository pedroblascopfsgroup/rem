<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%-- Buttons --%>

var btnSolicitar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.solicitar" text="**Solicitar" />',
	iconCls: 'icon_mas',
	cls: 'x-btn-text-icon',
	handler: function() {
		if (comprobarDatosCalculoRellenos()) {
			Ext.Msg.confirm(
			'<s:message code="app.confirmar" text="**Confirmar" />', 
			'<s:message code="plugin.precontencioso.grid.liquidacion.solicitarLiquidacion.confirmacion" text="**La liquidacion seleccionada se encuentra calculada, ¿Desea continuar?" />', 
			function(btn) {
				if (btn == 'yes') {
					abrirPantallaSolicitar();
				}
			});
		} else {
			abrirPantallaSolicitar();
		}
	}
});

var abrirPantallaSolicitar = function() {
	var w = app.openWindow({
		flow: 'liquidacion/abrirSolicitarLiquidacion',
		autoWidth: true,
		closable: true,
		title: '<s:message code="plugin.precontencioso.grid.liquidacion.titulo.solicitarliq" text="**Solicitar liquidación" />',
		params: {idLiquidacion: idLiquidacionSeleccionada()}
	});

	w.on(app.event.DONE, function() {
		refrescarLiquidacionesGrid();
		w.close();
	});

	w.on(app.event.CANCEL, function() {
		w.close();
	});
}

var btnEditarValores = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.editar" text="**Editar valores" />',
	iconCls: 'icon_edit',
	cls: 'x-btn-text-icon',
	handler: function() {
		var w = app.openWindow({
			flow: 'liquidacion/abrirEditarLiquidacion',
			width: 670,
			closable: true,
			title: '<s:message code="plugin.precontencioso.grid.liquidacion.titulo.editarliq" text="**Editar Liquidacion" />',
			params: {idLiquidacion: idLiquidacionSeleccionada()}
		});

		w.on(app.event.DONE, function() {
			refrescarLiquidacionesGrid();
			w.close();
		});

		w.on(app.event.CANCEL, function() {
			w.close();
		});
	}
});

var btnConfirmar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.confimar" text="**Confirmar" />',
	iconCls: 'x-tbar-page-next',
	cls: 'x-btn-text-icon',
	handler: function() {
		Ext.Ajax.request({
			url: page.resolveUrl('liquidacion/confirmar'),
			params: {idLiquidacion: idLiquidacionSeleccionada()},
			method: 'POST',
			success: function ( result, request ) {
				refrescarLiquidacionesGrid();
			}
		});
	}
});

var btnDescartar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.descartar" text="**Descartar" />',
	iconCls: 'icon_menos',
	cls: 'x-btn-text-icon',
	handler: function() {
		Ext.Ajax.request({
			url: page.resolveUrl('liquidacion/descartar'),
			params: {idLiquidacion: idLiquidacionSeleccionada()},
			method: 'POST',
			success: function ( result, request ) {
				refrescarLiquidacionesGrid();
			}
		});
	}
});

var btnGenerar = new Ext.Button({
	text: '<s:message code="plugin.precontencioso.grid.liquidacion.button.generar" text="**Generar" />',
	iconCls: 'icon_pdf',
	cls: 'x-btn-text-icon',
	handler: function() {

	}
});

<%-- Grid --%>

var liquidacionesRecord = Ext.data.Record.create([
	{name: 'id'},
	{name: 'contrato'},
	{name: 'producto'},
	{name: 'estadoLiquidacion'},
	{name: 'estadoCodigo'},
	{name: 'fechaSolicitud'},
	{name: 'fechaRecepcion'},
	{name: 'fechaConfirmacion'},
	{name: 'fechaCierre'},
	{name: 'capitalVencido'},
	{name: 'capitalNoVencido'},
	{name: 'interesesOrdinarios'},
	{name: 'interesesDemora'},
	{name: 'total'},
	{name: 'apoderado'}
]);

var storeLiquidaciones = page.getStore({
	eventName: 'resultado',
	flow: 'liquidacion/getLiquidacionesPorProcedimientoId',
	storeId: 'storeLiquidaciones',
	reader: new Ext.data.JsonReader({
		root: 'liquidaciones'
	}, liquidacionesRecord)
});

storeLiquidaciones.on(
	'load',
	function (store, data, options) {
		actualizarBotones();
	}
);

var cmLiquidacion = new Ext.grid.ColumnModel([
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.contrato" text="**Contrato" />', dataIndex: 'contrato'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.producto" text="**Producto" />', dataIndex: 'producto'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.estadoLiquidacion" text="**Estado Liquidacion" />', dataIndex: 'estadoLiquidacion'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaSolicitud" text="**Fecha Solicitud" />', dataIndex: 'fechaSolicitud'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaRecepcion" text="**Fecha Recepcion" />', dataIndex: 'fechaRecepcion'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaConfirmacion" text="**Fecha Confirmacion" />', dataIndex: 'fechaConfirmacion'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.fechaCierre" text="**Fecha Cierre" />', dataIndex: 'fechaCierre'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.capitalVencido" text="**Capital Vencido" />', dataIndex: 'capitalVencido'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.capitalNoVencido" text="**Capital No Vencido" />', dataIndex: 'capitalNoVencido'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.interesesOrdinarios" text="**Intereses Ordinarios" />', dataIndex: 'interesesOrdinarios'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.interesesDemora" text="**Intereses Demora" />', dataIndex: 'interesesDemora'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.total" text="**Total" />', dataIndex: 'total'},
	{header: '<s:message code="plugin.precontencioso.grid.liquidacion.apoderado" text="**Apoderado" />', dataIndex: 'apoderado', width: 200}
]);

var gridLiquidaciones = app.crearGrid(storeLiquidaciones, cmLiquidacion, {
	title: '<s:message code="plugin.precontencioso.grid.liquidacion.titulo" text="**Liquidaciones" />',
	bbar: [btnSolicitar, btnEditarValores, btnConfirmar, btnDescartar, new Ext.Toolbar.Fill(), btnGenerar],
	height: 250,
	autoWidth: true,
	style:'padding-top: inherit',
	collapsible: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true})
});

gridLiquidaciones.on('rowclick', function(grid, rowIndex, e) {
	actualizarBotones();
});

<%-- States --%>

var actualizarBotones = function() {

	// Se comprueba que el procedimiento se encuentre en un estado que permita editar las liquidaciones
	if (entidad.actualId != null && entidad.get('data')) {
		var estadoActualCodigoProcedimiento = entidad.get('data').precontencioso.estadoActualCodigo;
		if (estadoActualCodigoProcedimiento != 'PR'  && estadoActualCodigoProcedimiento != 'SU' && estadoActualCodigoProcedimiento != 'SC') {
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnDescartar.setDisabled(true);
			btnGenerar.setDisabled(true);
			return;
		}
	}

	var liquidacion = gridLiquidaciones.getSelectionModel().getSelected();

	var estadoCodigo = '';
	if (liquidacion) {
		estadoCodigo = liquidacion.get('estadoCodigo');
	}

	switch(estadoCodigo) {
		case 'SOL':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(false);
			btnConfirmar.setDisabled(false);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(true);
			break;

		case 'DES':
			btnSolicitar.setDisabled(false);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnDescartar.setDisabled(true);
			btnGenerar.setDisabled(true);
			break;

		case 'CON':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(false);
			break;

		case 'CAL':
			btnSolicitar.setDisabled(false);
			btnEditarValores.setDisabled(false);
			btnConfirmar.setDisabled(false);
			btnDescartar.setDisabled(false);
			btnGenerar.setDisabled(true);
			break;

		default:
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnDescartar.setDisabled(true);
			btnGenerar.setDisabled(true);
	}
}

<%-- Utils --%>

var comprobarDatosCalculoRellenos = function() {
	var liquidacion = gridLiquidaciones.getSelectionModel().getSelected();

	return (liquidacion
			&& liquidacion.get('capitalVencido') != ""
			&& liquidacion.get('capitalNoVencido') != ""
			&& liquidacion.get('interesesOrdinarios') != ""
			&& liquidacion.get('interesesDemora') != ""
			&& liquidacion.get('total') != "" );
}


var idLiquidacionSeleccionada = function() {
	return gridLiquidaciones.getSelectionModel().getSelected().get('id');
}

var refrescarLiquidacionesGrid = function() {
debugger;
	storeLiquidaciones.webflow({idProcedimientoPCO: '1'});
}

refrescarLiquidacionesGrid();