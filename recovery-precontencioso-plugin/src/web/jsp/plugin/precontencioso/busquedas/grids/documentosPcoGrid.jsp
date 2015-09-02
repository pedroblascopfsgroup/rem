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

var documentoPcoRecord = Ext.data.Record.create([
	{name: 'prcId'},
	{name: 'codigo'},
	{name: 'nombreExpediente'},
	{name: 'estadoExpediente'},
	{name: 'fechaEstado'},
	{name: 'tipoProcPropuesto'},
	{name: 'tipoPreparacion'},
	{name: 'diasEnPreparacion'},
<!-- 	{name: 'estadoDocumento'}, -->
<!-- 	{name: 'fechaSolicitud'}, -->	
	{name: 'docUltimaRespuesta'},
	{name: 'docUltimoActor'},
	{name: 'docFechaResultado'},
	{name: 'docFechaEnvio'},
	{name: 'docFechaRecepcion'},
	{name: 'docAdjunto'}
]);
			
var documentoPcoStore = page.getStore({
	flow: 'expedientejudicial/busquedaProcedimientos',
	limit: 25,
	remoteSort: true,
	reader: new Ext.data.JsonReader({
		root : 'procedimientosPco',
		totalProperty : 'total'
	}, documentoPcoRecord)
});

var documentoPcoCm = new Ext.grid.ColumnModel([
	{dataIndex: 'codigo', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.codigo" text="**Codigo"/>', sortable: false},
	{dataIndex: 'nombreExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.nombre" text="**Nombre"/>', sortable: false},
	{dataIndex: 'estadoExpediente', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.estado" text="**Estado exp."/>', sortable: false},
	{dataIndex: 'fechaEstado', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.fecha.estado" text="**Fecha estado"/>', sortable: false},
	{dataIndex: 'tipoProcPropuesto', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.procedimiento" text="**Proc. propuesto"/>', sortable: false},
	{dataIndex: 'tipoPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.tipo" text="**Tipo preparacion"/>', sortable: false},
	{dataIndex: 'diasEnPreparacion', header: '<s:message code="plugin.precontencioso.grid.buscador.expjudicial.preparacion.dias" text="**Dias preparacion"/>', sortable: false},
<%-- 	{dataIndex: 'estadoBurofax', header: '<s:message code="asd" text="**Estado burofax"/>', sortable: false}, --%>
<%-- 	{dataIndex: 'fechaSolicitud', header: '<s:message code="asd" text="**Fecha solicitud"/>', sortable: false}, --%>
	{dataIndex: 'docUltimaRespuesta', header: '<s:message code="plugin.precontencioso.grid.buscador.documento.ultsolicitud.respuesta" text="**Respuesta ultima solicitud"/>', sortable: false},
	{dataIndex: 'docUltimoActor', header: '<s:message code="plugin.precontencioso.grid.buscador.documento.ultsolicitud.actor" text="**Actor ultima solicitud"/>', sortable: false},
	{dataIndex: 'docFechaResultado', header: '<s:message code="plugin.precontencioso.grid.buscador.documento.fecha.resultado" text="**Fecha resultado"/>', sortable: false},
	{dataIndex: 'docFechaEnvio', header: '<s:message code="plugin.precontencioso.grid.buscador.documento.fecha.envio" text="**Fecha envio"/>', sortable: false},
	{dataIndex: 'docFechaRecepcion', header: '<s:message code="plugin.precontencioso.grid.buscador.documento.fecha.recepcion" text="**Fecha recepcion"/>', sortable: false},
	{dataIndex: 'docAdjunto', header: '<s:message code="plugin.precontencioso.grid.buscador.documento.adjunto" text="**Adjunto"/>', sortable: false}
]);

var pagingBar = fwk.ux.getPaging(documentoPcoStore);
pagingBar.hide();

var gridDocumentoPco = app.crearGrid(documentoPcoStore, documentoPcoCm, {
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

gridDocumentoPco.addListener('rowdblclick', function(grid, rowIndex, e) {
	var rec = grid.getStore().getAt(rowIndex);
	var id = rec.get('prcId');
	//app.abreAsuntoTab(id, nombre_asunto,'tabSubastas');
});