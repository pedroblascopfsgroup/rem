﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

<%-- Inicio Grid de  Historico de liquidaciones --%>
	var recordHistoricoLiquidacion = Ext.data.Record.create([
          {name : 'nombre'}
         ,{name : 'contrato'}
         ,{name : 'fecha'}
         ,{name : 'importe'}
         ,{name : 'estado'}
         ,{name : 'idLiquidacion'}

      ]);
      
    var historicoLiquidacionesStore = page.getStore({
        flow: ''
        ,storeId : 'historicoLiquidacionesStore'
        ,reader : new Ext.data.JsonReader(
            {root:'historicoLiquidaiones'}
            , recordHistoricoLiquidacion
        )
    }); 

	var cmHistoricoLiquidaciones = new Ext.grid.ColumnModel([
       {header : '<s:message code="acuerdos.codigo" text="**Nombre" />', dataIndex : 'nombre',width: 45}
      ,{header : '<s:message code="acuerdos.fechaPropuesta" text="**Contrato" />', dataIndex : 'contrato',width: 75}
      ,{header : '<s:message code="acuerdos.solicitante" text="**Fecha" />', dataIndex : 'fecha',width: 35}
      ,{header : '<s:message code="acuerdos.estado" text="**Importe" />', dataIndex : 'importe',width: 35}
      ,{header : '<s:message code="acuerdos.codigo.estado" text="**Estado" />',dataIndex : 'estado',  width: 55}
      ,{header : '<s:message code="acuerdos.codigo.idTipoAcuerdo" text="**id Liquidacion" />',dataIndex : 'idLiquidacion', hidden:true}
    ]);
    
    var btnNuevaLiquidacion = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.historicoLiquidaciones.grid.btn.nuevo" text="**Nuevo" />'
       <app:test id="btnNuevaLiquidacion" addComa="true" />
       ,iconCls : 'icon_mas'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
   	
   	var btnEditarLiquidacion = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.historicoLiquidaciones.grid.btn.editar" text="**Editar" />'
       <app:test id="btnEditarLiquidacion" addComa="true" />
       ,iconCls : 'icon_edit'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
   	
   	var btnCopiarLiquidacion = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.historicoLiquidaciones.grid.btn.copiar" text="**Copiar" />'
       <app:test id="btnCopiarLiquidacion" addComa="true" />
       ,iconCls : 'icon_edit'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
   	
    var btnEliminarLiquidacion = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.historicoLiquidaciones.grid.btn.eliminar" text="**Eliminar" />'
       <app:test id="btnEliminarLiquidacion" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
   	
   	var btnCalcularLiquidacion = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.historicoLiquidaciones.grid.btn.calcular" text="**Calcular" />'
       <app:test id="btnCalcularLiquidacion" addComa="true" />
       ,iconCls : 'icon_ok'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
   	
   	var btnModificarLiquidacion = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.historicoLiquidaciones.grid.btn.modificar" text="**Modificar" />'
       <app:test id="btnModificarLiquidacion" addComa="true" />
       ,iconCls : 'icon_edit'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});

	var historicoLiquidacionesGrid = app.crearGrid(historicoLiquidacionesStore,cmHistoricoLiquidaciones,{
         title : '<s:message code="plugin.liquidaciones.historicoLiquidaciones.grid.title" text="**Histórico de Liquidaciones" />'
         <app:test id="historicoLiquidacionesGrid" addComa="true" />
         ,autoHeight : true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [
        	 btnNuevaLiquidacion
        	,btnEditarLiquidacion
        	,btnCopiarLiquidacion
        	,btnEliminarLiquidacion
        	,btnCalcularLiquidacion
        	,btnModificarLiquidacion
	      ]

	}); 
	
	historicoLiquidacionesGrid.on('rowclick', function(grid, rowIndex, e) {
	});
	
<%-- Fin grid histórico de liquidaciones --%>

