Ext.define('HreRem.view.activos.tramites.TramiteDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.tramitedetalle', 

    control: {

         'tareaslist gridBase': {
             aftersaveTarea: function(grid) {
             	grid.getStore().load();
             }
         }
         
     },
    
	cargarTabData: function (tab) {

		var me = this,
		model = tab.getModelInstance(),
		id = me.getViewModel().get("tramite.idTramite");
		model.setId(id);
		model.load({
		    success: function(record) {
		    	tab.setBindRecord(record);
		    }
		});
	},
	
	onClickBotonCerrarPestanya: function(btn) {
    	var me = this;
    	me.getView().destroy();
    },
    
    onClickBotonCerrarTodas: function(btn) {
    	var me = this;
    	me.getView().up("tabpanel").fireEvent("cerrarTodas", me.getView().up("tabpanel"));    	

    },
	
	/**
     * Función que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la función 
     * funciónRecargar con el código necesario para refrescar los datos.
     */
	onClickBotonRefrescar: function (btn) {
		
		var me = this,
		activeTab = me.getView().down("tabpanel").getActiveTab();		
		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar
		if(activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
		
		me.getView().fireEvent("refrescarTramite", me.getView());
	},
	

	
	hacerEditable: function(form, xtype) {
				
		var me = this;
		var editor = new Ext.Editor({
		    // update the innerHTML of the bound element 
		    // when editing completes
		    updateEl: true,
		    alignment: 'l-l',
		    autoSize: {
		        width: 'boundEl'
		    },
		    field: {
		        xtype: 'textfield'
		    }
		});
		
		form.getTargetEl().on('dblclick', function(e, t) {
		    editor.startEdit(t);
		    // Manually focus, since clicking on the label will focus the text field
		    editor.field.focus(50, true);
		});

	},
	        
    onChangeChainedCombo: function(combo) {
    	
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);
		chainedCombo.clearValue("");
		me.getViewModel().notify();
		me.getViewModel().getStore(combo.chainedStore).load(); 	
    	
    },
   
   	onSaveFormularioCompleto: function(form) {
		var me = this;
		// TODO VALIDACIONES
		form.getBindRecord().save();
		
	},
	
	onClickBotonEditar: function(btn) {
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		
	},
    
	onClickBotonGuardar: function(btn) {
		
		var me = this;
		
		btn.hide();
		btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();
		
		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
		
		me.onSaveFormularioCompleto(btn.up('tabpanel').getActiveTab());				
	},
	
	onClickBotonCancelar: function(btn) {
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();
		
		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
	},
	
	onTramitesListDobleClick : function(gridView,record) {
    	var me = this;
    	me.getView().fireEvent('abrirDetalleTramite', grid,record);
    },
	
    onTareasListSelect : function(gridView,record) {
		var me = this;
		me.getView().down('[name=btnAutoprorroga]').setDisabled(false);
	},
	
    onTareasListDeselect : function(gridView,record) {
		var me = this;
		me.getView().down('[name=btnAutoprorroga]').setDisabled(true);
	},
	
	onTareasListDobleClick : function(gridView,record) {
		var me = this,
		idTrabajo = me.getViewModel().get("tramite.idTrabajo");
		idActivo = me.getViewModel().get("tramite.idActivo");
		idExpediente = me.getViewModel().get("tramite.idExpediente");
		numEC = me.getViewModel().get("tramite.numEC");
		
		me.getView().fireEvent('abrirtarea',record, gridView.up('grid'), me.getView(), idTrabajo, idActivo, idExpediente, numEC);
	},
	
	onTareasListDobleClickHistorico : function(gridView,record) {
		var me = this;
		me.getView().fireEvent('abrirtareahistorico',record);
	},
	
	onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
		
		var me = this;
		var grid = tableView.up('grid');
		var record = grid.store.getAt(indiceFila);
		
		grid.setSelection(record);
		
		//grid.fireEvent("abriractivo", record);
		me.getView().fireEvent('abrirDetalleActivoPrincipal', record.get('numActivoRem'));
		
	}, 

	solicitarAutoprorroga: function(button){
		var me = this;
		
		var idTareaExterna = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idTareaExterna");
		
		me.getView().fireEvent('solicitarautoprorroga', me.getView(), idTareaExterna);
	},
	
	generarAutoprorroga: function(button) {
		var me = this;
		
		var formulario = me.getView().down('[reference=formSolicitarProrroga]');
		
		if(formulario.getForm().isValid()) {
			
			button.up('window').mask("Guardando....");
			
    		var task = new Ext.util.DelayedTask(function(){    			
 
    			me.getView().mask(HreRem.i18n("msg.mask.loading"));
    			var parametros = formulario.getValues();
    			
    			
    			var url = $AC.getRemoteUrl('agenda/generarAutoprorroga');
    	    	var data;
    	    	Ext.Ajax.request({
    	    			url:url,
    	    			params: parametros,
    	    			success: function(response,opts){
    	    				data = Ext.decode(response.responseText);
    	    				if(data.success == 'true')
    	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
    	    				else
    	    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga")); 
    	    			},
    	    			failure: function(options, success, response){
    	    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga")); 
    	    			},
    	    			callback: function(options, success, response){
    	    				me.getView().unmask();
    	    				button.up('window').unmask();
    	    				button.up('window').destroy();
    	    			}
    	    	});
			});
			
			task.delay(500);
		}
		me.onClickBotonRefrescar(button);
	},
	
	saltoCierreEconomico: function(button){
		var me = this;
		
		var idTareaExterna = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idTareaExterna");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		var url = $AC.getRemoteUrl('agenda/saltoCierreEconomico');
		
		var data;
		Ext.Ajax.request({
			url:url,
			params: {idTareaExterna : idTareaExterna},
			success: function(response, opts){
				data = Ext.decode(response.responseText);
				if(data.success == 'true')
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				else
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
			},
			failure: function(options, success, response){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
			},
			callback: function(options, success, response){
				me.getView().unmask();
			}
		})
		me.onClickBotonRefrescar(button);
		//me.getView().fireEvent('saltocierreeconomico', me.getView(), idTareaExterna);
	},
	
	saltoResolucionExpediente: function(button){
		var me = this;
		
		var idTareaExterna = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idTareaExterna");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		var url = $AC.getRemoteUrl('agenda/saltoResolucionExpediente');
		
		var data;
		Ext.Ajax.request({
			url:url,
			params: {idTareaExterna : idTareaExterna},
			success: function(response, opts){
				data = Ext.decode(response.responseText);
				if(data.success == 'true')
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				else
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
			},
			failure: function(options, success, response){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
			},
			callback: function(options, success, response){
				me.getView().unmask();
			}
		})
		me.onClickBotonRefrescar(button);
		//me.getView().fireEvent('saltocierreeconomico', me.getView(), idTareaExterna);
	},
	
	//	generaSaltoCierreEconomico: function(button) {
	//		var me = this;
	//		
	//		var formulario = me.getView().down('[reference=formSolicitarProrroga]');
	//		
	//		if(formulario.getForm().isValid()) {
	//			
	//			button.up('window').mask("Guardando....");
	//			
	//    		var task = new Ext.util.DelayedTask(function(){    			
	// 
	//    			me.getView().mask(HreRem.i18n("msg.mask.loading"));
	//    			var parametros = formulario.getValues();
	//    			
	//    			
	//    			var url = $AC.getRemoteUrl('agenda/generarAutoprorroga');
	//    	    	var data;
	//    	    	Ext.Ajax.request({
	//    	    			url:url,
	//    	    			params: parametros,
	//    	    			success: function(response,opts){
	//    	    				data = Ext.decode(response.responseText);
	//    	    				if(data.success == 'true')
	//    	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	//    	    				else
	//    	    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga")); 
	//    	    			},
	//    	    			failure: function(options, success, response){
	//    	    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga")); 
	//    	    			},
	//    	    			callback: function(options, success, response){
	//    	    				me.getView().unmask();
	//    	    				button.up('window').unmask();
	//    	    				button.up('window').destroy();
	//    	    			}
	//    	    	});
	//			});
				
	//			task.delay(500);
	//		}
	//			
	//    	
	//	},
		
		
	cancelarProrroga: function(button) {
    	
		button.up('window').destroy();
        	
     }

});