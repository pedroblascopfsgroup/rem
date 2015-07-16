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
	
	var paramsBusquedaInicial={
		start:0
		,limit:limit
		,idCategoria: '${idCategoria}'
	};
	
	var dateRenderer = Ext.util.Format.dateRenderer('d/m/Y');
	
<!-- 	Ext.grid.CheckColumn = function(config){  -->
<!--         Ext.apply(this, config);  -->
<!--         if(!this.id){  -->
<!--             this.id = Ext.id();  -->
<!--         }  -->
<!--         this.renderer = this.renderer.createDelegate(this);  -->
<!--     };  -->
   
<!--     Ext.grid.CheckColumn.prototype = {  -->
<!--         init : function(grid){  -->
<!--             this.grid = grid;  -->
<!--             this.grid.on('render', function(){  -->
<!--                 var view = this.grid.getView();  -->
<!--                 view.mainBody.on('mousedown', this.onMouseDown, this);  -->
<!--             }, this);  -->
<!--         },  -->
<!--         onMouseDown : function(e, t){  -->
<!--             if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){  -->
<!--                 e.stopEvent();  -->
<!--                 var index = this.grid.getView().findRowIndex(t);  -->
<!--                 var record = this.grid.store.getAt(index);  -->
<!--                 var value = !record.data[this.dataIndex]; -->
<!--                 record.set(this.dataIndex, value);  -->
<!--             }  -->
<!--         },  -->
<!--         renderer : function(v, p, record){  -->
<!--             p.css += ' x-grid3-check-col-td';   -->
<!--             return '<div class="x-grid3-check-col'+(v?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';  -->
<!--         }  -->
<!--     }; -->
	
	var recordatoriosRecord = Ext.data.Record.create([
		{name:'id'}
		,{name:'titulo'}
		,{name:'descripcion'}
		,{name:'fecha', type:'date', dateFormat:'c'}
		,{name:'fechaTareaUno', type:'date', dateFormat:'c'}
		,{name:'fechaTareaDos', type:'date', dateFormat:'c'}
		,{name:'fechaTareaTres', type:'date', dateFormat:'c'}
		,{name:'categoria'}
	]);
	
	
	var tareasRecord = Ext.data.Record.create([
		{name:'tarea'}
		,{name:'codigoSubtipoTarea'}
		,{name:'descripcionTarea'}
		,{name:'fechaVenc', type:'date', dateFormat:'c'}
		,{name:'esVencido'}
	]);
	
	
	var recordatorioStore = page.getStore({
		id:'recordatorioStore'
		,remoteSort:true
		,event:'listado'
		,storeId:'recordatorioStore'
		,limit:limit
		,baseParams:paramsBusquedaInicial
		,flow:'recrecordatorio/getListaRecordatorios'
		,reader: new Ext.data.JsonReader({root:'recordatorios',totalProperty:'total',idProperty: 'id'},recordatoriosRecord)
	});
	
	var tareasStore = page.getGroupingStore({
		id:'tareasStore'
		,remoteSort:true
		,event:'listado'
		,storeId:'tareasStore'
		,sortInfo:{field: 'fechaVenc', direction: "ASC"}
		,groupField:'esVencido'
		,groupOnSort:'true'
		,limit:limit
		,baseParams:paramsBusquedaInicial
		,flow:'recrecordatorio/getListaTareasRecordatorios'
		,reader: new Ext.data.JsonReader({root:'listadoTareas',totalProperty:'total',idProperty: 'tarea'},tareasRecord)
	});
