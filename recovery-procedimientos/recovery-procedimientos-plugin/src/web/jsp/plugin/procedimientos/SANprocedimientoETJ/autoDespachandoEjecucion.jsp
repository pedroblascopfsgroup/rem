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

var codPlazaEnBD = '';
var juzgadoAsignado = '';
<c:forEach items="${form.items}" var="item">
	values = <app:dict value="${item.values}" />;
	<c:if test="${item.nombre=='numJuzgado'}">
		<c:if test="${item.value!=null}">
			juzgadoAsignado = '${item.value}';
		</c:if>
	</c:if>
	<c:if test="${item.nombre=='nPlaza' || item.nombre=='comboPlaza' || item.nombre=='plazaJuzgado'}">
		<c:if test="${item.value!=null}">
			codPlazaEnBD='${item.value}';
		</c:if>	
	</c:if>
	items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '<s:message text="${item.label}" javaScriptEscape="true" />', '<s:message text="${item.value}" javaScriptEscape="true" />', values));
</c:forEach>

var bottomBar = [];

//mostramos el botÛn guardar cuando la tarea no est· terminada y cuando no hay errores de validacion
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
	
	//Si tiene m·s items que el propio label de descripciÛn se crea el botÛn guardar
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
	
	//Si tiene m·s items que el propio label de descripciÛn se crea el botÛn guardar
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
// ***  A—AÅDIMOS LAS FUNCIONALIDADES EXTRA DE ESTE FORMULARIO  *** //
// *************************************************************** //
	
	// combo plaza de juzgado ------------------------------------------
	var codPlaza = "${valores['P16_InterposicionDemanda']['plazaJuzgado']}";
	if (codPlaza == ''){
		// la plaza se ha introducido en Confirmar admisiÛn demanda
		codPlaza = codPlazaEnBD;
	}

	var codPlazaParaHistorico = "${valores['P16_AutoDespachando_new1']['plazaJuzgado']}";
	if (codPlazaParaHistorico != ''){
		// cargar la plaza para historico, siempre de la propia tarea
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
		displayField: items[3 + offset].displayField, 	// descripcion
		valueField: items[3 + offset].valueField, 		// codigo
		fieldLabel: items[3 + offset].fieldLabel,		// Pla de juzgado
		hiddenName: 'values[3]',
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
	items[3 + offset] = comboPlaza;

	// combo juzgado ------------------------------------------
	
	var Juzgado = Ext.data.Record.create([
		 {name:'codigo'}
		,{name:'descripcion'}
	]);
	
	var juzgadosStore = page.getStore({
		flow: 'bpm/buscarJuzgados'
		,reader: new Ext.data.JsonReader({root : 'juzgados'} , Juzgado)
	});
	
	var comboJuzgado = new Ext.form.ComboBox({
		store: juzgadosStore
		,hiddenName: items[4 + offset].hiddenName
		,displayField: items[4 + offset].displayField
		,valueField: items[4 + offset].valueField
		,mode: items[4 + offset].mode
		,editable: items[4 + offset].editable
		,emptyText:''
		,width: 300
		,resizable: true		
		,triggerAction: 'all'
		,fieldLabel : items[4 + offset].fieldLabel
	});
	
	if (codPlaza=='') {
		comboJuzgado.setDisabled(true);
	}
	
	var recargarComboJuzgados = function(){
		comboJuzgado.store.removeAll();
		comboJuzgado.clearValue();
		if (comboPlaza.getValue()!=null && comboPlaza.getValue()!=''){
			comboJuzgado.store.webflow({id:comboPlaza.getValue()});
		}
	}
		
	comboPlaza.on('select', function(){
		comboJuzgado.setDisabled(false);	
		recargarComboJuzgados();
	});

	Ext.onReady(function() {
		if (codPlaza != ''){
			comboJuzgado.store.baseParams.id = codPlaza;
			comboJuzgado.store.reload();
			if (codPlazaEnBD == codPlaza) { // si no se ha cambiado de plaza en la tarea anterior
				if (juzgadoAsignado!=''){
					comboJuzgado.store.on('load', function(){  
						comboJuzgado.setValue(juzgadoAsignado);
						comboJuzgado.store.events['load'].clearListeners();
					});
				}
			}
		}
	});
	
	items[4 + offset] = comboJuzgado;
	
	// fin combo juzgado ---------------------------------------

var panelEdicion=new Ext.form.FormPanel({
	autoHeight:true
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

