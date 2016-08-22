<%@page pageEncoding="utf-8" contentType="text/html; charset=UTF-8" %>

function(entidad,page){

	var toolbar=new Ext.Toolbar();

	var tituloCreacionExpedienteRecuperacion='<s:message code="expedientes.creacion.recuperacion" text="**Expediente de Recuperación" />';
	var tituloCreacionExpedienteSeguimiento='<s:message code="expedientes.creacion.seguimiento" text="**Expediente de Seguimiento" />';
	var proponer=true;
	<sec:authorize ifAllGranted="SUPERUSUARIO_CREACION_EXPEDIENTE">
		proponer=false;
		tituloCreacionExpedienteRecuperacion='<s:message code="expedientes.creacion.recuperacionSinProponer" text="**Crear Expediente de Recuperación" />';
		tituloCreacionExpedienteSeguimiento='<s:message code="expedientes.creacion.seguimientoSinProponer" text="**Crear Expediente de Seguimiento" />';
	</sec:authorize>

	var decideBorrar = function(boton) {
		if (boton=='yes'){
				page.webflow({
					flow : 'expedientes/borrarCreacionManualExpediente'
					,params : {idExpediente : toolbar.getIdExpediente(), idPersona : toolbar.getIdPersona() }
					,success: function() {
						Ext.Msg.alert('<s:message code="app.informacion" text="**Información" />','<s:message code="" text="Expediente cancelado" />', entidad.refrescar());
					}
					,scope:this
				});
				//recargarTab();
		}
	};

	var rechazarExpedienteButton = new Ext.menu.Item({
		text : '<s:message code="expedientes.creacion.rechazar" text="**Rechazar Creación Manual Expediente" />'
		,iconCls : 'icon_cancelar_expediente'
		,handler : function(){
			Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="expedientes.creacion.cancelar" text="**Cancelar y borrar el expediente creado?" />', decideBorrar, this);
		}
	});
	
	var creacionExpedienteRecobroButton = new Ext.menu.Item({
		text :'<s:message code="expedientes.creacion.expedienteManualRecobro" text="**Creación expediente manual recobro" />'
		,iconCls : 'icon_expediente_manual'
		,handler : function(){
			var w = app.openWindow({
				flow:'plugin/recobroWeb/expedientes/creacionManualExpediente'
				,width:870
				,closable:false
				,title : tituloCreacionExpedienteRecuperacion
				,params:{idPersona:toolbar.getIdPersona(), isGestor:toolbar.isGestor(), isSupervisor:toolbar.isSupervisor(),proponer:proponer}
			});
			w.on(app.event.DONE, function(){
				w.close();
				//recargarTab();
				entidad.refrescar();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var creacionExpedienteButton = new Ext.menu.Item({
		text : tituloCreacionExpedienteRecuperacion
		,iconCls : 'icon_expediente_manual'
		,handler : function(){
			var w = app.openWindow({
				flow:'expedientes/creacionManualExpediente'
				,width:870
				,closable:false
				,title : tituloCreacionExpedienteRecuperacion
				,params:{idPersona:toolbar.getIdPersona(), isGestor:toolbar.isGestor(), isSupervisor:toolbar.isSupervisor(),proponer:proponer}
			});
			w.on(app.event.DONE, function(){
				w.close();
				//recargarTab();
				entidad.refrescar();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var creacionExpedienteSeguimientoButton = new Ext.menu.Item({
		text : tituloCreacionExpedienteSeguimiento
		,iconCls : 'icon_expediente_manual'
		,handler : function(){
			var w = app.openWindow({
				flow:'expedientes/creacionManualExpedienteSeguimiento'
				,width:870
				,closable:false
				,title : tituloCreacionExpedienteSeguimiento
				,params:{idPersona: toolbar.getIdPersona(), isGestor:toolbar.isGestor(), isSupervisor:toolbar.isSupervisor(),proponer:proponer}
			});
			w.on(app.event.DONE, function(){
				w.close();
				entidad.refrescar();
				//recargarTab();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
		}
	});

	var tituloCreacionExpedienteRecuperacion='<s:message code="expedientes.creacion.recuperacion" text="**Expediente de Recuperación" />';
	var tituloCreacionExpedienteSeguimiento='<s:message code="expedientes.creacion.seguimiento" text="**Expediente de Seguimiento" />';
	var proponer=true;
	
	<sec:authorize ifAllGranted="SUPERUSUARIO_CREACION_EXPEDIENTE">
		proponer=false;
		tituloCreacionExpedienteRecuperacion='<s:message code="expedientes.creacion.recuperacionSinProponer" text="**Crear Expediente de Recuperación" />';
		tituloCreacionExpedienteSeguimiento='<s:message code="expedientes.creacion.seguimientoSinProponer" text="**Crear Expediente de Seguimiento" />';
	</sec:authorize>

	var menuExpediente={
		text : '<s:message code="expedientes.creacion.titulo" text="**Creación Manual Expediente" />'
		,menu:[
			creacionExpedienteButton
			,creacionExpedienteSeguimientoButton 
			,rechazarExpedienteButton
			,creacionExpedienteRecobroButton
		]
	};

	var botonComunicacion = new Ext.Button({
		text:'<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicación" />'
		,iconCls : 'icon_comunicacion'
		,handler:function(){
			var w = app.openWindow({
				flow : 'tareas/generarTarea'
				,title : '<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="Comunicacion" />'
				,width:650 
				,params : {
						idEntidad : toolbar.getClienteActivoId()
						,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE" />'
						,tienePerfilGestor: toolbar.isGestor() || false
						,tienePerfilSupervisor: toolbar.isSupervisor() || false
				}

			});
			w.on(app.event.DONE, function(){w.close();});
			w.on(app.event.CANCEL, function(){w.close(); });
		}
		
	});
	
	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
			entidad.refrescar();
		}
	});

	var botonResponder = new Ext.Button({
		text:'Responder'
		,iconCls : 'icon_responder_comunicacion'
		,disabled: '${tareaPendiente.id}' == ''
		,handler:function(){
			var w = app.openWindow({
				flow : 'tareas/generarNotificacion'
				,title : '<s:message code="" text="Notificacion" />'
				,width:400 
				,params : {
						idEntidad: toolbar.getClienteActivoId()
						,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE" />'
						,descripcion: toolbar.getDescripcionTareaPendiente()
						,fecha: toolbar.getFechaCreacion()
						,situacion: toolbar.getDescEstado()
						,idTareaAsociada: toolbar.getIdTareaPendiente()
				}
			});
			w.on(app.event.DONE, function(){
				w.close();
				entidad.refrescar();
				//recargarTab();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
			w.on(app.event.OPEN_ENTITY, function(){ w.close(); });
		}
	});
	
	<sec:authorize ifAnyGranted="SOLICITAR_EXP_MANUAL, SOLICITAR_EXP_MANUAL_SEG">
		toolbar.add(menuExpediente);
	</sec:authorize>
	<sec:authorize ifAllGranted="RESPONDER">
		toolbar.add(botonResponder);
	</sec:authorize>
	
	toolbar.add(botonComunicacion);
	toolbar.add(buttonsL_cliente);
	toolbar.add('->');
	
	<sec:authorize ifAllGranted="MENU-TELECOBRO">
        var opSolicitarExclusionTelecobro = {
            text : '<s:message code="clientes.menu.solicitarExclusionTelecobro" text="**Solicitar Exclusion Telecobro" />'
             ,iconCls : 'icon_solicitud_telecobro'
            ,handler : function(){
                var w = app.openWindow({
                    flow:'clientes/exclusionTelecobro'
                    ,width:500
                    ,closable:true
                    ,title : '<s:message code="clientes.menu.solicitarExclusionTelecobro" text="**Solicitar Exclusion de Telecobro" />'
                    ,params:{idCliente:toolbar.getClienteActivoId()}
                });
                w.on(app.event.DONE, function(){
                    w.close();
					entidad.refrescar();
                    //TODO:recargarTab();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });   
            }
        ,id : 'x-cliente-exclusionTelecobro'
        };

        var opDecidicrSolicitudTelecobro = {
            text : '<s:message code="clientes.menu.aceptarRechazarExclusion" text="**Aceptar/Rechazar Exclusion Telecobro" />'
            ,iconCls : 'icon_decision_telecobro'
            ,handler : function(){
                var w = app.openWindow({
                    flow : 'clientes/decisionTelecobro'
                    ,title : '<s:message code="clientes.menu.aceptarRechazarExclusion" text="Aceptar/Rechazar Exclusion Telecobro" />'
                    ,width:400 
                    ,params:{idEntidad:toolbar.getClienteActivoId()}
                });
                w.on(app.event.DONE, function(){
                    w.close();
					entidad.refrescar();
                    //TODO:recargarTab();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });
                w.on(app.event.OPEN_ENTITY, function(){ w.close(); });
            }
          ,id : 'x-cliente-decisionTelecobro'
          };

        var  menuTelecobro={
                text : '<s:message code="clientes.menu.solicitarExclusionTelecobro" text="**Exclusion Telecobro" />'
                ,menu:[opSolicitarExclusionTelecobro,opDecidicrSolicitudTelecobro]
                ,id:'x-cliente-menuTelecobro'
        };

    	   toolbar.add(menuTelecobro);
	</sec:authorize>

	toolbar.add(buttonsR_cliente);
	toolbar.add(botonRefrezcar);
	toolbar.add(app.crearBotonAyuda());

  toolbar.getIdPersona = function(){
	  var data = entidad.get("data");
	  return data.id;
  }
	toolbar.getClienteActivoId = function(){
	  var data = entidad.get("data");
	  return data.idCliente;
	}
	toolbar.isGestor = function(){
	  var data = entidad.get("data");
	  return permisosVisibilidadGestorSupervisor(data.perfilGestor);
	}
	toolbar.isSupervisor = function(){
	  var data = entidad.get("data");
	  return permisosVisibilidadGestorSupervisor(data.perfilSupervisor);
	}
	toolbar.getIdExpediente = function(){
	  var data = entidad.get("data");
	  return data.expedientePropuesto.id;
	}
	toolbar.getDescEstado = function(){
		var data = entidad.get("data");
		return data.descEstado;
	}
	toolbar.getIdTareaPendiente = function(){
		var data = entidad.get("data");
		return data.idTareaPendiente;
	}
	toolbar.getFechaCreacion = function(){
		var data = entidad.get("data");
		return data.fechaCreacion;
	}
	toolbar.getDescripcionTareaPendiente = function(){
		var data = entidad.get("data");
		return data.descripcionTareaPendiente;
	}

	var permiso_SOLICITAR_EXP_MANUAL_SEG  = false <sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL_SEG"> || true </sec:authorize>;
	var permiso_SOLICITAR_EXP_MANUAL  = false <sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL"> || true </sec:authorize>;


	toolbar.setValue = function(data){
		var i;

		var exclusionTelecobro=data.codigoTipoTarea==app.subtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO;
		var decisionTelecobro=data.codigoTipoTarea==app.subtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO;
		
		var esVisible = [
			[menuExpediente, false]
			<sec:authorize ifAnyGranted="SOLICITAR_EXP_MANUAL, SOLICITAR_EXP_MANUAL_SEG">
				,[menuExpediente, data.noHayExpedientes || !data.expedientePropuesto.isNull]
				,[creacionExpedienteButton, permiso_SOLICITAR_EXP_MANUAL]
				,[creacionExpedienteSeguimientoButton, permiso_SOLICITAR_EXP_MANUAL_SEG ]
				,[rechazarExpedienteButton, !data.expedientePropuesto.isNull && toolbar.isSupervisor()] 
				,[creacionExpedienteRecobroButton, permiso_SOLICITAR_EXP_MANUAL]
			</sec:authorize>	
			,[botonComunicacion, toolbar.isSupervisor() || toolbar.isGestor()]
			,[botonResponder, toolbar.isSupervisor() || toolbar.isGestor()]
			<sec:authorize ifAllGranted="MENU-TELECOBRO">
				,['x-cliente-exclusionTelecobro', exclusionTelecobro ]
				,['x-cliente-decisionTelecobro', decisionTelecobro ]
				,['x-cliente-menuTelecobro', exclusionTelecobro || decisionTelecobro]
			</sec:authorize>
		];

		var esEnabled =[
			[botonResponder, data.idTareaPendiente!=''] 
			,[creacionExpedienteButton, (data.expedientePropuesto.isNull || !data.expedientePropuesto.seguimiento) 
					&&  !(data.arquetipoPersona.isSeguimiento || !data.arquetipoPersona.isArquetipoGestion || !data.tieneContratosParaCliente)]
			,[creacionExpedienteSeguimientoButton, (data.expedientePropuesto.isNull || data.expedientePropuesto.seguimiento)
					&& 	!(data.arquetipoPersona.isRecuperacion || !data.arquetipoPersona.isArquetipoGestion || !data.tieneContratosParaCliente)] 
			,[creacionExpedienteRecobroButton, (data.expedientePropuesto.isNull || !data.expedientePropuesto.seguimiento) 
					&&  !(data.arquetipoPersona.isSeguimiento || !data.arquetipoPersona.isArquetipoGestion || !data.tieneContratosParaCliente)]
		];

		var condition = '';
		for (i=0; i < buttonsL_cliente.length; i++){
			if (buttonsL_cliente[i].condition!=null && buttonsL_cliente[i].condition!=''){
				condition = eval(buttonsL_cliente[i].condition);
				esVisible.push([buttonsL_cliente[i], condition]);
			}
		}
		for (i=0; i < buttonsR_cliente.length; i++){
			if (buttonsR_cliente[i].condition!=null && buttonsR_cliente[i].condition!=''){
				condition = eval(buttonsR_cliente[i].condition);
				esVisible.push([buttonsR_cliente[i], condition]);
			}
		}

		return { esVisible : esVisible, esEnabled : esEnabled };

	}

	return toolbar;
};
