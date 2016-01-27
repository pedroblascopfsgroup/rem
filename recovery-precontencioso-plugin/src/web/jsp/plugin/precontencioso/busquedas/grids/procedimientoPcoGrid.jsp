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

var procedimientoPcoRecord = Ext.data.Record.create([
	{name: 'prcId'},
	{name: 'codigo'},
	{name: 'nombreProcedimiento'},
	{name: 'nombreExpediente'},
	{name: 'estadoExpediente'},
	{name: 'importe'},
	{name: 'diasEnGestion'},
	{name: 'fechaEstado'},
	{name: 'tipoProcPropuesto'},
	{name: 'tipoPreparacion'},
	{name: 'fechaInicioPreparacion'},
	{name: 'diasEnPreparacion'},
	{name: 'totalLiquidacion'},
	{name: 'fechaEnvioLetrado'},
	{name: 'aceptadoLetrado'},
	{name: 'todosDocumentos'},
	{name: 'todasLiquidaciones'},
	{name: 'todosBurofaxes'}
]);

var procedimientoPcoStore = page.getStore({
	flow: 'expedientejudicial/busquedaProcedimientos',
	limit: 25,
	remoteSort: true,
	reader: new Ext.data.JsonReader({
		root : 'procedimientosPco',
		totalProperty : 'total'
	}, procedimientoPcoRecord)
});

var procedimientoPcoCm = new Ext.grid.ColumnModel([
	{dataIndex: 'codigo', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.codigo" text="**Codigo"/>', sortable: false},
	{dataIndex: 'nombreExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.nombre" text="**Nombre"/>', sortable: false},
	{dataIndex: 'estadoExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.estado" text="**Estado exp."/>', sortable: false},
	{dataIndex: 'importe', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.importe" text="**Importe"/>', sortable: true},
	{dataIndex: 'diasEnGestion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.dias.gestion" text="**Dias gestion"/>', sortable: false},
	{dataIndex: 'fechaEstado', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.fecha.estado" text="**Fecha estado"/>', sortable: false},
	{dataIndex: 'tipoProcPropuesto', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.procedimiento" text="**Proc. propuesto"/>', sortable: false},
	{dataIndex: 'tipoPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.tipo" text="**Tipo preparacion"/>', sortable: false},
	{dataIndex: 'fechaInicioPreparacion', header: '<s:message code="plugin.precontencioso.tab.expjudicial.disponible.fecha.preparacion" text="**Fecha Ini. preparacion"/>', sortable: false},
	{dataIndex: 'diasEnPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.dias" text="**Dias preparacion"/>', sortable: false},
	{dataIndex: 'totalLiquidacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.total.liquidacion" text="**Total liquidacion"/>', sortable: false},
	{dataIndex: 'fechaEnvioLetrado', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.fecha.envio.letrado" text="**Fecha envio letrado"/>', sortable: false},
	{dataIndex: 'aceptadoLetrado', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.aceptado" text="**Aceptado"/>', renderer: OK_KO_Render, align:'center', sortable: false},
	{dataIndex: 'todosDocumentos', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.todos.doc" text="**Todos los documentos"/>', renderer: OK_KO_Render, align:'center', sortable: false},
	{dataIndex: 'todasLiquidaciones', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.todos.liquidaciones" text="**Todas las liquidaciones"/>', renderer: OK_KO_Render, align:'center', sortable: false},
	{dataIndex: 'todosBurofaxes', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.todos.burofaxes" text="**Todos los burofaxes"/>', renderer: OK_KO_Render, align:'center', sortable: false}
]);

var pagingBar = fwk.ux.getPaging(procedimientoPcoStore);
pagingBar.hide();

var gridProcedimientosPco = app.crearGrid(procedimientoPcoStore, procedimientoPcoCm, {
	title: '<s:message code="plugin.precontencioso.tab.expjudicial.listado" text="**Listado Expedientes judicial" />',
	cls: 'cursor_pointer',
	bbar : [pagingBar],
	collapsible: true,
	collapsed: false,
	titleCollapse: true,
	autoWidth: true,
	autoHeight: true,
	style:'padding-bottom:10px; padding-right:10px;'
});

<%-- Events --%>

procedimientoPcoStore.on('load', function() {
	gridProcedimientosPco.expand(true)
	pagingBar.show();
});

gridProcedimientosPco.addListener('rowdblclick', function(grid, rowIndex, e) {
	var rec = grid.getStore().getAt(rowIndex);
	var id = rec.get('prcId');
	var nombre_procedimiento = rec.get('nombreProcedimiento');

   	if (id != null && id != ''){
   		app.abreProcedimiento(id, nombre_procedimiento);
   	}
});