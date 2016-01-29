<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>


	var tabs = <app:includeArray files="${tabsAsunto}" />;
	var buttons = <app:includeArray files="${buttonsAsunto}" />;

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
	
	
	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			maskPanel=new Ext.LoadMask(panel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
		}
		maskPanel.show();
		panel.getTopToolbar().disable();
		
	};
	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
		panel.getTopToolbar().enable();
		
	};
	/**
	 * Cierra el tab
	 */
	var _cerrarTab = function(){
		app.contenido.remove(app.contenido.activeTab);
	}
	var _recargar = function(){
		app.contenido.activeTab.doAutoLoad();
	}
	var cerrarTab = function(msg){
		
		unmaskAll();
		if(msg){
			Ext.Msg.show({
				title:'**Aviso',
				   msg: msg,
				   buttons: Ext.Msg.OKCANCEL,
				   fn: _cerrarTab,
				   icon: Ext.MessageBox.INFO
			});
		}else{
			_cerrarTab();
		}	
	}
	var recargarTab = function(msg){
		
		unmaskAll();
		if (msg) {
			Ext.Msg.show({
				title:'**Aviso',
				   msg: msg,
				   buttons: Ext.Msg.OKCANCEL,
				   fn: _cerrarTab,
				   icon: Ext.MessageBox.INFO
			});
		}
		else {
			_recargar();
		}
	}
	
	
	var asuntoTabPanel=new Ext.TabPanel({
		items:tabs
		,layoutOnTabChange:true 
		,activeItem:nrotab
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false
			
	});
	var panel = new Ext.Panel({
		autoHeight : true
		,items : [asuntoTabPanel]
		,tbar : new Ext.Toolbar()
		,id:'asunto-${asunto.id}'
	});
	
	<c:if test="${esSupervisor || esGestor}">
	
		var botonComunicacion = new Ext.Button({
			text:'<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicación" />'
			,iconCls : 'icon_comunicacion'
			,handler:function(){
				
	           	var w = app.openWindow({
					flow : 'tareas/generarTarea'
					,title : '<s:message code="" text="Comunicacion" />'
					,width:650
					,params : {
									idEntidad:'${asunto.id}'
									,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'
									,tienePerfilGestor: ${esGestor}
									,tienePerfilSupervisor: ${esSupervisor}
							}
				});
				w.on(app.event.DONE, function(){w.close();});
						w.on(app.event.CANCEL, function(){w.close(); });
					}
					
				});
		
		<c:if test="${tareaPendiente!=null}">
			var botonResponder = new Ext.Button({
				text:'<s:message code="comunicacion.responder" text="**Responder" />'
				,iconCls : 'icon_responder_comunicacion'
				,disabled: false
				,handler:function(){
		           	var w = app.openWindow({
						flow : 'tareas/generarNotificacion'
						,title : '<s:message code="" text="Notificacion" />'
						,width:650
						,params : {
									idEntidad:'${asunto.id}'
									,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'
									,descripcion:'<s:message text="${tareaPendiente.descripcionTarea}" javaScriptEscape="true" />'
									,fecha: '${asunto.fechaCreacionFormateada}'
									,situacion: '${asunto.estadoItinerario.descripcion}'
									,idTareaAsociada:'${tareaPendiente.id}'
								    ,tienePerfilGestor: ${esGestor}
									,tienePerfilSupervisor: ${esSupervisor}		
								}
						});
						w.on(app.event.DONE, function(){
							w.close();
							app.contenido.activeTab.doAutoLoad();
						});
						w.on(app.event.CANCEL, function(){w.close(); });
					}
			});
		</c:if>
	</c:if>
	page.add(panel);
	
	<sec:authorize ifAllGranted="CAMBIAR-SUPERVISOR-ASUNTO">
	
	/**
	 * funcion para abrir formulario para asignar otro supervisor al asunto
	 * @param {Object} temporal true si la asignacion es temporal (por vacaciones), false si es definitiva
	 */
	var handlerCambioSupervisor=function(titulo,temporal){
		var w = app.openWindow({
				flow : 'asuntos/cambioSupervisorAsunto'
				,title : titulo
				,width:870
				,params : {
							idAsunto:'${asunto.id}'
							,cambioSupervisor:'true'
							,temporal:temporal
						}
				});
				w.on(app.event.DONE, function(){
					w.close();
					cerrarTab('<s:message code="asuntos.supervisorCambiado" text="**Supervisor cambiado" />');
					app.reloadFav();
				});
				w.on(app.event.CANCEL, function(){w.close(); });
	};
	/**
	 * Funcion para reasignarse el asunto cuando se cambio de supervisor por vacaciones
	 */
	var reasignarAsunto=function(){
		maskAll();
		page.webflow({
			flow: 'asuntos/reasignarAsuntoSupervisorOriginal' 
				,eventName: 'reasignarAsunto'
				,params:{idAsunto:${asunto.id}}
				,success: function(){
					recargarTab('<s:message code="asuntos.reasignado" text="**Asunto Reasignado" />');
				}
		});
	}
	
	</sec:authorize>
	
	var arrayAcciones = new Array();
	
	<c:if test="${esSupervisor || esGestor}">
		if(${asunto.estaPropuesto} == false) {
		   panel.getTopToolbar().add(botonComunicacion);
		   <c:if test="${tareaPendiente!=null}">
			   	panel.getTopToolbar().add('-');
			   	panel.getTopToolbar().add(botonResponder);
		   </c:if>
		 
		}
		arrayAcciones[arrayAcciones.length] = {
			text:'<s:message code="asuntos.cambiogestor" text="**Cambiar el Gestor" />'
			,iconCls : 'icon_cambio_gestor'
			,handler:function(){
	           	var w = app.openWindow({
					flow : 'asuntos/cambioGestorAsunto'
					,title : '<s:message code="asuntos.cambiogestor" text="Cambiar gestor" />'
					,width:870
					,params : {
								idAsunto:'${asunto.id}'
								,cambioGestor:'true'
							}
					});
					w.on(app.event.DONE, function(){
						w.close();
						app.contenido.activeTab.doAutoLoad();
						app.reloadFav();
					});
					w.on(app.event.CANCEL, function(){w.close(); });
			}
		};
	</c:if>
	
	
	<sec:authorize ifAllGranted="CAMBIAR-SUPERVISOR-ASUNTO">
	
	//Es supervisor del asunto y no ha sido reasignado temporalmente por vacaciones
	<c:if test="${esSupervisor && !asunto.reasignadoPorVacaciones}">
		arrayAcciones[arrayAcciones.length] = {
			text:'<s:message code="asuntos.cambioSupervisor" text="**Cambiar el Supervisor" />'
			,iconCls : 'icon_cambio_supervisor'
			,handler:function(){
				handlerCambioSupervisor('<s:message code="asuntos.cambioSupervisor" text="**Cambiar el Supervisor" />',false);	
			}
		};
		arrayAcciones[arrayAcciones.length] = {
			text:'<s:message code="asuntos.cambioSupervisorTemp" text="**Cambiar el Supervisor Temp" />'
			,iconCls : 'icon_cambio_supervisor_temporal'
			,handler:function(){
				handlerCambioSupervisor('<s:message code="asuntos.cambioSupervisorTemp" text="**Cambiar el Supervisor Temp" />',true);	
			}
		};
	</c:if>
	
	//es el supervisor original, pero no es supervisor actual del asunto se muestra el boton para reasignarse el asunto
	<c:if test="${esSupervisorOriginal && !esSupervisor}">
		arrayAcciones[arrayAcciones.length] = {
			text:'<s:message code="asuntos.reasignarAsuntoSupervisor" text="**Reasignarme el Asunto" />'
			,iconCls : 'icon_reasignar_supervisor_asunto'
			,handler:function(){
				reasignarAsunto();	
			}
		};
	</c:if>				
	</sec:authorize>
	
	if (arrayAcciones.length > 0)
	{	
		var menuAcciones = 
		{
			text : '<s:message code="asunto.menu.cambios" text="**Cambiar gestor/supervisor" />'
			,menu : arrayAcciones
		};
				
		panel.getTopToolbar().add(menuAcciones);	
	}		
		
	
	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			
			if (asuntoTabPanel.getActiveTab() != null && asuntoTabPanel.getActiveTab().initialConfig.nombreTab != null)
				app.abreAsuntoTab(${asunto.id},'${asunto.nombre}', asuntoTabPanel.getActiveTab().initialConfig.nombreTab);
			else
				app.abreAsunto(${asunto.id},'${asunto.nombre}');
			
			
		}
	});
	
	panel.getTopToolbar().add(buttons);
	
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	panel.getTopToolbar().add(botonRefrezcar);

	
</fwk:page>
