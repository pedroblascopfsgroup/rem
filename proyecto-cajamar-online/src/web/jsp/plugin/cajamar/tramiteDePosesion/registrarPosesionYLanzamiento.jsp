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

var offset=0;
<c:if test="${form.errorValidacion!=null}">
	offset=1;
</c:if>
var cb_ocupado = items[1 + offset];
var dt_fecha = items[2 + offset];
var cb_ffpp = items[3 + offset];
var cb_lanzamiento = items[4 + offset];
var dt_fechaSolLanz = items[5 + offset];

cb_ocupado.on('select', function(){
	//Borramos todos los combos dependientes ante cualquier cambio
	dt_fecha.setValue('');
	cb_ffpp.setValue('');
	cb_lanzamiento.setValue('');
	dt_fechaSolLanz.setValue('');
	
	if(cb_ocupado.getValue() == '01') {//si
		dt_fecha.setDisabled(true);
		cb_ffpp.setDisabled(true);
		cb_lanzamiento.setDisabled(true);
		dt_fechaSolLanz.setDisabled(true);
	}
	else if(cb_ocupado.getValue() == '02') {//no
		dt_fecha.setDisabled(false);
		cb_ffpp.setDisabled(false);
		cb_lanzamiento.setDisabled(false);
		dt_fechaSolLanz.setDisabled(false);
	}
});

cb_lanzamiento.on('select', function(){
	//Borramos todos los combos dependientes ante cualquier cambio
	dt_fechaSolLanz.setValue('');
	if(cb_lanzamiento.getValue() == '01') {//si
		dt_fechaSolLanz.setDisabled(false);
	}
	else if(cb_ocupado.getValue() == '02') {//no
		dt_fechaSolLanz.setDisabled(true);
	}
});

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