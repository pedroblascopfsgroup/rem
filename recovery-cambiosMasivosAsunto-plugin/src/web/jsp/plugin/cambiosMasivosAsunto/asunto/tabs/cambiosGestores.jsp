<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	var gridHeight = 225;

	var panel = new Ext.Panel({
		title: '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.tabTitle" text="**Cambio gestores" />'
		,autoHeight: true
		,nombreTab : 'tabCambiosGestoresAsunto'			
	});

	panel.getAsuntoId = function(){ return entidad.get("data").id; }

	// Grid cambios ya aplicados

	var cgHistoricoRecord = Ext.data.Record.create([
		{name : 'tipoGestor'}
		,{name : 'antiguoUsuario'}
		,{name : 'nuevoUsuario'}
		,{name : 'fechaInicio'}
		,{name : 'fechaFin'}
		,{name : 'usuarioModifica'}
	]);
			
	var storeCgHistorico = page.getStore({
		flow : 'cambiosgestores/getCambiosGestoresHistorico'
		,storeId : 'storeCgHistorico'
		,reader : new Ext.data.JsonReader({
			root : 'cambiosGestoresHistorico'
			,totalProperty : 'total'
		},cgHistoricoRecord)
	});

	entidad.cacheStore(storeCgHistorico);

	var cgHistorico = new Ext.grid.ColumnModel([
		 {header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.tipoGestor" text="**Tipo de gestor" />', dataIndex : 'tipoGestor'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.viejoUsuario" text="**Usuario anterior" />', dataIndex : 'antiguoUsuario'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.nuevoUsuario" text="**Usuario nuevo" />', dataIndex : 'nuevoUsuario'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.fechaInicio" text="**Fecha de inicio" />', dataIndex : 'fechaInicio'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.fechaFin" text="**Fecha de fin" />', dataIndex : 'fechaFin'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.usuarioModifica" text="**Usuario modfica" />', dataIndex : 'usuarioModifica'}
	]);
		
	var gridCgHistorico = app.crearGrid(storeCgHistorico, cgHistorico, {
		title : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.grid.historico" text="**Cambios de gestor aplicados" />'
		,height: gridHeight
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});

	// Grid cambios pendientes
	
	var cgPendienteRecord = Ext.data.Record.create([
		 {name : 'id'}
		,{name : 'tipoGestor'}
		,{name : 'usuarioActual'}
		,{name : 'usuarioFuturo'}
		,{name : 'fechaInicio'}
		,{name : 'fechaFin'}
		,{name : 'usuarioModifica'}
	]);
			
	var storeCgPendiente = page.getStore({
		flow : 'cambiosgestores/getCambiosGestoresPendiente'
		,storeId : 'storeCgPendiente'
		,reader : new Ext.data.JsonReader({
			root : 'cambiosGestoresPendientes'
		},cgPendienteRecord)
	});

	entidad.cacheStore(storeCgPendiente);

	var cgPendiente = new Ext.grid.ColumnModel([
		{hidden:true,sortable: false, dataIndex: 'id',fixed:true}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.tipoGestor" text="**Tipo de gestor" />', dataIndex : 'tipoGestor'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.usuarioActual" text="**Usuario actual" />', dataIndex : 'usuarioActual'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.usuarioFuturo" text="**Usuario futuro" />', dataIndex : 'usuarioFuturo'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.fechaIda" text="**Fecha de inicio" />', dataIndex : 'fechaInicio'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.fechaVuelta" text="**Fecha de fin" />', dataIndex : 'fechaFin'}
		,{header : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.usuarioModifica" text="**Usuario modfica" />', dataIndex : 'usuarioModifica'}
	]);
		
	var gridCgPendiente = app.crearGrid(storeCgPendiente, cgPendiente, {
		title : '<s:message code="cambiosMasivosAsunto.asunto.tab.cambioGestores.grid.pendiente" text="**Cambios de gestor pendientes" />'
		,height: gridHeight
		,autoWidth: true
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	function addPanel2Panel(grid){
		panel.add (new Ext.Panel({
			border : false
			,style : 'margin-top:10px; margin-left:10px'
			,items : [grid]
		}));
	}

	addPanel2Panel(gridCgHistorico);
	addPanel2Panel(gridCgPendiente);
	
	panel.getValue = function() {}

	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, storeCgHistorico, {idAsunto : panel.getAsuntoId()} ); 
		entidad.cacheOrLoad(data, storeCgPendiente, {idAsunto : panel.getAsuntoId()} ); 
	}

	return panel;

})