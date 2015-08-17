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
	{name: 'nombreExpediente'},
	{name: 'estadoExpediente'},
	{name: 'fechaEstado'},
	{name: 'tipoProcPropuesto'},
	{name: 'tipoPreparacion'},
	{name: 'diasEnPreparacion'},
<!-- 	{name: 'estadoLiquidacion'}, -->
<!-- 	{name: 'fechaSolicitud'}, -->	
	{name: 'liqContrato'},
	{name: 'liqFechaRecepcion'},
	{name: 'liqFechaConfirmacion'},
	{name: 'liqFechaCierre'},
	{name: 'liqTotal'}
]);

var liquidacionPcoStore = page.getStore({
	flow: 'expedientejudicial/busquedaProcedimientos',
	limit: 25,
	remoteSort: true,
	reader: new Ext.data.JsonReader({
		root : 'procedimientosPco',
		totalProperty : 'total'
	}, liquidacionPcoRecord)
});

var liquidacionPcoCm = new Ext.grid.ColumnModel([
	{dataIndex: 'codigo', header: '<s:message code="asd" text="**Codigo"/>', sortable: false},
	{dataIndex: 'nombreExpediente', header: '<s:message code="asd" text="**Nombre"/>', sortable: false},
	{dataIndex: 'estadoExpediente', header: '<s:message code="asd" text="**Estado exp."/>', sortable: false},
	{dataIndex: 'fechaEstado', header: '<s:message code="asd" text="**Fecha estado"/>', sortable: false},
	{dataIndex: 'tipoProcPropuesto', header: '<s:message code="asd" text="**Proc. propuesto"/>', sortable: false},
	{dataIndex: 'tipoPreparacion', header: '<s:message code="asd" text="**Tipo preparacion"/>', sortable: false},
	{dataIndex: 'diasEnPreparacion', header: '<s:message code="asd" text="**Dias preparacion"/>', sortable: false},
<%-- 	{dataIndex: 'estadoLiquidacion', header: '<s:message code="asd" text="**Estado burofax"/>', sortable: false}, --%>
<%-- 	{dataIndex: 'fechaSolicitud', header: '<s:message code="asd" text="**Fecha solicitud"/>', sortable: false}, --%>
	{dataIndex: 'liqContrato', header: '<s:message code="asd" text="**Contrato"/>', sortable: false},
	{dataIndex: 'liqFechaRecepcion', header: '<s:message code="asd" text="**Fecha recepcion"/>', sortable: false},
	{dataIndex: 'liqFechaConfirmacion', header: '<s:message code="asd" text="**Fecha confirmacion"/>', sortable: false},
	{dataIndex: 'liqFechaCierre', header: '<s:message code="asd" text="**Fecha del cierre"/>', sortable: false},
	{dataIndex: 'liqTotal', header: '<s:message code="asd" text="**Total"/>', sortable: false}
]);

var pagingBar = fwk.ux.getPaging(liquidacionPcoStore);
pagingBar.hide();

var gridLiquidacionPco = app.crearGrid(liquidacionPcoStore, liquidacionPcoCm, {
	title: '<s:message code="asd" text="**Expedientes Judiciales" />',
	cls: 'cursor_pointer',
	bbar : [pagingBar],
	height: 250,
	collapsible: true,
	collapsed: true,
	titleCollapse: true,
	autoWidth: true,
	style:'padding-bottom:10px; padding-right:10px;'
});

<%-- Events --%>

gridLiquidacionPco.addListener('rowdblclick', function(grid, rowIndex, e) {
	var rec = grid.getStore().getAt(rowIndex);
	var id = rec.get('prcId');
	//app.abreAsuntoTab(id, nombre_asunto,'tabSubastas');
});