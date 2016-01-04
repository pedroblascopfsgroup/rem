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
	var isBusqueda= true;
	
	var paramsBusquedaInicial={
		 start:0
		,limit:limit
		,idcategorizacion: '${idcategorizacion}'
	};
	
	var categoriasRecord = Ext.data.Record.create([
		 {name:'id'}
		,{name:'idcategorizacion'}
        ,{name:'nombre'}
        ,{name:'descripcion'}
        ,{name:'orden'}
    ]);
    
    var categoriasStore = page.getStore({
		id:'categoriasStore'
		,remoteSort:true
		,event:'listado'
		,storeId : 'categoriasStore'
		,limit: limit
		,baseParams:paramsBusquedaInicial
		,flow : 'categorias/getListaCategorias'
		,reader : new Ext.data.JsonReader({root:'categorias',totalProperty : 'total'}, categoriasRecord)
	});
	
	var categoriasCm = new Ext.grid.ColumnModel([
            {header: '<s:message code="plugin.procuradores.categorias.gridcolumn.nombre" text="**Nombre" />',dataIndex: 'nombre', sortable:true}
            ,{header: '<s:message code="plugin.procuradores.categorias.gridcolumn.descripcion" text="**Descripci&oacute;n" />',dataIndex: 'descripcion', sortable:true}
			,{header: '<s:message code="plugin.procuradores.categorias.gridcolumn.orden" text="**Orden visualizaci&oacute;n" />',dataIndex: 'orden', width: 25, align: 'center', sortable:true}
			,{header: '<s:message code="plugin.procuradores.categorias.gridcolumn.id" text="**Id" />',dataIndex: 'id', sortable:true, width: 25, hidden:true}
			,{header: '<s:message code="plugin.procuradores.categorias.gridcolumn.idcategorizacion" text="**IdCategorizacion" />',dataIndex: 'idcategorizacion', width: 25, sortable:true, hidden:true}
	 ]);

	
	
	var recargar = function(){
		var selection = categoriasGrid.getSelectionModel().getSelected();
		if(!selection){
			btnBorrar.setDisabled(true);
    	}else{
    		btnBorrar.setDisabled(false);
    	}
		categoriasStore.webflow(paramsBusquedaInicial);
		
	}
	
	
	//Limpia el formulario de alta/edici&oacute;n y oculta/muestra botones
	var resetFormulario =  function() {
		idcategoria.setValue("");
    	nombre.setValue("");
   		descripcion.setValue("");
   		orden.setValue("");
   		panelFormulario.setTitle('<s:message code="plugin.procuradores.categorias.form.alta.title" text="**Alta categor&iacute;a" />');
   		btnModificar.hide();
   		btnCancelar.hide();
    	btnCrearNuevo.show();
    	btnLimpiar.show();
	};
	
	
	var borrarCategoria = function(){
		var selection = categoriasGrid.getSelectionModel().getSelected();
		if(!selection)
			Ext.Msg.alert('<s:message code="plugin.procuradores.categorias.validacion.sinSeleccion.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorias.validacion.sinSeleccion.texto" text="**Seleccione una categor&iacute;a." />');
		else{
			mainPanel.container.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando" />');
			
			page.webflow({
      			flow:'categorias/comprobarBorradoCategoria'
      			,params:{
      				id: selection.data.id,
     			}
      			,success: function(result){		
      				if(result.permitirBorrar == true){
      					page.webflow({
			      			flow:'categorias/borrarCategoria'
			      			,params:{
			      				id: selection.data.id,
			      			}
			      			,success: function(){
			      				mainPanel.container.unmask();
			           		   	page.fireEvent(app.event.DONE);
			           		   	categoriasGrid.getSelectionModel().clearSelections();
			           		   	resetFormulario();
			           		   	recargar();
			           		}
			           	});    
      					
      				}else{
      					mainPanel.container.unmask();
      					Ext.Msg.confirm('<s:message code="plugin.procuradores.categorias.validacion.conRelaciones.titulo" text="**ConfirmaciÛn"/>', '<s:message code="plugin.procuradores.categorias.validacion.conRelaciones.texto" text="**La categorÌa tiene elementos relacionados. Si elimina la categorÌa se borrar·n todas sus asociaciones con los tipos de tarea/resoluciÛn. øDesea continuar?" />', function(btn){
		    				if (btn == 'yes'){
		    					mainPanel.container.mask('<s:message code="fwk.ui.form.cargando" text="**Cargando" />');
			      				page.webflow({
					      			flow:'categorias/borrarCategoria'
					      			,params:{
					      				id: selection.data.id,
					      			}
					      			,success: function(){
					      				mainPanel.container.unmask();
					           		   	page.fireEvent(app.event.DONE);
					           		   	categoriasGrid.getSelectionModel().clearSelections();
					           		   	resetFormulario();
					           		   	recargar();
					           		}
					           	});
				           	}
			           	});					
      				}
     			}
          	});	
      	}
	}
	
	
	var btnBorrar = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorias.boton.borrar" text="**Borrar" />'
		,iconCls:'icon_menos'
		,disabled:true
		,handler:function(){
			borrarCategoria();
		}
	});
		
	
	
	var pagingBar=fwk.ux.getPaging(categoriasStore);
	
	var categoriasGrid=app.crearGrid(categoriasStore,categoriasCm,{
        title:'<s:message code="plugin.procuradores.categorias.grid.titulo" text="**Categor&iacute;as" />'
        ,style : 'margin-bottom:10px;padding-right:10px'
        ,autoWidth: true
        ,height: 250
        ,bbar : [pagingBar
        		,btnBorrar         		   		      		
		]
    });
    
    
    //Al seleccionar un registro del grid, cargamos el formulario con los datos del registro para su edicion
    categoriasGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) { 
    	var recStore=categoriasStore.getAt(rowIndex);
    	btnBorrar.setDisabled(false);
    	btnModificar.show();
   		btnCancelar.show();
    	btnCrearNuevo.hide();
    	btnLimpiar.hide(); 
    	if (recStore.get('id')!=null && recStore.get('id')!=""){
    		idcategoria.setValue(recStore.get('id'));
    		nombre.setValue(recStore.get('nombre'));
    		descripcion.setValue(recStore.get('descripcion'));
    		orden.setValue(recStore.get('orden'));
    		panelFormulario.setTitle('<s:message code="plugin.procuradores.categorias.form.editar.title" text="**Edici&oacute;n categor&iacute;a" />' +' '+ recStore.get('nombre'));  		
   		}	
	}); 
	

	var saveCategoria =  function() {
		panelFormulario.container.mask('<s:message code="fwk.ui.form.guardando" text="**Guardando" />');
		panelFormulario.getForm().submit(
		{	
		    clientValidation: true,
			url: '/'+app.getAppName()+'/categorias/guardarCategoria.htm',
			 success: function(form, action) {
		       panelFormulario.container.unmask();
		       page.fireEvent(app.event.DONE);
		       categoriasGrid.getSelectionModel().clearSelections();
           	   resetFormulario();
		       recargar();
		    },
		    failure: function(form, action) {
		    	panelFormulario.container.unmask();
		        switch (action.failureType) {					
		            case Ext.form.Action.CLIENT_INVALID:
		                Ext.Msg.alert('<s:message code="plugin.procuradores.categorias.validacion.camposFormulario.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorias.validacion.revisarFormulario.texto" text="**Revise los campos del formulario." />');
		                break;
		            case Ext.form.Action.CONNECT_FAILURE:	            	
		                Ext.Msg.alert('<s:message code="plugin.procuradores.categorias.validacion.camposFormulario.titulo" text="**Error"/>','<s:message code="plugin.procuradores.categorias.validacion.errorComunicacion.texto" text="**Error de comunicaci&oacute;n." />');
		                break;
		       }
		    }
		});
	};


