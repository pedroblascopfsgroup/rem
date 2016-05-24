<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>	
	var limit = 25;
	var maskPanel;
	var maskAll=function(){
		if(maskPanel==null){
			maskPanel=new Ext.LoadMask(mainPanel.body, {msg:'<s:message code="fwk.ui.form.cargando" text="**Cargando.."/>'});
		}
		maskPanel.show();
	};

	var unmaskAll=function(){
		if(maskPanel!=null)
			maskPanel.hide();
	};
	
	
	var tarea = Ext.data.Record.create([
		{name:'subtipo'}
		,{name:'descripcion'}
		,{name:'codigoSubtipoTarea'}
		,{name:'descripcionTarea'}
		,{name:'group'}
		,{name:'dtype'}
		,{name:'categoriaTarea'}
	]);
    

	var tareasStore = page.getStore({
		id : 'tareasStore'
		,storeId: 'tareasStore'
		,eventName : 'listado'
		,limit: limit
		,flow:'gestionclientes/getContadores'
		,remoteSort : true
		,reader: new Ext.data.JsonReader({
	    	root : 'tareas'
	    	,totalProperty : 'total'
	    }, tarea)
	});

	var tareasNewCm=new Ext.grid.ColumnModel([
		{	/*Columna 0*/ header: '<s:message code="tareas.listado.tarea" text="**Tarea"/>', sortable: true, dataIndex: 'descripcionTarea'}
		,{	/*Columna 1*/ header: '<s:message code="tareas.listado.descripcion" text="**Descripcion"/>', sortable: false, dataIndex: 'descripcion'}
		,{  /*Columna 14*/ header: '<s:message code="tareas.listado.vencimiento" text="**vencimiento"/>', 	sortable: false, dataIndex: 'group', hidden:true}
	]);
		
	
	var pagingBar=fwk.ux.getPaging(tareasStore);
	var tituloGrid = '<s:message code="tareas.gc" text="**Gesti&oacute;n de Clientes"/>';
		
	var cfg = {	
		title:tituloGrid
		,style:'padding-top:10px'
		,bbar : [  pagingBar ]
		,iconCls : 'icon_gv_tree'
		,cls:'cursor_pointer'
		,height: 400
	};
		
	var tareasGrid = app.crearGrid(tareasStore,tareasNewCm,cfg);
	


	tareasGrid.on('rowclick', function(grid, rowIndex, e) {
		var rec = grid.getStore().getAt(rowIndex);
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		
		var tipoTareaNotificacion=rec.get('dtype');
		
	});
	
	
	tareasGrid.on('rowdblclick', function(grid, rowIndex, e) {
		//agregar funcionalidad....
		var rec = grid.getStore().getAt(rowIndex);
		
		var codigoSubtipoTarea = rec.get('codigoSubtipoTarea');
		var categoriaTarea = rec.get('categoriaTarea');


		switch (codigoSubtipoTarea){
			case app.subtipoTarea.CODIGO_GESTION_VENCIDOS:
				app.openTab("<s:message code="tareas.gv" text="**Gesti&oacute;n de Vencidos"/>", "gestionclientes/getListadoVencidos", {gv:true,gsis:false,gsin:false},{id:'GV',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SISTEMATICO:
				app.openTab("<s:message code="tareas.gsis" text="**Gesti&oacute;n de Seguimiento Sistem&aacute;tico"/>", "gestionclientes/getListadoSistematicos", {gv:false,gsis:true,gsin:false},{id:'GSIN',iconCls:'icon_busquedas'});
			break;
			case app.subtipoTarea.CODIGO_GESTION_SEGUIMIENTO_SINTOMATICO:
				app.openTab("<s:message code="tareas.gsin" text="**Gesti&oacute;n de Seguimiento Sintom&aacute;tico"/>", "gestionclientes/getListadoSintomaticos", {gv:false,gsis:false,gsin:true},{id:'GSIS',iconCls:'icon_busquedas'});
			break;
							
		}
		
    });

	tareasGrid.on('click', function(grid, rowIndex, e) {
    });
	
	var mainPanel = new Ext.Panel({
	    items : [
				tareasGrid
	    	]
	    ,bodyStyle:'padding:10px'
	    ,autoHeight : true
	    ,border: false
		,tbar:new Ext.Toolbar()
    });
    
    Ext.onReady(function () {
    	tareasGrid.store.load();
    })
	
	page.add(mainPanel);
	
	
</fwk:page>
