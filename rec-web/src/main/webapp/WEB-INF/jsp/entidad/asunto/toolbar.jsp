<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>




function(entidad,page){

	var toolbar=new Ext.Toolbar();

	toolbar.get = function(id){
      return entidad.get("data").toolbar[id];
  }

<%--
DESHABILITADO PARA USAR LAS OPCIONES DE LA AGENDA
	var botonComunicacion = new Ext.Button({
			text:'<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicación" />'
			,iconCls : 'icon_comunicacion'
			,handler:function(){
			var w = app.openWindow({
				flow : 'tareas/generarTarea'
				,title : '<s:message code="" text="Comunicacion" />'
				,width:650
				,params : {
								idEntidad : toolbar.get('asuntoId')
								,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'
								,tienePerfilGestor: toolbar.get('esGestor')
								,tienePerfilSupervisor: toolbar.get('esSupervisor')
						}
			});
			w.on(app.event.DONE, function(){w.close();});
					w.on(app.event.CANCEL, function(){w.close(); });
				}
				
			});
--%>
			
			<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>

var botonFinalizarAsunto =  new Ext.Button({
			text:'Finalizar asunto'
			,iconCls : 'icon_menos'
			,id:'botonFinalizarAsunto'
			,handler:function(){
				
				if(data.toolbar['puedeFinalizarAsunto'] == true){
					
						var w = app.openWindow({
							flow : 'plugin.mejoras.asuntos.finalizarAsunto'
							,title : 'Finalizar asunto'
							,width:650
							,params : {
											idAsunto : data.toolbar['asuntoId']
											
									}
						});
						w.on(app.event.DONE, function(){
							w.close();
							entidad.refrescar();
						});
								w.on(app.event.CANCEL, function(){w.close(); });
				}else{
					alert('Debe ser supervisor para finalizar el asunto');
				}
			}
				
			});
<%--		
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
									idEntidad:toolbar.get('asuntoId')
									,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_ASUNTO" />'
									,descripcion: toolbar.get('descripcionTarea')
									,fecha: toolbar.get('fechaCreacionFormateada')
									,situacion: toolbar.get('estadoItinerario')
									,idTareaAsociada:toolbar.get('tareaPendiente')
								    ,tienePerfilGestor: toolbar.get('esGestor')
									,tienePerfilSupervisor: toolbar.get('{esSupervisor')		
								}
						});
						w.on(app.event.DONE, function(){
							w.close();
							app.contenido.activeTab.doAutoLoad();
						});
						w.on(app.event.CANCEL, function(){w.close(); });
					}
			});

	
	toolbar.add(botonResponder);
