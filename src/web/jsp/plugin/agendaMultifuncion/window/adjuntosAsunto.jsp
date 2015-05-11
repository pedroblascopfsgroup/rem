﻿﻿﻿﻿﻿﻿﻿﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<fwk:page>
	
	var Adjunto = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
	]);

	var AdjuntosPersonas = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
	]);

	var AdjuntosExpedientes = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
	]);

	var AdjuntosContratos = Ext.data.Record.create([
		{name : 'id'}
		,{name : 'idEntidad'}
		,{name : 'descripcionEntidad'}
		,{name : 'nombre'}
		,{name : 'tipo'}
		,{name : 'length'}
		,{name : 'contentType'}
	]);

	
	
	var store = page.getStore({
		flow : 'asuntos/consultaAdjuntos'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},Adjunto)
	});

	var storePersonas = page.getStore({
		flow : 'asuntos/consultaAdjuntosPersonas'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosPersonas)
	});

	var storeExpedientes = page.getStore({
		flow : 'asuntos/consultaAdjuntosExpedientes'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosExpedientes)
	});

	var storeContratos = page.getStore({
		flow : 'asuntos/consultaAdjuntosContratos'
		,reader : new Ext.data.JsonReader({
			root : 'adjuntos'
			,totalProperty : 'total'
		},AdjuntosContratos)
	});

	
	var recargarAdjuntos = function (){
		store.webflow({id:${asunto.id}});
		storePersonas.webflow({id:${asunto.id}});
		storeExpedientes.webflow({id:${asunto.id}});
		storeContratos.webflow({id:${asunto.id}});
	};

	recargarAdjuntos();
	
	var cm = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
	]);

	var cmPersonas = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.cliente" text="**Cliente" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
	]);

	var cmExpedientes = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.expediente" text="**Expediente" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
	]);

	var cmContratos = new Ext.grid.ColumnModel([
		{header : '<s:message code="asuntos.adjuntos.contrato" text="**Contrato" />', dataIndex : 'descripcionEntidad', id:'colCodigoEntidad'}
		,{header : '<s:message code="asuntos.adjuntos.nombre" text="**Nombre" />', dataIndex : 'nombre'}
		,{header : '<s:message code="asuntos.adjuntos.tamanyo" text="**Tama&ntilde;o" />', dataIndex : 'length', renderer : app.format.fileSizeRenderer, align:'right'}
		,{header : '<s:message code="asuntos.adjuntos.tipo" text="**Tipo" />', dataIndex : 'contentType'}
	]);
	
	var gridHeight = 100;
	var grid = app.crearGrid(store, cm, {
		title : '<s:message code="asuntos.adjuntos.grid" text="**Ficheros adjuntos" />'
		,height: 100
		,collapsible:true
		,parentWidth:600
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	
	
	grid.on('expand', function(){
				grid.setHeight(200);				
				gridPersonas.collapse(true);				
				gridExpedientes.collapse(true);
				gridContratos.collapse(true);
			});
	alert('aaaa');
	 	
	var gridPersonas = app.crearGrid(storePersonas, cmPersonas, {
		title : '<s:message code="asuntos.adjuntos.grid.personas" text="**Ficheros adjuntos Personas" />'
		,height: gridHeight
		,parentWidth:600
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridPersonas.on('expand', function(){
				gridPersonas.setHeight(200);				
				gridExpedientes.collapse(true);
				gridContratos.collapse(true);
				grid.collapse(true);
			});

	var gridExpedientes = app.crearGrid(storeExpedientes, cmExpedientes, {
		title : '<s:message code="asuntos.adjuntos.grid.expediente" text="**Ficheros adjuntos del Expediente" />'
		,height: gridHeight
		,parentWidth:600
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridExpedientes.on('expand', function(){
				gridExpedientes.setHeight(200);				
				gridPersonas.collapse(true);
				gridContratos.collapse(true);
				grid.collapse(true);
			});
	
	var gridContratos = app.crearGrid(storeContratos, cmContratos, {
		title : '<s:message code="asuntos.adjuntos.grid.contratos" text="**Ficheros adjuntos Contratos" />'
		,height: gridHeight
		,parentWidth:600
		,collapsible:true
		,style:'padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	gridContratos.on('expand', function(){
				gridContratos.setHeight(200);				
				gridPersonas.collapse(true);
				gridExpedientes.collapse(true);
				grid.collapse(true);
			});

	var panel = new Ext.Panel({
		title: '<s:message code="asuntos.adjuntos.tabTitle" text="**Adjuntos" />'
		,autoHeight: true
		,items : [
				{items:[grid],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridExpedientes],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridPersonas],border:false,style:'margin-top: 7px; margin-left:5px'}
				,{items:[gridContratos],border:false,style:'margin-top: 7px; margin-left:5px'}
			]		
	});

	page.add(panel);   
</fwk:page>