<%-- Inicio grid entregas--%>

	var recordEntregasLiquidacion = Ext.data.Record.create([
          {name : 'fechaEntrega'}
         ,{name : 'fechaValor'}
         ,{name : 'tipoEntrega'}
         ,{name : 'conceptoEntrega'}
         ,{name : 'gastosProcurador'}
         ,{name : 'gastosLetrado'}
         ,{name : 'idEntrega'}

      ]);
      
    var entregasLiquidacionStore = page.getStore({
        flow: ''
        ,storeId : 'entregasLiquidacionStore'
        ,reader : new Ext.data.JsonReader(
            {root:'entregas'}
            , recordEntregasLiquidacion
        )
    }); 

	var cmEntregasLiquidacion = new Ext.grid.ColumnModel([
       {header : '<s:message code="plugin.liquidaciones.entrega.grid.fechaEntrega" text="**Fecha entrega" />', dataIndex : 'fechaEntrega',width: 55}
      ,{header : '<s:message code="plugin.liquidaciones.entrega.grid.fechaValor" text="**Fecha valor" />', dataIndex : 'fechaValor',width: 55}
      ,{header : '<s:message code="plugin.liquidaciones.entrega.grid.tipoEntrega" text="**Tipo entrega" />', dataIndex : 'tipoEntrega',width: 75}
      ,{header : '<s:message code="plugin.liquidaciones.entrega.grid.conceptoEntrega" text="**Concepto entrega" />', dataIndex : 'conceptoEntrega',width: 100}
      ,{header : '<s:message code="plugin.liquidaciones.entrega.grid.totalEntrega" text="**Total entrega" />',dataIndex : 'totalEntrega',  width: 55}
      ,{header : '<s:message code="plugin.liquidaciones.entrega.grid.gastosProcurador" text="**Gastos procurador" />',dataIndex : 'gastosProcurador',  width: 55}
      ,{header : '<s:message code="plugin.liquidaciones.entrega.grid.gastosLetrado" text="**Gastos letrado" />',dataIndex : 'gastosLetrado',  width: 55}
      ,{header : '<s:message code="plugin.liquidaciones.entrega.grid.idEntrega" text="**id entrega" />',dataIndex : 'idEntrega', hidden:true}
    ]);
    
    var btnNuevaEntrega = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.entrega.grid.btn.nuevo" text="**Añadir" />'
       <app:test id="btnNuevaEntrega" addComa="true" />
       ,iconCls : 'icon_mas'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
   	
   	var btnModificarEntrega = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.entrega.grid.btn.modificar" text="**Modificar" />'
       <app:test id="btnModificarEntrega" addComa="true" />
       ,iconCls : 'icon_edit'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
   	
   	var btnEliminarEntrega = new Ext.Button({
       text:  '<s:message code="plugin.liquidaciones.entrega.grid.btn.eliminar" text="**Eliminar" />'
       <app:test id="btnEliminarEntrega" addComa="true" />
       ,iconCls : 'icon_menos'
       ,cls: 'x-btn-text-icon'
       ,handler:function(){}
   	});
    
    var entregasLiquidacionGrid = app.crearGrid(entregasLiquidacionStore,cmEntregasLiquidacion,{
         title : '<s:message code="plugin.liquidaciones.entrega.grid.title" text="**Lista de entregas asociadas a una liquidación" />'
         <app:test id="entregasLiquidacionGrid" addComa="true" />
         ,style:'margin-top:15px'
         ,autoHeight : true
         ,cls:'cursor_pointer'
         ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
         ,bbar : [btnNuevaEntrega,btnModificarEntrega,btnEliminarEntrega]

	}); 
	
	entregasLiquidacionGrid.on('rowclick', function(grid, rowIndex, e) {
	});
	
<%-- Fin grid entregas --%>

<%-- Funcion que habilita y deshabilita los botones de los dos grids --%>
	var habilitarDeshabilitarBotonesGrid = function(){

	}

	
	var panel=new Ext.Panel({
		title : '<s:message code="plugin.liquidaciones.historicoLiquidaciones.panel.title" text="**Histórico de Liquidaciones"/>'
		,layout:'form'
		,border : false
		,autoScroll:true
		,bodyStyle:'padding:5px;margin:5px'
		,autoHeight:true
		,autoWidth : true
		,nombreTab : 'acuerdos'
		,items : [historicoLiquidacionesGrid ,entregasLiquidacionGrid]
	});
	
	panel.getValue = function(){
		return true;
	}
	
	panel.setValue = function(){}

	return panel;
})