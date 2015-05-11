<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>


<fwk:page>

	
	var idExpediente='${expediente.id}';
	var idTareaPendiente = '${tareaPendiente.id}';
	var descTareaPendiente = '${tareaPendiente.descripcionTarea}';
	var descEstado = '${expediente.estadoItinerario.descripcion}';
	var codigoEstado = '${expediente.estadoItinerario.codigo}';
	var estadoExpediente = '${expediente.estadoExpediente}';
	//var fechaCrear = '${persona.fechaCreacion}';
	
	function createGrid(myStore, columnModel, config){
		config = config || {};
		var cfg = {	
				title: config.title || '**'
				,store: myStore
				,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
				,style : config.style
				,cm:columnModel
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
				text : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prórroga" />'
				,iconCls : 'icon_sol_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/solicitarProrroga'
						,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prórroga" />'
						,width:550 
						,params : {
								idEntidadInformacion: '${expediente.id}'
								,fechaCreacion: '${expediente.fechaCreacionFormateada}'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'
								,descripcion:'<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />'
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarTab();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			},{
				text : '<s:message code="expedientes.menu.aceptarprorroga" text="**Aceptar Prórroga" />'
				,iconCls : 'icon_aceptar_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/decisionProrroga'
						,title : '<s:message code="" text="**Solicitar Prorroga" />'
						,width:470 
						,params : {
								idEntidadInformacion: '${expediente.id}'
								,isConsulta:false
								,fechaVencimiento:'<fwk:date value="${expediente.fechaVencimiento}" />'
								,fechaCreacion: '${expediente.fechaCreacionFormateada}'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,destareaOri: '<s:message text="${prorrogaPendiente.descripcionTarea}" javaScriptEscape="true" />'
								,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'
								,fechaPropuesta: '${prorrogaPendiente.fechaPropuestaFormateada}'
								,motivo: '${prorrogaPendiente.prorroga.causaProrroga.descripcion}'
								,idTareaOriginal: '${prorrogaPendiente.id}'		
								,descripcion:'${expediente.contratoPase.primerTitular.apellidoNombre}'
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'													
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarTab();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			},{
				text : '<s:message code="expedientes.menu.consultarprorroga" text="**Consultar Prórroga" />'
				//,iconCls : 'icon_aceptar_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/decisionProrroga'
						,title : '<s:message code="expedientes.menu.consultarprorroga" text="**Consultar Prórroga" />'
						,width:470 
						,params : {
								idEntidadInformacion: '${expediente.id}'
								,isConsulta:true
								,fechaVencimiento:'<fwk:date value="${expediente.fechaVencimiento}" />'
								,fechaCreacion: '${expediente.fechaCreacionFormateada}'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,destareaOri: '<s:message text="${prorrogaPendiente.descripcionTarea}" javaScriptEscape="true" />'
								,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'
								,fechaPropuesta: '${prorrogaPendiente.fechaPropuestaFormateada}'
								,motivo: '${prorrogaPendiente.prorroga.causaProrroga.descripcion}'
								,idTareaOriginal: '${prorrogaPendiente.id}'		
								,descripcion:'<s:message text="${expediente.descripcionExpediente}" javaScriptEscape="true" />'													
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'													
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
	
	var tipoAccion={};
	tipoAccion.ELEVAR_REVISION					=0;
	tipoAccion.ELEVAR_COMITE					=1;
	tipoAccion.DEVOLVER_REVISION				=2;
	tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE	=3;
	tipoAccion.SOLICITAR_CANCELACION			=4;
	tipoAccion.RECHAZAR_SOLICITAR_CANCELACION	=5;
	tipoAccion.CANCELACION_EXPEDIENTE			=6;
	
	var menuAcciones={};
	
	var recargarTab = function(msg){
		if(msg){
			Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', msg, _recargar);
		}else{
			_recargar();
		}	
	}
	
	var _recargar = function(){
		app.contenido.activeTab.doAutoLoad()
	}
	
	var cambioEstado=function(tipo){
		
		var titulo;
		var handler;
		switch(tipo){
			case tipoAccion.ELEVAR_REVISION:
				/*titulo='<s:message code="" text="**Elevar a Revisión" />';
				handler=function(btn){
					if (btn== 'ok'){*/
				elevarExpedienteRE(${expediente.id});
				//recargarTab();
					/*}
				};*/
				return;
			case tipoAccion.ELEVAR_COMITE:
				/*titulo='<s:message code="" text="**Elevar a Comité" />';
				handler=function(btn){
					if (btn== 'ok'){*/
				elevarExpedienteDC(${expediente.id});
				//recargarTab();
				/*	}
				};*/
				return;
			case tipoAccion.DEVOLVER_REVISION:
				titulo='<s:message code="" text="**Devolver a Revisión" />';
				handler=function(btn){
					if (btn== 'ok'){
						devolverExpedienteRE(${expediente.id});
				//		recargarTab();
					}
				};
				break;
			case tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE:
				titulo='<s:message code="" text="**Devolver a completar Expediente" />';
				handler=function(btn){
					if (btn== 'ok'){
						devolverExpedienteCE(${expediente.id});
					//	recargarTab();
					}
				};
				break;
			case tipoAccion.SOLICITAR_CANCELACION:
				titulo='<s:message code="" text="**Solicitar cancelacion" />';
				handler=function(btn){
					if (btn== 'ok'){
						solicitarCancelacionExp(${expediente.id});
					}
				};
				break;	
			case tipoAccion.RECHAZAR_SOLICITAR_CANCELACION:
				titulo='<s:message code="" text="**Solicitar cancelacion" />';
				handler=function(btn){
					if (btn== 'ok'){
						rechazarSolicitarCancelacionExp(${expediente.id});
						//recargarTab();
					}
				};
				break;
			case tipoAccion.CANCELACION_EXPEDIENTE:
				titulo='<s:message code="" text="**Solicitar cancelacion" />';
				handler=function(btn){
					if (btn== 'ok'){
						cancelacionExp(${expediente.id});
						//recargarTab();
					}
				};
				break;
		}
		texto='<s:message code="" text="**Motivos" />';
		bla= Ext.Msg.prompt(titulo, texto, handler,
						{ tipo : tipo, id:id}
							,150);
	}
	
	var elevarExpedienteRE = function(params){
		page.webflow({
				flow: 'expediente/elevarExpedienteRE' 
				,eventName: 'elevarExpediente'
				,params:{id:params}
				,success: function(){
					recargarTab('<s:message code="dc.elevadoARevision" text="**Elevado a Revisión" />');
				}	 
		});
	};
	
	var elevarExpedienteDC = function(params){
		page.webflow({
				flow: 'expediente/elevarExpedienteDC'
				,eventName: 'elevarExpediente'
				,params:{id:params}
				,success: function(){
					recargarTab('<s:message code="dc.elevadoADecision" text="**Elevado a DC" />');
				}	 
		});
	};
	
	var devolverExpedienteRE = function(params){
		page.webflow({
				flow:  'expediente/devolverExpedienteRE'
				,eventName: 'devolverExpediente'
				,params:{id:params}
				,success: function(){
					recargarTab('<s:message code="dc.devueltoARevision" text="**Devuelto a Revisión" />');
				}	 
		});
	};
	
	var devolverExpedienteCE = function(params){
		page.webflow({
				flow:  'expediente/devolverExpedienteCE'
				,eventName: 'devolverExpediente'
				,params:{id:params}
				,success: function(){
					recargarTab('<s:message code="dc.devueltoACompletar" text="**Devuelto a CE" />');
				}	 
		});
	};
	
	var solicitarCancelacionExp = function(params){
		page.webflow({
				flow:  'expediente/solicitarCancelacionExp'
				,eventName: 'solicitarCancelacion'
				,params:{id:params}
				,success: function(){
					recargarTab();
				}	 
		});
	};
	
	var rechazarSolicitarCancelacionExp = function(params){
		page.webflow({
				flow:  'expediente/rechazarSolicitarCancelacionExp'
				,eventName: 'rechazarCancelacionExpediente'
				,params:{id:params}
				,success: function(){
					recargarTab();
				}	 
		});
	};
	
	var cancelacionExp = function(params){
		page.webflow({
				flow:  'expediente/cancelacionExp'
				,eventName: 'cancelacionExp'
				,params:{id:params}
				,success: function(){
					recargarTab('<s:message code="dc.expedienteCancelado" text="**Expediente Cancelado" />');
				}	 
		});
	};
	
	
	<%@ include file="../../expedientes/tabCabecera.jsp" %>
	<%@ include file="../../expedientes/tabTitulos.jsp" %>
	<%@ include file="../../expedientes/tabGestionyAnalisis.jsp" %>
	<sec:authorize ifAllGranted="ROLE_COMITE">
		<c:if test="${puedeMostrar}">
			<%@ include file="../../expedientes/tabDecisionComite.jsp" %>
		</c:if>
	</sec:authorize>
	<%@ include file="../../tareas/tabTareas.jsp" %>
	<%@ include file="../../expedientes/tabAdjuntos.jsp" %>
	
	var tabCabecera=createCabeceraTab();
	var tabTitulos=createTitulosTab();
	var tabGestionyAnalisis=createGesyAnTab();
	<sec:authorize ifAllGranted="ROLE_COMITE">
		<c:if test="${puedeMostrar}">
			var tabDecisionComite=createDCTab();
		</c:if>
	</sec:authorize>
	var tareasTab=createTareasTab();
	var adjuntos = createAdjuntosTab();
	
	var expedienteTabPanel=new Ext.TabPanel({
		items:[
			tabCabecera
			,tabTitulos
			,tabGestionyAnalisis
			<sec:authorize ifAllGranted="ROLE_COMITE">
				<c:if test="${puedeMostrar}">
					,tabDecisionComite
				</c:if>	
			</sec:authorize>
			//FASE2
			//,tareasTab
			,adjuntos
		]
		,defaults:{
			height:350
			
		}
		,layoutOnTabChange:true 
		//,frame:true
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false
		//Esto iria dinamicamente?????
		
		
	});
	expedienteTabPanel.setActiveTab(tabCabecera);
	
	
	var perfilGestor = '${expediente.idGestorActual}';
	var perfilSupervisor = '${expediente.idSupervisorActual}';

	var isGestor;
	var isSupervisor;
	if(permisosVisibilidadGestorSupervisor(perfilGestor)) {
		isGestor=true;
	}
	if(permisosVisibilidadGestorSupervisor(perfilSupervisor)) {
		isSupervisor=true;
	}

	var botonComunicacion = new Ext.Button({
					text:'<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicación" />'
					,iconCls : 'icon_comunicacion'
					,handler:function(){
						
			           	var w = app.openWindow({
							flow : 'fase2/tareas/generarTarea'
							,title : '<s:message code="" text="Comunicacion" />'
							,width:400 
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
					text: '<s:message code="menu.clientes.consultacliente.menu.generarPDF" text="**Generar PDF" />'
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
						flow : 'tareas/generarNotificacion_fase2'
						,title : '<s:message code="" text="Notificacion" />'
						,width:400 
						,params : {
								idEntidad:'${expediente.id}'
								,codigoTipoEntidad: '2'
								,descripcion:'${tareaPendiente.descripcionTarea }'
								,fecha: '${expediente.fechaCreacionFormateada}'
								,situacion: '${expediente.estadoItinerario.descripcion}'
								,idTareaAsociada:'${tareaPendiente.id}'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						recargarTab();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
					w.on(app.event.OPEN_ENTITY, function(){ w.close(); });
				}
			}
	
	);
	
	var menuAcciones = 
			{
				text : '<s:message code="expedientes.menu.acciones" text="**Acciones" />'
				,menu : [
					{
			            text:'<s:message code="expedientes.menu.elevarrevision" text="**Elevar a Revisión" />'
			            ,iconCls : 'icon_elevar_revision'
						//,iconCls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.ELEVAR_REVISION)	
			            }
			            
		            },
		            {
			            text:'<s:message code="expedientes.menu.elevarcomite" text="**Elevar a Comité" />'
			            ,iconCls : 'icon_elevar_comite'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.ELEVAR_COMITE)
			            }
			        },
		            {
			            text:'<s:message code="expedientes.menu.devolverrevision" text="**Devolver a Revisión" />'
			            ,iconCls : 'icon_revisar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.DEVOLVER_REVISION)
			            }
		            },
		            {
			            text:'<s:message code="expedientes.menu.devolvercompexpediente" text="**Devolver a Comp." />'
			            ,iconCls : 'icon_completar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE)
			            }
		            },
		            {
			            text:'<s:message code="expedientes.menu.solicitarcancelacion" text="**Solicitar Cancelación" />'
			            ,iconCls : 'icon_cancelar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.SOLICITAR_CANCELACION)
			            }
	        		},
		            {
			            text:'<s:message code="expedientes.menu.rechazarsolicitarcancelacion" text="**Rechazar Solicitud Cancelación" />'
			            ,iconCls : 'icon_rechazar_cancelar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.RECHAZAR_SOLICITAR_CANCELACION)
			            }
	        		},
		            {
			            text:'<s:message code="expedientes.menu.cancelacionexpediente" text="**Cancelación Expediente" />'
			            ,iconCls : 'icon_cancelar_expediente'
						//,cls: 'x-btn-text-icon'
			            ,handler:function(){
			            	cambioEstado(tipoAccion.CANCELACION_EXPEDIENTE)
			            }
	        		}]
				};
			
	
	
	var panel = new Ext.Panel({
		bodyStyle : 'padding : 5px'
		,autoHeight : true
		,items : [expedienteTabPanel]
		,tbar: new Ext.Toolbar()
		,id:'exp-${expediente.id}'	
	});	
	
	
	page.add(panel);
	var nuevoMenuProrroga = new Array();
	var existeSolicitud = '${solicitudCancelacion.id}';
	var existeSolicitudProrroga = '${prorrogaPendiente.id}'
	
	
	if(permisosVisibilidadGestorSupervisor(perfilGestor) == true && estadoExpediente == '1'){
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

	if(permisosVisibilidadGestorSupervisor(perfilSupervisor) == true && estadoExpediente == '1'){
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
			<sec:authorize ifAllGranted="SOLICITAR_PRORROGA">
				//Agrego el solicitar prorroga
				if (existeSolicitudProrroga != null && existeSolicitudProrroga != ''){
					if (existeSolicitud == null || existeSolicitud == ''){
						nuevoMenuProrroga[nuevoMenuProrroga.length] = menuProrroga.menu[1];
						nuevoMenuProrroga[nuevoMenuProrroga.length] = menuProrroga.menu[2];
					}
				}
			</sec:authorize>
	}

	menuProrroga.menu = nuevoMenuProrroga;
	
	if (menuProrroga.menu.length>0 && estadoExpediente == '1'){
		panel.getTopToolbar().add(menuProrroga);
		panel.getTopToolbar().add('-');
	}
	
	var filtrarMenuAcciones = function(menuAccionesVar){
		var existeSolicitud = '${solicitudCancelacion.id}';
		var nuevoMenuAcciones = new Array();
		if (existeSolicitud == null || existeSolicitud == ''){
			if (permisosVisibilidadGestorSupervisor(perfilGestor) == true || permisosVisibilidadGestorSupervisor(perfilSupervisor) == true){
				if (codigoEstado == 'CE'){
					//Completar expediente
					nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[0];	
				}else if (codigoEstado == 'RE'){
					//Revision Expediente
					nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[1];
					nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[3];	
				}else{
					//Desicion comite
					nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[2];
				}
			}
		}
		
		if(permisosVisibilidadGestorSupervisor(perfilGestor) == true){
			//Se agrega la solicitud de cancelacion
			if (existeSolicitud == null || existeSolicitud == ''){
				nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[4];
			}
		}
		if(permisosVisibilidadGestorSupervisor(perfilSupervisor) == true){
			//Se agrega la cancelacion y rechazo de solicitud de cancelacion
			var existeSolicitud = '${solicitudCancelacion.id}';
			if (existeSolicitud != null && existeSolicitud != ''){
				nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[5];
			}
			nuevoMenuAcciones[nuevoMenuAcciones.length] = menuAccionesVar.menu[6];
		}
		return nuevoMenuAcciones;
	}
	
	menuAcciones.menu = filtrarMenuAcciones(menuAcciones);
	
	if (menuAcciones.menu.length>0 && (estadoExpediente == '1' || estadoExpediente == '2' || estadoExpediente == '4')){    
		panel.getTopToolbar().add(menuAcciones);
		panel.getTopToolbar().add('-');
	}
	
	panel.getTopToolbar().add(botonPDF);
	
	var menuDatosClientes ={
		text:'Datos Clientes'
		,menu:[
		{
			text:'<s:message code="expedientes.menu.excluirclientes" text="**Excluir Clientes del Expediente" />'
			,handler:function(){
				var w = app.openWindow({
					flow : 'fase2/expedientes/excluirClientesExpediente'
					,width:420
					,title : '<s:message code="" text="**Excluir Clientes del Expediente" />'
					
				});
				w.on(app.event.DONE, function(){
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					w.close();
				});
			}
		},{
			text:'<s:message code="expedientes.menu.excluirclientes" text="**Comprobar Exclusión Datos Clientes" />'
			,handler:function(){
				var w = app.openWindow({
					flow : 'fase2/expedientes/decisionExcluirClientesExpediente'
					,width:420
					,title : '<s:message code="" text="**Clientes del Expediente" />'
					
				});
				w.on(app.event.DONE, function(){
					w.close();
				});
				w.on(app.event.CANCEL, function(){
					w.close();
				});
			}
		}
		]
	};
	panel.getTopToolbar().add(menuDatosClientes);
		
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
</fwk:page>