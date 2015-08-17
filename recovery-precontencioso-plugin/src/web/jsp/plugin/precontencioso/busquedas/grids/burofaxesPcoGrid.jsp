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
	{name: 'nombreExpediente'},
	{name: 'estadoExpediente'},
	{name: 'fechaEstado'},
	{name: 'tipoProcPropuesto'},
	{name: 'tipoPreparacion'},
	{name: 'diasEnPreparacion'},
	
<!-- 	{name: 'estadoBurofax'}, -->
	{name: 'burFechaSolicitud'},
	{name: 'burNif'},
	{name: 'burNombre'},
	{name: 'burFechaSolicitud'},
	{name: 'burFechaEnvio'},
	{name: 'burFechaAcuse'},
	{name: 'burResultado'}
]);

var burofaxPcoStore = page.getStore({
	flow: 'expedientejudicial/busquedaProcedimientos',
	limit: 25,
	remoteSort: true,
	reader: new Ext.data.JsonReader({
		root : 'procedimientosPco',
		totalProperty : 'total'
	}, burofaxesPcoRecord)
});

var burofaxPcoCm = new Ext.grid.ColumnModel([
	{dataIndex: 'codigo', header: '<s:message code="asd" text="**Codigo"/>', sortable: false},
	{dataIndex: 'nombreExpediente', header: '<s:message code="asd" text="**Nombre"/>', sortable: false},
	{dataIndex: 'estadoExpediente', header: '<s:message code="asd" text="**Estado exp."/>', sortable: false},
	{dataIndex: 'fechaEstado', header: '<s:message code="asd" text="**Fecha estado"/>', sortable: false},
	{dataIndex: 'tipoProcPropuesto', header: '<s:message code="asd" text="**Proc. propuesto"/>', sortable: false},
	{dataIndex: 'tipoPreparacion', header: '<s:message code="asd" text="**Tipo preparacion"/>', sortable: false},
	{dataIndex: 'diasEnPreparacion', header: '<s:message code="asd" text="**Dias preparacion"/>', sortable: false},
<%-- 	{dataIndex: 'estadoBurofax', header: '<s:message code="asd" text="**Estado burofax"/>', sortable: false}, --%>
<%-- 	{dataIndex: 'fechaSolicitud', header: '<s:message code="asd" text="**Fecha solicitud"/>', sortable: false}, --%>
	{dataIndex: 'burNif', header: '<s:message code="asd" text="**NIF"/>', sortable: false},
	{dataIndex: 'burNombre', header: '<s:message code="asd" text="**Nombre apellidos"/>', sortable: false},
	
	{dataIndex: 'burFechaSolicitud', header: '<s:message code="asd" text="**Fecha solicitud"/>', sortable: false},
	{dataIndex: 'burFechaEnvio', header: '<s:message code="asd" text="**Fecha envio"/>', sortable: false},
	{dataIndex: 'burFechaAcuse', header: '<s:message code="asd" text="**Fecha acuse"/>', sortable: false},
	{dataIndex: 'burResultado', header: '<s:message code="asd" text="**Resultado"/>', sortable: false}
]);

var pagingBar = fwk.ux.getPaging(burofaxPcoStore);
pagingBar.hide();

var gridBurofaxPco = app.crearGrid(burofaxPcoStore, burofaxPcoCm, {
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

gridBurofaxPco.addListener('rowdblclick', function(grid, rowIndex, e) {
	var rec = grid.getStore().getAt(rowIndex);
	var id = rec.get('prcId');
	//app.abreAsuntoTab(id, nombre_asunto,'tabSubastas');
});