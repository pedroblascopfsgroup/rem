<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %> 

<%-- Buttons --%>

var btnSolicitar = new Ext.Button({
	text: '<s:message code="" text="**Solicitar liquidación" />',
	iconCls: 'icon_mas',
	cls: 'x-btn-text-icon',
	handler: function() {
		var w = app.openWindow({
			flow: 'liquidacion/abrirSolicitarLiquidacion',
			autoWidth: true,
			closable: true,
			title: '<s:message code="" text="**Solicitar liquidación" />',
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

var btnEditarValores = new Ext.Button({
	text: '<s:message code="" text="**Editar valores" />',
	iconCls: 'icon_edit',
	cls: 'x-btn-text-icon',
	handler: function() {
		var w = app.openWindow({
			flow: 'liquidacion/abrirEditarLiquidacion',
			autoWidth: true,
			closable: true,
			title: '<s:message code="" text="**Editar Liquidacion" />',
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
	text: '<s:message code="" text="**Confirmar liquidación" />',
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
	text: '<s:message code="" text="**Descartar" />',
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
	{header: '<s:message code="precontencioso.grid.liquidacion.contrato" text="**Contrato" />', dataIndex: 'contrato'},
	{header: '<s:message code="precontencioso.grid.liquidacion.producto" text="**Producto" />', dataIndex: 'producto'},
	{header: '<s:message code="precontencioso.grid.liquidacion.estadoLiquidacion" text="**Estado Liquidacion" />', dataIndex: 'estadoLiquidacion'},
	{header: '<s:message code="precontencioso.grid.liquidacion.fechaSolicitud" text="**Fecha Solicitud" />', dataIndex: 'fechaSolicitud'},
	{header: '<s:message code="precontencioso.grid.liquidacion.fechaRecepcion" text="**Fecha Recepcion" />', dataIndex: 'fechaRecepcion'},
	{header: '<s:message code="precontencioso.grid.liquidacion.fechaConfirmacion" text="**Fecha Confirmacion" />', dataIndex: 'fechaConfirmacion'},
	{header: '<s:message code="precontencioso.grid.liquidacion.fechaCierre" text="**Fecha Cierre" />', dataIndex: 'fechaCierre'},
	{header: '<s:message code="precontencioso.grid.liquidacion.capitalVencido" text="**Capital Vencido" />', dataIndex: 'capitalVencido'},
	{header: '<s:message code="precontencioso.grid.liquidacion.capitalNoVencido" text="**Capital No Vencido" />', dataIndex: 'capitalNoVencido'},
	{header: '<s:message code="precontencioso.grid.liquidacion.interesesOrdinarios" text="**Intereses Ordinarios" />', dataIndex: 'interesesOrdinarios'},
	{header: '<s:message code="precontencioso.grid.liquidacion.interesesDemora" text="**Intereses Demora" />', dataIndex: 'interesesDemora'},
	{header: '<s:message code="precontencioso.grid.liquidacion.total" text="**Total" />', dataIndex: 'total'},
	{header: '<s:message code="precontencioso.grid.liquidacion.apoderado" text="**Apoderado" />', dataIndex: 'apoderado'}
]);

var gridLiquidaciones = app.crearGrid(storeLiquidaciones, cmLiquidacion, {
	title: '<s:message code="precontencioso.grid.liquidacion.titulo" text="**Liquidaciones" />',
	bbar: [btnSolicitar, btnEditarValores, btnConfirmar, btnDescartar],
	height: 250,
	autoWidth: true,
	collapsible: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true})
});

gridLiquidaciones.on('rowclick', function(grid, rowIndex, e) {
	actualizarBotones();
});

<%-- States --%>

var actualizarBotones = function() {
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
			break;

		case 'DES':
			btnSolicitar.setDisabled(false);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnDescartar.setDisabled(true);
			break;

		case 'CON':
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnDescartar.setDisabled(false);
			break;

		default:
			btnSolicitar.setDisabled(true);
			btnEditarValores.setDisabled(true);
			btnConfirmar.setDisabled(true);
			btnDescartar.setDisabled(true);
	}
}

<%-- Utils --%>

var idLiquidacionSeleccionada = function() {
	return gridLiquidaciones.getSelectionModel().getSelected().get('id');
}

var refrescarLiquidacionesGrid = function() {
	storeLiquidaciones.webflow({idProcedimientoPCO: '1'});
}

refrescarLiquidacionesGrid();