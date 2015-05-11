<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<fwk:page>
array = [];
array['uno']=1;
array['dos']=2;
array['tres']=3;
var tipo_wf='${tipoWf}'

<%@ include file="/WEB-INF/jsp/plugin/procedimientos/elementos.jsp" %>

var items=[];
var muestraBotonGuardar = 0;

<c:if test="${form.errorValidacion!=null}">
	items.push({ html : '<s:message code="${form.errorValidacion}" text="${form.errorValidacion}" />', border:false, bodyStyle:'color:red;margin-bottom:5px'});
	var textError = '${form.errorValidacion}';
	if (textError.indexOf('<div id="permiteGuardar">')>0) {
		muestraBotonGuardar=1;
	}
</c:if>

var values;

<c:forEach items="${form.items}" var="item">
values = <app:dict value="${item.values}" />;
items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '<s:message text="${item.label}" javaScriptEscape="true" />', '<s:message text="${item.value}" javaScriptEscape="true" />', values));
</c:forEach>


var bottomBar = [];

//mostramos el botón guardar cuando la tarea no está terminada y cuando no hay errores de validacion
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
			});
		}
	});
	
	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)
	{
		bottomBar.push(btnGuardar);
	}
	muestraBotonGuardar = 0;
</c:if>

if (muestraBotonGuardar==1){
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			//page.fireEvent(app.event.DONE);
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
			});
		}
	});
	
	//Si tiene más items que el propio label de descripción se crea el botón guardar
	if (items.length > 1)	{
		bottomBar.push(btnGuardar);
	}
}

var btnCancelar= new Ext.Button({
	text : '<s:message code="app.cancelar" text="**Cancelar" />'
	,iconCls : 'icon_cancel'
	,handler : function(){
		page.fireEvent(app.event.CANCEL);
	}
});

bottomBar.push(btnCancelar);

// *************************************************************** //
// ***  AÑADIMOS LAS FUNCIONALIDADES EXTRA DE ESTE FORMULARIO  *** //
// *************************************************************** //

	var dsNotarios = new Ext.data.Store({
		autoLoad: false,
		proxy: new Ext.data.HttpProxy({
			url: page.resolveUrl('plugin/procedimientos/notarios')
		}),
		reader: new Ext.data.JsonReader({
			root: 'notarios'
		}, [
			{name: 'codigo', mapping: 'codigo'},
			{name: 'descripcion', mapping: 'descripcion'}
		])
	});
	var comboNotarios = new Ext.form.ComboBox ({
		store:  dsNotarios,
		displayField: items[3].displayField, 	// descripcion
		valueField: items[3].valueField, 		// codigo
		fieldLabel: items[3].fieldLabel,		// Pla de juzgado
		hiddenName: 'values[3]',
		typeAhead: false,
		loadingText: 'Searching...',
		width: 300,
		resizable: true,
		triggerAction: 'all',
		mode: 'local',
		value: items[3].value
	});	
	
	Ext.onReady(function() {
		if (items[3].value!=''){
			Ext.Ajax.request({
				url: page.resolveUrl('plugin/procedimientos/notarios')
				,params: {codigo: items[3].value}
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText)
					comboNotarios.store.reload();
					dsNotarios.on('load', function(){  
						comboNotarios.setValue(items[3].value);
						dsNotarios.events['load'].clearListeners();
					});
				}				
			});
		}
	});
	
	comboNotarios.on('afterrender', function(combo) {
		combo.mode='remote';
	});
	
	items[3] = comboNotarios;
	
// *************************************************************** //
	
var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,width:700
	,bodyStyle:'padding:10px;cellspacing:20px'
	//,xtype:'fieldset'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errorList' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			//,bodyStyle:'padding:5px;cellspacing:20px;'
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,autoHeight:true
					,items:items
					//,columnWidth:.5
				}
			]
		}
	]
	,bbar:bottomBar
});
page.add(panelEdicion);
</fwk:page>