Ext.define('HreRem.view.activos.comercial.solicitudes.SolicitudesMainController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.solicitudes',
    
    requires: ['HreRem.view.activos.comercial.solicitudes.SolicitudDetalle', 'HreRem.model.Solicitud'],
    	
    	
    	onSolicitudesListDblClick: function ( grid, record) {    
    		var me = this;
    		me.abrirVentanaEdicionSolicitud(record);    		
    	},
    
    	// Funcion que se ejecuta al hacer click en el botón de añadir solicitud
        onAddClick: function(btn) {
        	var me = this;          	
        	// Abrimos el formulario con una solicitud vacia
        	me.abrirVentanaEdicionSolicitud(Ext.create("HreRem.model.Solicitud", {idActivo:me.getViewModel().get("idActivo")}));       	
        },
        
        // Funcion que se ejecuta al hacer click en el botón de editar solicitud
        onEditClick: function(btn) {

        	var me = this,
        	seleccion = btn.up('grid').getSelection();
        	
        	if(Ext.isArray(seleccion) && seleccion.length != 1) {
        		Ext.Msg.show({
				    message: 'Es obligatorio seleccionar un único registro.',
				    buttons: Ext.Msg.YES,
				    icon: Ext.Msg.WARNING}); 
        	} else {
        		// Abrimos el formulario con la solicitud seleccionada
        		me.abrirVentanaEdicionSolicitud(seleccion[0]);  
        	}        
        },
        
            	// Funcion que se ejecuta al hacer click en el botón de eliminar solicitud/es
        onDeleteClick: function(btn) {
        	
        	var me = this,
        	seleccionados = btn.up('grid').getSelection(),
        	gridStore = me.lookupReference("solicitudesList").getStore();
        	
        	if(Ext.isArray(seleccionados) && seleccionados.length != 0) {
				
				Ext.Msg.show({
				    title:'Eliminar registros',
				    message: '¿Está seguro que desea eliminar los registros seleccionados?',
				    buttons: Ext.Msg.YESNO,
				    icon: Ext.Msg.QUESTION,
				    fn: function(btn) {
				        if (btn === 'yes') {
				        	
				        	// Eliminamos todas las solicitudes seleccionadas
				        	Ext.Array.each(seleccionados, function(seleccion, index) {
        						gridStore.remove(seleccion);
        					});
				        }
				    }
				});  
        	}      	

        },
        
        abrirVentanaEdicionSolicitud: function (solicitud) {

	        var me = this;	        
	        var solicitudDetalle = me.lookupReference("solicitudDetalle");
	        var solicitudesMainCard = me.lookupReference("solicitudesMain");
	        winFormSolicitud = Ext.create('HreRem.view.common.WindowBase',{
	        	header: false,
	        	items: [{
	        				xtype: 'solicituddetalle',
	        				controller: 'solicitudform'
	        	}]
	        });
	        

	        winFormSolicitud.down('solicituddetalle').actualizarDetalle(solicitud);     
	        winFormSolicitud.show();
       
        },
        /*  Se utiliza en el caso de querere mostrar el formulario como un card por encima del buscador de solicitudes
        abrirFormularioEdicionSolicitud: function (solicitud) {

	        var me = this;	        
	        var solicitudDetalle = me.lookupReference("solicitudDetalle");
	        var solicitudesMainCard = me.lookupReference("solicitudesMain");
	        //winFormSolicitud = Ext.create(HreRem.view.activos.comercial.solicitudes.SolicitudDetalle,{altaSolicitud:  Ext.isEmpty(solicitud.get("id"))});
			
	        solicitudDetalle.actualizarDetalle(solicitud);     
	        
	        me.getView().getLayout().next();
	        
       
        },
        
       
        
        
        
        onSaveClick: function(button) {
        	
        	var me = this,
        	solicitudDetalle = me.lookupReference("solicitudDetalle"),
        	form = me.lookupReference("formSolicitudDetalle"),
        	record;  
        	
        	Ext.Msg.show({
			    title:'Guardar solicitud',
			    message: '¿Está seguro que desea guardar los cambios?',
			    buttons: Ext.Msg.YESNO,
			    icon: Ext.Msg.QUESTION,
			    fn: function(btn) {
			        if (btn === 'yes') { 
			        	
			        	form.updateRecord();        	
			        	record = form.getRecord();
			        	
			        	if(solicitudDetalle.isNew) {
			        		me.lookupReference("solicitudesList").getStore().add(record);
			        	}
			        	
			        	me.getView().getLayout().prev();
			        }
			    }
			});
        	
        	
        	

        },
        
        onCancelClick: function(button) {
        	
        	var me = this;
        	
        	Ext.Msg.show({
			    title:'Cancelar edición',
			    message: '¿Está seguro que desea cerrar la ventana?',
			    buttons: Ext.Msg.YESNO,
			    icon: Ext.Msg.QUESTION,
			    fn: function(btn) {
			        if (btn === 'yes') { 
			        	var solicitudesGestion = me.lookupReference("solicitudesGestion");
				    	me.getView().getLayout().prev();
			        	
			        }
			    }
			});    	
        	
        } ,
        
        onChangeCheckboxPresentarOferta: function(chkBox, newValue) {
        	
        	var me = this,
        	fieldOferta = me.lookupReference("textfieldOferta");
        	
        	if (newValue) {
        		fieldOferta.setDisabled(false)        		
        	} else {
        		fieldOferta.setDisabled(true);
        		fieldOferta.setValue("");
        	}
        },*/
        
	        //Funcion que se ejecuta al hacer click en el botón buscar
		onSearchClick: function(btn) {
			
			var initialData = {};
			var filters = [];

			var searchForm = btn.up('formBase');
			if (searchForm.isValid()) {
				var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
				
				Ext.Object.each(criteria, function(key, val) {
					filters.push(Ext.util.Filter.create({property: key, value: val}));
				});
	
				btn.up('formBase').up('panel').down('gridBase').getStore().filter(filters);
	        }
		},
		
		
		// Funcion que se ejecuta al hacer click en el botón limpiar
		onCleanFiltersClick: function(btn) {
	
			btn.up('panel').getForm().reset();
				
		}

});