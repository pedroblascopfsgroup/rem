﻿﻿﻿﻿﻿<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

(function(page,entidad){

	constantes={};
	constantes.TIPO_ENTIDAD_TAREA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_TAREA" />';
	constantes.TIPO_ENTIDAD_COMUNICACION = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_COMUNICACION" />';
	constantes.TIPO_ENTIDAD_PETICION_RECURSO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_RECURSO" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_RECURSO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_RECURSO" />';
	constantes.TIPO_ENTIDAD_PETICION_PRORROGA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_PRORROGA" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_PRORROGA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_PRORROGA" />';
	constantes.TIPO_ENTIDAD_PETICION_ACUERDO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_ACUERDO" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_ACUERDO = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_ACUERDO" />';
	constantes.TIPO_ENTIDAD_PETICION_DECISION = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_PETICION_DECISION" />';
	constantes.TIPO_ENTIDAD_RESPUESTA_DECISION = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_RESPUESTA_DECISION" />';
	constantes.TIPO_ENTIDAD_TAREA_CANCELADA = '<fwk:const value="es.capgemini.pfs.registro.model.HistoricoProcedimiento.TIPO_ENTIDAD_TAREA_CANCELADA" />';
	
	var idTrazaSeleccionada = 0;
	var idTareaSeleccionada = 0;
	
	var HistoricoAsuntoRT = Ext.data.Record.create([
		{name:'id'}
		,{name : 'idEntidad', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoEntidad', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tarea', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'idTarea', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'idTraza', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoTraza', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoActuacion', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoProcedimiento', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'numeroProcedimiento', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'fechaInicio'}
		,{name : 'fechaFin'}
		,{name : 'fechaVencReal'}
		,{name : 'fechaVencimiento'}
		,{name : 'nombreUsuario', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'importe', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'numeroAutos', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'group', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'descripcionCorta', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'destinatarioTarea', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'subtipoTarea', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoRegistro', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'descripcionTarea', type:'string', sortType:Ext.data.SortTypes.asText}
]);
	
	<pfs:defineColumnModel name="historicoAsuntoCM">
		<pfs:defineHeader dataIndex="fechaInicio" captionKey="plugin.mejoras.asunto.tabHistorico.fechainicio" 
			caption="**fecha inicio" firstHeader="true"  sortable="false"/>
		<pfs:defineHeader dataIndex="group" captionKey="plugin.mejoras.asunto.tabHistorico.tipo" 
			caption="**Tipo" sortable="true"  />
		<pfs:defineHeader dataIndex="nombreUsuario" captionKey="plugin.mejoras.asunto.tabHistorico.usuario" 
			caption="**usuario" sortable="true" hidden="true"/>
		<pfs:defineHeader dataIndex="destinatarioTarea" captionKey="plugin.mejoras.asunto.tabHistorico.destinatarioTarea" 
			caption="**Destinatario" sortable="true" />
		<pfs:defineHeader dataIndex="fechaVencimiento" captionKey="plugin.mejoras.asunto.tabHistorico.fechaVenc" 
			caption="**fecha venc" sortable="false"/>	
		<pfs:defineHeader dataIndex="fechaVencReal" captionKey="plugin.mejoras.asunto.tabHistorico.fechaVencReal" 
			caption="**fecha venc real" sortable="false"/>
		<pfs:defineHeader dataIndex="fechaFin" captionKey="plugin.mejoras.asunto.tabHistorico.fechafin" 
			caption="**fecha fin" sortable="false"/>
		<pfs:defineHeader dataIndex="tipoProcedimiento" captionKey="plugin.mejoras.asunto.tabHistorico.tipoProcedimiento" 
			caption="**Tipo de procedimiento" sortable="true"  />
		<pfs:defineHeader dataIndex="tipoActuacion" captionKey="plugin.mejoras.asunto.tabHistorico.tipoActuacion" 
			caption="**Tipo de actuacin" sortable="true"  hidden="true"/>
		<pfs:defineHeader dataIndex="descripcionCorta" captionKey="plugin.mejoras.asunto.tabHistorico.descripcion" 
			caption="**Tarea" sortable="true" firstHeader="false" />
			
		
		<pfs:defineHeader dataIndex="numeroProcedimiento" captionKey="plugin.mejoras.asunto.tabHistorico.numeroProcedimiento" 
			caption="**Numero de procedimiento" sortable="true"  hidden="true" />
		<pfs:defineHeader dataIndex="importe" captionKey="plugin.mejoras.asunto.tabHistorico.importe" 
			caption="**importe" sortable="true" renderer="app.format.moneyRenderer" hidden="true"/>
		<pfs:defineHeader dataIndex="numeroAutos" captionKey="plugin.mejoras.asunto.tabHistorico.numeroAutos" 
			caption="**Numero autos" sortable="true"  hidden="true" />
		
		
	</pfs:defineColumnModel>
	
	var tareasProcStore = page.getGroupingStore({
        flow: 'historicoasunto/getHistoricoAgregadoAsunto'
        ,storeId : 'tareasProcStore'
        ,groupField:'group'
		,groupOnSort:'true'
		,limit:20
        ,reader : new Ext.data.JsonReader(
            {root:'historicoAsunto',totalProperty : 'total'}
            , HistoricoAsuntoRT
        )
	}); 
	
	var pagingBar=fwk.ux.getPaging(tareasProcStore);
	
	tareasProcStore.addListener('load', agrupa);
	function agrupa(store, meta) {
		
			store.groupBy('group', true);
	
		tareasProcStore.removeListener('load', agrupa);
    }; 
    
	var btnBorrar = new Ext.Button({
		text: '<s:message code="app.borrar" text="**Borrar" />',
		iconCls: 'icon_menos',
		handler: function(){

			if (idTrazaSeleccionada){
				//BORRAR
				Ext.Msg.confirm('<s:message code="plugin.mejoras.asuntos.tabs.tarea.borrarTarea" text="**Borrar Tarea" />', 
	                    	       '<s:message code="plugin.mejoras.asuntos.tabs.tarea.borrarMsgTarea" text="**Est&aacute; seguro de que desea borrar la tarea?" />',
	                    	       this.evaluateAndSend);
			}else{
	           	Ext.Msg.alert('<s:message code="fwk.ui.errorList.fieldLabel"/>','<s:message code="dc.asuntos.listado.sinSeleccion"/>')	
	        }
		}
		,evaluateAndSend: function(seguir) {
		     			if(seguir== 'yes') {
	            			page.webflow({
								 flow: 'historicoasunto/borrarTareaAsunto'
								,eventName: 'borrarAsunto'
								,params:{id:idTrazaSeleccionada, idTarea:idTareaSeleccionada}
								,success: function(){	
									tareasProcStore.webflow({id : data.id });
									btnBorrar.disable();
								}	 
							});
	         			}
	       			 }
	});
	
	var cfg = {	
		title:'<s:message code="plugin.mejoras.asunto.tabHistorico.grid.titulo" text="**Histico de tareas" />'
		,collapsible:false
		,height:400
		,bbar : [  pagingBar, btnBorrar]
		,view: new Ext.grid.GroupingView({
			forceFit:true
			,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			,enableNoGroups:true
		})
	};
	
	
	<%-- PRODUCTO-671 Comprueba si la tarea es de tipo COMUNICACION y es dueño o destinatario de la misma *Para users de perfil solo consulta--%>		
	var comprobacionComunicacionesYPerfil = function(tipoTareaCom, userCreador, userDestino) {
		<sec:authorize ifAllGranted="SOLO_CONSULTA"> 
			if(tipoTareaCom == '700' || tipoTareaCom == '701')
			{ 
				if( (userCreador == app.usuarioLogado.apellidoNombre || userDestino == app.usuarioLogado.apellidoNombre) ) {
						return 	true;
				}
				return false;
			}
		</sec:authorize>
		
		return true;
	}
		
	var historicoGrid = app.crearGrid(tareasProcStore,historicoAsuntoCM,cfg);
	
	
	historicoGrid.on('rowclick', function(grid, rowIndex,e){
		var rec = grid.getStore().getAt(rowIndex);
		var tipoEntidad = rec.get('tipoEntidad');
		var usuPropietario = rec.get('nombreUsuario');
		var usuLogeado  =app.usuarioLogado.apellidoNombre;
		var usuDestinatario  =rec.get('destinatarioTarea');
		var subtipoTarea = rec.get('subtipoTarea');
		var tipoRegistro = rec.get('tipoRegistro');

		/*Solo si la tarea es de tipo autotarea y quiere borrarla el mismo usuario que la creó*/
		if(tipoEntidad==null || tipoEntidad=='' || tipoEntidad!='3' || usuPropietario!=usuLogeado) {			
			btnBorrar.disable();
		} else if(usuLogeado==usuDestinatario){
			btnBorrar.enable();
			idTrazaSeleccionada = rec.get('idTraza');
			idTareaSeleccionada = rec.get('idTarea');
		} else if((tipoEntidad == '3' && (subtipoTarea == '700' || subtipoTarea == '701')) 
			|| (tipoRegistro == 'ANO_TAREA') || (tipoRegistro == 'ANO_COMENTARIO') || (tipoRegistro == 'ANO_NOTIFICACION')){
			btnBorrar.enable();
			idTrazaSeleccionada = rec.get('idTraza');
			idTareaSeleccionada = rec.get('idTarea');
		}else{
			btnBorrar.disable();
		}
	});
	
	
	historicoGrid.on('rowdblclick', function(grid, rowIndex, e) {

		var recStore = grid.getStore().getAt(rowIndex);
    	var destinatarioTarea = recStore.get('destinatarioTarea');
		var subtipoTarea = recStore.get('subtipoTarea');
		var fechaVencimiento = recStore.get('fechaVencimiento');
		var fechaFin = recStore.get('fechaFin');

		if((destinatarioTarea == app.usuarioLogado.apellidoNombre) && (subtipoTarea == '700' || subtipoTarea == '701') 
			&& (fechaVencimiento != null && fechaVencimiento != '' && fechaVencimiento != 'null')
			&& (fechaFin == null || fechaFin == '' || fechaFin == 'null')){

			 var w = app.openWindow({
                  	 	  		flow: 'buzontareas/abreTarea'
                 	   	  		,width: 835
                  		  		,y:1 
                  		  		,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
								,params : {
										idTarea:recStore.get('idTarea')
										,subtipoTarea:recStore.get('subtipoTarea')
								}
							});
							w.on(app.event.OPEN_ENTITY, function(){
                				w.close();

								if (recStore.get('tipoEntidad') == '9'){
									app.abreCliente(recStore.get('idEntidad'), recStore.get('descripcionCorta'));
								}
								if (recStore.get('tipoEntidad') == '2'){
									app.abreExpediente(recStore.get('idEntidad'), recStore.get('descripcionCorta'));
								}	
								if (recStore.get('tipoEntidad') == '3'){
									app.abreAsunto(recStore.get('idEntidad'), recStore.get('descripcionCorta'));
								}
								if (recStore.get('tipoEntidad') == '5'){
									app.abreProcedimiento(recStore.get('idEntidad'), recStore.get('descripcionCorta'));
							}			                   
               			 });                
                		 w.on(app.event.DONE, function(){
							w.close();
							tareasProcStore.webflow({id : data.id }); 
							//Recargamos el arbol de tareas
							app.recargaTree();
                		 });
               			 w.on(app.event.CANCEL, function(){ 
               			 	w.close(); 
               			 });



		}else if(recStore.get('tarea') || recStore.get('idTraza')){
		
			var abrirTarea = true;
		
			if(subtipoTarea == '703'){
				var w = app.openWindow({
					flow : 'especializadamasiva/abreDetalleAnotacionEspecializada'
					,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
					,closable:true
					,width:650
					,y:1 
					,params : {
							idEntidad: recStore.get('idEntidad')
							,codigoTipoEntidad: recStore.get('tipoEntidad')
							,descripcion: recStore.get('descripcionTarea')
							,fecha: app.format.dateRenderer(recStore.get('fechaInicio'))
							,situacion: 'Asunto'
							,idTareaAsociada: recStore.get('idTarea')
							,idTraza:recStore.get('idTraza')
							,idTarea:recStore.get('idTarea')
							,tipoTraza:recStore.get('tipoTraza')
					}
				});					
			}
			else{			
				if(comprobacionComunicacionesYPerfil(subtipoTarea, recStore.get('nombreUsuario'), destinatarioTarea))
				{
					
					var w = app.openWindow({
						flow : 'historicoasunto/abreDetalleHistorico'
						,title : '<s:message code="tareas.notificacion" text="Notificacion" />'
						,closable:true
						,width:650
						,y:1 
						,params : {
								idEntidad: recStore.get('idEntidad')
								,codigoTipoEntidad: recStore.get('tipoEntidad')
								,descripcion: recStore.get('descripcionTarea')
								,fecha: app.format.dateRenderer(recStore.get('fechaInicio'))
								,situacion: 'Asunto'
								,idTareaAsociada: recStore.get('idTarea')
								,isConsulta:true
								,idTraza:recStore.get('idTraza')
								,idTarea:recStore.get('idTarea')
								,tipoTraza:recStore.get('tipoTraza')
						}
					});
				} 
				else {
					abrirTarea = false;
				}
			}
			if(abrirTarea) {
				w.on(app.event.DONE, function(){
					w.close();
				});
				w.on(app.event.CANCEL, function(){ w.close(); });
				w.on(app.event.OPEN_ENTITY, function(){
					w.close();
																			
					app.abreAsuntoTab(recStore.get('idEntidad'), recStore.get('tarea'), 'cabeceraAsunto');
					
								
				});
			}
		}
		
	});	
	
	entidad.cacheStore(historicoGrid.getStore());
	
	var panel = new Ext.Panel({
		title: '<s:message code="procedimiento.historico" text="**Historico" />'
		,autoHeight: true
		,items : [
				{items:historicoGrid
				,border:false
				,style:'margin-top: 7px; margin-left:5px'}
			]
		,nombreTab : 'tabAdjuntosAsunto'			
	});

	panel.getValue = function(){}
	
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, tareasProcStore, {id : data.id });
		tareasProcStore.webflow({id : data.id });
		//this.doLayout()
		btnBorrar.disable();
		
	}
   
	return panel;
})