<!-- 	tareasStore.groupBy('esVencido', true); -->
<!-- 	tareasStore.addListener('load', agrupa); -->
<!-- 	tareasStore.setDefaultSort('fechaVenc', 'ASC'); -->
<!-- 	function agrupa(store, meta) { -->
<!-- 		store.groupBy('group', true);		 -->
<!-- 		tareasStore.removeListener('load', agrupa); -->
<!--     }; -->
	
	var groupRenderer=function(val){

		if(val){
			return '<s:message code="plugin.procuradores.recordatorio.gridorder.vencidas" text="**Vencidas" />';
		}else{
			return '<s:message code="plugin.procuradores.recordatorio.gridorder.novencidas" text="**No vencidas" />';
		}
			
	}
	
	var tareasCm = new Ext.grid.ColumnModel([
		{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.id" text="**Id" />', dataIndex: 'id', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.titulo" text="**Titulo" />', dataIndex: 'titulo', sortable:true, sortable:true}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.descripcion" text="**Descripción" />',  dataIndex: 'descripcion', sortable:true}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.fecha" text="**Fecha señalamiento" />', dataIndex: 'fecha', sortable:true, renderer:app.format.dateRenderer}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.fechaPrimerRecordatorio" text="**Primer recordatorio" />', dataIndex: 'fechaTareaUno', sortable:true, renderer:app.format.dateRenderer}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.fechaSegundoRecordatorio" text="**Segundo recordatorio" />', dataIndex: 'fechaTareaDos', renderer:app.format.dateRenderer}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.fechaTercerRecordatorio" text="**Tercer recordatorio" />', dataIndex: 'fechaTareaTres',  renderer:app.format.dateRenderer}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.categoria" text="**Categoría" />',  dataIndex: 'categoria', sortable:true}
	]);
	
	var pagingBar=fwk.ux.getPaging(recordatorioStore);
	
	var tareasCm2 = new Ext.grid.ColumnModel([
		{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.id" text="**Id" />', dataIndex: 'tarea', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridcolumn.codigoSubtipoTarea" text="**codigoSubtipoTarea" />', dataIndex: 'codigoSubtipoTarea', sortable:true, hidden:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.tareaDescripcion" text="**TareaDescripcion" />',width: 180, dataIndex: 'descripcionTarea', sortable:true}
		,{header: '<s:message code="plugin.procuradores.tareas.gridcolumn.fechaVencimiento" text="**FechaVencimiento" />', width: 40, dataIndex: 'fechaVenc', sortable:true, renderer:dateRenderer}
		,{header: '<s:message code="plugin.procuradores.recordatorio.gridorder.estaVencida" text="**Vencimiento" />',sortable: false ,dataIndex: 'esVencido', hidden:true, renderer:groupRenderer}
	]);
	
	var pagingBarTarea=fwk.ux.getPaging(tareasStore);
	
	var btnCrear=new Ext.Button({
		text:'<s:message code="app.botones.recordatorios.crear" text="**Crear" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
				var titulo = "Crear recordatorio";
				var w = app.openWindow({
				  flow : 'recrecordatorio/abreVentanaNuevoRecordatorio'
				  //,width:320
				  ,autoWidth:true
				  ,closable:true
				  ,title : titulo
				  ,params:{}
				
				});
				w.on(app.event.DONE, function(){ 
					w.close();     
				  	buscarFunc();
				  	buscarFuncTar();
				  	app.recargaRecordatoriosTree();
				});
				w.on(app.event.CANCEL, function(){
				  w.close();
				});
		}
	});	
	
	
	var btnCrearRecTar=new Ext.Button({
		text:'<s:message code="app.botones.recordatorios.crear" text="**Crear" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
				var titulo = "Crear recordatorio";
				var w = app.openWindow({
				  flow : 'recrecordatorio/abreVentanaNuevoRecordatorio'
				  //,width:320
				  ,autoWidth:true
				  ,closable:true
				  ,title : titulo
				  ,params:{}
				
				});
				w.on(app.event.DONE, function(){      
				  	w.close();
				  	buscarFunc();
				  	buscarFuncTar();
				  	app.recargaRecordatoriosTree();
				});
				w.on(app.event.CANCEL, function(){
				  w.close();
				});
		}
	});	
	
	var RecordatoriosGrid=app.crearGrid(recordatorioStore,tareasCm,{
		title:'<s:message code="plugin.procuradores.recordatorios.gridcolumn.tituloGrid" text="**Recordatorios" />'
		,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:350
        ,bbar : [ pagingBar,btnCrear ]
	});
	
	RecordatoriosGrid.on('rowdblclick', function(grid, rowIndex, e){
		
		var rec = grid.getStore().getAt(rowIndex);
		var id = rec.get('id');
		
		var titulo = "Crear recordatorio";
		var w = app.openWindow({
		  	flow : 'recrecordatorio/abreVentanaNuevoRecordatorio'
		  	//,width:320
		  	,autoWidth:true
		  	,closable:true
		  	,title : titulo
		  	,params:{idRecordatorio:id}
		
		});
		w.on(app.event.DONE, function(){      
		  	w.close();
		  	buscarFunc();
		  	buscarFuncTar();
		  	app.recargaRecordatoriosTree();
		});
		w.on(app.event.CANCEL, function(){
		  	w.close();
		});
		
	});
	
	
	var tareasGrid=app.crearGrid(tareasStore,tareasCm2,{
		title:'<s:message code="plugin.procuradores.tareas.gridcolumn.tituloGrid" text="**Tareas Pendientes" />'
		,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:350
        ,bbar : [ pagingBarTarea,btnCrearRecTar ]
		,view: new Ext.grid.GroupingView({
			forceFit:true
			,groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
			//,enableNoGroups:true
		})
	});
	
	tareasGrid.on('rowdblclick', function(grid, rowIndex, e){
		var rec = grid.getStore().getAt(rowIndex);
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
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
           	app.recargaRecordatoriosTree();
			//Recargamos el arbol de tareas
			//app.recargaTree();
          });
          
         w.on(app.event.CANCEL, function(){
          w.close(); 
         });
		
	});
	
	
    var titRecordatorio=new Ext.form.TextField({
    	fieldLabel:'<s:message code="plugin.procuradores.tareas.busqueda.titRecordatorio" text="**Título" />'
    	,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
    });
    
    
    var titRecordatorioTareas=new Ext.form.TextField({
    	fieldLabel:'<s:message code="plugin.procuradores.tareas.busqueda.titRecordatorio" text="**Título" />'
    	,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	               buscarFuncTar();
	            }  
	        } 
		}
    });


	var btnBuscar=app.crearBotonBuscar({
		handler:function(){
			buscarFunc();
		}
	});
	
	var btnBuscarTareas=app.crearBotonBuscar({
		handler:function(){
			buscarFuncTar();
		}
	});
	
	var getParametrosBusqueda=function(){
		return {
			 start:0
			,limit:limit
			,titulo:titRecordatorio.getValue()
			,idCategoria: '${idCategoria}'
		}
	}
	
	var getParametrosBusquedaTareas=function(){
		return {
			 start:0
			,limit:limit
			,titulo:titRecordatorioTareas.getValue()
			,idCategoria: '${idCategoria}'
		}
	}
	
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			app.resetCampos([titRecordatorio]);
			recordatorioStore.webflow(paramsBusquedaInicial);
			panelFiltros.collapse(true);
		}
	});	
	
	var btnCleanTareas=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			app.resetCampos([titRecordatorioTareas]);
			tareasStore.webflow(paramsBusquedaInicial);
			panelFiltrosTareas.collapse(true);
		}
	});	
	
	
	var panelFiltros = new Ext.Panel({
		title : '<s:message code="plugin.procuradores.recordatorios.busqueda.recordatorio" text="**Buscar recordatorios"/>'
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
				,items:[titRecordatorio]
			}
		]              
		,tbar:[btnBuscar,btnClean]
	});
	
	var panelFiltrosTareas = new Ext.Panel({
		title : '<s:message code="plugin.procuradores.recordatorios.busqueda.tareasRecordatorios" text="**Buscar tareas de recordatorios"/>'
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
				,items:[titRecordatorioTareas]
			}
		]              
		,tbar:[btnBuscarTareas,btnCleanTareas]
	});
	
	var buscarFunc=function(){
		isBusqueda=true;
		panelFiltros.collapse(true);
		recordatorioStore.webflow(getParametrosBusqueda());
	}
	
	
	var buscarFuncTar=function(){
		isBusqueda=true;
		panelFiltrosTareas.collapse(true);
		tareasStore.webflow(getParametrosBusquedaTareas());
	}
	
	var recordatoriosPanel = new Ext.Panel({
		id:'recordatoriosPanel',
		title:'<s:message code="plugin.procuradores.recordatorios.tab.recordatorio.title" text="**Recordatorios" />',
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
   					items:[RecordatoriosGrid]
   				}]
    });
    
    
   	var tareasPanel = new Ext.Panel({
   		id:'tareasPanel',
   		title:'<s:message code="plugin.procuradores.recordatorios.tab.tareas.title" text="**Tareas" />',
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:true,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
        items: [{
   					bodyStyle:'padding: 5px;padding-right:15px;',
   					border:false,
   					items:[panelFiltrosTareas]
   				},{
   					bodyStyle:'padding: 5px',
   					border:false,
   					items:[tareasGrid]
   				}]
    });
    
    
    var tabs = new Ext.TabPanel({
		items:[tareasPanel,recordatoriosPanel],
	    activeTab: 0
	});
	
	var mainPanel = new Ext.Panel({
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:true,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
		items:tabs
    });
    
    
    page.add(mainPanel);
    
        
   	Ext.onReady(function(){
		tareasStore.webflow({idCategoria: '${idCategoria}'});
		recordatorioStore.webflow({idCategoria: '${idCategoria}'});
		tareasStore.groupBy('esVencido', true);
	});
	
</fwk:page>