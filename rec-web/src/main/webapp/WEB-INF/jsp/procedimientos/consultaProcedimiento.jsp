<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%@page import="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad" %>

<fwk:page>
		var openTab = function(title, flow, params, config){
			var url = '/${appProperties.appName}/'+flow+'.htm';
			config = config || {};
			//si existe, lo mostraremos
			//TODO: controlar en el callback en caso de que tengamos un error
			var autoLoad = {url : url+"?"+Math.random()
					,scripts: true
					,method : 'POST'
					,callback : function(scope, success, response, options){}
					};
			if (params){
				autoLoad.params = params;
			}
			
			//si existe el tab, borraremos el contenido y recargamos
			if (config.id){
				var control = Ext.getCmp(config.id);
				if (control){
					var id =control.el.child('.x-panel').id;
		            Ext.getCmp(config.id).remove(id,true);
					Ext.getCmp(config.id).load(autoLoad);
					control.show();
					return false;
				}
			}
			var cfg = {
				title : title
				,closable : 'true'
				,layout : 'fit'
				,autoScroll : true
				,autoHeight : true
				,iconCls: config.iconCls || ''
				//,autoWidth  : true
				,autoLoad : autoLoad
			};
			if (config.id) cfg.id=config.id;
			procedimientoTabPanel.add(cfg).show();
			return true;
		};



	
	var menuAcciones={
		text : '<s:message code="app.botones.acciones" text="**Acciones" />'
		,menu :[
		{
			text:'Embargo Bienes'
			,iconCls:'icon_embargo_bienes'
			,handler : function(){ 
				openTab("Embargo Bienes","fase2/procedimientos/embargoBienes",{},{iconCls:'icon_embargo_bienes'})
			}	 
		}
		,{
			text:'Interrupcion por recurso'
			,iconCls:'icon_interrupcion_recurso'
			,handler : function(){ 
				openTab("Interrupcion por Recurso","fase2/procedimientos/interrupcionRecurso",{},{iconCls:'icon_interrupcion_recurso'})
			}
		},{
				text:'Propuestas de Acuerdo'
				,iconCls:'icon_acuerdo'
				,handler : function(){ 
					openTab("Propuestas de Acuerdo","fase2/procedimientos/propuestasAcuerdo",{},{iconCls:'icon_acuerdo'})
				}
		},{
			text:'<s:message code="" text="**Decision de Continuidad" />'
		}
		]
	}


	
	

	
	//tab historico
	<%@ include file="tabHistoricoProcedimiento.jsp" %> 
	var historico = createHistoricoProcedimientoTab();
	
	var tabs = <app:includeArray files="${tabsProcedimiento}" />
	
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
	
	var procedimientoTabPanel=new Ext.TabPanel({
		items:tabs
		,layoutOnTabChange:true 
		//,frame:true
		,activeItem:nrotab
		,autoScroll:true
		,autoHeight:true
		,autoWidth : true
		,border : false
			
	});
	var panel = new Ext.Panel({
		autoHeight : true
		,items : [procedimientoTabPanel]
		,tbar : new Ext.Toolbar()
		,id: 'procedimiento-${procedimiento.id}'
	});
	
	page.add(panel);


	var botonDOC = new Ext.Button({
		//name: 'genPDF'
		text: '<s:message code="procedimientos.generarDemanda" text="**Generar demanda hipotecaria" />'
		,iconCls: 'icon_editar_propuesta'
		,handler: function() {
			var flow='politica/formularioDemanda';
			var tipo='generaPDF';
			var params='id='+'${procedimiento.id}'+'&adjuntar=true'+'&REPORT_NAME=formularioDemanda'+'${procedimiento.id}'+'.doc';
			app.openPDF(flow,tipo,params);
        }
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
						idEntidad:'${procedimiento.id}'
						,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
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
				text:'Responder'
				,iconCls : 'icon_responder_comunicacion'
				,disabled: false
				,handler:function(){
		           	var w = app.openWindow({
						flow : 'tareas/generarNotificacion'
						,title : '<s:message code="" text="Notificacion" />'
						,width:400
						,params : {
									idEntidad:'${procedimiento.id}'
									,codigoTipoEntidad: '<fwk:const value="es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad.CODIGO_ENTIDAD_PROCEDIMIENTO" />'
									,descripcion:'<s:message text="${tareaPendiente.descripcionTarea}" javaScriptEscape="true" />'
									,fecha: '${procedimiento.asunto.fechaCreacionFormateada}'
									,situacion: '${procedimiento.asunto.estadoItinerario.descripcion}'
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


	<c:if test="${esSupervisor || esGestor}">
	   panel.getTopToolbar().add(botonComunicacion);
	   <c:if test="${tareaPendiente!=null}">
	   	panel.getTopToolbar().add('-');
	   	panel.getTopToolbar().add(botonResponder);
	   </c:if>
	</c:if>

	var botonRefrezcar = new Ext.Button({
		text: '<s:message code="app.refrezcar" text="**Refrezcar" />'
		,iconCls: 'icon_refresh'
		,handler: function() {
		
			if (procedimientoTabPanel.getActiveTab() != null && procedimientoTabPanel.getActiveTab().initialConfig.nombreTab != null)
				app.abreProcedimientoTab('${procedimiento.id}', '<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />', procedimientoTabPanel.getActiveTab().initialConfig.nombreTab);
			else
				app.abreProcedimiento('${procedimiento.id}', '<s:message text="${procedimiento.nombreProcedimiento}" javaScriptEscape="true" />');
		
		}
	});

	panel.getTopToolbar().add('->');
	panel.getTopToolbar().add(app.crearBotonAyuda());
	 //esta funcionalidad no entra en esta versión
	//panel.getTopToolbar().add(botonDOC);
	panel.getTopToolbar().add(botonRefrezcar);
	
</fwk:page>
