<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
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
			,valueField:'codigo'
			,mode: 'local'
			,triggerAction: 'all'
			,labelStyle:'font-weight:bolder'
			,fieldLabel : '<s:message code="productos.tipoproducto" text="**Tipo de Producto" />'
});
var importeDesde = app.creaText('importeDesde','<s:message code="productos.importemin" text="**Importe Desde" />','0');
var importeHasta = app.creaText('importeHasta','<s:message code="productos.importemax" text="**Importe Hasta" />','1000');

var incluir = new Ext.form.Checkbox({
	fieldLabel:'<s:message code="productos.incluir" text="**Incluir/Excluir"/>'
	,name:'incluir'
});
var fallido = new Ext.form.Checkbox({
	fieldLabel:'<s:message code="productos.fallido" text="**Fallido"/>'
	,name:'fallido'
});
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

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,bodyStyle:'padding:10px'
	,xtype:'fieldset'
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
					,items:[
						comboTipoProducto
						,importeDesde
						,importeHasta
						,incluir
						,fallido]
					//,columnWidth:.5
				}
			]
		}
	]
	,bbar:[btnGuardar,btnCancelar]
});
page.add(panelEdicion);
</fwk:page>