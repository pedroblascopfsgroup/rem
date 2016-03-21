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
	var limit = 100;
	var isBusqueda= true;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
	};


//Store de Categorizaciones	
	var categorizacionesRecord = Ext.data.Record.create([
		 {name:'id'}
        ,{name:'nombre'}
        ,{name:'codigo'}
        ,{name:'iddespacho'}
        ,{name:'despacho'}
    ]);
    
     var categorizacionesStore = page.getStore({
		id:'categorizacionesStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'categorizacionesStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow : 'categorizaciones/getListaCategorizaciones'
		,reader : new Ext.data.JsonReader({root:'categorizaciones',totalProperty : 'total'}, categorizacionesRecord)
	});
	
	
	
	
//Store de Despachos	
	
	var despachosRecord = Ext.data.Record.create([
		{name:'idDespExt'}
        ,{name:'despacho'}
    ]);
       
    var despachosStore = page.getStore({
		flow : 'categorizaciones/listaDespachosExternos'
		,limit: limit
		,reader : new Ext.data.JsonReader({root:'listaDespachos', totalProperty : 'total'}, despachosRecord)
	});
		
	despachosStore.webflow({});		
	
	
	
	var categorizacionesCm = new Ext.grid.ColumnModel([
			{header: '<s:message code="plugin.procuradores.categorizaciones.gridcolumn.id" text="**Id" />',dataIndex: 'id', sortable:true, hidden:true}			
            ,{header: '<s:message code="plugin.procuradores.categorizaciones.gridcolumn.nombre" text="**Nombre" />',dataIndex: 'nombre', sortable:true}
            ,{header: '<s:message code="plugin.procuradores.categorizaciones.gridcolumn.codigo" text="C&oacute;digo" />',dataIndex: 'codigo', sortable:true}
	 		,{header: '<s:message code="plugin.procuradores.categorizaciones.gridcolumn.iddespacho" text="**IdDespacho" />',dataIndex: 'iddespacho', sortable:true, hidden:true}	
	 		,{header: '<s:message code="plugin.procuradores.categorizaciones.gridcolumn.nomdespacho" text="**Despacho" />',dataIndex: 'despacho', sortable:true}	
	]);



	//Funcion encargada de abrir el popup para editar los datos de las categorizaciones.
	var nuevaCategorizacion=function(){
			win = app.openWindow(
				{
					flow:'categorizaciones/abreVentanaAltaCategorizaciones',
					title : '<s:message code="plugin.procuradores.categorizaciones.form.nuevo.titulo" text="**Nueva Categorizaci&oacute;n" />',
					params: {},
					height:800,
					width: 600
				}
			);
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
	};
	
	
	var updateCategorizacion = function(){
		var selection = categorizacionesGrid.getSelectionModel().getSelected();
		if(!selection){
			Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.texto" text="**Seleccione una categorizaci&oacute;n." />');
		}else{			
			win = app.openWindow(
				{
					flow:'categorizaciones/abreVentanaAltaCategorizaciones',
					title : '<s:message code="plugin.procuradores.categorizaciones.form.modificar.titulo" text="**Modificar Categorizaci&oacute;n" />',
					params: {
						idCategorizacion: idCategorizacion,
						nombreCategorizacion: nombreCategorizacion
					},
					height:800,
					width: 600
				}
			);
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
	};
	
	
	var deleteCategorizacion = function(){
		var selection = categorizacionesGrid.getSelectionModel().getSelected();
		if(!selection)
			Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.texto." text="**Seleccione una categorizaci&oacute;n." />');
		else{	
		
			mainPanel.container.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando" />');
			
			page.webflow({
      			flow:'categorizaciones/comprobarBorradoCategorizacion'
      			,params:{
      				idCategorizacion: idCategorizacion
     			}
      			,success: function(result){		
      				if(result.permitirBorrar == true){
      					page.webflow({
			      			flow:'categorizaciones/borrarCategorizacion'
			      			,params:{
			      				idCategorizacion: idCategorizacion
			      			}
			      			,success: function(){
			      				mainPanel.container.unmask();
			           		    page.fireEvent(app.event.DONE);
			           		    categorizacionesGrid.getSelectionModel().clearSelections();
			           		    recargar();
			           		}
			           	});    
      					
      				}else{
      					mainPanel.container.unmask();
      					Ext.Msg.confirm('<s:message code="plugin.procuradores.categorizaciones.validacion.confirm.titulo" text="**Confirmaci&oacute;n"/>','<s:message code="plugin.procuradores.categorizaciones.validacion.confirm.texto" text="**La categorizaci&oacute;n tiene categor&iacute;as asociadas. Si elimina la categorizaci�n se borrar�n todas sus categor�as y sus asociaciones con los tipos de tarea/resoluci�n. �Desea continuar?" />', function(btn){
		    				if (btn == 'yes'){
		    					mainPanel.container.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando" />');
			      				page.webflow({
					      			flow:'categorizaciones/borrarCategorizacion'
					      			,params:{
					      				idCategorizacion: idCategorizacion
					      			}
					      			,success: function(){
					      				mainPanel.container.unmask();
					           		    page.fireEvent(app.event.DONE);
					           		    categorizacionesGrid.getSelectionModel().clearSelections();
					           		    recargar();
					           		}
					           	});
				           	}
			           	});					
      				}
     			}
          	});	
      	}
	};
	
	
	var asignarTareasCategorias = function(){
		var selection = categorizacionesGrid.getSelectionModel().getSelected();
		if(!selection)
			Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.texto." text="**Seleccione una categorizaci&oacute;n." />');
		else{	
			win = app.openWindow(
				{
					flow:'relacioncategorias/abreVentanaRelacionCategorias',
					title : '<s:message code="plugin.procuradores.categorizaciones.form.relacionTareasCategorias.titulo" text="**Asociar tipos de tarea a categor&oacute;as de" />'+' '+selection.get('nombre') ,
					params: {
						idcategorizacion: idCategorizacion
						,tipoRelacion: 1
					},
					height:800,
					width: 1100
				}
			);
			win.on(app.event.CANCEL,
					function(){
						win.close();
					}
			);
			win.on(app.event.DONE,
					function(){
						win.close();
					}
			);			
      	}
	};
	
	
	
	
	var asignarTiposResolCategorias = function(){
		var selection = categorizacionesGrid.getSelectionModel().getSelected();
		if(!selection)
			Ext.Msg.alert('<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorizaciones.validacion.sinSeleccion.texto." text="**Seleccione una categorizaci&oacute;n." />');
		else{	
			win = app.openWindow(
				{
					flow:'relacioncategorias/abreVentanaRelacionCategorias',
					title : '<s:message code="plugin.procuradores.categorizaciones.form.relacionResolucionCategorias.titulo" text="**Asociar tipos de resoluci&oacute;n a categor&iacute;as de" />'+' '+selection.get('nombre') ,
					params: {
						idcategorizacion: idCategorizacion
						,tipoRelacion: 2
					},
					height:800,
					width: 1100
				}
			);
			win.on(app.event.CANCEL,
					function(){
						win.close();
					}
			);
			win.on(app.event.DONE,
					function(){
						win.close();
					}
			);			
      	}
	};
	
	
	
	
	var recargar = function(){
		var selection = categorizacionesGrid.getSelectionModel().getSelected();
		if(!selection){
			btnBorrar.setDisabled(true);
	    	btnModificar.setDisabled(true);		
	    	btnAsignarTareas.setDisabled(true);	
	    	btnAsignarTipoResol.setDisabled(true);
    	}else{
    		btnBorrar.setDisabled(false);
	    	btnModificar.setDisabled(false);
	    	btnAsignarTareas.setDisabled(false);	
	    	btnAsignarTipoResol.setDisabled(false);
    	}
		categorizacionesStore.webflow(paramsBusquedaInicial);
		
	};
	
	
	var btnAgregar = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorizaciones.boton.agregar" text="**Agregar" />'
		,iconCls:'icon_mas'
		,handler:function(){
				nuevaCategorizacion();
			
		}
	});
	
	
	var btnModificar = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorizaciones.boton.modificar" text="**Modificar" />'
		,iconCls:'icon_edit'
		,disabled:true
		,handler:function(){
			updateCategorizacion();
		}
	});
	
	
	var btnBorrar = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorizaciones.boton.borrar" text="**Borrar" />'
		,iconCls:'icon_menos'
		,disabled:true
		,handler:function(){
			deleteCategorizacion();
		}
	});
		
		
	var btnAsignarTareas = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorizaciones.boton.asignarTareas" text="**Asignar tareas" />'
		,iconCls:'icon_despacho'
		,disabled:true
		,handler:function(){
			asignarTareasCategorias();
		}
	});
	
	
	var btnAsignarTipoResol = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorizaciones.boton.asignarTiposResol" text="**Asignar tipos resoluciones" />'
		,iconCls:'icon_despacho'
		,disabled:true
		,handler:function(){
			asignarTiposResolCategorias();
		}
	});
	
	
	
	
	var categorizacionesGrid=app.crearGrid(categorizacionesStore,categorizacionesCm,{
        title:'<s:message code="plugin.procuradores.categorizaciones.grid.titulo" text="**Categorizaciones" />'
        ,id: 'gridCategorizaciones'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height:350
        ,bbar : [btnAgregar
        		,btnModificar
        		,btnBorrar
        		,btnAsignarTareas
        		,btnAsignarTipoResol
			 ]
    });
    
    var idCategorizacion;
    var nombreCategorizacion;
    categorizacionesGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
    	var recStore=categorizacionesStore.getAt(rowIndex);
    	
    	btnBorrar.setDisabled(false);
    	btnModificar.setDisabled(false);
    	btnAsignarTareas.setDisabled(false);
    	btnAsignarTipoResol.setDisabled(false);
    	if (recStore.get('id')!=null && recStore.get('id')!=""){
    		idCategorizacion = recStore.get('id');
    		nombreCategorizacion = recStore.get('nombre');
   		}
    	
	  }); 
	  
	  
	  
	categorizacionesGrid.on('rowdblclick', function(grid, rowIndex, e){
	var rec = grid.getStore().getAt(rowIndex);
    app.openTab( "<s:message code="plugin.procuradores.categorizaciones.categorias.tab.titulo" text="**Categor&iacute;as de "/>"+" "+rec.get('nombre') 
                 ,'categorias/abreVentanaCategorias'
                 ,{idcategorizacion : rec.get('id')}
		   		 ,{id:'categorizacion_'+rec.get('id') , iconCls:'icon_busquedas'});
	});

	
	
	
	var nombreSeachCategorizacion = new Ext.form.TextField({
		fieldLabel:'<s:message code="plugin.procuradores.categorizaciones.busqueda.filtros.nombre" text="**Nombre" />'
		,listeners:{
			specialkey: function(f,e){  
	            if(e.getKey()==e.ENTER){  
	                buscarFunc();
	            }  
	        } 
		}
	});
	

	var despachoSeachCategorizacion = new Ext.form.ComboBox({
		name: 'comboDespachos'
    	,store: despachosStore
    	,id: 'comboDespachos'
    	,displayField: 'despacho'
    	,valueField: 'idDespExt'
    	,mode: 'local'
    	,triggerAction: 'all'
   		,editable: false
    	,emptyText: 'Seleccionar...'
   		,fieldLabel: '<s:message code="plugin.procuradores.categorizaciones.busqueda.filtros.despacho" text="**Despacho" />'
		,width: 200
		,forceSelection: true
	});

	despachoSeachCategorizacion.on('afterrender', function(combo) {
		combo.mode='remote';	
	});
	
	var getParametrosBusqueda=function(){
		return {
			 start:0
			,limit:limit
			,nombre:nombreSeachCategorizacion.getValue()
			,idDespExt:despachoSeachCategorizacion.getValue()
		}
	};


	var buscarFunc=function(){
		isBusqueda=true;
		panelFiltros.collapse(true);
		categorizacionesStore.webflow(getParametrosBusqueda());
	};

	
	var btnBuscar=app.crearBotonBuscar({
		handler : buscarFunc
	});
	
	var btnClean=new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			app.resetCampos([nombreSeachCategorizacion,despachoSeachCategorizacion]);
			categorizacionesStore.webflow(paramsBusquedaInicial);
			panelFiltros.collapse(true);
		}
	});	
	
	
	
	
	var panelFiltros = new Ext.Panel({
		title : '<s:message code="plugin.procuradores.categorizaciones.form.busqueda.titulo" text="**B&uacute;squeda de Categorizaciones"/>'
		,collapsible : true
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {columns:2}
		,bodyStyle:'cellspacing:10px;padding-right:10px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:10px;cellspacing:10px;'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset'}
				,items:[nombreSeachCategorizacion]
			},{
				layout:'form' 
				,defaults:{xtype:'fieldset'}
				,items:[despachoSeachCategorizacion]
			}
		]              
		,tbar:[btnBuscar,btnClean]	
	});
	
	
	
	
	var mainPanel = new Ext.Panel({
        labelWidth: 50,
    	autoWidth: true,
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
   					items:[categorizacionesGrid]
   				}]
    });
    
    
    
	page.add(mainPanel);
	
	Ext.onReady(function(){

		recargar();
	});
	
</fwk:page>



