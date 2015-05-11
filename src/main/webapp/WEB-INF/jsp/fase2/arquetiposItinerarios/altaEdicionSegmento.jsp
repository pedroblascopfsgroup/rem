<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
var dictSegmento = {diccionario:[{codigo:'1',descripcion:'Descr1'},{codigo:'2',descripcion:'Descr2'}]};

//store generico de combo diccionario
var optionsSegmentoStore = new Ext.data.JsonStore({
       fields: ['codigo', 'descripcion']
       ,root: 'diccionario'
       ,data : dictSegmento
});

var comboSegmento = new Ext.form.ComboBox({
			store:optionsSegmentoStore
			,displayField:'descripcion'
			,valueField:'codigo'
			,mode: 'local'
			,triggerAction: 'all'
			,labelStyle:'font-weight:bolder'
			,fieldLabel : '<s:message code="segmentos.segmento" text="**Tipo de Segmento" />'
});

var incluir = new Ext.form.Checkbox({
	fieldLabel:'<s:message code="segmentos.incluir" text="**Incluir/Excluir"/>'
	,name:'incluir'
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
		,comboSegmento
		,incluir
	]
	,bbar:[btnGuardar,btnCancelar]
});
page.add(panelEdicion);
</fwk:page>