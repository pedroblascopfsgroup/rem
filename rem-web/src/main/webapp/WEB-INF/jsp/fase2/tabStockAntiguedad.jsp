<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
var createTabStockAntiguedad=function(){
	var labelStyle='font-weight:bolder;width:150px';
	var dictNivel = {diccionario:[{codigo:'1',descripcion:'Gestor'},{codigo:'2',descripcion:'Descr2'}]};
	
	//store generico de combo diccionario
	var optionsNivelStore = new Ext.data.JsonStore({
	       fields: ['codigo', 'descripcion']
	       ,root: 'diccionario'
	       ,data : dictNivel
	});
	
	var comboNivel = new Ext.form.ComboBox({
				store:optionsNivelStore
				,displayField:'descripcion'
				,valueField:'codigo'
				,editable:false
				,mode: 'local'
				,labelStyle:labelStyle
				,triggerAction: 'all'
				,fieldLabel : '<s:message code="" text="**Nivel Consulta" />'
	});	
		
	var productos = {productos :[	
		{antiguedad:'1 y 3 meses',stockentregado:'800000 / 3A',stockrecuperado:'1000000 / 2A',stockfinal:'600000 / 2A'}
		,{antiguedad:'3 y 6 meses',stockentregado:'800000 / 3A',stockrecuperado:'1000000 / 2A',stockfinal:'600000 / 2A'}
		,{antiguedad:'.....',stockentregado:'800000 / 3A',stockrecuperado:'1000000 / 2A',stockfinal:'600000 / 2A'}
		
		]};
	
	var productosStore = new Ext.data.JsonStore({
		data : productos
		,root : 'productos'
		,fields : ['antiguedad','stockentregado','stockrecuperado','stockfinal']
	});
	var productosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="" text="**Antiguedad"/>', dataIndex : 'antiguedad' }
		,{header : '<s:message code="" text="**Stock Entregado"/>', dataIndex : 'stockentregado' }
		,{header : '<s:message code="" text="**Stock Recuperado"/>', dataIndex : 'stockrecuperado' }
		,{header : '<s:message code="" text="**Stock Final"/>', dataIndex : 'stockfinal' }
	]);
	
	var productosGrid = new Ext.grid.GridPanel({
		store : productosStore
		,cm : productosCm
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,width : 700
		,height : 200
	});	
	
	var panel = new Ext.Panel({
		title:'<s:message code="" text="**Sock Actual (Antiguo)"/>'
		,autoHeight:true
		,style:'padding: 10px'
		,items:[
		{
					layout : 'table'
					,border : false
					,layoutConfig:{
						columns:1
					}
					,defaults : {xtype : 'fieldset',width:350, autoHeight : true, border : false ,cellCls : 'vtop', bodyStyle : 'padding-left:5px'}
					,items:[
						{ items:[ comboNivel]	}
					]
				},productosGrid
		]
	});
		
	return panel;
}
