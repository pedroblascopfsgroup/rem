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

	var coloredRender = function (value, meta, record) {
		return '<span style="color: #4169E1; font-weight: bold;">'+value+'</span>';
	};
	
	var moneyColoredRender = function (value, meta, record) {
		var valor = app.format.moneyRenderer(value, meta, record);
		return coloredRender(valor, meta, record);
	};
	
	var dateColoredRender = function (value, meta, record) {
		return coloredRender(value, meta, record);
	};	
	
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
		,{name : 'fechaInicio', sortType:Ext.data.SortTypes.asDate}
		,{name : 'fechaFin', sortType:Ext.data.SortTypes.asDate}
		,{name : 'fechaVencReal', sortType:Ext.data.SortTypes.asDate}
		,{name : 'fechaVencimiento', sortType:Ext.data.SortTypes.asDate}
		,{name : 'nombreUsuario', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'importe', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'numeroAutos', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'group', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'descripcionCorta', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'destinatarioTarea', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'subtipoTarea', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'tipoRegistro', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : 'descripcionTarea', type:'string', sortType:Ext.data.SortTypes.asText}
		,{name : "historicoResoluciones"}
]);
	
	
	
	var expanderAsu = new Ext.ux.grid.RowExpander({
		renderer: function(v,p,record){	
			if (record.data.historicoResoluciones!=undefined) {
				if(record.data.historicoResoluciones.length>0)
						return '<div class="x-grid3-row-expander"> </div>';
					else
						return ' ';
			}
		},
    	tpl : new Ext.Template('<div id="myrow-asu-{idEntidad}" ></div>')
	});
	
	
	var historicoAsuntoCM = new Ext.grid.ColumnModel([
		expanderAsu,
		{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.numeroProcedimiento" text="**Numero de procedimiento"/>'
						, dataIndex : 'numeroProcedimiento' 
						,sortable:true
						,hidden:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.numeroAutos" text="**Numero autos"/>'
						, dataIndex : 'numeroAutos' 
						,sortable:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.tipoProcedimiento" text="**Tipo de procedimiento"/>'
						, dataIndex : 'tipoProcedimiento' 
						,sortable:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.descripcion" text="**Descripción"/>'
						, dataIndex : 'tarea' 
						,sortable:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.fechainicio" text="**fecha inicio"/>'
						, dataIndex : 'fechaInicio' 
						,sortable:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.fechaVenc" text="**fecha venc"/>'
						, dataIndex : 'fechaVencimiento' 
						,sortable:true
		}	
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.fechafin" text="**fecha fin"/>'
						, dataIndex : 'fechaFin' 
						,sortable:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.tipo" text="**Tipo"/>'
						, dataIndex : 'group' 
						,sortable:true
						,hidden:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.usuario" text="**Usuario"/>'
						, dataIndex : 'nombreUsuario' 
						,sortable:true
		}
		
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.fechaVencReal" text="**fecha venc real"/>'
						, dataIndex : 'fechaVencReal' 
						,sortable:true
						,hidden:true
		}
		
		
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.tipoActuacion" text="**Tipo de actuacion"/>'
						, dataIndex : 'tipoActuacion' 
						,sortable:true
						,hidden:true
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.importe" text="**importe"/>'
						, dataIndex : 'importe' 
						,sortable:true
						,hidden:true
						,renderer: app.format.moneyRenderer
		}
		,{header : '<s:message code="plugin.mejoras.asunto.tabHistorico.destinatarioTarea" text="**Destinatario"/>'
						, dataIndex : 'destinatarioTarea' 
						,sortable:true
						,hidden:true
		}
		]);
		
		//historicoasunto/getHistoricoAgregadoAsunto
		//msvhistoricotareas/getHistoricoPorTareasAsunto
	var tareasAsuStore = page.getGroupingStore({
        flow: 'msvhistoricotareas/getHistoricoPorTareasAsunto'
        ,storeId : 'tareasAsuStore'
        ,groupField:'group'
		,groupOnSort:'true'
		,limit:20
        ,reader : new Ext.data.JsonReader(
            {root:'historicoAsunto',totalProperty : 'total'}
            , HistoricoAsuntoRT
        )
	}); 
	
	var pagingBar=fwk.ux.getPaging(tareasAsuStore);
		
	tareasAsuStore.addListener('load', agrupa);
	function agrupa(store, meta) {
		
			store.groupBy('group', true);
	
		tareasAsuStore.removeListener('load', agrupa);
    }; 
    
    tareasAsuStore.on('load', function(store, records, options){
	   expandAll();
	});
    
    var expandAll = function() {
     	for (var i=0; i < tareasAsuStore.getCount(); i++){
	      expanderAsu.expandRow(i);		  
	    }
    };
    
     var collapseAll = function() {
     	for (var i=0; i < tareasAsuStore.getCount(); i++){
	      expanderAsu.collapseRow(i);		  
	    }
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
									tareasAsuStore.webflow({id : data.id });
									btnBorrar.disable();
								}	 
							});
	         			}
	       			 }
	});
	
	
	var funcionConsultar = function(){
		//var recStore = grid.getStore().getAt(rowIndex);
		var recStore = historicoGridAsunto.getSelectionModel().getSelected();
		if (recStore == null) return;
		
    	var destinatarioTarea = recStore.get('destinatarioTarea');
		var subtipoTarea = recStore.get('subtipoTarea');
		var fechaVencimiento = recStore.get('fechaVencimiento');
		var fechaFin = recStore.get('fechaFin');
		var tipoTraza = recStore.get('tipoTraza');
		
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
							tareasAsuStore.webflow({id : data.id }); 
							//Recargamos el arbol de tareas
							app.recargaTree();
                		 });
               			 w.on(app.event.CANCEL, function(){ 
               			 	w.close(); 
               			 });

		}else if((recStore.get('tarea') || recStore.get('idTraza')) && (tipoTraza != 'TareaProcedimiento')){		
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
										,fecha: recStore.get('fechaInicio')
										,situacion: 'Asunto'
										,idTareaAsociada: recStore.get('idTarea')
										,isConsulta:true
										,idTraza:recStore.get('idTraza')
										,idTarea:recStore.get('idTarea')
										,tipoTraza:recStore.get('tipoTraza')
								}
							});
							w.on(app.event.DONE, function(){
								w.close();
							});
							w.on(app.event.CANCEL, function(){ w.close(); });
							w.on(app.event.OPEN_ENTITY, function(){
								w.close();
																						
								app.abreAsuntoTab(recStore.get('idEntidad'), recStore.get('tarea'), 'cabeceraAsunto');
								
											
							});
		}
		
	};	
	
	
	
	var btnConsultar =new Ext.Button({
      text:'<s:message code="app.consultar" text="**Consultar" />'
	    <app:test id="btnConsultarTareahistorica" addComa="true" />
	         ,iconCls : 'icon_edit'
	    ,cls: 'x-btn-text-icon'
	    ,handler:funcionConsultar
	    ,disabled: false
  	});
  	  		
  	var btnCollapseAll =new Ext.Button({
  		tooltip:'<s:message code="plugin.masivo.procedimiento.historicoRes.collapseAll" text="**Contraer todo" />'
        ,iconCls : 'icon_collapse'
	    ,cls: 'x-btn-icon'
	    ,handler:collapseAll
	    ,disabled: false
  	});
  	
  	var btnExpandAll =new Ext.Button({
      	tooltip:'<s:message code="plugin.masivo.procedimiento.historicoRes.expandAll" text="**Expandir todo" />'	    
	    ,iconCls : 'icon_expand'
	    ,cls: 'x-btn-icon'
	    ,handler:expandAll
	    ,disabled: false
  	});
  	
	var cfg = {	
		title:'<s:message code="plugin.mejoras.asunto.tabHistorico.grid.titulo" text="**Histico de tareas" />'
		,collapsible:false
		,cls:'cursor_pointer' 
		,height:400
		,plugins: expanderAsu
		,bbar : [ btnExpandAll, btnCollapseAll, pagingBar, btnBorrar, btnConsultar]
		,view: new Ext.grid.GroupingView({
			forceFit:true
			,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			,enableNoGroups:true
		})
	};
		
	var historicoGridAsunto = app.crearGrid(tareasAsuStore,historicoAsuntoCM,cfg);
	
	historicoGridAsunto.on('rowdblclick', function(grid, rowIndex, e) {
		funcionConsultar()
	});
	
	historicoGridAsunto.on('rowclick', function(grid, rowIndex,e){
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
	

	
	entidad.cacheStore(historicoGridAsunto.getStore());
	
	 var resolucion = Ext.data.Record.create([                                                                                                                              
   	 {name : "idResolucion" }
   	,{name : "juzgado" }
   	,{name : "plaza" }
   	,{name : "tipoPrc" }
   	,{name : "numAuto" }
	,{name : "fechaCarga"}
	,{name : "idTipoResolucion"}
	,{name : "tipo" }
	,{name : "usuario" }
	,{name : "observaciones"}	
  ]); 

  var resolucionesProcStore = page.getStore({
    event:'listado'
    ,flow : 'msvhistoricotareas/getHistoricoPorResolucionesAsunto'
    ,storeId : 'historicoResolucionesProcStore'
    ,groupField:'group'
	,groupOnSort:'true'
	,limit:20
    ,reader : new Ext.data.JsonReader(
      {root:'historicoResoluciones'}
      , resolucion
    )                                                                                                  
  });                                                                                                                                                                  
  entidad.cacheStore(resolucionesProcStore);

	var pagingBarResoluciones=fwk.ux.getPaging(resolucionesProcStore);

	var historicoResCM = new Ext.grid.ColumnModel([
		{header : 'id. Resolucion', dataIndex : 'idResolucion', fixed:true, hidden:true}
		,{header : 'id. Tipo Resolucion', dataIndex : 'idTipoResolucion', hidden:true, renderer: coloredRender}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.juzgado" text="**Juzgado"/>', dataIndex : 'juzgado', width:275, renderer: coloredRender,hidden:true}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.plaza" text="**Plaza"/>', dataIndex : 'plaza', width:100, renderer: coloredRender,hidden:true}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.numAuto" text="**Num. auto"/>', dataIndex : 'numAuto', width:75, renderer: coloredRender}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.prc_tramite" text="**Procedimiento/Trámite"/>', dataIndex : 'tipoPrc', width:175, renderer: coloredRender}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.resolucion" text="**Tipo Resolución"/>', dataIndex : 'tipo', width:175, renderer: coloredRender}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.fechaCarga" text="**Fecha carga"/>', dataIndex : 'fechaCarga', renderer: dateColoredRender, width:75}	
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.observaciones" text="**Observaciones"/>', dataIndex : 'observaciones', width:450, renderer: coloredRender}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.usuario" text="**Usuario"/>', dataIndex : 'usuario', width:150, renderer: coloredRender}
	]);
	
	var historicoResCM2 = new Ext.grid.ColumnModel([
		{header : 'id. Resolucion', dataIndex : 'idResolucion', fixed:true, hidden:true}
		,{header : 'id. Tipo Resolucion', dataIndex : 'idTipoResolucion', hidden:true}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.juzgado" text="**Juzgado"/>', dataIndex : 'juzgado', width:275, hidden:true}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.plaza" text="**Plaza"/>', dataIndex : 'plaza', width:100, hidden:true}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.numAuto" text="**Num. auto"/>', dataIndex : 'numAuto', width:75}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.prc_tramite" text="**Procedimiento/Trámite"/>', dataIndex : 'tipoPrc', width:175}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.resolucion" text="**Tipo Resolución"/>', dataIndex : 'tipo', width:175}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.fechaCarga" text="**Fecha carga"/>', dataIndex : 'fechaCarga', width:75}		
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.observaciones" text="**Observaciones"/>', dataIndex : 'observaciones', width:450}
		,{header : '<s:message code="plugin.masivo.procedimientos.historico.subgrid.resoluciones.usuario" text="**Usuario"/>', dataIndex : 'usuario', width:150}
	]);
    
	//Define the function to be called when the row is expanded.
	function expandedRowAsunto(obj, record, body, rowIndex){
	    var absId = record.get('idEntidad');
	
	 	var row = "myrow-asu-" + record.get("idEntidad");
		    
		var resoluciones = record.get('historicoResoluciones');
		
		if (resoluciones.length) {
			var dynamicStoreAsunto = new Ext.data.JsonStore({
				fields: ['idResolucion'
						,'juzgado'
						,'plaza'
						,'tipoPrc'
						,'numAuto'
						,{name : "fechaCarga"}
						,'idTipoResolucion'
						,'tipo'
						,'usuario'
						,'observaciones'],
				data: resoluciones
			});
			
		   var id2 = "mygrid-asu-" + record.get("idEntidad");
		   
		   var gridXAsunto = new Ext.grid.GridPanel({
		        store: dynamicStoreAsunto,
		        stripeRows: true,
		        autoHeight: true,
		        cm: historicoResCM,
		        id: id2                  
		    });        
		
		    gridXAsunto.render(row);
		    gridXAsunto.getEl().swallowEvent([ 'mouseover', 'mousedown', 'click', 'dblclick' ]);
		    
		    gridXAsunto.on('rowdblclick', function(grid, rowIndex, e) {
				var recStore = grid.getStore().getAt(rowIndex);
				//var recStore = historicoResolucionesGridAsunto.getSelectionModel().getSelected();
				if (recStore == null) return;
				
				var tipo = recStore.get('tipo');
				var idResolucion = recStore.get('idResolucion');
				var idTipoResolucion = recStore.get('idTipoResolucion');
				var w = app.openWindow({
						flow : 'msvhistoricotareas/abreFormularioDinamico'
						,title : tipo
						,closable:true
						,width:870
						,y:1 
						,params : {
							idInput: idResolucion,
							idTipoResolucion: idTipoResolucion
						}
					});
					w.on(app.event.DONE, function(){
						w.close();
					});
					w.on(app.event.CANCEL, function(){ w.close(); });
			});
		  }
		  
	};
	
	expanderAsu.on('expand', expandedRowAsunto);
   
   	var funcionConsultarRes = function(){
		//var recStore = grid.getStore().getAt(rowIndex);
		var recStore = historicoResolucionesGridAsunto.getSelectionModel().getSelected();
		if (recStore == null) return;
		
		var idResolucion = recStore.get('idResolucion');
		var tipo = recStore.get('tipo');
		var idTipoResolucion = recStore.get('idTipoResolucion');
		var w = app.openWindow({
				flow : 'msvhistoricotareas/abreFormularioDinamico'
				,title : tipo
				,closable:true
				,width:870
				,y:1 
				,params : {
					idInput: idResolucion,
					idTipoResolucion: idTipoResolucion
				}
			});
			w.on(app.event.DONE, function(){
				w.close();
			});
			w.on(app.event.CANCEL, function(){ w.close(); });
	};
   
   var btnConsultarRes =new Ext.Button({
      text:'<s:message code="app.consultar" text="**Consultar" />'
	    <app:test id="btnConsultarTareahistorica" addComa="true" />
	         ,iconCls : 'icon_edit'
	    ,cls: 'x-btn-text-icon'
	    ,handler:funcionConsultarRes
	    ,disabled: false
  	});
  	
	var historicoResolucionesGridAsunto = app.crearGrid(resolucionesProcStore,historicoResCM2,{
		title:'<s:message code="plugin.masivo.procedimiento.historicoRes.grid" text="**Historico resoluciones" />'
		,cls:'cursor_pointer'
		,width : 700		
		,height : 400
		,bbar : [ pagingBarResoluciones, btnConsultarRes ]
        	 
    });
	
	historicoResolucionesGridAsunto.on('rowdblclick', function(grid, rowIndex, e) {
		funcionConsultarRes()
	});
	
	var historicoTabPanel = new Ext.TabPanel({
		items:[
			historicoGridAsunto, historicoResolucionesGridAsunto
		]
		,height : 480
		,border: true
	  });                                                                                                                                                                  
    historicoTabPanel.setActiveTab(historicoGridAsunto);
  
	var panel = new Ext.Panel({
		title: '<s:message code="procedimiento.historico" text="**Historico" />'
		,autoHeight: true
		,items : [
				{items:historicoTabPanel
				,border:false
				,style:'margin-top: 7px; margin-left:5px'}
			]
		,nombreTab : 'tabAdjuntosAsunto'			
	});

	panel.getValue = function(){}
	
	panel.setValue = function(){
		var data = entidad.get("data");
		entidad.cacheOrLoad(data, tareasAsuStore, {id : data.id });
		tareasAsuStore.webflow({id : data.id });
		entidad.cacheOrLoad(data, resolucionesProcStore, {id : data.id});
		//this.doLayout()
		btnBorrar.disable();
		
	}
   
	return panel;
})