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

<%@ include file="/WEB-INF/jsp/plugin/cajamar/elementos.jsp" %>

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

<c:if test="${form.tareaExterna.tareaProcedimiento.descripcion=='Dictar Instrucciones'}">

    var btnExportarPDF=new Ext.Button({
        text:'<s:message code="menu.clientes.listado.filtro.exportar.pdf" text="**Exportar a PDF" />'
        ,iconCls:'icon_pdf'
        ,handler: function() {
         	var flow = 'plugin/agendaMultifuncion/operaciones/plugin.agendaMultifuncion.operaciones.exportarDetalleDictarInstruccionesHistorico';
		var params = {
			idTareaExterna: '${form.tareaExterna.id}'
		};
		app.openBrowserWindow(flow,params);
	}
    });
</c:if>
var bottomBar = [];

<c:if test="${form.errorValidacion==null}">

var cb_comboResultado = items[2 + muestraBotonGuardar];
var cb_comboCondena = items[3 + muestraBotonGuardar];
var n_importeCondena = items[4 + muestraBotonGuardar];
var cb_comboGarantias = items[5 + muestraBotonGuardar];
var n_importeGarantias = items[6 + muestraBotonGuardar];
var cb_comboOperacion = items[7 + muestraBotonGuardar];
var cb_comboCreditos = items[8 + muestraBotonGuardar];
var ta_otros = items[9 + muestraBotonGuardar];

cb_comboCondena.setDisabled(true);
n_importeCondena.setDisabled(true);
cb_comboGarantias.setDisabled(true);
n_importeGarantias.setDisabled(true);
cb_comboOperacion.setDisabled(true);
cb_comboCreditos.setDisabled(true);
ta_otros.setDisabled(true);

cb_comboResultado.on('select', function(){
	if(cb_comboResultado.getValue() == '01') {//favorable
		cb_comboCondena.setDisabled(true);
		n_importeCondena.setDisabled(true);
		cb_comboGarantias.setDisabled(true);
		n_importeGarantias.setDisabled(true);
		cb_comboOperacion.setDisabled(true);
		cb_comboCreditos.setDisabled(true);
		ta_otros.setDisabled(true);
		cb_comboCondena.setValue('');
		n_importeCondena.setValue('');
		cb_comboGarantias.setValue('');
		n_importeGarantias.setValue('');
		cb_comboOperacion.setValue('');
		cb_comboCreditos.setValue('');
		ta_otros.setValue('');
		cb_comboCondena.allowBlank = true;
		cb_comboGarantias.allowBlank = true;
		cb_comboOperacion.allowBlank = true;
		cb_comboCreditos.allowBlank = true;
		n_importeCondena.allowBlank = true;
		n_importeGarantias.allowBlank = true;
		ta_otros.allowBlank = true;
	}
	else if(cb_comboResultado.getValue() == '02') {//no_favorable
		cb_comboCondena.setDisabled(false);
		cb_comboGarantias.setDisabled(false);
		cb_comboOperacion.setDisabled(false);
		cb_comboCreditos.setDisabled(false);
		ta_otros.setDisabled(false);
		cb_comboCondena.allowBlank = false;
		cb_comboGarantias.allowBlank = false;
		cb_comboOperacion.allowBlank = false;
		cb_comboCreditos.allowBlank = false;
	}
});	

cb_comboCondena.on('select', function(){
	if(cb_comboCondena.getValue() == '01') {//si
		n_importeCondena.setDisabled(false);
		n_importeCondena.allowBlank = false;
	}
	else if(cb_comboCondena.getValue() == '02') {//no
		n_importeCondena.setDisabled(true);
		n_importeCondena.setValue('');
		n_importeCondena.allowBlank = true;
	}
});

cb_comboGarantias.on('select', function(){
	if(cb_comboGarantias.getValue() == '01') {//si
		n_importeGarantias.setDisabled(false);
		n_importeGarantias.allowBlank = false;
	}
	else if(cb_comboGarantias.getValue() == '02') {//no
		n_importeGarantias.setDisabled(true);
		n_importeGarantias.setValue('');
		n_importeGarantias.allowBlank = true;
	}
});

</c:if>



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
				,error : function(response,config){ 
							anyadirFechaFaltante(response);
						}
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
				,error : function(response,config){ 
							anyadirFechaFaltante(response);
						}
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
<c:if test="${form.tareaExterna.tareaProcedimiento.descripcion=='Dictar Instrucciones'}">
	bottomBar.push(btnExportarPDF);
</c:if>

var anyadirFechaFaltante = function(response){
							var win;
							var fechaNoExiste = new Ext.form.DateField({
								id:'fechaNoExiste'
								,name:'fechaNoExiste'
								,value : ''
								, allowBlank : false,autoWidth:true
							});
							var mensajeError = response.fwk.fwkUserExceptions[0];
							var error = mensajeError.split('%');
							
							if(error[0] == 'ERROR_CAMPO_NO_ENCONTRADO'){
							
								var errorL = Ext.getCmp('errorList');
								errorL.setValue('');
								
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
												,items :[new Ext.form.Label({text:campoDescripcion,style:'margin:10px;font-size:8pt;font-family:Arial'})
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


var panelEdicion=new Ext.form.FormPanel({
	height:520
	,width:700
	,autoScroll:true
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