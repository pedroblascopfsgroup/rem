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
var offset=0;
var muestraBotonGuardar = 0;

<c:if test="${form.errorValidacion!=null}">
	items.push({ html : '<s:message code="${form.errorValidacion}" text="${form.errorValidacion}" />', border:false, bodyStyle:'color:red;margin-bottom:5px'});
	offset=1;
	var textError = '${form.errorValidacion}';
	if (textError.indexOf('<div id="permiteGuardar">')>0) {
		<c:if test="${!readOnly}">muestraBotonGuardar=1;</c:if>
	}
</c:if>


var codPlaza = '';
<c:forEach items="${form.items}" var="item">
	values = <app:dict value="${item.values}" />;
	<c:if test="${((item.nombre=='plazaJuzgado')||(item.nombre=='comboPlaza')||(item.nombre=='nPlaza'))}">
		<c:if test="${item.value!=null}">
			codPlaza='${item.value}';
		</c:if>	
	</c:if>
	items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '<s:message text="${item.label}" javaScriptEscape="true" />', '<s:message text="${item.value}" javaScriptEscape="true" />', values));
</c:forEach>

var bottomBar = [];

//mostramos el botón guardar cuando la tarea no está terminada y cuando no hay errores de validacion
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
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
	
	// cargar la plaza para historico de la propia tarea
	var codPlazaParaHistorico = "${valores['P02_InterposicionDemanda']['plazaJuzgado']}";
	if (codPlazaParaHistorico != '' || "${valores['P02_ConfirmarAdmisionDemanda']['nPlaza']}" != ''){
		// de la propia tarea o si esta vacio pero la siguiente tarea esta rellena 
		// lo que indica que el campo se dejo vacio.
		codPlaza = codPlazaParaHistorico;
	}
	
var decenaInicio = 0;

var dsplazas = new Ext.data.Store({
	autoLoad: false,
	baseParams: {limit:10, start:0},
	proxy: new Ext.data.HttpProxy({
		url: page.resolveUrl('plugin/procedimientos/plazasDeJuzgados')
	}),
	reader: new Ext.data.JsonReader({
		root: 'plazas'
		,totalProperty: 'total'
	}, [
		{name: 'codigo', mapping: 'codigo'},
		{name: 'descripcion', mapping: 'descripcion'}
	])
});

var comboPlaza = new Ext.form.ComboBox ({
	store:  dsplazas,
	displayField: items[2 + offset].displayField, 	// descripcion
	valueField: items[2 + offset].valueField, 		// codigo
	fieldLabel: items[2 + offset].fieldLabel,		// Pla de juzgado
	hiddenName: 'values[2]',
	typeAhead: false,
	loadingText: 'Searching...',
	width: 300,
	resizable: true,
	pageSize: 10,
	triggerAction: 'all',
	mode: 'local'
});	

Ext.onReady(function() {
	decenaInicio = 0;
	if (codPlaza!=''){
		Ext.Ajax.request({
				url: page.resolveUrl('plugin/procedimientos/paginaDePlaza')
				,params: {codigo: codPlaza}
				,method: 'POST'
				,success: function (result, request){
					var r = Ext.util.JSON.decode(result.responseText)
					decenaInicio = (r.paginaParaPlaza);
					dsplazas.baseParams.start = decenaInicio;	
					comboPlaza.store.reload();
					dsplazas.on('load', function(){  
						comboPlaza.setValue(codPlaza);
						dsplazas.events['load'].clearListeners();
					});
				}				
		});
	}
});

comboPlaza.on('afterrender', function(combo) {
	combo.mode='remote';
});

items[2 + offset] = comboPlaza;

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
	,width:700
	,bodyStyle:'padding:10px;cellspacing:20px'
	,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
	,items:[
		{ xtype : 'errorList', id:'errorList' }
		,{
			autoHeight:true
			,layout:'table'
			,layoutConfig:{columns:1}
			,border:false
			,defaults : {xtype:'panel' ,cellCls : 'vtop',border:false}
			,items:[{
					layout:'form'
					,bodyStyle:'padding:5px;cellspacing:10px'
					,autoHeight:true
					,items:items
				}
			]
		}
	]
	,bbar:bottomBar
});

page.add(panelEdicion);
</fwk:page>