<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

function(entidad,page){

	var toolbar=new Ext.Toolbar();

	var maskPanel;

	var maskAll=function(){
		app.entidad.showMask();
//		toolbar.disable();
	};

	var unmaskAll=function(){
		app.entidad.hideMask();
		toolbar.enable();
	};
	
	var recargarTab = function(msg){
		unmaskAll();
		if(msg){
			Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />', msg, _cerrarTab);
		}else{
			_cerrarTab();
		}	
	}
	
	var _cerrarTab = function(){
		app.contenido.remove(app.contenido.activeTab);
	}
	
	var tipoAccion={};
	tipoAccion.ELEVAR_REVISION					=0;
	tipoAccion.ELEVAR_COMITE					=1;
	tipoAccion.DEVOLVER_REVISION				=2;
	tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE	=3;
	tipoAccion.SOLICITAR_CANCELACION			=4;
	tipoAccion.VER_SOLICITUD_CANCELACION	    =5;
	tipoAccion.CANCELACION_EXPEDIENTE			=6;
	tipoAccion.ELEVAR_FORMALIZAR_PROPUESTA		=7;
	tipoAccion.DEVOLVER_COMITE					=8;
	tipoAccion.ELEVAR_ENSANCION					=9;
	tipoAccion.ELEVAR_SANCIONADO				=10;
	tipoAccion.DEVOLVER_ENSANCION				=11;
	tipoAccion.ELEVAR_FOR_PROP					=12;
	tipoAccion.DEVOLVER_COMPL_EXP				=13;
	tipoAccion.DEVOLVER_SANCIONADO				=14;
	tipoAccion.DEVOLVER_A_ENSANCION				=15;
	
	var cambioEstado=function(tipo){
		var titulo;
		var handler;
		var maxLength = 3500;
		texto='<s:message code="expedientes.motivos" text="**Motivos" />';
		switch(tipo){
			case tipoAccion.ELEVAR_REVISION:
				maskAll();
				elevarExpedienteRE(toolbar.getIdExpediente(), toolbar.isSupervisor())
				return;
			case tipoAccion.ELEVAR_COMITE:
				maskAll();
				elevarExpedienteDC(toolbar.getIdExpediente(), toolbar.isSupervisor());
				return;
			case tipoAccion.DEVOLVER_REVISION:
				titulo='<s:message code="expedientes.menu.devolverrevision"	text="**Devolver a Revisión" />';
				handler=function(btn, rta){
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteRE(toolbar.getIdExpediente(), rta);
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
			case tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE:
				titulo='<s:message code="expedientes.menu.devolvercompexpediente" text="**Devolver a completar Expediente" />';
				handler=function(btn, rta){
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteCE(toolbar.getIdExpediente(), rta);
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
			case tipoAccion.SOLICITAR_CANCELACION:
				//titulo='<s:message code="" text="**Solicitar cancelacion" />';
				solicitarCancelacionExp(toolbar.getIdExpediente(), false);
				return;	
			/*Acción ver solcicitud*/	
			case tipoAccion.VER_SOLICITUD_CANCELACION:
				var idSCX =  entidad.getData('toolbar.solicitudCancelacion')
				if (idSCX == null || idSCX == ''){
					idSCX = 0;
				}
				verSolicitudCancelacionExp(toolbar.getIdExpediente(),idSCX);
				return;
			case tipoAccion.CANCELACION_EXPEDIENTE:
				solicitarCancelacionExp(toolbar.getIdExpediente(),true);
				return;	
			
			/*Accion elevar a formalizar propuestas*/
			case tipoAccion.ELEVAR_FORMALIZAR_PROPUESTA:
				maskAll();
				elevarFP(toolbar.getIdExpediente(), toolbar.isSupervisor())
				return;
			
			/*Accion devolver a comite*/
			case tipoAccion.DEVOLVER_COMITE:
			titulo='<s:message code="expedientes.menu.devolverComite" text="**Devolver a Decisión de Comité" />';
				handler=function(btn, rta){
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteDC(toolbar.getIdExpediente(), rta);
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
			
			case tipoAccion.ELEVAR_ENSANCION:
				<%-- Realizamos acciones de elevar de RE a ENSAN --%>
				elevarExpedienteDeREaENSAN(toolbar.getIdExpediente(), toolbar.isSupervisor());
			return;
			
			case tipoAccion.ELEVAR_SANCIONADO:
				<%-- Realizamos acciones de elevar de ENSAN a SANC--%>
				elevarExpedienteDeENSANaSANC(toolbar.getIdExpediente(), toolbar.isSupervisor());
			return;
			
			case tipoAccion.DEVOLVER_ENSANCION:
				titulo='<s:message code="expedientes.menu.devolverrevision" text="**Devolver a Revisin" />';
				handler=function(btn, rta){
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteDeENSANaRE(toolbar.getIdExpediente(), rta, toolbar.isSupervisor());
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
				
			case tipoAccion.ELEVAR_FOR_PROP:
				<%-- Realizamos acciones de elevar formalizar propuesta--%>
				elevarExpedienteDeSANCaFP(toolbar.getIdExpediente(), toolbar.isSupervisor());
			return;
			
			case tipoAccion.DEVOLVER_COMPL_EXP:
				titulo='<s:message code="expedientes.menu.devolvercompexpediente" text="**Devolver a Comp." />';
				handler=function(btn, rta){
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteDeSANCaCE(toolbar.getIdExpediente(), rta, toolbar.isSupervisor());
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
				
			case tipoAccion.DEVOLVER_SANCIONADO:
				titulo='<s:message code="expedientes.menu.devolversancionado" text="**Devolver a Sancionado" />';
				handler=function(btn, rta){
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteDeFPaSANC(toolbar.getIdExpediente(), rta);
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
			
			case tipoAccion.DEVOLVER_A_ENSANCION:
				titulo='<s:message code="expedientes.menu.devolverEnSancion" text="**Devolver a en sanción" />';
				handler=function(btn, rta){
					if (btn== 'ok'){
						maskAll();
						devolverExpedienteDeSANCaENSAN(toolbar.getIdExpediente(), rta, toolbar.isSupervisor());
					}
				};				
				app.prompt(titulo, texto,handler);
				return;
		}
	}
	
	var elevarExpedienteDeREaENSAN = function(params, isSupervisor){
		page.webflow({
			flow: 'expediente/elevarExpedienteDeREaENSAN' 
			,eventName: 'elevarExpediente'
			,params:{id:params, isSupervisor:isSupervisor}
			,success: function(){
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.elevadoAEnSancion" text="**Elevado a En Sanción" />', entidad.refrescar());
			}
			,error:function(){
				unmaskAll();
			}	 
		});
	};
	
	var devolverExpedienteDeENSANaRE = function(params, rta, isSupervisor){
		page.webflow({
				flow:  'expediente/devolverExpedienteDeENSANaRE'
				,eventName: 'devolverExpediente'
				,params:{id:params, respuesta:rta, isSupervisor:isSupervisor}
				,success: function(){
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.devueltoARevision" text="**Devuelto a Revisión" />', entidad.refrescar());
				},error:function(){
						unmaskAll();
				}	 
		});
	};
	
	var elevarExpedienteDeENSANaSANC = function(params, isSupervisor){
		page.webflow({
			flow: 'expediente/elevarExpedienteDeENSANaSANC' 
			,eventName: 'elevarExpediente'
			,params:{id:params, isSupervisor:isSupervisor}
			,success: function(){
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.elevadoASancionado" text="**Elevado a Sancionado" />', entidad.refrescar());
			}
			,error:function(){
				unmaskAll();
			}	 
		});
	};
	
	var elevarExpedienteDeSANCaFP = function(params, isSupervisor){
		page.webflow({
				flow: 'expediente/elevarExpedienteDeSANCaFP'
				,eventName: 'elevarExpediente'
				,params:{id:params, isSupervisor:isSupervisor}
				,success: function(){
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.elevadoAFormalizarPropuesta" text="**Elevado a Formalizar Propuesta" />', entidad.refrescar());
				}
				,error:function(){
						unmaskAll();
				}	 
		});
	};

	var devolverExpedienteDeSANCaCE = function(params, rta, isSupervisor){
		page.webflow({
				flow:  'expediente/devolverExpedienteDeSANCaCE'
				,eventName: 'devolverExpediente'
				,params:{id:params, respuesta:rta, isSupervisor:isSupervisor}
				,success: function(){
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.devueltoACompletar" text="**Devuelto a Completar Expediente" />', entidad.refrescar());
				},error:function(){
						unmaskAll();
				}	 
		});
	};

	var elevarExpedienteRE = function(params, isSupervisor){
		page.webflow({
			flow: 'expediente/elevarExpedienteRE' 
			,eventName: 'elevarExpediente'
			,params:{id:params, isSupervisor:isSupervisor}
			,success: function(){
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.elevadoARevision" text="**Elevado a Revisión" />', entidad.refrescar());
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
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.elevadoADecision" text="**Elevado a DC" />', entidad.refrescar());
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
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.devueltoARevision" text="**Devuelto a Revisión" />', entidad.refrescar());
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
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.devueltoACompletar" text="**Devuelto a CE" />', entidad.refrescar());
				},error:function(){
					unmaskAll();
				}	 
		});
	};
	
	var devolverExpedienteDeFPaSANC = function(params, isSupervisor){
		page.webflow({
			flow: 'expediente/devolverExpedienteDeFPaSANC' 
			,eventName: 'elevarExpediente'
			,params:{id:params, isSupervisor:isSupervisor}
			,success: function(){
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.devueltoASancionado" text="**Devuelto a sancionado" />', entidad.refrescar());
			}
			,error:function(){
				unmaskAll();
			}	 
		});
	};
	
	var devolverExpedienteDeSANCaENSAN = function(params, rta, isSupervisor){
		page.webflow({
				flow:  'expediente/devolverExpedienteDeSANCaENSAN'
				,eventName: 'devolverExpediente'
				,params:{id:params, respuesta:rta, isSupervisor:isSupervisor}
				,success: function(){
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.devueltoAEnSancion" text="**Devuelto a En Sanción" />', entidad.refrescar());
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
			code="expedientes.consulta.solicitarcancelacion" text="**Solicitar cancelacion" />'
			,params : {id:params, esSupervisor:esSupervisor}
		});
			
		w.on(app.event.DONE, function(){
			w.close();
			maskAll();
			if(esSupervisor){
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expedientes.consulta.decisionCancelacionOk" text="**Cancelacion Confirmada" />', entidad.refrescar());
			}else{
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expedientes.consulta.solicitudCancelacionRealizada" text="**expedientes.consulta.solicitudCancelacionRealizada" />', entidad.refrescar());
			}
			
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	};
	
	var verSolicitudCancelacionExp = function(idExpediente, idTarPend){
		var w = app.openWindow({
			flow : 'expedientes/decisionSolicitudCancelacion'
			,eventName: 'formulario'
			,title : '<s:message code="expedientes.menu.solicitarcancelacion" text="**Solicitar cancelacion" />'
			,params : {idExpediente:idExpediente, idSolicitud:idTarPend}
		});
			
		w.on(app.event.DONE, function(){
			w.close();
			maskAll();
			Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expedientes.consulta.decisionCancelacionOk" text="**Cancelacion Confirmada" />', entidad.refrescar());
		});
		w.on(app.event.CANCEL, function(){ w.close(); });
	}

	var rechazarSolicitarCancelacionExp = function(params){
		page.webflow({
			flow:  'expediente/rechazarSolicitarCancelacionExp'
			,eventName: 'rechazarCancelacionExpediente'
			,params:{id:params}
			,success: function(){
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expedientes.consulta.decisionCancelacionDenegada" text="**expedientes.consulta.decisionCancelacionDenegada" />', entidad.refrescar());
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
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.expedienteCancelado" text="**Expediente Cancelado" />', entidad.refrescar());
			},error:function(){
				unmaskAll();
			}	 
		});
	};
	
	var elevarFP = function(params, isSupervisor){
		page.webflow({
				flow: 'expediente/elevarExpedienteFP'
				,eventName: 'elevarExpediente'
				,params:{id:params, isSupervisor:isSupervisor}
				,success: function(){
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.elevadoAFormalizarPropuesta" text="**Elevado a Formalizar Propuesta" />', entidad.refrescar());
				}
				,error:function(){
						unmaskAll();
				}	 
		});
	};
	
	var devolverExpedienteDC = function(params, rta){
		page.webflow({
				flow:  'expediente/devolverExpedienteDC'
				,eventName: 'devolverExpediente'
				,params:{id:params, respuesta:rta}
				,success: function(){
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="dc.devueltoAComite" text="**Devuelto a Decisión Comité" />', entidad.refrescar());
				},error:function(){
					unmaskAll();
				}	 
		});
	};
	
	var menuAcciones = 
		{
			text : '<s:message code="expedientes.menu.acciones" text="**Acciones" />'
			,id : 'expediente-menu-menuAcciones'
			,menu : [
				{
					text:'<s:message code="expedientes.menu.elevarrevision" text="**Elevar a Revisin" />'
					,id : 'expediente-accion0-elevarRevision'
					,iconCls : 'icon_elevar_revision'
					,handler:function(){ cambioEstado(tipoAccion.ELEVAR_REVISION)	}
					
				}, {
					text:'<s:message code="expedientes.menu.elevarcomite" text="**Elevar a Comit" />'
					,id : 'expediente-accion1-elevarComite'
					,iconCls : 'icon_elevar_comite'
					,handler:function(){
						cambioEstado(tipoAccion.ELEVAR_COMITE)
					}
				},
				 //Botn elevar FP
				{
					text:'<s:message code="expedientes.menu.elevarFormulacionPropuesta" text="**Elevar a Formalizar Propuesta" />'
					,id : 'expediente-accion7-formulacionPropuesta'
					,iconCls : 'icon_elevar_revision'
					,handler:function(){
						cambioEstado(tipoAccion.ELEVAR_FORMALIZAR_PROPUESTA)
					}
				},
				{
					text:'<s:message code="expedientes.menu.elevarAceptarPropuesta" text="**Elevar a Aceptar Propuesta" />'
					,id : 'expediente-accion9-aceptarPropuesta'
					,iconCls : 'icon_elevar_revision'
					,handler:function(){
						cambioEstado(tipoAccion.ELEVAR_FORMALIZAR_PROPUESTA)
					}
				},				
				{
					text:'<s:message code="expedientes.menu.devolverrevision" text="**Devolver a Revisin" />'
					,id : 'expediente-accion2-devolverRevision'
					,iconCls : 'icon_revisar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.DEVOLVER_REVISION)
					}
				},  
				{
					text:'<s:message code="expedientes.menu.devolverComite" text="**Devolver a Decisión Comité" />'
					,id : 'expediente-accion8-devolverComite'
					,iconCls : 'icon_revisar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.DEVOLVER_COMITE)
					}
				},
				{
					text:'<s:message code="expedientes.menu.elevaEnSancion" text="**Elevar a en Sancion" />'
					,id : 'expediente-accion10-elevarEnSancion'
					,iconCls : 'icon_elevar_comite'
					,handler:function(){
						cambioEstado(tipoAccion.ELEVAR_ENSANCION)
					}
				},
				{
					text:'<s:message code="expedientes.menu.elevaSancionado" text="**Elevar a Sancionado" />'
					,id : 'expediente-accion11-elevarSancionado'
					,iconCls : 'icon_elevar_comite'
					,handler:function(){
						cambioEstado(tipoAccion.ELEVAR_SANCIONADO)
					}
				},
				{
					text:'<s:message code="expedientes.menu.devolverrevision" text="**Devolver a Revisin" />'
					,id : 'expediente-accion12-devolverEnSancion'
					,iconCls : 'icon_completar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.DEVOLVER_ENSANCION)
					}
				},
				{
					text:'<s:message code="expedientes.menu.elevarAceptarPropuesta" text="**Elevar a Aceptar Propuesta" />'
					,id : 'expediente-accion13-elevarFormalizarPropuesta'
					,iconCls : 'icon_elevar_revision'
					,handler:function(){
						cambioEstado(tipoAccion.ELEVAR_FOR_PROP)
					}
				},
				{
					text:'<s:message code="expedientes.menu.devolverEnSancion" text="**Devolver a En Sanción" />'
					,id : 'expediente-accion16-devolverAEnSancion'
					,iconCls : 'icon_completar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.DEVOLVER_A_ENSANCION)
					}
				},
				{
					text:'<s:message code="expedientes.menu.devolvercompexpediente" text="**Devolver completar expediente" />'
					,id : 'expediente-accion14-devolverCompletarExpediente'
					,iconCls : 'icon_completar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.DEVOLVER_COMPL_EXP)
					}
				}
				,
				{
					text:'<s:message code="expedientes.menu.devolversancionado" text="**Devolver a Sancionado" />'
					,id : 'expediente-accion15-devolverAsancionado'
					,iconCls : 'icon_revisar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.DEVOLVER_SANCIONADO)
					}
				}
				,{
					text:'<s:message code="expedientes.menu.devolvercompexpediente" text="**Devolver a Comp." />'
					,id : 'expediente-accion3-devolverComite'
					,iconCls : 'icon_completar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.DEVOLVER_COMPLETAR_EXPEDIENTE)
					}
				}
				,{
					text:'<s:message code="expedientes.menu.solicitarcancelacion" text="**Solicitar Cancelacion" />'
					,id : 'expediente-accion4-solicitarCancelacion'
					,iconCls : 'icon_cancelar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.SOLICITAR_CANCELACION)
					}
				},
				//Botn ver solicitud: Se muestra si es supervisor y hay solicitud pendiente.
				{
					text:'<s:message code="expedientes.menu.verSolicitudCancelacion" text="**Ver Solicitud Cancelacion" />'
					,id : 'expediente-accion5-verCancelacion'
					,iconCls : 'icon_rechazar_cancelar_expediente'
					,handler:function(){
						//TODO cambiar el codigo de la accion
						cambioEstado(tipoAccion.VER_SOLICITUD_CANCELACION)
					}
				},
				
				//Botn cancelar: se muestra si es supervisor y NO hay solicitud pendiente.
				{
					text:'<s:message code="expedientes.menu.cancelacionexpediente" text="**Cancelacin Expediente" />'
					,id : 'expediente-accion6-cancelacionExpediente'
					,iconCls : 'icon_cancelar_expediente'
					,handler:function(){
						cambioEstado(tipoAccion.CANCELACION_EXPEDIENTE)
					}
				}
				
				
			]
		};


	var CODIGO_ENTIDAD_EXPEDIENTE =  '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />';

	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			entidad.refrescar();
		}
	});
	
	toolbar.add(menuAcciones);
	toolbar.add(buttonsL_expediente);
	
	var menuProrroga={
		 text : '<s:message code="expedientes.menu.prorroga" text="**Prorroga" />'
		,id : 'expediente-menu-prorroga'
		,menu :[{
				text : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prrroga" />'
				,id : 'expediente-prorroga0-solicitarProrroga'
				,iconCls : 'icon_sol_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/solicitarProrroga'
						,title : '<s:message code="expedientes.menu.solicitarprorroga" text="**Solicitar Prrroga" />'
						,width:650 
						,params : {
								idEntidadInformacion: entidad.getData("id")
								,fechaCreacion: entidad.getData('toolbar.fechaVencimiento')
								,situacion: entidad.getData('toolbar.situacion')
								,fechaVencimiento:entidad.getData('toolbar.fechaVencimiento')
								,idTipoEntidadInformacion: CODIGO_ENTIDAD_EXPEDIENTE
								,descripcion: entidad.getData('toolbar.descripcion')
								,idTareaAsociada: entidad.getData('toolbar.idTareaExpediente')
								,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expedientes.consulta.prorrogaSolicitada" text="**expedientes.consulta.prorrogaSolicitada" />', entidad.refrescar());
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			},{
				text : '<s:message code="expedientes.menu.aceptarprorroga" text="**Aceptar Prrroga" />'
				,id : 'expediente-prorroga1-aceptarProrroga'
				,iconCls : 'icon_aceptar_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/decisionProrroga'
						,title : '<s:message code="expedientes.menu.decisionProrroga" text="**Desicion sobre Prorroga" />'
						,width:650
						,params : {
							idEntidadInformacion: entidad.getData('id')
							,isConsulta:false
							,fechaVencimiento:entidad.getData('toolbar.fechaVencimiento')
							,fechaCreacion: entidad.getData('toolbar.fechaCreacionFormateada')
							,situacion: entidad.getData('toolbar.situacion')
							,destareaOri: entidad.getData('toolbar.prorrogaPendienteTarea')
							,idTipoEntidadInformacion: CODIGO_ENTIDAD_EXPEDIENTE
							,fechaPropuesta: entidad.getData('toolbar.prorrogaFechaPropuesta')
							,motivo: entidad.getData('toolbar.causaProrroga')
							,idTareaOriginal:entidad.getData('toolbar.prorrogaPendiente') 
							,descripcion:entidad.getData('toolbar.descripcionExpediente')
							,codigoTipoProrroga: '<fwk:const value="es.capgemini.pfs.prorroga.model.DDTipoProrroga.TIPO_PRORROGA_INTERNA_PRIMARIA" />'
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expedientes.consulta.prorrogaDecidida" text="**expedientes.consulta.prorrogaDecidida" />', entidad.refrescar());
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			},{
				text : '<s:message code="expedientes.menu.consultarprorroga" text="**Consultar Prrroga" />'
				,id : 'expediente-prorroga2-consultarProrroga'
				,iconCls : 'icon_consultar_prorroga'
				,handler : function(){
					var w = app.openWindow({
						flow : 'tareas/decisionProrroga'
						,title : '<s:message code="expedientes.menu.consultarprorroga" text="**Consultar Prrroga" />'
						,width:650
						,params : {
							idEntidadInformacion: entidad.getData('id')
							,isConsulta:true
							,fechaVencimiento:entidad.getData('toolbar.fechaVencimiento')
							,fechaCreacion: entidad.getData('fechaCreacionFormateada')
							,situacion: entidad.getData('toolbar.situacion')
							,destareaOri: entidad.getData('toolbar.prorrogaPendienteTarea')
							,idTipoEntidadInformacion: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_EXPEDIENTE" />'
							,fechaPropuesta: entidad.getData('toolbar.prorrogaFechaPropuesta')
							,motivo: entidad.getData('toolbar.causaProrroga')
							,idTareaOriginal: entidad.getData('toolbar.prorrogaPendiente') 
							,descripcion:entidad.getData('toolbar.descripcionExpediente')
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

	toolbar.add(menuProrroga);

	<sec:authorize ifAllGranted="EXCLUIR_CLIENTES">
		var menuDatosClientes = {
		text:'Datos Clientes'
		,id : 'expediente-datosClientes'
		,menu:[	{
				text:'<s:message code="expedientes.menu.excluirclientes" text="**Excluir Clientes del Expediente" />'
				,id : 'expediente-datosClientes-excluirclientes'
				,iconCls:'icon_excluir_clientes'
				,handler:function(){
					var w = app.openWindow({
						flow : 'fase2/expedientes/excluirClientesExpediente'
						,params : {id:entidad.getData('id')}
						,width:650
						,title : '<s:message code="expedientes.menu.excluirclientes" text="**Excluir Clientes del Expediente" />'
						
					});
					w.on(app.event.DONE, function(){
						w.close();
						entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
			
				}
			},{
				text:'<s:message code="expedientes.menu.comprobarexclusionclientes" text="**Comprobar Exclusin Datos Clientes" />'
				,id : 'expediente-datosClientes-comprobarexclusionclientes'
				,iconCls:'icon_excluir_datos_clientes'
				,handler:function(){
					var w = app.openWindow({
						flow : 'fase2/expedientes/decisionExcluirClientesExpediente'
						,params : {id:entidad.getData('id')}
						,width:650
						,title : '<s:message code="expedientes.menu.consultarexclusionclientes" text="**Clientes del Expediente" />'
						
					});
					w.on(app.event.DONE, function(){
						w.close();
						entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
				}
			}
		]};

		//Si tiene algn elemento mostramos el men
		toolbar.add(menuDatosClientes);
		toolbar.add('-');
	</sec:authorize>

	var botonComunicacion = new Ext.Button({
		text:'<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicacin" />'
        ,id : 'expedientes-boton-comunicacion'
		,iconCls : 'icon_comunicacion'
		,handler:function(){
			var w = app.openWindow({
				flow : 'tareas/generarTarea'
				,title : '<s:message code="" text="Comunicacion" />'
				,width:650
				,params : {
					idEntidad: entidad.getData('id')
					,codigoTipoEntidad: '2'
					,tienePerfilGestor: permisosVisibilidadGestorSupervisor(entidad.getData('toolbar.idGestorActual')) || false
					,tienePerfilSupervisor: permisosVisibilidadGestorSupervisor(entidad.getData('toolbar.idSupervisorActual')) || false
				}
			});
			w.on(app.event.DONE, function(){
				w.close();
				entidad.refrescar();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
          }
	});

	toolbar.add(botonComunicacion);

	var botonResponder = new Ext.Button({
		text:'Responder'
        ,id : 'expedientes-boton-responder'
		,iconCls : 'icon_responder_comunicacion'
		,handler:function(){
			var w = app.openWindow({
				flow : 'tareas/generarNotificacion'
				,title : '<s:message code="" text="Notificacion" />'
				,width:650
				,params : {
					idEntidad:entidad.getData('id')
					,codigoTipoEntidad: '2'
					,descripcion: entidad.getData('toolbar.tareaPendienteDescripcion')
					,fecha: entidad.getData('toolbar.fechaCreacionFormateada')
					,situacion: entidad.getData('toolbar.situacion')
					,idTareaAsociada:entidad.getData('toolbar.tareaPendiente')
				}
			});
			w.on(app.event.DONE, function(){
				w.close();
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expedientes.consulta.notificacionRespondida" text="**expedientes.consulta.notificacionRespondida" />', entidad.refrescar());
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
			w.on(app.event.OPEN_ENTITY, function(){ w.close(); });
		}
	});

	toolbar.add(botonResponder);

	<sec:authorize ifAllGranted="EXPORTAR_PDF_EXPEDIENTE">
	var botonPDF = new Ext.Button({
		//name: 'genPDF'
		text: '<s:message code="menu.clientes.consultacliente.menu.generarPDF" text="**Generar PDF" />'
		,iconCls: 'icon_pdf'
		,handler: function() {
			var flow='expedientes/reporteExpediente';
			var tipo='generaPDF';
			var params='id='+ entidad.getData('id')+'&REPORT_NAME=reporteExpediente'+entidad.getData('id')+'.pdf';
			app.openPDF(flow,tipo,params);
		}
	});
	

	toolbar.add(botonPDF);
	</sec:authorize>

	var elevarAComiteSuperior = function(idComite){
		page.webflow({
			 flow:  'comites/elevarAComiteSuperior'
			,params:{idComite:idComite, idExpediente:entidad.getData('id')}
			,success: function(){
				Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expediente.elevadoAOtroComite" text="**expediente.elevadoAOtroComite" />', entidad.refrescar());
			}
			,error:function(){ unmaskAll(); }
		})		
	}	 
	var elevarAComiteSuperiorButton = new Ext.Button({
		 text:'<s:message code="comite.elevar" text="**Elevar a otro comit" />'
		,iconCls:'icon_elevar_expediente_otro_comite'
		,handler:function(){
			if (!entidad.getData('toolbar.comiteElevarNull')){
				Ext.Msg.confirm('<s:message code="expediente.elevarAComite" text="**Elevar a otro Comit" />', '<s:message code="expediente.confirmacionElevar" arguments="${comiteElevar.nombre}" />',	this.evaluateAndSend);
			}else{
				Ext.Msg.alert('<s:message code="expediente.tituloNoSePuedeElevar" text="**No se puede elevar" />','<s:message code="expediente.noSePuedeElevar" text="**El expediente ya s encuentra en lo ms alto de la jerarqua" />');
			}
		}
		,evaluateAndSend:function(seguir){
			if (seguir==true || seguir=='yes'){
				elevarAComiteSuperior(entidad.getData('toolbar.comiteElevar'));
			}		
		}
	});

	toolbar.add(elevarAComiteSuperiorButton);

	var delegarAOtroComiteButton = new Ext.Button({
		 text:'<s:message code="comite.delegar" text="**Delegar a otro comit" />'
		,iconCls:'icon_delegar_expediente_otro_comite'
		,handler:function(){
			
			if (!entidad.getData('toolbar.comitesDelegarNull') && !entidad.getData('toolbar.comitesDelegarLen')){
				var w = app.openWindow({
					flow : 'comites/listadoComitesADelegar'
					,params : {idExpediente:entidad.getData('id')}
					,width:900
					,title : '<s:message code="comite.comitesDelegacion" text="**Delegar Expediente" />'
				});
				w.on(app.event.DONE, function(){
					w.close();
					Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="expediente.delegadoAOtroComite" text="**expediente.delegadoAOtroComite" />', entidad.refrescar());
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
			}
			
			if (entidad.getData('toolbar.comitesDelegarNull') || entidad.getData('toolbar.comitesDelegarLen')){
				Ext.Msg.alert('<s:message code="expediente.tituloNoSePuedeDelegar" text="**No se puede delegar" />','<s:message code="expediente.noSePuedeDelegar" text="**No se encuentra ningn comit por debajo de la jerarqua actual" />');
			}
		}
	});

	toolbar.add(delegarAOtroComiteButton);

	var EXP_ACTIVO =  '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_ACTIVO" />';
	var EXP_CONGELADO =  '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CONGELADO" />';
	var EXP_PROPUESTO =  '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_PROPUESTO" />';
	var EXP_BLOQUEADO =  '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_BLOQUEADO" />';
	var EXP_CANCELADO =  '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_CANCELADO" />';
	var EXP_DECIDIDO =  '<fwk:const value="es.capgemini.pfs.expediente.model.DDEstadoExpediente.ESTADO_EXPEDIENTE_DECIDIDO" />';
    
	toolbar.getIdExpediente = function(){
		var data = entidad.get("data");
		return data.id;
	}
	toolbar.isSupervisor = function(){
		var data = entidad.get("data");
		var d = data.toolbar;
		
		if(permisosVisibilidadGestorSupervisor(d.idSupervisorActual)) 
			return true;
		else 
			return false;
	}
	toolbar.isGestor = function(){
		var data = entidad.get("data");
		var d = data.toolbar;
		
		if(permisosVisibilidadGestorSupervisor(d.idGestorActual)) 
			return true;
		else 
			return false;
	}
	
	toolbar.getValue = function(){};
  	
  	
	toolbar.setValue = function(){
		
		var data = entidad.get("data");
		var d = data.toolbar;
		
		var estadoExpediente = d.estadoExpediente;

		var iconClass="";
		if (d.esRecuperacion){iconClass = 'icon_expedientes_R';}
		if (d.esSeguimiento){ iconClass= 'icon_expedientes_S'; }
		if (estadoExpediente==EXP_CANCELADO) { iconClass = 'icon_expedientes_X'; }
		if (d.tipoExpediente=='REC') { iconClass = 'icon_expedientes_R2'; }

		if (iconClass!='') Ext.getCmp('expediente-'+entidad.getData('id')).setIconClass(iconClass); 
	  
		var perfilGestor = d.idGestorActual;
		var perfilSupervisor = d.idSupervisorActual;
		
		var permisosGestor = permisosVisibilidadGestorSupervisor(perfilGestor);
		var permisosSupervisor = permisosVisibilidadGestorSupervisor(perfilSupervisor);
		var esGestorSupervisorDeFase = entidad.get("data").esGestorSupervisorActual;

		var solicitud = d.solicitudCancelacion;

		var solicitudYPermisos = (solicitud == null || solicitud=='') && (permisosGestor ||  permisosSupervisor);
		
		var subMenusVisibles = 0;
		
		var permiteElevar = false;
		var permiteDevolver = false;
		var mostrarRec = false;
		
		
		function showHide(action, elements___){
			for(var i=1;i< arguments.length;i++){
				if (action){
					Ext.getCmp(arguments[i]).show();
					subMenusVisibles += 1;
				}else{
					Ext.getCmp(arguments[i]).hide();
				}
			}
		}
		
		//inicialmente ocultamos todos
		showHide(false, 'expediente-accion0-elevarRevision', 'expediente-accion1-elevarComite',  'expediente-accion2-devolverRevision',  'expediente-accion3-devolverComite',  'expediente-accion4-solicitarCancelacion',  'expediente-accion5-verCancelacion',  'expediente-accion6-cancelacionExpediente', 'expediente-accion7-formulacionPropuesta', 'expediente-accion8-devolverComite', 'expediente-accion9-aceptarPropuesta','expediente-accion10-elevarEnSancion','expediente-accion11-elevarSancionado','expediente-accion12-devolverEnSancion','expediente-accion13-elevarFormalizarPropuesta','expediente-accion14-devolverCompletarExpediente','expediente-accion15-devolverAsancionado','expediente-accion16-devolverAEnSancion');
		if ( solicitudYPermisos){
			
			var estados = entidad.getData('estados');
		
			switch(d.codigoEstado){
				case 'CE' : 
					if(esGestorSupervisorDeFase){
						for(var i = 0; i < estados.length; i++){
							if(estados[i].codigo == 'RE'){
								showHide(estadoExpediente == EXP_ACTIVO, 'expediente-accion0-elevarRevision');
							}
						}	
					}
					break;
				case 'RE' :
					if(esGestorSupervisorDeFase){
						for(var i = 0; i < estados.length; i++){
							if(estados[i].codigo == 'DC'){
								showHide(estadoExpediente ==  EXP_ACTIVO ,'expediente-accion1-elevarComite');
							}
												
							if(estados[i].codigo == 'CE')
							{
								showHide(estadoExpediente ==  EXP_ACTIVO ,'expediente-accion3-devolverComite');
							}
							
							if(estados[i].codigo == 'ENSAN')
							{
								showHide(estadoExpediente ==  EXP_ACTIVO ,'expediente-accion10-elevarEnSancion');
							}
						}	
					}
					break;
				case 'DC' : 
					if(esGestorSupervisorDeFase){
						
						var permEle = false;
						var permDevo = false;
						
						for(var i = 0; i < estados.length; i++){
							if(estados[i].codigo == 'FP'){
								permEle = true;
							}
							
							if(estados[i].codigo == 'RE'){
								permDevo = true;
							}
						}
						if(permEle && permDevo){
							<sec:authorize ifAllGranted="PERSONALIZACION-BCC">
								if(d.esRecuperacion){
									showHide(estadoExpediente == EXP_CONGELADO , 'expediente-accion7-formulacionPropuesta','expediente-accion2-devolverRevision');
								}else{
									showHide(estadoExpediente == EXP_CONGELADO , 'expediente-accion9-aceptarPropuesta','expediente-accion2-devolverRevision');
								}
								showHide(estadoExpediente == EXP_CONGELADO , 'expediente-accion7-formulacionPropuesta','expediente-accion2-devolverRevision');
							</sec:authorize>
						}else if(!permiteElevar && permiteDevolver){
							showHide(estadoExpediente == EXP_CONGELADO , 'expediente-accion2-devolverRevision');
						}
					}
					break;
				
				case 'ENSAN' :
					if(esGestorSupervisorDeFase){
						for(var i = 0; i < estados.length; i++){
							if(estados[i].codigo == 'SANC'){
								showHide(estadoExpediente ==  EXP_ACTIVO ,'expediente-accion11-elevarSancionado');
							}
												
							if(estados[i].codigo == 'RE')
							{
								showHide(estadoExpediente ==  EXP_ACTIVO ,'expediente-accion12-devolverEnSancion');
							}
						}	
					}
					break;
					
				case 'SANC' :
					if(esGestorSupervisorDeFase){
						for(var i = 0; i < estados.length; i++){
												
							if(estados[i].codigo == 'CE')
							{
								showHide((estadoExpediente ==  EXP_ACTIVO || estadoExpediente ==  EXP_CONGELADO) ,'expediente-accion14-devolverCompletarExpediente');
							}
							
							if(estados[i].codigo == 'ENSAN'){
								showHide((estadoExpediente ==  EXP_ACTIVO || estadoExpediente ==  EXP_CONGELADO) ,'expediente-accion16-devolverAEnSancion');
							}
						}	
					}
					break;
					
				case 'FP' :
					if(esGestorSupervisorDeFase){
						for(var i = 0; i < estados.length; i++){
							if(estados[i].codigo == 'DC'){
								showHide(estadoExpediente == EXP_CONGELADO , 'expediente-accion8-devolverComite');
							}
							
							if(estados[i].codigo == 'SANC'){
								showHide(estadoExpediente == EXP_CONGELADO , 'expediente-accion15-devolverAsancionado');
							}
						}	
					}
					break;
					
				default : 
					showHide(estadoExpediente == EXP_CONGELADO, 'expediente-accion2-devolverRevision' );
			}
		}
		if ( permisosGestor && ([EXP_ACTIVO	, EXP_PROPUESTO, EXP_CONGELADO].indexOf(estadoExpediente)>=0)  ){
			if (solicitud==null || solicitud==""){	
				showHide(true, 'expediente-accion4-solicitarCancelacion');
			}else{
				showHide(false, 'expediente-accion4-solicitarCancelacion');
			}
		}
		
		if ( permisosSupervisor && ([EXP_ACTIVO	, EXP_PROPUESTO, EXP_CONGELADO, EXP_BLOQUEADO].indexOf(estadoExpediente)>=0)  ){
			if (solicitud!=null && solicitud!=""){	
				showHide(true, 'expediente-accion5-verCancelacion');
			}else{
				showHide(true, 'expediente-accion6-cancelacionExpediente');
			}
			<%-- Si el usuario es supervisor deshabilitar la opcion de solicitar cancelacion --%>
			showHide(false, 'expediente-accion4-solicitarCancelacion');
		}
		if (entidad.getData('esSupervisor')  && ([EXP_ACTIVO, EXP_PROPUESTO, EXP_CONGELADO, EXP_BLOQUEADO].indexOf(estadoExpediente)>=0) ){
			if (solicitud!=null && solicitud!=""){	
				showHide(true, 'expediente-accion5-verCancelacion');
			}else{
				showHide(true, 'expediente-accion6-cancelacionExpediente');
			}
		}

		showHide( subMenusVisibles>0, 'expediente-menu-menuAcciones');

		//ahora vamos con la visibilidad del menuProrroga
		subMenusVisibles=0;
		showHide(false,  'expediente-prorroga0-solicitarProrroga', 'expediente-prorroga1-aceptarProrroga',  'expediente-prorroga2-consultarProrroga');

		var tieneTareaNotificacion = entidad.getData('toolbar.tieneTareaNotificacion');

		var prorroga = entidad.getData('toolbar.prorrogaPendiente');
		
		var estadosExpediente = [EXP_ACTIVO, EXP_CONGELADO];
		
		if (d.codigoEstado == 'FP')
			estadosExpediente = [EXP_ACTIVO, EXP_CONGELADO, EXP_DECIDIDO];

		if (tieneTareaNotificacion && permisosGestor && (estadosExpediente.indexOf(estadoExpediente)>=0)){
			<sec:authorize ifAllGranted="SOLICITAR_PRORROGA">
				if (prorroga==null || prorroga == ''){
					if (solicitud==null || solicitud==""){
						showHide(true, 'expediente-prorroga0-solicitarProrroga');
					}
				}else{
					showHide(true, 'expediente-prorroga2-consultarProrroga');
				}
			</sec:authorize>
		}
		
		estadosExpediente = [EXP_ACTIVO, EXP_CONGELADO, EXP_BLOQUEADO];
		
		if (d.codigoEstado == 'FP')
			estadosExpediente = [EXP_ACTIVO, EXP_CONGELADO, EXP_BLOQUEADO, EXP_DECIDIDO];

		if (tieneTareaNotificacion && permisosSupervisor && estadosExpediente.indexOf(estadoExpediente)>=0){
			<sec:authorize ifAllGranted="SOLICITAR_PRORROGA">
				if (prorroga != null &&  prorroga != ''){
					if (solicitud == null || solicitud == ''){
						showHide(true,  'expediente-prorroga1-aceptarProrroga');
					}
				}
			</sec:authorize>
		}
		
		estadosExpediente = [EXP_ACTIVO, EXP_CONGELADO];
		if (d.codigoEstado == 'FP')
			estadosExpediente = [EXP_ACTIVO, EXP_CONGELADO, EXP_DECIDIDO];
		
		showHide( tieneTareaNotificacion && subMenusVisibles>0 && estadosExpediente.indexOf(estadoExpediente)>=0, 'expediente-menu-prorroga');

		//menu de datosClientes
		<sec:authorize ifAllGranted="EXCLUIR_CLIENTES">
			subMenusVisibles=0;
			showHide(false, 'expediente-datosClientes', 'expediente-datosClientes-excluirclientes', 'expediente-datosClientes-comprobarexclusionclientes');
			var codigoEstado = entidad.getData('toolbar.codigoEstado');
			var cond1= (codigoEstado=='CE' || ( codigoEstado=='RE' && entidad.getData('toolbar.exclusionNotNull')));
			showHide(cond1 && estadoExpediente && entidad.getData('toolbar.estaEstadoActivo'),  'expediente-datosClientes-excluirclientes');
			showHide(cond1 && codigoEstado=='RE' && entidad.getData('toolbar.exclusionNotNull'),  'expediente-datosClientes-comprobarexclusionclientes');
			showHide( subMenusVisibles>0, 'expediente-datosClientes');
		</sec:authorize>
	
		var COMUNICACION = false;
		var RESPONDER = false;
			<sec:authorize ifAllGranted="COMUNICACION">COMUNICACION=true;</sec:authorize>
			<sec:authorize ifAllGranted="RESPONDER">RESPONDER=true;</sec:authorize>
      
		showHide( COMUNICACION && ((permisosGestor && estadoExpediente == EXP_ACTIVO) || (permisosSupervisor && [EXP_ACTIVO,EXP_BLOQUEADO,EXP_CONGELADO].indexOf(estadoExpediente)>=0) ),  'expedientes-boton-comunicacion' );
		showHide( RESPONDER && ((permisosGestor && estadoExpediente == EXP_ACTIVO) || (permisosSupervisor && [EXP_ACTIVO,EXP_BLOQUEADO,EXP_CONGELADO].indexOf(estadoExpediente)>=0) ),  'expedientes-boton-responder' );

		if (entidad.getData('toolbar.tareaPendiente')==''){
			botonResponder.disable();
		}else{
			botonResponder.enable();
		}
		
		elevarAComiteSuperiorButton.hide();

		delegarAOtroComiteButton.hide();


		var expedienteActivo=false;
		if ([EXP_ACTIVO,EXP_BLOQUEADO,EXP_CONGELADO].indexOf(estadoExpediente)>=0) expedienteActivo=true;
		<sec:authorize ifAllGranted="ROLE_COMITE">
			if (expedienteActivo && (d.puedeMostrarSolapaDecisionComite || d.puedeMostrarSolapaMarcadoPoliticas)){
				elevarAComiteSuperiorButton.show();
				delegarAOtroComiteButton.show();
			}
		</sec:authorize>
		
		var visible = [];
		var condition = '';
		for (i=0; i < buttonsL_expediente.length; i++){
			if (buttonsL_expediente[i].condition!=null && buttonsL_expediente[i].condition!=''){
				condition = eval(buttonsL_expediente[i].condition);
				visible.push([buttonsL_expediente[i], condition]);
			}
		}
		for (i=0; i < buttonsR_expediente.length; i++){
			if (buttonsR_expediente[i].condition!=null && buttonsR_expediente[i].condition!=''){
				condition = eval(buttonsR_expediente[i].condition);
				visible.push([buttonsR_expediente[i], condition]);
			}
		}
		
		entidad.setVisible(visible);
		
	};

	toolbar.add('->');
	toolbar.add(buttonsR_expediente);
	toolbar.add(botonRefrezcar);
	toolbar.add(app.crearBotonAyuda());
	
	return toolbar;
};
