<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
var labelStyle='font-weight:bolder;width:150px'
var nroProcedimiento=app.creaText('procedimiento','<s:message code="moverprocedimientos.procedimiento" text="**Procedimiento" />','',{labelStyle:labelStyle})
var dictTipoProc = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};

//store generico de combo diccionario
var optionsTipoProcStore = new Ext.data.JsonStore({
       fields: ['codigo', 'descripcion']
       ,root: 'diccionario'
       ,data : dictTipoProc
});

var comboTipoProc = new Ext.form.ComboBox({
			store:optionsTipoProcStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
			,editable:false
			,triggerAction: 'all'
			,labelStyle:labelStyle
			,fieldLabel : '<s:message code="moverprocedimientos.tipoproc" text="**TipoProcedimiento" />'
});
var nroContrato=app.creaText('contrato','<s:message code="moverprocedimientos.contrato" text="**Contrato" />','',{labelStyle:labelStyle})
var dictTipoProducto = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};

//store generico de combo diccionario
var optionsTipoProductoStore = new Ext.data.JsonStore({
       fields: ['codigo', 'descripcion']
       ,root: 'diccionario'
       ,data : dictTipoProducto
});

var comboTipoProducto = new Ext.form.ComboBox({
			store:optionsTipoProductoStore
			,displayField:'descripcion'
			,editable:false
			,valueField:'codigo'
			,mode: 'local'
			,triggerAction: 'all'
			,labelStyle:labelStyle
			,fieldLabel : '<s:message code="moverprocedimientos.tipoproducto" text="**Tipo Producto" />'
});
var dictAsunto = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};

//store generico de combo diccionario
var optionsAsuntoStore = new Ext.data.JsonStore({
       fields: ['codigo', 'descripcion']
       ,root: 'diccionario'
       ,data : dictAsunto
});

var comboAsunto = new Ext.form.ComboBox({
			store:optionsAsuntoStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
			,editable:false
			,triggerAction: 'all'
			,labelStyle:labelStyle
			,fieldLabel : '<s:message code="moverprocedimientos.asunto" text="**Asunto" />'
});
var dictDespacho = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};

//store generico de combo diccionario
var optionsDespachoStore = new Ext.data.JsonStore({
       fields: ['codigo', 'descripcion']
       ,root: 'diccionario'
       ,data : dictDespacho
});

var comboDespacho = new Ext.form.ComboBox({
			store:optionsDespachoStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,editable:false
			,mode: 'local'
			,triggerAction: 'all'
			,labelStyle:labelStyle
			,fieldLabel : '<s:message code="moverprocedimientos.despacho" text="**Despacho" />'
});
var dictGestor = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};

//store generico de combo diccionario
var optionsGestorStore = new Ext.data.JsonStore({
       fields: ['codigo', 'descripcion']
       ,root: 'diccionario'
       ,data : dictGestor
});

var comboGestor = new Ext.form.ComboBox({
			store:optionsGestorStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,editable:false
			,mode: 'local'
			,triggerAction: 'all'
			,labelStyle:labelStyle
			,fieldLabel : '<s:message code="moverprocedimientos.gestor" text="**Gestor" />'
});
var btnBuscar=app.crearBotonBuscar({
	handler:function(){
		
	}
});
var panelFiltros=new Ext.form.FieldSet({
	layout:'table'
	,layoutConfig:{
		columns:2
	},autoHeight:true
	,title:'<s:message code="moverprocedimientos.filtro" text="**Filtros" />'
	,defaults:{layout:'form',autoHeight:true,border:false,width:350}
	,items:[
		{items:[nroProcedimiento,comboTipoProc,nroContrato,comboTipoProducto]}
		,{items:[comboAsunto,comboDespacho,comboGestor,{border:false,items:btnBuscar,style:'text-align:right',cellCls:'vbottom'}]}
	]
});
	var procedimientos = {procedimientos :[	
		{contrato: '365123654123', saldovencido : '34000',saldototal:'100000',tipoactuacion:'Judicial',tipoprocedimiento:'Subasta',tiporeclamacion:'Total',saldorecuperacion:'30000',recuperacion:'70%',meses:'12'}
		,{contrato: '366665843', saldovencido : '84000',saldototal:'230000',tipoactuacion:'Judicial',tipoprocedimiento:'Hipotecario',tiporeclamacion:'Vencido',saldorecuperacion:'20000',recuperacion:'10%',meses:'3'}

		]};
	
	var procedimientosStore = new Ext.data.JsonStore({
		data : procedimientos
		,root : 'procedimientos'
		,fields : ['contrato','saldovencido','saldototal','tipoactuacion','tipoprocedimiento','tiporeclamacion','saldorecuperacion','recuperacion','meses']
	});
	var procedimientosCm = new Ext.grid.ColumnModel([
		{header : '<s:message code="asunto.tabconformacion.grid.contrato" text="**contrato"/>', dataIndex : 'contrato' }
		,{header : '<s:message code="asunto.tabconformacion.grid.saldovencido" text="**saldovencido"/>', dataIndex : 'saldovencido' }
		,{header : '<s:message code="asunto.tabconformacion.grid.saldototal" text="**Saldo Total"/>', dataIndex : 'saldototal' }
		,{header : '<s:message code="asunto.tabconformacion.grid.tipoactuacion" text="**Tipo Actuacion"/>', dataIndex : 'tipoactuacion' }
		,{header : '<s:message code="asunto.tabconformacion.grid.tipoprocedimiento" text="**Tipo Procedimiento"/>', dataIndex : 'tipoprocedimiento' }
		,{header : '<s:message code="asunto.tabconformacion.grid.tiporeclamacion" text="**Tipo Reclamacion"/>', dataIndex : 'tiporeclamacion' }
		,{header : '<s:message code="asunto.tabconformacion.grid.saldorecuperacion" text="**Saldo Recuperacion"/>', dataIndex : 'saldorecuperacion' }
		,{header : '<s:message code="asunto.tabconformacion.grid.recuperacion" text="**Recuperacion"/>', dataIndex : 'recuperacion' }
		,{header : '<s:message code="asunto.tabconformacion.grid.meses" text="**Meses"/>', dataIndex : 'meses' }
	]);
	
	var procedimientosGrid = new Ext.grid.GridPanel({
		title:'<s:message code="asunto.tabconformacion.grid.titulo" text="**Procedimientos conformados" />'
		,store:procedimientosStore
		,cm:procedimientosCm
		,height : 200
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,width:850
		,style : 'margin-bottom:10px;padding-right:10px'
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	});
	var btnIncorporar = new Ext.Button({
		text : '<s:message code="" text="**Incorporar" />'
		,iconCls : 'icon_incorporar_procedimiento'
		,handler : function() {
				//Pasar Parametros
					page.submit({
						eventName : 'update'
						,formPanel : mainPanel
						,success : function(){ page.fireEvent(app.event.DONE); }
					});
				   }
	});

	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,handler : function(){
			page.submit({
				eventName : 'cancel'
				,formPanel : mainPanel
				,success : function(){ page.fireEvent(app.event.CANCEL); } 	
			});
		}
	});
var mainPanel=new Ext.form.FormPanel({
	autoHeight:true
	,bodyStyle:'padding:10px'
	,items:[
			{ xtype : 'errorList', id:'errL' }
			,panelFiltros
			,procedimientosGrid
		]
	,bbar:[btnIncorporar,btnCancelar]
});
page.add(mainPanel)
</fwk:page>