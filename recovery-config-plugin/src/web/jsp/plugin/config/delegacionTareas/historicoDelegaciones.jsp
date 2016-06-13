<%@page pageEncoding="iso-8859-1" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fwk" tagdir="/WEB-INF/tags/fwk"%>
<%@ taglib prefix="app" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="pfs" tagdir="/WEB-INF/tags/pfs"%>
<%@ taglib prefix="pfsforms" tagdir="/WEB-INF/tags/pfs/forms"%>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<fwk:page>
	var limit = 12;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
	};
	
	var DelegacionesRecord = Ext.data.Record.create([
		 {name:'id'}
        ,{name:'fechaCrear'}
        ,{name:'usuarioCrear'}
        ,{name:'usuarioOrigenName'}
        ,{name:'usuarioDestinoName'}
        ,{name:'fechaIniVigencia'}
        ,{name:'fechaFinVigencia'}
        ,{name:'estadoDesc'}
        ,{name:'estadoCod'}
    ]);
    
     var delegacionesStore = page.getStore({
		id:'delegacionesStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'delegacionesStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow : 'delegaciontareas/getListaDelegaciones'
		,reader : new Ext.data.JsonReader({root:'delegaciones',totalProperty : 'total'}, DelegacionesRecord)
	});
	
	var pagingBar=fwk.ux.getPaging(delegacionesStore);
	
	var delegacionesCm = new Ext.grid.ColumnModel({
  		columns:[
			{header: '<s:message code="plugin.config.delegaciones.gridcolumn.id" text="**Id" />',dataIndex: 'id', sortable:true, hidden:true}			
            ,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.fechacrear" text="**Fecha crear" />',dataIndex: 'fechaCrear', width:90, sortable:true}
            ,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.usuariocrear" text="**Usuario crear" />',dataIndex: 'usuarioCrear', width:160, sortable:true}
	 		,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.usuarioorigen" text="**Usuario origen" />',dataIndex: 'usuarioOrigenName', width:160, sortable:true}	
	 		,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.usuariodestino" text="**Usuario destino" />',dataIndex: 'usuarioDestinoName', width:160, sortable:true}	
	 		,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.fechaini" text="**Fecha inicio" />',dataIndex: 'fechaIniVigencia', width:90, sortable:true}	
	 		,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.fechafin" text="**Fecha fin" />',dataIndex: 'fechaFinVigencia', width:90, sortable:true}
	 		,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.estado" text="**Estado" />',dataIndex: 'estadoDesc', width:100, sortable:true}
			,{header: '<s:message code="plugin.config.delegaciones.gridcolumn.estado.codigo" text="**Codigo estado" />',dataIndex: 'estadoCod',  hidden:true}
		]
	});

	var ESTADO_ACTVA =  '<fwk:const value="es.pfsgroup.plugin.recovery.config.delegaciones.model.DDEstadoDelegaciones.ACTIVA" />';
	var ESTADO_CERRADA =  '<fwk:const value="es.pfsgroup.plugin.recovery.config.delegaciones.model.DDEstadoDelegaciones.CERRADA" />';
	
	var updateDelegacion = function(){
		var selection = DelegacionesGrid.getSelectionModel().getSelected();
		if(!selection){
			Ext.Msg.alert('<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion.error" text="**Error"/>','<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion" text="**Debe seleccionar alguna delegación." />');
		}else{	
			if(selection.data.estadoCod == ESTADO_ACTVA || selection.data.estadoCod == ESTADO_CERRADA){
				Ext.Msg.alert('<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion.error" text="**Error"/>','<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion.activa" text="**La delegaci&oacute;n seleccionada está activa o cerrada y no se puede editar ni borrar" />');
			}else{
				win = app.openWindow({
                     flow : 'delegaciontareas/editDelegacion'
                     ,title : '<s:message code="plugin.config.delegaciones.new.title" text="**Delegar tareas internas" />'
                     ,width:470
	  				 ,closable:true
                     ,params : {
                     		idDelegacion:selection.id
                     }
	            });
				win.on(app.event.CANCEL,
						function(){
							win.close();
						}
				);
				win.on(app.event.DONE,
						function(){
							win.close();
							recargar();
						}
				);
			}		
	      }
	};
	
	
	var deleteDelegacion = function(){
		var selection = DelegacionesGrid.getSelectionModel().getSelected();
		if(!selection)
			Ext.Msg.alert('<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion.error" text="**Error"/>','<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion" text="**Debe seleccionar alguna delegación." />');
		else{	
	      	Ext.Msg.confirm('<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion.confirmacion" text="**Confirmaci&oacute;n"/>','<s:message code="plugin.config.delegaciones.form.busqueda.validacion.seleccion.borrar" text="**Desea eliminar la delegaci&oacute;n seleccionada?" />', function(btn){
   				if (btn == 'yes'){
      				page.webflow({
		      			flow:'delegaciontareas/borrarDelegacion'
		      			,params:{
		      				idDelegacion:selection.id
		      			}
		      			,success: function(){
		           		    DelegacionesGrid.getSelectionModel().clearSelections();
		           		    recargar();
		           		}
		           	});
	           	}
           	});
      	}
	};
	
	
	
	var recargar = function(){
		var selection = DelegacionesGrid.getSelectionModel().getSelected();
		if(!selection){
			btnBorrar.setDisabled(true);
	    	btnModificar.setDisabled(true);		
    	}else{
    		btnBorrar.setDisabled(false);
	    	btnModificar.setDisabled(false);
    	}
    	
    	var params={
			 start:0
			,limit:limit
			,usuarioOrigen: '${idUserOrigen}'
		};
		
		<sec:authorize ifAllGranted="DELEGAR-CUALQUIER-TAREAS">
		params={
			 start:0
			,limit:limit
		};
		</sec:authorize>
	
		delegacionesStore.webflow(params);		
	};
	
	
	
	
	var btnModificar = new Ext.Button({
		text:'<s:message code="plugin.config.delegaciones.historico.btn.Editar" text="**Modificar" />'
		,iconCls:'icon_edit'
		,disabled:true
		,handler:function(){
			updateDelegacion();
		}
	});
	
	
	var btnBorrar = new Ext.Button({
		text:'<s:message code="plugin.config.delegaciones.historico.btn.Borrar" text="**Borrar" />'
		,iconCls:'icon_menos'
		,disabled:true
		,handler:function(){
			deleteDelegacion();
		}
	});
   
    
    var DelegacionesGrid = new Ext.grid.EditorGridPanel({
    	title: '<s:message code="plugin.config.delegaciones.historico.grid.title" text="**Delegaciones" />'
		,loadMask: {msg: "Cargando...", msgCls: "x-mask-loading"}
		,store: delegacionesStore
		,style : 'margin-bottom:10px;padding-right:10px'
		,cm:delegacionesCm
	    ,clicksToEdit:1
	    ,resizable:true
	    ,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
	    ,width:868
	    ,height: 350
	    ,bbar : [pagingBar,btnModificar,btnBorrar]
	    ,viewConfig : {  forceFit : true}
	    ,monitorResize: true
    });
     
    
    var idCategorizacion;
    var nombreCategorizacion;
    DelegacionesGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
    	var recStore=delegacionesStore.getAt(rowIndex);
    	
    	btnBorrar.setDisabled(false);
    	btnModificar.setDisabled(false);
    	if (recStore.get('id')!=null && recStore.get('id')!=""){
    		idCategorizacion = recStore.get('id');
    		nombreCategorizacion = recStore.get('nombre');
   		}
    	
	});
	
	
	var usuarioRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'username'}
	]);
	 	
	var usuarioOrigenStore = page.getStore({
	       flow: 'coreextension/getListAllUsersPaginated'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, usuarioRecord)	       
	});
	
	var comboUsuarioOrigen = new Ext.form.ComboBox ({
		store:  usuarioOrigenStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText:'---',
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.config.delegaciones.new.usuario.origen" text="**Usuario origen" />',
		loadingText: 'Buscando...',
		labelStyle:'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'remote'
	});
	
	
	var usuarioDestinoStore = page.getStore({
	       flow: 'coreextension/getListAllUsersPaginated'
	       ,reader: new Ext.data.JsonReader({
	    	 root : 'listadoUsuarios'
	    }, usuarioRecord)	       
	});
	
	var lblUsuarioOrigen = new Ext.form.Label({
   		text:'<s:message code="plugin.config.delegaciones.new.usuario.origen" text="**Usuario origen" />: ${userNameOrigen}'
        ,style:{
         'font-size':'10px'
        }
  		,labelStyle:{
                'font-size':'10px'
         }
	});
	
	var usuarioOrigen = lblUsuarioOrigen;
	<sec:authorize ifAllGranted="DELEGAR-CUALQUIER-TAREAS">
		var usuarioOrigen = comboUsuarioOrigen;
	</sec:authorize>
	
	var comboUsuarioDestino = new Ext.form.ComboBox ({
		store:  usuarioDestinoStore,
		allowBlank: true,
		blankElementText: '---',
		emptyText:'---',
		displayField: 'username',
		valueField: 'id',
		fieldLabel: '<s:message code="plugin.config.delegaciones.new.usuario.destino" text="**Usuario destino" />',
		loadingText: 'Buscando...',
		labelStyle:'width:100px',
		width: 250,
		resizable: true,
		pageSize: 10,
		triggerAction: 'all',
		mode: 'remote'
	});
	
	var fechaInicioDesde = new Ext.ux.form.XDateField({
        name : 'fechaInicioDesde'
        ,fieldLabel : '<s:message
		code="plugin.config.delegaciones.busqueda.fechaini.desde"
		text="**Fecha inicio desde" />'
        ,value : ''
        ,width:125
    });
    
    var fechaInicioHasta = new Ext.ux.form.XDateField({
        name : 'fechaInicioHasta'
        ,fieldLabel : '<s:message
		code="plugin.config.delegaciones.busqueda.fechaini.hasta"
		text="**Fecha inicio hasta" />'
        ,value : ''
        ,width:125
    });
    
    var fechaFinDesde = new Ext.ux.form.XDateField({
        name : 'fechaFinDesde'
        ,fieldLabel : '<s:message
		code="plugin.config.delegaciones.busqueda.fechaFin.desde"
		text="**Hasta" />'
        ,value : ''
        ,width:125
    });
    
    var fechaFinHasta = new Ext.ux.form.XDateField({
        name : 'fechaFinHasta'
        ,fieldLabel : '<s:message
		code="plugin.config.delegaciones.busqueda.fechaFin.hasta"
		text="**Hasta" />'
        ,value : ''
        ,width:125
    });

	
	var getParametrosBusqueda=function(){
		var p={
			 start:0
			,limit:limit
			,usuarioDestino:comboUsuarioDestino.getValue()
			,usuarioOrigen: '${idUserOrigen}' 
		}
		
		if(fechaInicioDesde.getValue()!=''){
			p.fechaDesdeIniVigencia = fechaInicioDesde.getValue().format('d/m/Y');
		}
		
		if(fechaInicioHasta.getValue()!=''){
			p.fechaHastaIniVigencia = fechaInicioHasta.getValue().format('d/m/Y');
		}
		
		if(fechaFinDesde.getValue()!=''){
			p.fechaDesdeFinVigencia = fechaFinDesde.getValue().format('d/m/Y');
		}
		
		if(fechaFinHasta.getValue()!=''){
			p.fechaHastaFinVigencia = fechaFinHasta.getValue().format('d/m/Y');
		}
		
		<sec:authorize ifAllGranted="DELEGAR-CUALQUIER-TAREAS">
			p.usuarioOrigen = comboUsuarioOrigen.getValue();
		</sec:authorize>
		
		return p;
	};

	var buscarFunc=function(){
		panelFiltros.collapse(true);
		delegacionesStore.webflow(getParametrosBusqueda());
	};

	
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			app.resetCampos([comboUsuarioDestino,comboUsuarioOrigen,fechaInicioDesde,fechaInicioHasta,fechaFinDesde,fechaFinHasta]);
			recargar();
			panelFiltros.collapse(true);
		}
	});	
	
	
	
	
	var panelFiltros = new Ext.Panel({
		title : '<s:message code="plugin.config.delegaciones.form.busqueda.titulo" text="**B&uacute;squeda de delegaciones"/>'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {columns:2}
		,bodyStyle:'cellspacing:10px;padding-right:10px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:10px;cellspacing:10px;'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset'}
				,items:[usuarioOrigen]
			},{
				layout:'form' 
				,defaults:{xtype:'fieldset'}
				,items:[comboUsuarioDestino]
			},{
				layout:'form' 
				,defaults:{xtype:'fieldset'}
				,items:[fechaInicioDesde]
			},{
				layout:'form' 
				,defaults:{xtype:'fieldset'}
				,items:[fechaInicioHasta]
			},{
				layout:'form' 
				,defaults:{xtype:'fieldset'}
				,items:[fechaFinDesde]
			},{
				layout:'form' 
				,defaults:{xtype:'fieldset'}
				,items:[fechaFinHasta]
			}
			
		]              
		,tbar:[btnBuscar,btnClean]	
	});
	
	
	var mainPanel = new Ext.Panel({
        labelWidth: 50,
    	width: 850,
    	autoHeight: true,
    	border: false,
        bodyStyle: 'padding:5px;',
        layout: 'form',
        items: [{
   					bodyStyle:'padding: 5px;padding-right:15px;',
   					border: false,
   					items:[panelFiltros]
   				},{
   					bodyStyle:'padding: 5px',
   					border: false,
   					items:[DelegacionesGrid]
   				}]
    });
    
    
    
	page.add(mainPanel);
	
	Ext.onReady(function(){
		recargar();
	});
	
</fwk:page>