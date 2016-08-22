<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
var descripcion = app.creaText('descripcion','<s:message code="arquetipos.descripcion" text="**Descripcion" />','Hipotecas autonomos < 120000',{width:200});
var listaClientes = app.creaText('listaClientes','<s:message code="arquetipos.listaclientes" text="**Lista de Clientes" />','clientes_lista_blanca.txt',{width:200});
var reincidencia = app.creaNumber('reincidencia', '<s:message code="arquetipos.reincidencia" text="**Reincidencia" />','5');
var riesgoTotal = app.creaNumber('riesgoTotal','<s:message code="arquetipos.riesgototal" text="**Riesgo Total" />','5');

var btnGuardar = new Ext.Button({
	text : '<s:message code="app.guardar" text="**Guardar" />'
	,iconCls : 'icon_ok'
	,handler : function(){
		page.fireEvent(app.event.DONE);		
	}
});

var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);  	
	}
	
});
var tiposProducto = {tiposProducto :[	
	{id:'1',tipoProducto: 'Hipotecas', incluir : 'Si',fallido:'No',importeMinimo:'10',importeMaximo:'100000'}
	]};
	
var tiposProductoStore = new Ext.data.JsonStore({
	data : tiposProducto
	,root : 'tiposProducto'
	,fields : ['tipoProducto', 'incluir','fallido','importeMinimo','importeMaximo']
});
var tiposProductoCm = new Ext.grid.ColumnModel([
	{	header: '<s:message code="productos.tipoproducto" text="**Tipo de Producto"/>', 
    	width: 150, sortable: true, dataIndex: 'tipoProducto'},
    	
    {	header: '<s:message code="productos.incluir" text="**Incluir/Excluir"/>', 
    	width: 50, sortable: true, dataIndex: 'incluir'},	
    
    {	header: '<s:message code="productos.fallido" text="**Fallido"/>', 
    	width: 50, sortable: true, dataIndex: 'fallido'},	
    
	{	header: '<s:message code="productos.importemin" text="**Importe Minimo"/>', 
		width: 100, dataIndex: 'importeMinimo',renderer: app.format.moneyRenderer,align:'right'},
		
	{	header: '<s:message code="productos.importemax" text="**Importe Maximo"/>', 
		width: 100, dataIndex: 'importeMaximo',renderer: app.format.moneyRenderer,align:'right'}
]);
var btnAgregarProducto= app.crearBotonAgregar({
		flow:'fase2/arquetiposItinerarios/altaEdicionProducto'
		,title : '<s:message code="productos.alta" text="**Alta Producto" />'
		,width:500
		,page : page
	});
var btnEditarProducto= app.crearBotonEditar({
		flow:'fase2/arquetiposItinerarios/altaEdicionProducto'
		,title : '<s:message code="productos.edicion" text="**Edicion Producto" />'
		,width:500
		,page : page
	});
var btnBorrarProducto= app.crearBotonBorrar({
		flow : ''
		,page : page
	});
var cfgProductos={
	title:'<s:message code="arquetipos.gridproductos.titulo" text="**Tipos de Producto"/>'
	<app:test id="tiposProductoGrid" addComa="true" />
	,store: tiposProductoStore
	,cm: tiposProductoCm
	,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
	//,autoWidth:true
	,width:350
	,style:'padding-bottom:10px'
	,height:150
	,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	//,iconCls : 'icon_antecedentes_ext'
	,viewConfig:{forceFit:true}
	,monitorResize:true
	,bbar:[btnAgregarProducto,btnEditarProducto,btnBorrarProducto]
};
var tiposProductoGrid = new Ext.grid.GridPanel(cfgProductos);


var segmentos = {segmentos:[	
	{id:'1',segmento: 'Autonomos', incluir : 'Si'}
	]};
	
var segmentosStore = new Ext.data.JsonStore({
	data : segmentos
	,root : 'segmentos'
	,fields : ['segmento', 'incluir']
});
var segmentosCm = new Ext.grid.ColumnModel([
	{	header: '<s:message code="segmentos.segmento" text="**Segmento"/>', 
    	width: 150, sortable: true, dataIndex: 'segmento'},
    	
    {	header: '<s:message code="segmentos.incluir" text="**Incluir/Excluir"/>', 
    	width: 50, sortable: true, dataIndex: 'incluir'}
]);

var btnAgregarSegmento= app.crearBotonAgregar({
		flow:'fase2/arquetiposItinerarios/altaEdicionSegmento'
		,title : '<s:message code="segmentos.edicion" text="**Segmentos Cliente" />'
		,width:500
		,page : page
	});
var btnEditarSegmento= app.crearBotonEditar({
		flow:'fase2/arquetiposItinerarios/altaEdicionSegmento'
		,title : '<s:message code="segmentos.edicion" text="**Segmentos Cliente" />'
		,width:500
		,page : page
	});
var btnBorrarSegmento= app.crearBotonBorrar({
		flow : ''
		,page : page
	});
var cfgSegmentos={
	title:'<s:message code="arquetipos.gridsegmentos.titulo" text="**Segmentos"/>'
	<app:test id="tiposProductoGrid" addComa="true" />
	,store: segmentosStore
	,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
	,cm: segmentosCm
	//,autoWidth:true
	,width:250
	,height:150
	,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	,viewConfig:{forceFit:true}
	,monitorResize:true
	,bbar:[btnAgregarSegmento,btnEditarSegmento,btnBorrarSegmento]
};
var segmentosGrid = new Ext.grid.GridPanel(cfgSegmentos);

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,bodyStyle:'padding:10px;cellspacing:20px'
	//,xtype:'fieldset'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errL' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,items:[descripcion, listaClientes,reincidencia, riesgoTotal]
					,columnWidth:.5
				}
			]
		}
		,tiposProductoGrid
		,segmentosGrid
	]
	,bbar:[btnGuardar,btnCancelar]
});
page.add(panelEdicion);
</fwk:page>