//Definici√≥n de botones de la p&aacute;gina

	var btnCrearNuevo = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorias.boton.crearNuevo" text="**Crear nuevo" />'
		,iconCls:'icon_mas'
		,handler:function(){
			saveCategoria();
		}
	});
	

	var btnLimpiar = new Ext.Button({
		text:'<s:message code="app.botones.limpiar" text="**Limpiar" />'
		,iconCls:'icon_limpiar'
		,handler:function(){
			categoriasGrid.getSelectionModel().clearSelections();
			resetFormulario();
			recargar();
		}
	});
	
	
	var btnModificar = new Ext.Button({
		text:'<s:message code="plugin.procuradores.categorias.boton.modificar" text="**Modificar" />'
		,iconCls:'icon_edit'
		,hidden:true
		,handler:function(){
			saveCategoria();
		}
	});
	
	
	var btnCancelar= new Ext.Button({
		text : '<s:message code="app.cancelar" text="**Cancelar" />'
		,iconCls : 'icon_cancel'
		,hidden:true
		,handler:function(){
			categoriasGrid.getSelectionModel().clearSelections();
			resetFormulario();
			recargar();
		}
	});
	
	
//Definici&oacute;n de campos del formulario
	
	var idcategoria = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorias.form.campo.id" text="**Id" />'				
		, name:'id'
		, value:'${Categoria.id}'
		, hidden:true
	});
	
	
	var idcategorizacion = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorias.form.campo.idcategorizacion" text="**Idcategorizacion" />'		
		, name:'idcategorizacion'
		, value:'${idcategorizacion}'
		, hidden:true
	});
	
	
	var descripcion = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorias.form.campo.descripcion" text="**Descripci&oacute;n" />'
		, name:'descripcion'
		, value:'${Categoria.descripcion}'
		, width: 400	
	});
	
	
	
	var nombre = new Ext.form.TextField({
		fieldLabel: '<s:message code="plugin.procuradores.categorias.form.campo.nombre" text="**Nombre" />'
		,name:'nombre'
		, value:'${Categoria.nombre}'
		, width: 200
		, allowBlank: false
		, listeners: {
       		blur: function(cmp) {
		    	if (cmp.getValue().trim() == ''){
		    		cmp.setValue("");
		   		}	
       		}
    	}
	});
	
	
	
	var orden = new Ext.form.NumberField({
		fieldLabel: '<s:message code="plugin.procuradores.categorias.form.campo.orden" text="**Orden" />'				
		, name: 'orden'
		, value: '${Categoria.orden}'
		, allowDecimals: false
		, allowNegative: false
		, maxValue: 999
		, hidden: false
	});
	
	
	var panelFormulario = new Ext.form.FormPanel({
		title : '<s:message code="plugin.procuradores.categorias.form.alta.title" text="**Alta categor&iacute;a"/>'
		,collapsible : false
		,titleCollapse : true
		,layout:'table'
		,layoutConfig : {columns:2}
		,bodyStyle:'cellspacing:10px;padding-right:10px;'
		,defaults : {xtype:'panel', border : false ,cellCls : 'vtop', layout : 'form', bodyStyle:'padding:5px;cellspacing:10px;'}
		,items:[{
				layout:'form'
				,defaults:{xtype:'fieldset',border:false}
				,width:'600px'
				,items:[{
					items: [ 
						idcategoria
						, idcategorizacion
						, nombre
						, descripcion 
						, orden
					]
				}]
			}
		]              
		,tbar:[
			btnCrearNuevo
			, btnLimpiar
			, btnModificar
			, btnCancelar			
		]
	}); 
	  
	
	var mainPanel = new Ext.Panel({
        labelWidth: 50,
    	autoWidth:true,
    	autoHeight:true,
    	border:false,
        bodyStyle: 'padding:5px;border:0',
        layout: 'form',
        items: [{
   					bodyStyle:'padding: 5px',
   					border:false,
   					items:[categoriasGrid]
   				},
   				{
   					bodyStyle:'padding: 5px;padding-right:15px;',
   					border:false,
   					items:[panelFormulario]
   				}
 		]
    });
    
    
    
	page.add(mainPanel);
	
	Ext.onReady(function(){
		recargar();
	});
	
</fwk:page>



