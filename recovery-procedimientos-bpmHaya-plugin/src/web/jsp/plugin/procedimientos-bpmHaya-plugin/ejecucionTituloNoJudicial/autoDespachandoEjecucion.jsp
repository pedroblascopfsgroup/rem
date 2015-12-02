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

<%@ include file="/WEB-INF/jsp/plugin/procedimientos-bpmHaya-plugin/elementos.jsp" %>

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
	<c:if test="${item.nombre=='comboPlaza'}">
		<c:if test="${item.value!=null}">
			codPlazaEnBD='${item.value}';
		</c:if>	
	</c:if>
	items.push(creaElemento('${item.nombre}','${item.order}','${item.type}', '<s:message text="${item.label}" javaScriptEscape="true" />', '<s:message text="${item.value}" javaScriptEscape="true" />', values));
</c:forEach>

var bottomBar = [];

//mostramos el bot�n guardar cuando la tarea no est� terminada y cuando no hay errores de validacion
<c:if test="${form.tareaExterna.tareaPadre.fechaFin==null && form.errorValidacion==null && !readOnly}">
	var btnGuardar = new Ext.Button({
		text : '<s:message code="app.guardar" text="**Guardar" />'
		,iconCls : 'icon_ok'
		,handler : function(){
			page.submit({
				eventName : 'ok'
				,formPanel : panelEdicion
				,success : function(){ page.fireEvent(app.event.DONE); }
				,error : function(response,config){ 
							anyadirFechaFaltante(response);
						}
			});
		}
	});
	
	//Si tiene m�s items que el propio label de descripci�n se crea el bot�n guardar
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
				,error : function(response,config){ 
							anyadirFechaFaltante(response);
						}
			});
		}
	});
	
	//Si tiene m�s items que el propio label de descripci�n se crea el bot�n guardar
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

var anyadirFechaFaltante = function(response){
							var win;
							var fechaNoExiste = new Ext.form.DateField({id:'fechaNoExiste', name:'fechaNoExiste',value : '', allowBlank : false,autoWidth:true});
							var mensajeError = response.fwk.fwkUserExceptions[0];
							var error = mensajeError.split('%');
							
							if(error[0] == 'ERROR_CAMPO_NO_ENCONTRADO'){
							
								var errorL = Ext.getCmp('errorList');
								errorL.setValue('');
								console.debug(Ext.getCmp('errorList'));
								var campoDescripcion = error[1];
								var tareaDescripcion = error[2];
								var idTarea = error[3];
								var tokenIdBPM = error[4];
								var idProcedimiento = error[5];
								var campo = error[6]
								var tarea = error[7]
								if(!win){
								
									var panelFecha = new Ext.form.FormPanel({
										id:'panelFecha'
										,name:'panelFecha'
										,bodyStyle : 'padding:10px'
										,autoWidth:true
										,autoHeight:true
										,items:[{border : false, layout : 'table',viewConfig : { columns : 1 }  
												,items :[ {html:'Para poder completar esta tarea debe introducir el valor del campo '+campoDescripcion+' correspondiente a la tarea previa '+tareaDescripcion, border:false,style:'margin:10px;font-size:8pt;font-family:Arial'}
														]
												},{border : false, layout : 'table',viewConfig : { columns : 1 }  
												,items :[new Ext.form.Label({text:campo,style:'margin:10px;font-size:8pt;font-family:Arial'})
														,fechaNoExiste]
												}
												
												]
									});
						            win = new Ext.Window({
						               // applyTo:'hello-win',
						                title:'Falta un campo de una tarea anterior',
						               	width:450,
										autoHeight:true,
						                closeAction:'hide',
						                plain: false,
										
						                items: [panelFecha],
						
						                buttons: [new Ext.Button({
						                	text:'<s:message code="app.guardar" text="**Guardar" />',
						                	handler:function(){
						                		console.debug(fechaNoExiste);
						                		Ext.Ajax.request({
													url: page.resolveUrl('completarcampotarea/insertarCampo')
													,params: {campo:campo,tarea:tarea,idTarea:idTarea,nuevaFecha:fechaNoExiste.getValue(),tokenIdBPM:tokenIdBPM, idProcedimiento:idProcedimiento}
													,method: 'POST'
													,success: function (result, request){
															Ext.Msg.alert('Ahora puede volver a guardar el formulario');
															win.hide();
															win.destroy();
															
														}
												});
						                	}
						                }),{
						                    text: '<s:message code="app.cancelar" text="**Cancelar" />',
						                    handler: function(){
						                        win.hide();
						                        win.destroy();
						                    }
						                }]
						            });
						       }
						        win.show(this);
							
							}
							
}

// *************************************************************** //
// ***  A�A�DIMOS LAS FUNCIONALIDADES EXTRA DE ESTE FORMULARIO  *** //
// *************************************************************** //
	
	// combo plaza de juzgado ------------------------------------------
	
	var codPlaza = "${valores['H020_InterposicionDemandaMasBienes']['nPlaza']}";
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
	if(codPlaza!=''){
		comboPlaza.setDisabled(true);
	}
	
	comboPlaza.on('select', function(){
		comboJuzgado.setDisabled(false);	
		recargarComboJuzgados();
	});
	
	items[2 + offset] = comboPlaza;

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
		,hiddenName: items[3 + offset].hiddenName
		,displayField: items[3 + offset].displayField
		,valueField: items[3 + offset].valueField
		,mode: items[3 + offset].mode
		,editable: items[3 + offset].editable
		,emptyText:''
		,triggerAction: 'all'
		,resizable: true
		,width: 300
		,fieldLabel : items[3 + offset].fieldLabel
	});
	
	var recargarComboJuzgados = function(){
		comboJuzgado.store.removeAll();
		comboJuzgado.clearValue();
		if (comboPlaza.getValue()!=null && comboPlaza.getValue()!=''){
			comboJuzgado.store.webflow({id:comboPlaza.getValue()});
		}
	}
	
	Ext.onReady(function() {
		comboJuzgado.store.baseParams.id = codPlaza;
		comboJuzgado.store.reload();
		if (juzgadoAsignado!='' && juzgadoAsignado!='0'){
			comboJuzgado.store.on('load', function(){  
				comboJuzgado.setValue(juzgadoAsignado);
				comboJuzgado.store.events['load'].clearListeners();
			});
		}

	});
	
	items[3 + offset] = comboJuzgado;
	
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