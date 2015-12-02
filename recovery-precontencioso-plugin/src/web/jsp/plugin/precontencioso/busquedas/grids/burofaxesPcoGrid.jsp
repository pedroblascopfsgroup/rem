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

var burofaxesPcoRecord = Ext.data.Record.create([
	{name: 'prcId'},
	{name: 'codigo'},
	{name: 'nombreProcedimiento'},
	{name: 'nombreExpediente'},
	{name: 'estadoExpediente'},
	{name: 'fechaEstado'},
	{name: 'tipoProcPropuesto'},
	{name: 'tipoPreparacion'},
	{name: 'diasEnPreparacion'},
	{name: 'fechaSolicitud'},
	{name: 'burEstado'},
	{name: 'burFechaSolicitud'},
	{name: 'burNif'},
	{name: 'burNombre'},
	{name: 'burFechaSolicitud'},
	{name: 'burFechaEnvio'},
	{name: 'burFechaAcuse'},
	{name: 'burResultado'}
]);

var burofaxPcoStore = page.getStore({
	flow: 'expedientejudicial/busquedaElementosPco',
	limit: 25,
	remoteSort: true,
	reader: new Ext.data.JsonReader({
		root : 'procedimientosPco',
		totalProperty : 'total'
	}, burofaxesPcoRecord)
});

var burofaxPcoCm = new Ext.grid.ColumnModel([
	{dataIndex: 'codigo', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.codigo" text="**Codigo"/>', sortable: false},
	{dataIndex: 'nombreExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.nombre" text="**Nombre"/>', sortable: false},
	{dataIndex: 'estadoExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.estado" text="**Estado exp."/>', sortable: false},
	{dataIndex: 'fechaEstado', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.fecha.estado" text="**Fecha estado"/>', sortable: false},
	{dataIndex: 'fechaSolicitud', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.fecha.solicitud" text="**Fecha solicitud"/>', sortable: false},
	{dataIndex: 'tipoProcPropuesto', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.procedimiento" text="**Proc. propuesto"/>', sortable: false},
	{dataIndex: 'tipoPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.tipo" text="**Tipo preparacion"/>', sortable: false},
	{dataIndex: 'diasEnPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.dias" text="**Dias preparacion"/>', sortable: false},
	{dataIndex: 'burEstado', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.estado" text="**Estado"/>', sortable: false},
	{dataIndex: 'burNif', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.nif" text="**NIF"/>', sortable: false},
	{dataIndex: 'burNombre', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.nombre.apellidos" text="**Nombre apellidos"/>', sortable: false},
	{dataIndex: 'burFechaSolicitud', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.fecha.solicitud" text="**Fecha solicitud"/>', sortable: false},
	{dataIndex: 'burFechaEnvio', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.fecha.envio" text="**Fecha envio"/>', sortable: false},
	{dataIndex: 'burFechaAcuse', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.fecha.acuse" text="**Fecha acuse"/>', sortable: false},
	{dataIndex: 'burResultado', header: '<s:message code="plugin.precontencioso.grid.buscador.burofax.resultado" text="**Resultado"/>', renderer: OK_KO_Render, align:'center', sortable: false}
]);

var pagingBarBur = fwk.ux.getPaging(burofaxPcoStore);
pagingBarBur.hide();

var gridBurofaxPco = app.crearGrid(burofaxPcoStore, burofaxPcoCm, {
	title: '<s:message code="plugin.precontencioso.tab.burofax.listado" text="**Listado Burofaxes" />',
	cls: 'cursor_pointer',
	bbar : [pagingBarBur],
	height: 250,
	collapsible: true,
	collapsed: false,
	titleCollapse: true,
	autoWidth: true,
	autoHeight: true,
	style:'padding-bottom:10px; padding-right:10px;'
});

<%-- Events --%>
burofaxPcoStore.on('load', function() {
	gridBurofaxPco.expand(true)
	pagingBarBur.show();
});

gridBurofaxPco.addListener('rowdblclick', function(grid, rowIndex, e) {
	var rec = grid.getStore().getAt(rowIndex);
	var id = rec.get('prcId');
	var nombre_procedimiento = rec.get('nombreProcedimiento');

   	if (id != null && id != ''){
   		app.abreProcedimiento(id, nombre_procedimiento);
   	}
});