<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>

<fwk:page>
	var limit = 25;
	var isBusqueda = true;
	var TIP_RES_ACTIVABLE = 1003;
	
	var paramsBusquedaInicial={
		start:0
		,limit:limit
		,idCategoria: '${idCategoria}'
	};
	
	var dateRenderer = Ext.util.Format.dateRenderer('d/m/Y');
	
	var tareasRecord = Ext.data.Record.create([
		{name:'usuario'}
		,{name:'tarea'}
		,{name:'asunto'}
		,{name:'nombreTarea'}
		,{name:'descripcionTarea'}
		,{name:'procedimiento'}
		,{name:'fechaVenc', type:'date', dateFormat:'c'}
		,{name:'resolucion'}
		,{name:'idResolucion'}
		,{name:'idTipoResolucion'}
		,{name:'codigoSubtipoTarea'}
		,{name:'tipoAccionCodigo'}
		,{name:'descripcionProcedimiento'}
	]);
	
	
	var urlStore = 'procuradores/getListadoTareasPendientesValidar';
	if('${pausadas}' == 'true'){
		urlStore = 'procuradores/getListadoTareasPendientesValidarPausadas'
	}
	
	var tareasStore = page.getStore({
		id:'tareasStore'
		,remoteSort:true
		,event:'listado'
		,storeId:'tareasStore'
		,limit:limit
		,baseParams:paramsBusquedaInicial
		,flow:urlStore
		,reader: new Ext.data.JsonReader({root:'listadoTareas',totalProperty:'total',idProperty: 'idResolucion'},tareasRecord)
	});
	
	var tareasCm = new Ext.grid.ColumnModel([
		{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.usuario" text="**Usuario" />', dataIndex: 'usuario', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.tarea" text="**Tarea" />', dataIndex: 'tarea', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.asunto" text="**Asunto" />', width: 25, dataIndex: 'asunto', sortable:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.tareaTarea" text="**TareaTarea" />', dataIndex: 'nombreTarea', sortable:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.tareaDescripcion" text="**TareaDescripcion" />',width: 180, dataIndex: 'descripcionTarea', sortable:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.descripcionProcedimiento" text="**Procedimiento" />', dataIndex: 'descripcionProcedimiento', sortable:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.procedimiento" text="**Procedimiento" />', dataIndex: 'procedimiento', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.fechaVencimiento" text="**FechaVencimiento" />', width: 40, dataIndex: 'fechaVenc', sortable:true, renderer:dateRenderer}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.resolucion" text="**Resolucion" />', dataIndex: 'resolucion', sortable:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.idResolucion" text="**IdResolucion" />', width: 35, dataIndex: 'idResolucion', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.idTipoResolucion" text="**idTipoResolucion" />', width: 35, dataIndex: 'idTipoResolucion', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.tipoAccionCodigo" text="**tipoAccionCodigo" />', dataIndex: 'tipoAccionCodigo', hidden:true}
	]);
	
	var pagingBar=fwk.ux.getPaging(tareasStore);
	
	var btnReasignar=new Ext.Button({
		text:'<s:message code="app.botones.reasignar" text="**Reasignar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
				var rec = tareasGrid.getSelectionModel().getSelected();
				var resolucion = rec.get('idResolucion');
				var titulo = "Reasignar categoria";
				var w = app.openWindow({
				  flow : 'categorias/abreVentanaReasignarCategoriasTarea'
				  //,width:320
				  ,autoWidth:true
				  ,closable:true
				  ,title : titulo
				  ,params:{idResolucion:resolucion}
				
				});
				w.on(app.event.DONE, function(){      
				  w.close();
				  app.recargaResolucionesTree();
				  //app.abreProcedimientoTab(panel.getProcedimientoId(), null, 'tareas');
				});
				w.on(app.event.CANCEL, function(){
				  w.close();
				});
		}
		,disabled: true
	});	
	
	var tareasGrid=app.crearGrid(tareasStore,tareasCm,{
		title:'<s:message code="plugin.procuradores.tareas.gridcolumn.tituloGrid" text="**Tareas Pendientes" />'
		,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:350
        ,bbar : [ pagingBar,btnReasignar ]
	});
	
	tareasGrid.on('rowdblclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		var codigoTipoAccion = rec.get('tipoAccionCodigo');
		
		if(codigoSubtipoTarea == 700 || codigoSubtipoTarea == 'TAREA_RECORDATORIO'){

	    	var idTarea = rec.get('tarea');
            var w = app.openWindow({
                flow: 'buzontareas/abreTarea'
                ,width: 835
                ,y:1 
                ,title: '<s:message code="aceptar.tarea.objetivo" text="**Aceptar tarea" />'
                ,params: {idTarea:idTarea, subtipoTarea:codigoSubtipoTarea}
            });
                          
           w.on(app.event.DONE, function(){
            	w.close();
            	tareasStore.webflow(paramsBusquedaInicial); 
				//Recargamos el arbol de tareas
				app.recargaTree();
           });
          w.on(app.event.CANCEL, function(){ w.close(); });
		}else{
		
			if(codigoTipoAccion == 'INFO'){
				
				var idResol = rec.get('idResolucion');
				var titulo = rec.get('descripcionTarea');
				
				var w = app.openWindow({
				  flow : 'pcdprocesadoresoluciones/abreFormularioDinamicoDesdeProcedimiento'
				  ,width:858
				  ,autoWidth:true
				  ,closable:true
				  ,title : titulo
				  ,params:{idResolucion:idResol}
				
				});
				w.on(app.event.DONE, function(){      
	            	w.close();
	            	tareasStore.webflow(paramsBusquedaInicial); 
					//Recargamos el arbol de tareas
					app.recargaTree();
				});
				w.on(app.event.CANCEL, function(){
				  w.close();
				});
				
			}else{
				app.abreProcedimientoTab(rec.get('procedimiento'), rec.get('descripcionTarea'), 'tareas');
			}
		}
		
	});
	
	tareasGrid.on('rowclick', function(grid, rowIndex, e){
	
		var rec = tareasGrid.getSelectionModel().getSelected();
		var TIP_RES = rec.get('idTipoResolucion');
		
		if(TIP_RES == TIP_RES_ACTIVABLE){
			btnReasignar.enable();
		}else{
			btnReasignar.disable();
		}
		
	});
	
    var asunto=new Ext.form.NumberField({
    	fieldLabel:'<s:message code="plugin.procuradores.tareas.busqueda.asunto" text="**N&ordm; Asunto" />'
    	,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
    });
    
    var tareaTarea=new Ext.form.TextField({
    	fieldLabel:'<s:message code="plugin.procuradores.tareas.busqueda.tarea" text="**Nombre tarea" />'
    	,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
    });


	var btnBuscar=app.crearBotonBuscar({
		handler:function(){
			buscarFunc();
		}
	});
	
	var getParametrosBusqueda=function(){
		return {
			 start:0
			,limit:limit
			,asunto:asunto.getValue()
			,tareaTarea:tareaTarea.getValue()
			,idCategoria: '${idCategoria}'
		}
	}
	
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			app.resetCampos([asunto, tareaTarea]);
			tareasStore.webflow(paramsBusquedaInicial);
			panelFiltros.collapse(true);
		}
	});	
	
	
	var panelFiltros = new Ext.Panel({
		title : '<s:message code="plugin.procuradores.tareas.busqueda" text="**Buscar Tareas Pendientes"/>'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {columns:2}
		,bodyStyle:'cellspacing:10px;padding-right:10px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset',border:false}
				,width:'320px'
				,items:[asunto,tareaTarea]
			}
		]              
		,tbar:[btnBuscar,btnClean]
	});
	
	var buscarFunc=function(){
		isBusqueda=true;
		panelFiltros.collapse(true);
		tareasStore.webflow(getParametrosBusqueda());
	}
	
	var mainPanel = new Ext.Panel({
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:true,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
        items: [{
   					bodyStyle:'padding: 5px;padding-right:15px;',
   					border:false,
   					items:[panelFiltros]
   				},{
   					bodyStyle:'padding: 5px',
   					border:false,
   					items:[tareasGrid]
   				}]
    });
    
    
    page.add(mainPanel);
    
        
   	Ext.onReady(function(){
		tareasStore.webflow({idCategoria: '${idCategoria}'});
	});
	
</fwk:page>