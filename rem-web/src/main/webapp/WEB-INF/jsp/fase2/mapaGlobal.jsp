<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>

//Nivel Jerarquico
var grid = {grid :[	
	{nroClientes: 'dato1-1', nroContratos : 'dato 1-2'}
	,{nroClientes: 'dato2-1', nroContratos : 'dato 2-2'}
	,{nroClientes: '...', nroContratos : '...'}
	,{nroClientes: 'TOTAL:', nroContratos : 'dato 2-2'}
	]};

var gridStore = new Ext.data.JsonStore({
	data : grid
	,root : 'grid'
	,fields : ['nroClientes', 'nroContratos']
});
var gridCm = new Ext.grid.ColumnModel([
	{header : '<s:message code="grid.nroClientes" text="**Bloque"/>', dataIndex : 'nroClientes' }
	,{header : '<s:message code="grid.nroClientes" text="**Nº Clientes"/>', dataIndex : 'nroContratos' ,align:'right'}
	,{header : '<s:message code="grid.nroContratos" text="**Nº Contratos"/>', dataIndex : 'nroContratos',align:'right' }
	,{header : '<s:message code="grid.nroContratos" text="**Saldo Vencido"/>', dataIndex : 'nroContratos',align:'right' }
	,{header : '<s:message code="grid.nroContratos" text="**Saldo Total"/>', dataIndex : 'nroContratos',align:'right' }
	,{header : '<s:message code="grid.nroContratos" text="**% Sobre Total"/>', dataIndex : 'nroContratos' ,align:'right'}
]);

var gridJerarquica = app.crearGrid(gridStore,gridCm,{
	title:'<s:message code="" text="**Desglose de nodo N por lista nodos N-1" />'
	,style : 'padding:10px'
	,width : 700
	,height : 200
});
var gridProducto = app.crearGrid(gridStore,gridCm,{
	title:'<s:message code="" text="**Desglose de nodo N por productos" />'
	,style : 'padding:10px'
	,width : 700
	,height : 200
});
var gridClientes = app.crearGrid(gridStore,gridCm,{
	title:'<s:message code="" text="**Desglose de nodo N por segmentos clientes" />'
	,style : 'padding:10px'
	,width : 700
	,height : 200
});
var nivelJerarquicoTab=new Ext.Panel({
	title:'Vista Jerarquica'
	,style : 'padding : 5px'
	,autoHeight:true
	,items:[gridJerarquica]
});
//Tipo Producto
var tipoProductoTab=new Ext.Panel({
	title:'Vista por Productos'
	,style : 'padding : 5px'
	,autoHeight:true
	,items:gridProducto
});
//Segmento Cliente
var segmentoClienteTab=new Ext.Panel({
	title:'Vista por Cliente'
	,style : 'padding : 5px'
	,autoHeight:true
	,items:gridClientes
});
//Posicion Irregular Nodo
<%@ include file="posicionNodo.jsp" %>
var posicionNodo=tabPosicionNodo();

var tabPanel=new Ext.TabPanel({
	autoHeight:true
	,items:[nivelJerarquicoTab,tipoProductoTab,segmentoClienteTab,posicionNodo]
	,layoutOnTabChange:true 
	//,frame:true
	,activeItem:0 
	,autoScroll:true
	//,autoWidth : true
	,border : false
})
var panel = new Ext.Panel({
	bodyStyle : 'padding : 5px'
	,autoHeight : true
	,items : [tabPanel]
	,tbar : new Ext.Toolbar()
});
//panel.getTopToolbar().add('->');
//panel.getTopToolbar().add(app.crearBotonAyuda());
page.add(panel);
</fwk:page>