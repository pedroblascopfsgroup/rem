<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>


<fwk:page>

	<%@ include file="../main/comunicaciones.jsp"%>
	var idExpediente='${expediente.id}';
	var idTareaPendiente = '${tareaPendiente.id}';
	var descEstado = '${expediente.estadoItinerario.descripcion}';
	
	var codigoEstado = '${expediente.estadoItinerario.codigo}';
	var estadoExpediente = '${expediente.estadoExpediente.codigo}';
	//var fechaCrear = '${persona.fechaCreacion}';
	
	var expedienteActivo = false;
	if (estadoExpediente == '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />'
	    || estadoExpediente == '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO" />'
	    || estadoExpediente == '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />') {	    
	    expedienteActivo = true;
	}
	    	
	
	

	function createGrid(myStore, columnModel, config){
		config = config || {};
		var cfg = {	
				title: config.title || '**'
				,store: myStore
				,style : config.style
				,cm:columnModel
				,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
			    ,clicksToEdit:1
			    ,resizable:true
			    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
			    //,width:200
			    ,height: config.height || 150
			    //,autoHeight:true
			    ,bbar : config.bbar
			    ,viewConfig : {  forceFit : true}
				
			};
		if (config.iconCls) cfg.iconCls=config.iconCls;
		if(config.autoWidth){
			cfg.autoWidth=config.autoWidth;
		}	
		else{
			cfg.width = config.width || (columnModel.getTotalWidth()+25);
		}
			
		var myGrid = new Ext.grid.GridPanel(cfg)
		return myGrid;
	};

	//aca no va un menu, sino un boton u otro segun estado y Perfil
	var menuProrroga={
		text : '<s:message code="expedientes.menu.prorroga" text="**Prorroga" />'
		,menu :[
			{
				text : '<s:message code="expedientes.menu.solicitarprorroga"
		text="**Solicitar Prórroga" />'
				,iconCls : 'icon_sol_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/solicitarProrroga'
						,title : '<s:message code="expedientes.menu.solicitarprorroga"
		text="**Solicitar Prórroga" />'
						,width:650 
						,params : {
								idEntidadInformacion: '${expediente.id}'
								,fechaCreacion: '<fwk:date
		value="${expediente.fechaVencimiento}" />'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,fechaVencimiento:'<fwk:date
		value="${expediente.fechaVencimiento}" />'
								,idTipoEntidadInformacion: '<fwk:const
		value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'
								,descripcion:'<s:message
		text="${expediente.descripcionExpediente}" javaScriptEscape="true" />'
								,idTareaAsociada:'${expediente.idTareaExpediente}' 
								,codigoTipoProrroga: '<fwk:const
		value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarTab('<s:message
		code="expedientes.consulta.prorrogaSolicitada"
		text="**expedientes.consulta.prorrogaSolicitada" />');
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			},{
				text : '<s:message code="expedientes.menu.aceptarprorroga"
		text="**Aceptar Prórroga" />'
				,iconCls : 'icon_aceptar_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/decisionProrroga'
						,title : '<s:message code="expedientes.menu.decisionProrroga"
		text="**Desicion sobre Prorroga" />'
						,width:650
						,params : {
								idEntidadInformacion: '${expediente.id}'
								,isConsulta:false
								,fechaVencimiento:'<fwk:date value="${expediente.fechaVencimiento}" />'
								,fechaCreacion: '${expediente.fechaCreacionFormateada}'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,destareaOri: '<s:message
		text="${prorrogaPendiente.descripcionTarea}" javaScriptEscape="true" />'
								,idTipoEntidadInformacion: '<fwk:const
		value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'
								,fechaPropuesta: '<fwk:date
		value="${prorrogaPendiente.prorroga.fechaPropuesta}" />'
								,motivo: '${prorrogaPendiente.prorroga.causaProrroga.descripcion}'
								,idTareaOriginal: '${prorrogaPendiente.id}'		
								,descripcion:'<s:message
		text="${expediente.descripcionExpediente}" javaScriptEscape="true" />'
								,codigoTipoProrroga: '<fwk:const
		value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarTab('<s:message
		code="expedientes.consulta.prorrogaDecidida"
		text="**expedientes.consulta.prorrogaDecidida" />');
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			},{
				text : '<s:message code="expedientes.menu.consultarprorroga"
		text="**Consultar Prórroga" />'
				,iconCls : 'icon_consultar_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/decisionProrroga'
						,title : '<s:message code="expedientes.menu.consultarprorroga"
		text="**Consultar Prórroga" />'
						,width:650
						,params : {
								idEntidadInformacion: '${expediente.id}'
								,isConsulta:true
								,fechaVencimiento:'<fwk:date value="${expediente.fechaVencimiento}" />'
								,fechaCreacion: '${expediente.fechaCreacionFormateada}'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,destareaOri: '<s:message
		text="${prorrogaPendiente.descripcionTarea}" javaScriptEscape="true" />'
								,idTipoEntidadInformacion: '<fwk:const
		value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'
								,fechaPropuesta: '<fwk:date
		value="${prorrogaPendiente.prorroga.fechaPropuesta}" />'
								,motivo: '${prorrogaPendiente.prorroga.causaProrroga.descripcion}'
								,idTareaOriginal: '${prorrogaPendiente.id}'		
								,descripcion:'<s:message
		text="${expediente.descripcionExpediente}" javaScriptEscape="true" />'												
								,codigoTipoProrroga: '<fwk:const
		value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			}
		]
	};
	
	var perfilGestor = '${expediente.idGestorActual}';
	var perfilSupervisor = '${expediente.idSupervisorActual}';

	var isGestor=false;
	var isSupervisor=false;
	if(permisosVisibilidadGestorSupervisor(perfilGestor)) {
		isGestor=true;
	}
	if(permisosVisibilidadGestorSupervisor(perfilSupervisor)) {
		isSupervisor=true;
	}
	
	var tipoAccion={};
	tipoAccion.ELEVAR_REVISION					=0;
	tipoAccion.ELEVAR_COMITE					=1;
	tipoAccion.DEVOLVER_REVISION				=2;
	tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE	=3;
	tipoAccion.SOLICITAR_CANCELACION			=4;
	tipoAccion.VER_SOLICITUD_CANCELACION	    =5;
	tipoAccion.CANCELACION_EXPEDIENTE			=6;
	
	
	
	var menuAcciones={};
	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			maskPanel=new Ext.LoadMask(panel.body, {msg:'<s:message
		code="fwk.ui.form.cargando" text="**Cargando.." />'});
		}
		maskPanel.show();
		panel.getTopToolbar().disable();
		
	};
	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
		panel.getTopToolbar().enable();
		
	};
	var recargarTab = function(msg){
		
		unmaskAll();
		if(msg){
			Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', msg, _cerrarTab);
		}else{
			_cerrarTab();
		}	
	}
	var _recargar = function(){
		app.contenido.activeTab.doAutoLoad();
	}
	var _cerrarTab = function(){
		app.contenido.remove(app.contenido.activeTab);
	}
	
	var cambioEstado=function(tipo){
		var titulo;
		var handler;
		var maxLength = 3500;
		texto='<s:message code="expedientes.motivos" text="**Motivos" />';
		switch(tipo){
			case tipoAccion.ELEVAR_REVISION:
				maskAll();
				elevarExpedienteRE(${expediente.id}, isSupervisor);
				return;
			case tipoAccion.ELEVAR_COMITE:
				maskAll();
				elevarExpedienteDC(${expediente.id}, isSupervisor);
				return;
			case tipoAccion.DEVOLVER_REVISION:
				titulo='<s:message code="expedientes.menu.devolverrevision"
		text="**Devolver a Revisión" />';
				handler=function(btn, rta){
			
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteRE(${expediente.id}, rta);
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
				
			case tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE:
				titulo='<s:message code="expedientes.menu.devolvercompexpediente"
		text="**Devolver a completar Expediente" />';
				handler=function(btn, rta){
			
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteCE(${expediente.id}, rta);
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
				
			case tipoAccion.SOLICITAR_CANCELACION:
				//titulo='<s:message code="" text="**Solicitar cancelacion" />';
				
				solicitarCancelacionExp(${expediente.id}, false);
				return;	
			/*Acción ver solcicitud*/	
			case tipoAccion.VER_SOLICITUD_CANCELACION:
				var idSCX =  '${solicitudCancelacion.solicitudCancelacion.id}';
				if (idSCX == null || idSCX == ''){
					idSCX = 0;
				}
				verSolicitudCancelacionExp(${expediente.id},idSCX);
				
				return;
			case tipoAccion.CANCELACION_EXPEDIENTE:
				solicitarCancelacionExp(${expediente.id},true);
				return;	
		}
		
	}
	
	var elevarExpedienteRE = function(params, isSupervisor){
		if (isSupervisor==null){
			isSupervisor = false;
		}
		page.webflow({
				flow: 'expediente/elevarExpedienteRE' 
				,eventName: 'elevarExpediente'
				,params:{id:params, isSupervisor:isSupervisor}
				,success: function(){
					recargarTab('<s:message code="dc.elevadoARevision"
		text="**Elevado a Revisión" />');
				}
				,error:function(){
						unmaskAll();
				}	 
		});
	};
	
	var elevarExpedienteDC = function(params, isSupervisor){
		page.webflow({
				flow: 'expediente/elevarExpedienteDC'
				,eventName: 'elevarExpediente'
				,params:{id:params, isSupervisor:isSupervisor}
				,success: function(){
					recargarTab('<s:message code="dc.elevadoADecision"
		text="**Elevado a DC" />');
				}
				,error:function(){
						unmaskAll();
				}	 
		});
	};
	
	var devolverExpedienteRE = function(params, rta){
		page.webflow({
				flow:  'expediente/devolverExpedienteRE'
				,eventName: 'devolverExpediente'
				,params:{id:params, respuesta:rta}
				,success: function(){
					recargarTab('<s:message code="dc.devueltoARevision"
		text="**Devuelto a Revisión" />');
				},error:function(){
						unmaskAll();
				}	 
		});
	};
	
	var devolverExpedienteCE = function(params, rta){
		page.webflow({
				flow:  'expediente/devolverExpedienteCE'
				,eventName: 'devolverExpediente'
				,params:{id:params, respuesta:rta}
				,success: function(){
					recargarTab('<s:message code="dc.devueltoACompletar"
		text="**Devuelto a CE" />');
				},error:function(){
						unmaskAll();
				}	 
		});
	};
	
	var solicitarCancelacionExp = function(params, esSupervisor){
		var w = app.openWindow({
				flow : 'expedientes/solicitudCancelacion'
				,eventName: 'formulario'
				,title : '<s:message
		code="expedientes.consulta.solicitarcancelacion"
		text="**Solicitar cancelacion" />'
				,params : {id:params, esSupervisor:esSupervisor}
			});
			
		w.on(app.event.DONE, function(){
								w.close();
								maskAll();
								recargarTab('<s:message
		code="expedientes.consulta.solicitudCancelacionRealizada"
		text="**expedientes.consulta.solicitudCancelacionRealizada" />');
							 }	 
		);
		w.on(app.event.CANCEL, function(){ w.close(); });
	};
	
	var verSolicitudCancelacionExp = function(idExpediente, idTarPend){
		var w = app.openWindow({
					flow : 'expedientes/decisionSolicitudCancelacion'
					,eventName: 'formulario'
					,title : '<s:message code="expedientes.menu.solicitarcancelacion"
		text="**Solicitar cancelacion" />'
					,params : {idExpediente:idExpediente, idSolicitud:idTarPend}
				});
			
		w.on(app.event.DONE, function(){
								w.close();
								maskAll();
								recargarTab('<s:message
		code="expedientes.consulta.decisionCancelacionOk"
		text="**Cancelacion Confirmada" />');
							 }	 
		);
		w.on(app.event.CANCEL, function(){ w.close(); });
	}

	var rechazarSolicitarCancelacionExp = function(params){
		page.webflow({
				flow:  'expediente/rechazarSolicitarCancelacionExp'
				,eventName: 'rechazarCancelacionExpediente'
				,params:{id:params}
				,success: function(){
					recargarTab('<s:message
		code="expedientes.consulta.decisionCancelacionDenegada"
		text="**expedientes.consulta.decisionCancelacionDenegada" />');
				},error:function(){
						unmaskAll();
				}	 
		});
	};
	
	var cancelacionExp = function(params){
		page.webflow({
				flow:  'expediente/cancelacionExp'
				,eventName: 'cancelacionExp'
				,params:{id:params}
				,success: function(){
					recargarTab('<s:message code="dc.expedienteCancelado"
		text="**Expediente Cancelado" />');
				},error:function(){
						unmaskAll();
				}	 
		});
	};
	
	
	var tabs =  <app:includeArray files="${tabsExpediente}" />;

	//Buscamos la solapa que queremos abrir
	var nombreTab = '${nombreTab}';
	var nrotab = 0;
	
	//tab activo por nombre
	if (nombreTab != null){
		for(var i=0;i< tabs.length;i++){
			if (tabs[i].initialConfig && nombreTab==tabs[i].initialConfig.nombreTab){
				nrotab = i;
				break;
			}
		}
	}

	var expedienteTabPanel=new Ext.TabPanel({
		items : tabs
		,defaults:{
			height:350
		}
		,layoutOnTabChange:true 
		//,frame:true
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false
		,activeItem:nrotab
		,enableTabScroll : true
		
		
	});
	expedienteTabPanel.setActiveTab(tabs[0]);

	var botonComunicacion = new Ext.Button({
					text:'<s:message
		code="menu.clientes.consultacliente.menu.comunicacion"
		text="**Comunicación" />'
					,iconCls : 'icon_comunicacion'
					,handler:function(){
						
			           	var w = app.openWindow({
							flow : 'tareas/generarTarea'
							,title : '<s:message code="" text="Comunicacion" />'
							,width:650
							,params : {
									idEntidad: '${expediente.id}'
									,codigoTipoEntidad: '2'
									,tienePerfilGestor: isGestor || false
									,tienePerfilSupervisor: isSupervisor || false
							}
	
						});
						w.on(app.event.DONE, function(){
							w.close();
						});
						w.on(app.event.CANCEL, function(){ w.close(); });	
			        }
	});
	var botonPDF = new Ext.Button({
					//name: 'genPDF'
					text: '<s:message
		code="menu.clientes.consultacliente.menu.generarPDF"
		text="**Generar PDF" />'
					,iconCls: 'icon_pdf'
					,handler: function() {
						var flow='expedientes/reporteExpediente';
						var tipo='generaPDF';
						var params='id='+ '${expediente.id}'+'&REPORT_NAME=reporteExpediente'+'${expediente.id}'+'.pdf';
						app.openPDF(flow,tipo,params);
			        }
	});
	
	
	var botonResponder = new Ext.Button(
			{
				text:'Responder'
				,iconCls : 'icon_responder_comunicacion'
				,disabled: '${tareaPendiente.id}' == ''
				,handler:function(){
					var w = app.openWindow({
						flow : 'tareas/generarNotificacion'
						,title : '<s:message code="" text="Notificacion" />'
						,width:650
						,params : {
								idEntidad:'${expediente.id}'
								,codigoTipoEntidad: '2'
								,descripcion:'<s:message
		text="${tareaPendiente.descripcionTarea}" javaScriptEscape="true" />'
								,fecha: '${expediente.fechaCreacionFormateada}'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,idTareaAsociada:'${tareaPendiente.id}'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarTab('<s:message
		code="expedientes.consulta.notificacionRespondida"
		text="**expedientes.consulta.notificacionRespondida" />');
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.OPEN_ENTITY, function(){ w.close(); });
				}
			}
	
	);


	var refrescarTab=function()
	{
		if (expedienteTabPanel.getActiveTab() != null && expedienteTabPanel.getActiveTab().initialConfig.nombreTab != null)
		{
			app.abreExpediente(${expediente.id}, '<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />', expedienteTabPanel.getActiveTab().initialConfig.nombreTab);
		}
		else
		{
			app.abreExpediente(${expediente.id}, '<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />');
		}
	};



	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: refrescarTab
	});

	var menuAcciones = 
			{
				text : '<s:message code="expedientes.menu.acciones"
		text="**Acciones" />'
				,menu : [
					{
			            text:'<s:message code="expedientes.menu.elevarrevision"
		text="**Elevar a Revisión" />'
			            ,iconCls : 'icon_elevar_revision'
						//,iconCls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.ELEVAR_REVISION)	
			            }
			            
		            },
		            {
			            text:'<s:message code="expedientes.menu.elevarcomite"
		text="**Elevar a Comité" />'
			            ,iconCls : 'icon_elevar_comite'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.ELEVAR_COMITE)
			            }
			        },
		            {
			            text:'<s:message code="expedientes.menu.devolverrevision"
		text="**Devolver a Revisión" />'
			            ,iconCls : 'icon_revisar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.DEVOLVER_REVISION)
			            }
		            },
		            {
			            text:'<s:message
		code="expedientes.menu.devolvercompexpediente"
		text="**Devolver a Comp." />'
			            ,iconCls : 'icon_completar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE)
			            }
		            },
		            {
			            text:'<s:message
		code="expedientes.menu.solicitarcancelacion"
		text="**Solicitar Cancelación" />'
			            ,iconCls : 'icon_cancelar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.SOLICITAR_CANCELACION)
			            }
	        		},
		            /********/
		            //Botón ver solicitud: Se muestra si es supervisor y hay solicitud pendiente.
		            {
			            text:'<s:message
		code="expedientes.menu.verSolicitudCancelacion"
		text="**Ver Solicitud Cancelación" />'
			            ,iconCls : 'icon_rechazar_cancelar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	//TODO cambiar el codigo de la accion
			            	cambioEstado(tipoAccion.VER_SOLICITUD_CANCELACION)
			            }
	        		},
		            
		            //Botón cancelar: se muestra si es supervisor y NO hay solicitud pendiente.
		            {
			            text:'<s:message
		code="expedientes.menu.cancelacionexpediente"
		text="**Cancelación Expediente" />'
			            ,iconCls : 'icon_cancelar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.CANCELACION_EXPEDIENTE)
			            }
	        		}
	        		]
				};
			
	
	
	var panel = new Ext.Panel({
		autoHeight : true
		,items : [expedienteTabPanel]
		,tbar: new Ext.Toolbar()
		,id:'exp-${expediente.id}'	
	});	
	
	
	page.add(panel);
	
	
	var filtrarMenuAcciones = function(menuAccionesVar){
		var existeSolicitud = '${solicitudCancelacion.id}';
		var nuevoMenuAcciones = new Array();
		if (existeSolicitud == null || existeSolicitud == ''){
			if (permisosVisibilidadGestorSupervisor(perfilGestor) == true || permisosVisibilidadGestorSupervisor(perfilSupervisor) == true){
				if (codigoEstado == 'CE'){
					//Completar expediente
					if (estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />'){
						nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[0];	
					}
				}else if (codigoEstado == 'RE'){
					//Revision Expediente
					if (estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />'){
						nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[1];
						nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[3];	
					}
				}else{
					//Desicion comite
					if (estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />'){
						nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[2];
					}
				}
			}
		}
		
		if(permisosVisibilidadGestorSupervisor(perfilGestor) == true 
		   && (estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />'
		   		|| estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO" />'
				|| estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />')){
			//Se agrega la solicitud de cancelacion
			if (existeSolicitud == null || existeSolicitud == ''){
				nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[4];
			}
		}
		if(permisosVisibilidadGestorSupervisor(perfilSupervisor) == true
		   && (estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />'
		   		|| estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO" />'
		   		|| estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO" />'
				|| estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />')){
			//Se agrega la cancelacion y rechazo de solicitud de cancelacion
			var existeSolicitud = '${solicitudCancelacion.id}';
			if (existeSolicitud != null && existeSolicitud != ''){
				nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[5];
			}else{
				nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[6];
			}
		}
		return nuevoMenuAcciones;
	}
	
	menuAcciones.menu = filtrarMenuAcciones(menuAcciones);
	
	if (menuAcciones.menu.length>0){    
		panel.getTopToolbar().add(menuAcciones);
		panel.getTopToolbar().add('-');
	}

	var estadoActivo = '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />';
	var estadoCongelado = '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />';
	var estadoBloqueado = '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO" />';
    var tieneTareaNotificacion = ${expediente.fechaVencimiento != null};

	var nuevoMenuProrroga = new Array();
	var existeSolicitud = '${solicitudCancelacion.id}';
	var existeSolicitudProrroga = '${prorrogaPendiente.id}'
	
	//Puede solicitar prorroga en caso de que tenga visibilidad y esté en activo (CE,RE) o congelado (DC)
	if(tieneTareaNotificacion == true && permisosVisibilidadGestorSupervisor(perfilGestor) == true && (estadoExpediente == estadoActivo || estadoExpediente == estadoCongelado)){
			<sec:authorize ifAllGranted="SOLICITAR_PRORROGA">
				//Agrego el solicitar prorroga
				if (existeSolicitudProrroga == null || existeSolicitudProrroga == ''){
					if (existeSolicitud == null || existeSolicitud == ''){
						nuevoMenuProrroga[nuevoMenuProrroga.length] = menuProrroga.menu[0];
					}
				}else{
					nuevoMenuProrroga[nuevoMenuProrroga.length] = menuProrroga.menu[2];
				}
			</sec:authorize>
	}
	if(tieneTareaNotificacion == true && permisosVisibilidadGestorSupervisor(perfilSupervisor) == true && 
	    (estadoExpediente == estadoActivo
	    || estadoExpediente == estadoCongelado
	    || estadoExpediente == estadoBloqueado)
	    ){
			
			<sec:authorize ifAllGranted="SOLICITAR_PRORROGA">
				//Agrego el solicitar prorroga
				if (existeSolicitudProrroga != null && existeSolicitudProrroga != ''){
					if (existeSolicitud == null || existeSolicitud == ''){
						nuevoMenuProrroga[nuevoMenuProrroga.length] = menuProrroga.menu[1];
						//nuevoMenuProrroga[nuevoMenuProrroga.length] = menuProrroga.menu[2];
					}
				}
			</sec:authorize>
	}

	menuProrroga.menu = nuevoMenuProrroga;
	

	if (tieneTareaNotificacion == true && menuProrroga.menu.length>0 && (estadoExpediente == estadoActivo || estadoExpediente == estadoCongelado)){
		panel.getTopToolbar().add(menuProrroga);
		panel.getTopToolbar().add('-');
	}

	<sec:authorize ifAllGranted="EXCLUIR_CLIENTES">
		<c:if
			test="${expediente.estadoItinerario.codigo=='CE' || (expediente.estadoItinerario.codigo=='RE' && exclusion!=null)}">
		var menuDatosClientes = {
		text:'Datos Clientes'
		,menu:[
		<c:if
				test="${expediente.estadoItinerario.codigo=='CE' && expediente.estaEstadoActivo}">
			{
				text:'<s:message code="expedientes.menu.excluirclientes"
					text="**Excluir Clientes del Expediente" />'
				,iconCls:'icon_excluir_clientes'
				,handler:function(){
					var w = app.openWindow({
						flow : 'fase2/expedientes/excluirClientesExpediente'
						,params : {id:'${expediente.id}'}
						,width:650
						,title : '<s:message code="expedientes.menu.excluirclientes"
					text="**Excluir Clientes del Expediente" />'
						
					});
					w.on(app.event.DONE, function(){
						w.close();
					});
					w.on(app.event.CANCEL, function(){
						w.close();
					});
				}
			}
		</c:if>
			<c:if
				test="${expediente.estadoItinerario.codigo=='RE' && exclusion!=null}">
			{
				text:'<s:message code="expedientes.menu.comprobarexclusionclientes"
					text="**Comprobar Exclusión Datos Clientes" />'
				,iconCls:'icon_excluir_datos_clientes'
				,handler:function(){
					var w = app.openWindow({
						flow : 'fase2/expedientes/decisionExcluirClientesExpediente'
						,params : {id:'${expediente.id}'}
						,width:650
						,title : '<s:message
					code="expedientes.menu.consultarexclusionclientes"
					text="**Clientes del Expediente" />'
						
					});
					w.on(app.event.DONE, function(){
						w.close();
					});
					w.on(app.event.CANCEL, function(){
						w.close();
					});
				}
			}
		</c:if>
		]
	};

	//Si tiene algún elemento mostramos el menú
	if (menuDatosClientes.menu[0] != undefined)
	{
		panel.getTopToolbar().add(menuDatosClientes);
		panel.getTopToolbar().add('-');
	}
	</c:if>
	</sec:authorize>


	if(permisosVisibilidadGestorSupervisor(perfilGestor) == true && estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />'){
			<sec:authorize ifAllGranted="COMUNICACION">
				//Agrego el boton comunicacion
				panel.getTopToolbar().add(botonComunicacion);
				panel.getTopToolbar().add('-');
			</sec:authorize>
	<sec:authorize ifAllGranted="RESPONDER">	
				//Responder comunicacion
				panel.getTopToolbar().add(botonResponder);
				panel.getTopToolbar().add('-');
			</sec:authorize>
	}
	if(permisosVisibilidadGestorSupervisor(perfilSupervisor) == true && 
	    (estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />'
	    || estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO" />'
	    || estadoExpediente == '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />')
	    ){
			<sec:authorize ifAllGranted="COMUNICACION">
				//Agrego el boton comunicacion
				panel.getTopToolbar().add(botonComunicacion);
				panel.getTopToolbar().add('-');
			</sec:authorize>
	<sec:authorize ifAllGranted="RESPONDER">	
				//Responder comunicacion
				panel.getTopToolbar().add(botonResponder);
				panel.getTopToolbar().add('-');
			</sec:authorize>
		}
	
	panel.getTopToolbar().add(botonPDF);
	
	<%-- DELEGAR A OTRO COMITE --%>

	if (expedienteActivo)
	{
	<sec:authorize ifAllGranted="ROLE_COMITE">
		<c:if
			test="${puedeMostrarSolapaDecisionComite || puedeMostrarSolapaMarcadoPoliticas}">
		var elevarAComiteSuperior = function(idComite){
			page.webflow({
				 flow:  'comites/elevarAComiteSuperior'
				,params:{idComite:idComite, idExpediente:${expediente.id}}
				,success: function(){
					recargarTab('<s:message code="expediente.elevadoAOtroComite"
				text="**expediente.elevadoAOtroComite" />');
				}
				,error:function(){
						unmaskAll();
				}
			})		
		}	 
	
		var abrirVentanaDelegarExpediente = function(){
			var w = app.openWindow({
				flow : 'comites/listadoComitesADelegar'
				,params : {idExpediente:'${expediente.id}'}
				,width:900
				,title : '<s:message code="comite.comitesDelegacion"
				text="**Delegar Expediente" />'
				
			});
			w.on(app.event.DONE, function(){
				w.close();
				recargarTab('<s:message code="expediente.delegadoAOtroComite"
				text="**expediente.delegadoAOtroComite" />');
			});
			w.on(app.event.CANCEL, function(){
				w.close();
			});
		}

		var elevarAComiteSuperiorButton = new Ext.Button({
			 text:'<s:message code="comite.elevar" text="**Elevar a otro comité" />'
			,iconCls:'icon_elevar_expediente_otro_comite'
			,handler:function(){
				<c:if test="${comiteElevar!=null}">
					Ext.Msg.confirm('<s:message code="expediente.elevarAComite"
					text="**Elevar a otro Comité" />', 
	                    	    '<s:message
					code="expediente.confirmacionElevar"
					arguments="${comiteElevar.nombre}" />',
	                    	       this.evaluateAndSend);
				</c:if>
			<c:if test="${comiteElevar==null}">
					Ext.Msg.alert('<s:message code="expediente.tituloNoSePuedeElevar"
					text="**No se puede elevar" />','<s:message
					code="expediente.noSePuedeElevar"
					text="**El expediente ya sé encuentra en lo más alto de la jerarquía" />');
				</c:if>
			}
			,evaluateAndSend:function(seguir){
				if (seguir==true || seguir=='yes'){
					elevarAComiteSuperior(${comiteElevar.id});
				}		
			}
		});



		var delegarAOtroComiteButton = new Ext.Button({
			 text:'<s:message code="comite.delegar"
				text="**Delegar a otro comité" />'
			,iconCls:'icon_delegar_expediente_otro_comite'
			,handler:function(){
				<c:if
				test="${comitesDelegar!=null && fn:length(comitesDelegar) > 0}">
					abrirVentanaDelegarExpediente();
				</c:if>
			<c:if
				test="${comitesDelegar==null || fn:length(comitesDelegar) == 0}">
					Ext.Msg.alert('<s:message code="expediente.tituloNoSePuedeDelegar"
					text="**No se puede delegar" />','<s:message
					code="expediente.noSePuedeDelegar"
					text="**No se encuentra ningún comité por debajo de la jerarquía actual" />');
				</c:if>
			}
		});

		panel.getTopToolbar().add('-');
		panel.getTopToolbar().add(elevarAComiteSuperiorButton);
		panel.getTopToolbar().add('-');
		panel.getTopToolbar().add(delegarAOtroComiteButton);
	</c:if>
	</sec:authorize>
	}

	<%-- FIN DELEGAR A OTRO COMITE --%>
	
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	
	var iconClass = null;
	
	<c:if
		test="${expediente.arquetipo.itinerario.dDtipoItinerario.itinerarioRecuperacion == true}">
		iconClass = 'icon_expedientes_R';
	</c:if>

	<c:if
		test="${expediente.arquetipo.itinerario.dDtipoItinerario.itinerarioSeguimiento == true}">
		iconClass = 'icon_expedientes_S';	
	</c:if>
	
	
	

	//Se comprueba si el expediente está cancelado
	var estadoCancelado = '<fwk:const
		value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO" />';
	var estadoExpediente = '${expediente.estadoExpediente.codigo}';

	if (estadoCancelado == estadoExpediente)
	{
		iconClass = 'icon_expedientes_X';
	}


	if (iconClass != null)
	{
		var cmp = Ext.getCmp('exp${expediente.id}');
		Ext.fly(cmp.ownerCt.getTabEl(cmp)).child('.x-tab-strip-text').replaceClass(cmp.iconCls, iconClass);
		cmp.setIconClass(iconClass);
	}

	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(botonRefrezcar);

</fwk:page>