--%>	
	var botonCambioGestor = new Ext.menu.Item({
		text:'<s:message code="asuntos.cambiogestor" text="**Cambiar el Gestor" />'
		,iconCls : 'icon_cambio_gestor'
		,handler:function(){
			var w = app.openWindow({
				flow : 'asuntos/cambioGestorAsunto'
				,title : '<s:message code="asuntos.cambiogestor" text="Cambiar gestor" />'
				,width:870
				,params : {
						idAsunto:toolbar.get('asuntoId')
						,cambioGestor:'true'
						,tienePerfilGestor: toolbar.get('esGestor')		
					}
			});
			w.on(app.event.DONE, function(){
				w.close();
				entidad.refrescar();
			});
			w.on(app.event.CANCEL, function(){w.close(); });
		}
	});

	var tieneFuncionesSupervisor = false;
	var tieneFuncionesCambioGestorHP = false;

	<sec:authorize ifAllGranted="CAMBIAR-GESTORHP">
		var handlerCambioGestorHP=function(titulo,temporal){
			var w = app.openWindow({
					flow : 'plugin/ugas/asuntos/plugin.ugas.asuntos.cambioGestorHP'
					,title : titulo
					,width:350
					,closable:true
					,params : {
							idAsunto:toolbar.get('asuntoId')
							,cambioSupervisor:'true'
							,temporal:temporal
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
						entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){w.close(); });
		};

		var botonCambioGestorHP = new Ext.menu.Item({
				text:'<s:message code="asuntos.cambioGestorHP.cambio" text="**Cambiar Gestor HP" />'
				,iconCls : 'icon_cambio_gestor'
				,handler:function(){
					handlerCambioGestorHP('<s:message code="asuntos.cambioGestorHP.cambio" text="**Cambiar Gestor HP" />',true);	
				}
		});

		tieneFuncionesCambioGestorHP = true;
			
	</sec:authorize>

	<sec:authorize ifAllGranted="CAMBIAR-SUPERVISOR-ASUNTO">
		var handlerCambioSupervisor=function(titulo,temporal){
			var w = app.openWindow({
					flow : 'asuntos/cambioSupervisorAsunto'
					,title : titulo
					,width:870
					,params : {
								idAsunto:toolbar.get('asuntoId')
								,cambioSupervisor:'true'
								,temporal:temporal
							}
					});
					w.on(app.event.DONE, function(){
						w.close();
						entidad.refrescar();
					});
					w.on(app.event.CANCEL, function(){w.close(); });
		};

		

		var botonCambioSupervisor1 = new Ext.menu.Item({
				text:'<s:message code="asuntos.cambioSupervisor" text="**Cambiar el Supervisor" />'
				,iconCls : 'icon_cambio_supervisor'
				,handler:function(){
					handlerCambioSupervisor('<s:message code="asuntos.cambioSupervisor" text="**Cambiar el Supervisor" />',false);	
				}
			});

		var botonCambioSupervisor2 = new Ext.menu.Item({
			text:'<s:message code="asuntos.cambioSupervisorTemp" text="**Cambiar el Supervisor Temp" />'
			,iconCls : 'icon_cambio_supervisor_temporal'
			,handler:function(){
				handlerCambioSupervisor('<s:message code="asuntos.cambioSupervisorTemp" text="**Cambiar el Supervisor Temp" />',true);	
			}
		});

		var botonCambioSupervisor3 = new Ext.menu.Item({
				text:'<s:message code="asuntos.reasignarAsuntoSupervisor" text="**Reasignarme el Asunto" />'
				,iconCls : 'icon_reasignar_supervisor_asunto'
				,handler:function(){
					maskAll();
					page.webflow({
						flow: 'asuntos/reasignarAsuntoSupervisorOriginal' 
						,eventName: 'reasignarAsunto'
						,params:{idAsunto:toolbar.get('asuntoId')}
						,success: function(){
							entidad.refrescar();
						}
					});
				}
		});

		

		
		if(tieneFuncionesCambioGestorHP) {
			toolbar.add({
				text : '<s:message code="asunto.menu.cambios" text="**Cambiar gestor/supervisor" />'
				,id : 'asunto-menu-menuGestores'
				,menu : [ botonCambioGestor, botonCambioSupervisor1, botonCambioSupervisor2, botonCambioSupervisor3, botonCambioGestorHP]
			});
		}
		else{
			toolbar.add({
				text : '<s:message code="asunto.menu.cambios" text="**Cambiar gestor/supervisor" />'
				,id : 'asunto-menu-menuGestores'
				,menu : [ botonCambioGestor, botonCambioSupervisor1, botonCambioSupervisor2, botonCambioSupervisor3]
			});
		}
		
		tieneFuncionesSupervisor = true;
	</sec:authorize>

	

	if (!tieneFuncionesSupervisor ){

		if(tieneFuncionesCambioGestorHP) {
			toolbar.add({
				text : '<s:message code="asunto.menu.cambios" text="**Cambiar gestor/supervisor" />'
				,id : 'asunto-menu-menuGestores'
				,menu : [ botonCambioGestor, botonCambioGestorHP]
			});
		}
		else{
			toolbar.add({
				text : '<s:message code="asunto.menu.cambios" text="**Cambiar gestor/supervisor" />'
				,id : 'asunto-menu-menuGestores'
				,menu : [ botonCambioGestor]
			});
		}	
	}
	
	toolbar.setValue = function(data){
		
		function showHide(action, menu){
			<%--
			if (action){
				Ext.getCmp(menu).show();
			}else{
			 --%>
				Ext.getCmp(menu).hide();
			<%--} --%>

		}
		
		var esGestor = toolbar.get('esGestor');
		var esSupervisor = toolbar.get('esSupervisor');
		var esSupervisorOriginal = toolbar.get('esSupervisorOriginal');
		var puedeFinalizarAsunto = toolbar.get('puedeFinalizarAsunto');

		var esVisible = [];
		
		
		if(data.cabecera['estado'] == "Cerrado"){
			esVisible.push([botonFinalizarAsunto, (false)]);
		}
		else{
			esVisible.push([botonFinalizarAsunto, ( puedeFinalizarAsunto && true)]);
		}
			
		<%--esVisible.push([botonResponder, (esSupervisor || esGestor) && (toolbar.get('estaPropuesto')==false) && (toolbar.get("tareaPendiente")!="") ]);--%>
		esVisible.push([botonCambioGestor, (esSupervisor || esGestor)]);
		
		<sec:authorize ifAllGranted="CAMBIAR-SUPERVISOR-ASUNTO">
			esVisible.push([botonCambioSupervisor1, (esSupervisor && (toolbar.get('reasignadoPorVacaciones')==false)) ||  (tieneFuncionesCambioGestorHP && tieneFuncionesSupervisor) ]);
			esVisible.push([botonCambioSupervisor2, esSupervisor && (toolbar.get('reasignadoPorVacaciones')==false)  ]);
			esVisible.push([botonCambioSupervisor3, esSupervisorOriginal && !esSupervisor  ]);
		</sec:authorize>
		
		showHide( (esSupervisor || esGestor || (esSupervisorOriginal && !esSupervisor)), 'asunto-menu-menuGestores');
		
		var condition = '';
		for (i=0; i < buttonsL_asunto.length; i++){
			
		
			if (buttonsL_asunto[i].condition!=null && buttonsL_asunto[i].condition!=''){
				condition = eval(buttonsL_asunto[i].condition);
				esVisible.push([buttonsL_asunto[i], condition]);
			}
		}
		for (i=0; i < buttonsR_asunto.length; i++){
			if (buttonsR_asunto[i].condition!=null && buttonsR_asunto[i].condition!=''){
				condition = eval(buttonsR_asunto[i].condition);
				esVisible.push([buttonsR_asunto[i], condition]);
			}
		}

		entidad.setVisible(esVisible);
	}
 
	toolbar.getValue = function(data){}


	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			entidad.refrescar();
		}
	});
	
	<%-- BKREC-1537 Como ya se va a adjuntar un botonFinalizar, eliminamos el que viene en buttosL_asunto ya que hacen lo mismo --%>
	for (i=0; i < buttonsL_asunto.length; i++){
		if(buttonsL_asunto[i].getText().localeCompare("Finalizar asunto") == 0)
			buttonsL_asunto.remove(buttonsL_asunto[i]);
		<%--PRODUCTO-671 Boton 'Alta Direcciones' borrado para usuarios con funcion SOLO_CONSULTA --%>
		if(buttonsL_asunto[i].getText().localeCompare("Alta de Direcciones") == 0) {
			<sec:authorize ifAllGranted="SOLO_CONSULTA">buttonsL_asunto.remove(buttonsL_asunto[i]);</sec:authorize>
		}
	}
	
	toolbar.add(botonFinalizarAsunto);
	toolbar.add(buttonsL_asunto);
	toolbar.add('->');
	toolbar.add(buttonsR_asunto);
	toolbar.add(botonRefrezcar);
	toolbar.add(app.crearBotonAyuda());
	return toolbar;
};
