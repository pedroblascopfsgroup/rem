<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>

<%-- Renders --%>

var OK_KO_Render = function(value, meta, record) {	
	if (value) {
		return '<img src="/pfs/css/true.gif" height="16" width="16" alt=""/>';
	} else {
		return '<img src="/pfs/css/false.gif" height="16" width="16" alt=""/>';
	}
};

<%-- Grid --%>

var liquidacionPcoRecord = Ext.data.Record.create([
	{name: 'prcId'},
	{name: 'codigo'},
	{name: 'nombreProcedimiento'},
	{name: 'nombreExpediente'},
	{name: 'estadoExpediente'},
	{name: 'importe'},
	{name: 'fechaEstado'},
	{name: 'tipoProcPropuesto'},
	{name: 'tipoPreparacion'},
	{name: 'diasEnPreparacion'},
	{name: 'liqEstado'},
	{name: 'fechaSolicitud'},
	{name: 'liqContrato'},
	{name: 'liqFechaRecepcion'},
	{name: 'liqFechaConfirmacion'},
	{name: 'liqFechaCierre'},
	{name: 'liqTotal'}
]);

var liquidacionPcoStore = page.getStore({
	flow: 'expedientejudicial/busquedaElementosPco',
	limit: 25,
	remoteSort: true,
	reader: new Ext.data.JsonReader({
		root : 'procedimientosPco',
		totalProperty : 'total'
	}, liquidacionPcoRecord)
});

var liquidacionPcoCm = new Ext.grid.ColumnModel([
	{dataIndex: 'codigo', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.codigo" text="**Codigo"/>', sortable: false},
	{dataIndex: 'nombreExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.nombre" text="**Nombre"/>', sortable: false},
	{dataIndex: 'estadoExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.estado" text="**Estado exp."/>', sortable: false},
	{dataIndex: 'importe', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.importe" text="**Importe"/>', sortable: true},
	{dataIndex: 'fechaEstado', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.fecha.estado" text="**Fecha estado"/>', sortable: false},
 	{dataIndex: 'fechaSolicitud', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.fecha.solicitud" text="**Fecha solicitud"/>', sortable: false},
	{dataIndex: 'tipoProcPropuesto', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.procedimiento" text="**Proc. propuesto"/>', sortable: false},
	{dataIndex: 'tipoPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.tipo" text="**Tipo preparacion"/>', sortable: false},
	{dataIndex: 'diasEnPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.dias" text="**Dias preparacion"/>', sortable: false},
	{dataIndex: 'liqEstado', header: '<s:message code="plugin.precontencioso.grid.buscador.liquidaciones.estado" text="**Estado"/>', sortable: false},
	{dataIndex: 'liqContrato', header: '<s:message code="plugin.precontencioso.grid.buscador.liquidaciones.contrato" text="**Contrato"/>', sortable: false},
	{dataIndex: 'liqFechaRecepcion', header: '<s:message code="plugin.precontencioso.grid.buscador.liquidaciones.fecha.recepcion" text="**Fecha recepcion"/>', sortable: false},
	{dataIndex: 'liqFechaConfirmacion', header: '<s:message code="plugin.precontencioso.grid.buscador.liquidaciones.fecha.confirmacion" text="**Fecha confirmacion"/>', sortable: false},
	{dataIndex: 'liqFechaCierre', header: '<s:message code="plugin.precontencioso.grid.buscador.liquidaciones.fecha.cierre" text="**Fecha del cierre"/>', sortable: false},
	{dataIndex: 'liqTotal', header: '<s:message code="plugin.precontencioso.grid.buscador.liquidaciones.total" text="**Total"/>', sortable: false}
]);

var pagingBarLiq = fwk.ux.getPaging(liquidacionPcoStore);
pagingBarLiq.hide();

var gridLiquidacionPco = app.crearGrid(liquidacionPcoStore, liquidacionPcoCm, {
	title: '<s:message code="plugin.precontencioso.tab.liquidacion.listado" text="**Listado Liquidaciones" />',
	cls: 'cursor_pointer',
	bbar : [pagingBarLiq],
	height: 250,
	collapsible: true,
	collapsed: true,
	titleCollapse: true,
	autoWidth: true,
	style:'padding-bottom:10px; padding-right:10px;'
});

<%-- Events --%>
liquidacionPcoStore.on('load', function() {
	gridLiquidacionPco.expand(true)
	pagingBarLiq.show();
});

gridLiquidacionPco.addListener('rowdblclick', function(grid, rowIndex, e) {
	var rec = grid.getStore().getAt(rowIndex);
	var id = rec.get('prcId');
	var nombre_procedimiento = rec.get('nombreProcedimiento');

   	if (id != null && id != ''){
   		app.abreProcedimiento(id, nombre_procedimiento);
   	}
});