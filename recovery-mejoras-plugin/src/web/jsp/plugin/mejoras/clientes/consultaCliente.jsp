<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>

<fwk:page>

/**
 * Interfaz de Usuario para ABM de clientes
 * 
 * @type {} TabPanel
 */
	var buttonsR = <app:includeArray files="${buttonsRight}" />;
	var buttonsL = <app:includeArray files="${buttonsLeft}" />;
		

	//envuelve una lista de controles en un fieldSet
	var creaFieldSet = function(items, config){
		var ft = new Ext.form.FieldSet({
			autoHeight:true
			,labelStyle:'font-weight:bolder'
			,border : false
			,items:items
		});
		return ft;
	};
	
	
	var idCliente;
	var idTareaPendiente;
	var descEstado;
	var fechaCrear;
	
	var isRecuperacion = false;
	var isSeguimiento = false;

	<c:if test="${arquetipoPersona != null && arquetipoPersona.itinerario.dDtipoItinerario.itinerarioRecuperacion == true}">
		isRecuperacion = true;
	</c:if>
	
	<c:if test="${arquetipoPersona != null && arquetipoPersona.itinerario.dDtipoItinerario.itinerarioSeguimiento == true}">
		isSeguimiento = true;
	</c:if>
	
	var arquetipoGestion = false;
	<c:if test="${arquetipoPersona != null && arquetipoPersona.gestion == true}">
		arquetipoGestion = true;
	</c:if>
		
	//Permitimos que el arquetipo sin gestión pueda generar un expediente ---- PEDIDO POR AGUSTÍN (25/11/09) ----
	arquetipoGestion = true;
	
	var tieneContratosParaCliente = false;
	<c:if test="${tieneContratos == true}">
		tieneContratosParaCliente = true;
	</c:if>
	
	
		
	buscarCliente();
	
	//Verifica si existe el cliente para la persona seleccionada.
	function buscarCliente(){
		if('${persona.clienteActivo}' != ''){
			idCliente='${persona.clienteActivo.id}';
			idTareaPendiente = '${tareaPendiente.id}';
			descEstado = '${persona.clienteActivo.estadoItinerario.descripcion}';
		}
	};
	
		
		
	
	/**
	 * funcion para crear un grid
	 * @param {} myStore el Store
	 * @param {} columnModel el ColumnModel
	 * @param {} config parametros de configuracion
	 * @return {} Ext.grid.GridPanel
	 */
	function createGrid(myStore,columnModel, config){
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
		if (config.autoWidth) {
			cfg.autoWidth = config.autoWidth;
		}else{
			cfg.width= config.width || (columnModel.getTotalWidth()+25)
		};
		var myGrid = new Ext.grid.GridPanel(cfg)
		return myGrid;
	};
	
	
	
    
	
	<%@ include file="../../../main/comunicaciones.jsp" %>
	
	
	var perfilGestor = '${persona.clienteActivo.idGestorActual}';
	var perfilSupervisor = '${persona.clienteActivo.idSupervisorActual}';

	var isGestor=false;
	var isSupervisor=false;
	if(permisosVisibilidadGestorSupervisor(perfilGestor)) {
		isGestor=true;
	}
	if(permisosVisibilidadGestorSupervisor(perfilSupervisor)) {
		isSupervisor=true;
	}

	var idExpediente = '${expedientePropuesto.id}' || null;
	<c:if test="${expedientePropuesto!=null}">
		var decideBorrar = function(boton) {
				if (boton=='yes'){
						page.webflow({
							flow : 'expedientes/borrarCreacionManualExpediente'
							,params : {idExpediente : idExpediente, idPersona : '${persona.id}' }
							,success : function() { page.fireEvent(app.event.CANCEL); }
							,scope:this
						});
						recargarTab();
				}
		};
	</c:if>
	//Creacion manual de expediente por un superusuario
	//Se asignan variables
	var tituloCreacionExpedienteRecuperacion='<s:message code="expedientes.creacion.recuperacion" text="**Expediente de Recuperación" />';
	var tituloCreacionExpedienteSeguimiento='<s:message code="expedientes.creacion.seguimiento" text="**Expediente de Seguimiento" />';
	var proponer=true;
	<sec:authorize ifAllGranted="SUPERUSUARIO_CREACION_EXPEDIENTE">
	
	proponer=false;
	tituloCreacionExpedienteRecuperacion='<s:message code="expedientes.creacion.recuperacionSinProponer" text="**Crear Expediente de Recuperación" />';
	tituloCreacionExpedienteSeguimiento='<s:message code="expedientes.creacion.seguimientoSinProponer" text="**Crear Expediente de Seguimiento" />';
	
	</sec:authorize>

	//aca no va un menu, sino un boton u otro segun estado y Perfil
	//Solicitar Creacion Manual Expediente
	//Solicitar Exclusion Telecobro
	//Solicitar Exclusioin Recobro

	<sec:authorize ifAnyGranted="SOLICITAR_EXP_MANUAL_RECOBRO, SOLICITAR_EXP_MANUAL_SEGUIMIENTO, SOLICITAR_EXP_MANUAL_RECUPERACIONES">
		//Menú Creación Manual Expediente: book_add.png 
		//Creación Manual Expediente: book_go.png 
		//Rechazar Creación Manual Expediente: book_delete.png
		var menuExpediente={
					text : '<s:message code="expedientes.creacion.titulo" text="**Creación Manual Expediente" />'
					,menu:[
					   <sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL_RECUPERACIONES">
						   {
								text : tituloCreacionExpedienteRecuperacion
								,iconCls : 'icon_expediente_manual'
								,handler : function(){
									var w = app.openWindow({
										flow:'expedientes/creacionManualExpediente'
										,width:870
										,closable:false
										,title : tituloCreacionExpedienteRecuperacion
										,params:{idPersona:'${persona.id}', isGestor:isGestor, isSupervisor:isSupervisor,proponer:proponer}
									});
									w.on(app.event.DONE, function(){
										w.close();
										recargarTab();
									});
									w.on(app.event.CANCEL, function(){ w.close(); });
								}
							}
						</sec:authorize>
						<sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL_SEGUIMIENTO">
							<sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL_SEGUIMIENTO">,</sec:authorize>
						    {
								text : tituloCreacionExpedienteSeguimiento
								,iconCls : 'icon_expediente_manual'
								,handler : function(){
									var w = app.openWindow({
										flow:'expedientes/creacionManualExpedienteSeguimiento'
										,width:870
										,closable:false
										,title : tituloCreacionExpedienteSeguimiento
										,params:{idPersona:'${persona.id}', isGestor:isGestor, isSupervisor:isSupervisor,proponer:proponer}
									});
									w.on(app.event.DONE, function(){
										w.close();
										recargarTab();
									});
									w.on(app.event.CANCEL, function(){ w.close(); });
								}
							}
						</sec:authorize>
						<c:if test="${expedientePropuesto!=null}">
							,{
								text : '<s:message code="expedientes.creacion.rechazar" text="**Rechazar Creación Manual Expediente" />'
								,iconCls : 'icon_cancelar_expediente'
								,handler : function(){
									Ext.Msg.confirm(fwk.constant.confirmar, '<s:message code="expedientes.creacion.cancelar" text="**¿Cancelar y borrar el expediente creado?" />', decideBorrar, this);
								}
							}
						</c:if>
					]
				};
	</sec:authorize>

	//Buscamos la solapa que queremos abrir
	var nombreTab = '${nombreTab}';
	var nrotab = 0;
	var tabs =  <app:includeArray files="${tabsCliente}" />;
	var buttons =  <app:includeArray files="${buttonsCliente}" />;
	
		
	//tab activo por nombre
	if (nombreTab != null){
		for(var i=0;i< tabs.length;i++){
			if (tabs[i].initialConfig && nombreTab==tabs[i].initialConfig.nombreTab){
				nrotab = i;
				break;
			}
		}
	}
	
	
	
	var clienteTabPanel=new Ext.TabPanel({
		items: tabs
		,layoutOnTabChange:true 
		//,frame:true
		,autoScroll:true
		,activeItem:nrotab
		,autoHeight:true
		,autoWidth : true
		,border : false
		,enableTabScroll : true
			
	});
	//clienteTabPanel.setTitle(titulo);
	
	

	var perfiles = app.usuarioLogado.perfiles;

	var recargarTab = function(){
		setTimeout("app.contenido.activeTab.doAutoLoad()",3);
	}
	var botonComunicacion = new Ext.Button({
				text:'<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="**Comunicación" />'
				,iconCls : 'icon_comunicacion'
				,disabled: '${persona.clienteActivo}' == '' 
				,handler:function(){
					var w = app.openWindow({
						flow : 'tareas/generarTarea'
						,title : '<s:message code="menu.clientes.consultacliente.menu.comunicacion" text="Comunicacion" />'
						,width:650 
						,params : {
								idEntidad:'${persona.clienteActivo.id}'
								,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE" />'
								,tienePerfilGestor: isGestor || false
								,tienePerfilSupervisor: isSupervisor || false
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
			if (clienteTabPanel.getActiveTab() != null && clienteTabPanel.getActiveTab().initialConfig.nombreTab != null)
				app.abreClienteTab(${persona.id}, '${apellidoNombre}', clienteTabPanel.getActiveTab().initialConfig.nombreTab);
			else
				app.abreCliente(${persona.id}, '${apellidoNombre}');
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
						,width:400 
						,params : {
								idEntidad:'${persona.clienteActivo.id}'
								,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_CLIENTE" />'
								,descripcion:'<s:message text="${tareaPendiente.descripcionTarea }" javaScriptEscape="true" />'
								,fecha: '${persona.fechaCreacionFormateada}'
								,situacion: '${persona.clienteActivo.estadoItinerario.descripcion}'
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


	var panel = new Ext.Panel({		
		autoHeight : true
		,items : [clienteTabPanel]
		,tbar : new Ext.Toolbar()
		,id:'cli-'+'${persona.id}' 
	});
	
	page.add(panel);
	
	<c:if test="${noHayExpedientes || expedientePropuesto!=null}">

		<sec:authorize ifAnyGranted="SOLICITAR_EXP_MANUAL_RECOBRO, SOLICITAR_EXP_MANUAL_SEGUIMIENTO, SOLICITAR_EXP_MANUAL_RECUPERACIONES">

			var menuExpedienteNuevo = new Array();
			var indexCrear = 0;
			var indexCrearSeg = 0;
			var indexRechazar = 1;

			<sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL_SEGUIMIENTO, SOLICITAR_EXP_MANUAL_RECUPERACIONES">
				indexCrearSeg = 1;
				indexRechazar = 2;
			</sec:authorize>
			
			<sec:authorize ifNotGranted="SUPERUSUARIO_CREACION_EXPEDIENTE">
			if( (permisosVisibilidadGestorSupervisor(perfilSupervisor) == true || permisosVisibilidadGestorSupervisor(perfilGestor) == true)
			     || idCliente == null ) {
			</sec:authorize>
					
				<sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL_RECOBRO">
					menuExpedienteNuevo[indexCrear] = menuExpediente.menu[indexCrear];
					<c:if test="${expedientePropuesto!=null && expedientePropuesto.seguimiento}">
						menuExpedienteNuevo[indexCrear].disabled=true;
					</c:if>
					
					//Comprobamos que si es un cliente de seguimiento no se puede crear un expediente de recuperación
					//Si no es un arquetipo que genere gestión, no le permitimos crear
					//Si no tiene contratos tampoco le dejamos crear el expediente					
					if (isSeguimiento  || !arquetipoGestion || !tieneContratosParaCliente){
						menuExpedienteNuevo[indexCrear].disabled=true;				
					}
				</sec:authorize>
				
				<sec:authorize ifAllGranted="SOLICITAR_EXP_MANUAL_SEGUIMIENTO">
					menuExpedienteNuevo[indexCrearSeg] = menuExpediente.menu[indexCrearSeg];
					<c:if test="${expedientePropuesto!=null && !expedientePropuesto.seguimiento}">
						menuExpedienteNuevo[indexCrearSeg].disabled=true;
					</c:if>
					
					//Comprobamos que si es un cliente de recuperación no se puede crear un expediente de seguimiento
					//Si no es un arquetipo que genere gestión, no le permitimos crear
					//Si no tiene contratos tampoco le dejamos crear el expediente					
					if (isRecuperacion || !arquetipoGestion || !tieneContratosParaCliente){
						menuExpedienteNuevo[indexCrearSeg].disabled=true;
					}
				</sec:authorize>
				
			<sec:authorize ifNotGranted="SUPERUSUARIO_CREACION_EXPEDIENTE">
			}
			</sec:authorize>
	
			<c:if test="${expedientePropuesto!=null}">
				if(permisosVisibilidadGestorSupervisor(perfilSupervisor) == true) {
					menuExpedienteNuevo[indexRechazar] = menuExpediente.menu[indexRechazar];
				}
			</c:if>
			
			
			
			<sec:authorize ifNotGranted="SUPERUSUARIO_CREACION_EXPEDIENTE">
			if(permisosVisibilidadGestorSupervisor(perfilSupervisor) == true || permisosVisibilidadGestorSupervisor(perfilGestor) == true
			     || idCliente == null ){
			</sec:authorize>
			
				menuExpediente.menu = menuExpedienteNuevo;
				
				panel.getTopToolbar().add(menuExpediente);
			
			<sec:authorize ifNotGranted="SUPERUSUARIO_CREACION_EXPEDIENTE">
			}
			</sec:authorize>
			
		</sec:authorize>
    </c:if>

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
                    ,params:{idCliente:'${persona.clienteActivo.id}'}
                });
                w.on(app.event.DONE, function(){
                    w.close();
                    recargarTab();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });   
            }
        };

        var opDecidicrSolicitudTelecobro = {
            text : '<s:message code="clientes.menu.aceptarRechazarExclusion" text="**Aceptar/Rechazar Exclusion Telecobro" />'
            ,iconCls : 'icon_decision_telecobro'
            ,handler : function(){
                var w = app.openWindow({
                    flow : 'clientes/decisionTelecobro'
                    ,title : '<s:message code="clientes.menu.aceptarRechazarExclusion" text="Aceptar/Rechazar Exclusion Telecobro" />'
                    ,width:400 
                    ,params:{idEntidad:'${persona.clienteActivo.id}'}
                });
                w.on(app.event.DONE, function(){
                    w.close();
                    recargarTab();
                });
                w.on(app.event.CANCEL, function(){ w.close(); });
                w.on(app.event.OPEN_ENTITY, function(){ w.close(); });
            }};

        var codigoTipoTarea="${subtipoTareaTelecobro}";
        
        var menuTelecobro;
        if(codigoTipoTarea == app.subtipoTarea.CODIGO_TAREA_VERIFICAR_TELECOBRO) {
            menuTelecobro={
                text : '<s:message code="clientes.menu.solicitarExclusionTelecobro" text="**Exclusion Telecobro" />'
                ,menu:[opSolicitarExclusionTelecobro]};
        }
        if(codigoTipoTarea == app.subtipoTarea.CODIGO_TAREA_SOLICITUD_EXCLUSION_TELECOBRO) {
            menuTelecobro={
                text : '<s:message code="clientes.menu.solicitarExclusionTelecobro" text="**Exclusion Telecobro" />'
                ,menu:[opDecidicrSolicitudTelecobro]};
        }
        if(codigoTipoTarea.trim() != "") {
    	   panel.getTopToolbar().add(menuTelecobro);
        }
	</sec:authorize>
	
	if(permisosVisibilidadGestorSupervisor(perfilGestor) == true || permisosVisibilidadGestorSupervisor(perfilSupervisor) == true){
		panel.getTopToolbar().add(botonComunicacion);
		panel.getTopToolbar().add('-');
	}
	
	<sec:authorize ifAllGranted="RESPONDER">
		if(permisosVisibilidadGestorSupervisor(perfilSupervisor) == true || permisosVisibilidadGestorSupervisor(perfilGestor) == true){
			panel.getTopToolbar().add(botonResponder);
			panel.getTopToolbar().add('-');	
		}
	</sec:authorize>

	panel.getTopToolbar().add(buttonsL);
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(buttonsR);
	

	//Si es un cliente
	if (idCliente != null)
	{		
		var iconClass = null;
		
		if (isRecuperacion)
		{	
			iconClass = 'icon_cliente_R';
		}
		else if (isSeguimiento)
		{
			iconClass = 'icon_cliente_S';	
		}
	
		if (iconClass != null)
		{
			var cmp = Ext.getCmp('cliente${persona.id}');
			Ext.fly(cmp.ownerCt.getTabEl(cmp)).child('.x-tab-strip-text').replaceClass(cmp.iconCls, iconClass);
			cmp.setIconClass(iconClass);
		}
	}
	
	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(botonRefrezcar);

</fwk:page>
