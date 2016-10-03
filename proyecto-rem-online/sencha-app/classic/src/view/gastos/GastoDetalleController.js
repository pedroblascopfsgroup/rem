Ext.define('HreRem.view.gastos.GastoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gastodetalle',  
	
    requires: ['HreRem.view.gastos.SeleccionTrabajosGasto'],
	
	cargarTabData: function (form) {
		var me = this,
		id = me.getViewModel().get("gasto.id"),
		model = form.getModelInstance();
		form.up("tabpanel").mask(HreRem.i18n("msg.mask.loading"));	
		
		model.setId(id);
		model.load({
		    success: function(record) {
		    	
		    	form.setBindRecord(record);
		    	
		    	form.up("tabpanel").unmask();
		    }
		});
	},
	
	cargarTabDataMultiple: function (form,index, models, nameModels) {
		var me = this,
		id = me.getViewModel().get("gasto.id");
		
		models[index].setId(id);
		
		if(Ext.isDefined(models[index].getProxy().getApi().read)) {
			// Si la API tiene metodo de lectura (read).
			models[index].load({
			    success: function(record) {		    	
			    	me.getViewModel().set(nameModels[index], record);
			    	index++;
							
					if (index < models.length) {							
						me.cargarTabDataMultiple(form, index, models, nameModels);
					} else {	
						form.unmask();				
					}
			    },			            
				failure: function (a, operation) {
					 form.unmask();
				}
			});
		} else {
			// Si la API no contiene metodo de lectura (read).
			me.getViewModel().set(nameModels[index], models[index]);
	    	index++;
					
			if (index < models.length) {							
				me.cargarTabDataMultiple(form, index, models, nameModels);
			} else {	
				form.unmask();				
			}
		}
	
	},

	onSaveFormularioCompleto: function(btn, form, success) {
		
		var me = this;
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones
		if(form.isFormValid() && !form.disableValidation || form.disableValidation) {

			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);
			
			if(!Ext.isEmpty(btn)) {
				btn.hide();
				btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
				btn.up('tabbar').down('button[itemId=botoneditar]').show();
				me.getViewModel().set("editing", false);
			}
			
			if (!form.saveMultiple) {
				if(Ext.isDefined(form.getBindRecord().getProxy().getApi().create) || Ext.isDefined(form.getBindRecord().getProxy().getApi().update)) {
					// Si la API tiene metodo de escritura (create or update).
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
					
					form.getBindRecord().save({
						success: success,				            
			            failure: function (a, operation) {
			            	var data = {};
                            try {
                            	data = Ext.decode(operation._response.responseText);
                            }
                            catch (e){ };
                            if (!Ext.isEmpty(data.msg)) {
                            	me.fireEvent("errorToast", data.msg);
                            } else {
                            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                            }
							me.getView().unmask();
							me.refrescarGasto(form.refreshAfterSave);
			            }
					});
				}
			//Guardamos múltiples records	
			} else {
				var records = form.getBindRecords();
				var contador = 0;
				me.saveMultipleRecords(contador, records);
			}
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
		
	},
	
	saveMultipleRecords: function(contador, records) {
		var me = this;
		if(Ext.isDefined(records[contador].getProxy().getApi().create) || Ext.isDefined(records[contador].getProxy().getApi().update)) {
			// Si la API tiene metodo de escritura (create or update).
			
			records[contador].save({
				success: function (a, operation, c) {
						contador++;
						
						if (contador < records.length) {
							me.saveMultipleRecords(contador, records);
						} else {
							 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));						
							 me.getView().unmask();
							 me.refrescarExpediente(false);							 
						}
	            },
	            failure: function (a, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.getView().unmask();
	            }
			});		
		}
	},

	onClickBotonEditar: function(btn) {
		var me = this;
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();
		me.getViewModel().set("editing", true);		

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		
	},
    
	onClickBotonGuardar: function(btn) {
		var me = this;
		
		var success = function (a, operation, c) {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().unmask();
					me.refrescarGasto(btn.up('tabpanel').getActiveTab().refreshAfterSave);
		};
		
		me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab(), success);				
	},
	
	onClickBotonCancelar: function(btn) {
		var me = this,
		activeTab = btn.up('tabpanel').getActiveTab();

		if (!activeTab.saveMultiple) {
			if(activeTab && activeTab.getBindRecord && activeTab.getBindRecord()) {
				/*activeTab.getForm().clearInvalid();
				activeTab.getBindRecord().reject();*/
				me.onClickBotonRefrescar();
				
			}
		} else {
			
			var records = activeTab.getBindRecords();
			
			for (i=0; i<records.length; i++) {
				//records[i].reject();
				me.onClickBotonRefrescar();
			}

		}	

		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();
		me.getViewModel().set("editing", false);
		
		Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
	},
	
	 /**
     * Función que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la función 
     * funciónRecargar con el código necesario para refrescar los datos.
     */
	onClickBotonRefrescar: function (btn) {
		var me = this;
		me.refrescarGasto(true);

	},
	
	refrescarGasto: function(refrescarPestañaActiva) {
		var me = this,
		
		refrescarPestañaActiva = Ext.isEmpty(refrescarPestañaActiva) ? false: refrescarPestañaActiva,
		activeTab = me.getView().down("tabpanel").getActiveTab();
		if(!Ext.isEmpty(activeTab.down('[name=buscadorNifEmisorField]'))){
  			var buscadorNifEmisor= activeTab.down('[name=buscadorNifEmisorField]').getValue();
		}
		if(!Ext.isEmpty(activeTab.down('[name=buscadorNifPropietarioField]'))){
  			var buscadorNifPropietario= activeTab.down('[name=buscadorNifPropietarioField]').getValue();
		}
    	/*if(!Ext.isEmpty(buscadorNifEmisor)){
    		activeTab.down('[name=buscadorNifEmisorField]').setHidden(true);
    		//activeTab.down('[name=nifEmisor]').setHidden(false);
    	}
    	if(!Ext.isEmpty(buscadorNifPropietario)){
    		activeTab.down('[name=buscadorNifPropietarioField]').setHidden(true);
    		//activeTab.down('[name=nifPropietario]').setHidden(false);
    	}*/
		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar 
		if(refrescarPestañaActiva && activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
		
		me.getView().fireEvent("refrescarGasto", me.getView());
		
	},
	
	buscarProveedor: function(field, e){
		var me= this;
		var url =  $AC.getRemoteUrl('gastosproveedor/searchProveedorNif');
		var nifProveedor= field.getValue();
		var data;
		
		Ext.Ajax.request({
		    			
		    		     url: url,
		    		     params: {nifProveedor : nifProveedor},
		    		
		    		     success: function(response, opts) {
		    		    	 data = Ext.decode(response.responseText);
		    		    	 var emisorGastoField = field.up('formBase').down('[name=nifEmisor]');
		    		    	 buscadorNifEmisor = field.up('formBase').down('[name=buscadorNifEmisorField]'),
		    		    	 nombreEmisorGasto = field.up('formBase').down('[name=nombreEmisor]'),
		    		    	 codigoEmisorGasto = field.up('formBase').down('[name=codigoEmisor]');
		    		    	 
		    		    	 if(!Utils.isEmptyJSON(data.data)){
		    		    	 	var id= data.data.id;
		    		    	 	var nombreEmisor= data.data.nombre;
		    		    	 	var codigoEmisor= data.data.codProveedorUvem;	    		    	 	
		    		    	 	
		    		    	 	if(!Ext.isEmpty(emisorGastoField)) {
		    		    	 		emisorGastoField.setValue(nifProveedor);
		    		    	 	}
		    		    	 	
		    		    	 	if(!Ext.isEmpty(buscadorNifEmisor)) {
		    		    	 		buscadorNifEmisor.setValue(nifProveedor);
		    		    	 	}
		    		    	 	
		    		    	 	if(!Ext.isEmpty(nombreEmisorGasto)) {
		    		    	 		nombreEmisorGasto.setValue(nombreEmisor);
		    		    	 	}
		    		    	 	
		    		    	 	if(!Ext.isEmpty(codigoEmisorGasto)) {
		    		    	 		codigoEmisorGasto.setValue(codigoEmisor);
		    		    	 	}
		
		    		    	 }
		    		    	 else{
		    		    	 	if(!Ext.isEmpty(nombreEmisorGasto)) {
		    		    	 		nombreEmisorGasto.setValue('');
		    		    	 	}
		    		    	 	if(!Ext.isEmpty(codigoEmisorGasto)) {
		    		    	 		codigoEmisorGasto.setValue('');
		    		    	 	}
		    		    	 	me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.proveedor"));
		    		    	 }
		    		    	 
		    		     },
		    		     failure: function(response) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    		     },
		    		     callback: function(options, success, response){
		    		     }
		    		     
		});
		
	},
	
	buscarPropietario: function(field, e){
		
		var me= this;
		var url =  $AC.getRemoteUrl('gastosproveedor/searchPropietarioNif');
		var nifPropietario= field.getValue();
		var data;
		
		Ext.Ajax.request({
		    			
		 		url: url,
		   		params: {nifPropietario : nifPropietario},
		    		
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
			    	//var propietarioGastoField = field.up('formBase').down('[name=nifPropietario]')
		    		var buscadorNifPropietario = field.up('formBase').down('[name=buscadorNifPropietarioField]'),
		    		nombrePropietarioGasto = field.up('formBase').down('[name=nombrePropietario]');
		    		
			    	if(!Utils.isEmptyJSON(data.data)){
						var id= data.data.id;
		    		    var nombrePropietario= data.data.nombre;
		    		    /*if(!Ext.isEmpty(propietarioGastoField)) {
		    		    	propietarioGastoField.setValue(nifPropietario);
		    		    }*/
		    		    if(!Ext.isEmpty(buscadorNifPropietario)) {
		    		    	buscadorNifPropietario.setValue(nifPropietario);
		    		    }
		    		    if(!Ext.isEmpty(nombrePropietarioGasto)) {
		    		    	nombrePropietarioGasto.setValue(nombrePropietario);
		    		    }
		    		    
			    	}
			    	else{
			    		if(!Ext.isEmpty(nombrePropietarioGasto)) {
		    		    	nombrePropietarioGasto.setValue('');
		    		    }
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.propietario"));
			    	}
		    		    	 
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}
		    		     
		  });
		
	},
	
	onHaCambiadoComboDestinatario: function(combo, value){
		var me= this;
		/*if(CONST.TIPOS_DESTINATARIO_GASTO['PROPIETARIO'] == value){
			me.getView().down('[name=nifPropietario]').setVisible(false);
			me.getView().down('[name=nombrePropietario]').setVisible(false);
			me.getView().down('[name=buscadorNifPropietarioField]').setVisible(false);
			me.getView().down('[name=nifPropietario]').allowBlank= false;
		}
		else{
			me.getView().down('[name=nifPropietario]').setDisabled(true);
			me.getView().down('[name=nombrePropietario]').setDisabled(true);
		}*/
		
	},
	
	onCambiaImportePrincipalSujeto: function(field, e){
		var me= this;
		if(!Ext.isEmpty(field.getValue())){
			me.lookupReference('importePrincipalNoSujeto').allowBlank= true;
		}else{
			me.lookupReference('importePrincipalNoSujeto').allowBlank= false;
		}
	},
	
	onCambiaImportePrincipalNoSujeto: function(field, e){
		var me= this;
		if(!Ext.isEmpty(field.getValue())){
			me.lookupReference('importePrincipalSujeto').allowBlank= true;
		}else{
			me.lookupReference('importePrincipalSujeto').allowBlank= false;
		}
	},
	
	onHaCambiadoFechaTopePago: function(field, value){
		var me= this;
		var fechaPago= me.lookupReference('fechaPago').getValue();
		if(!Ext.isEmpty(me.lookupReference('destinatariosPago'))){
			if(fechaPago<value){
				me.lookupReference('destinatariosPago').setDisabled(false);
				me.lookupReference('destinatariosPago').allowBlank= false;
			}else{
				me.lookupReference('destinatariosPago').setDisabled(true);
				me.lookupReference('destinatariosPago').allowBlank= true;
			}
		}
	},
	
	onHaCambiadoFechaPago: function(field, value){
		var me= this;
		var fechaTopePago= me.lookupReference('fechaTopePago').getValue();
		if(!Ext.isEmpty(me.lookupReference('destinatariosPago'))){
			if(fechaTopePago<value){
				me.lookupReference('destinatariosPago').setDisabled(false);
				me.lookupReference('destinatariosPago').allowBlank= false;
			}
			else{
				me.lookupReference('destinatariosPago').setDisabled(true);
				me.lookupReference('destinatariosPago').allowBlank= true;
			}
		}
	},
	
	onChangeChainedCombo: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);   
    	
    	me.getViewModel().notify();
    	
    	if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
    	}
		
		chainedCombo.getStore().load({ 			
			callback: function(records, operation, success) {
   				if(!Ext.isEmpty(records) && records.length > 0) {
   					if (chainedCombo.selectFirst == true) {
	   					chainedCombo.setSelection(1);
	   				};
   					chainedCombo.setDisabled(false);
   				} else {
   					chainedCombo.setDisabled(true);
   				}
			}
		});
		
		if (me.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}

    },
    
    onCambiaBuscadorActivo: function(field, value){
    	var me= this;
    	if(!Ext.isEmpty(value)){
    		me.lookupReference('botonIncluirActivoRef').setDisabled(false);
    	}else{
    		me.lookupReference('botonIncluirActivoRef').setDisabled(true);
    	}
    },
    
    onCambiaBuscadorAgrupacion: function(field, value){
    	var me= this;
    	if(!Ext.isEmpty(value)){
    		me.lookupReference('botonIncluirAgrupacionRef').setDisabled(false);
    	}else{
    		me.lookupReference('botonIncluirAgrupacionRef').setDisabled(true);
    	}
    },
    
    onClickBotonCancelarGastoActivo: function(btn){
    	var me = this,
		window = btn.up('window');
    	window.close();
    },
    
    onClickBotonGuardarGastoActivo: function(btn){
    	var me= this;
    	var window = btn.up('window');
    	var form= window.down('formBase');
    	var detalle= btn.up().up().down('anyadirnuevogastoactivodetalle');
    	var idGasto = detalle.up().idGasto;
    	if(!Ext.isEmpty(detalle.getBindRecord())){
	    	
	    	var numeroActivo= detalle.getBindRecord().numActivo;
	    	var numeroAgrupacion= detalle.getBindRecord().numAgrupacion;
	    	
	    	if(!Ext.isEmpty(numeroActivo) && !Ext.isEmpty(numeroAgrupacion)){
	    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.activo.gasto.busqueda.no.posible"));
	    	}
	    	else if(!Ext.isEmpty(numeroActivo)){
	    		if(Ext.isDefined(detalle.getModelInstance().getProxy().getApi().create)){
	    			detalle.getModelInstance().getProxy().extraParams.idGasto = idGasto;
	    			detalle.getModelInstance().getProxy().extraParams.numActivo = numeroActivo;
	    			detalle.getModelInstance().getProxy().extraParams.numAgrupacion = null;
	    			detalle.getModelInstance().save({
	    				success: function(a, operation, c){
	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    				},
	    				failure: function(a, operation){
	    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    				},
	    				callback: function(records, operation, success) {
	    					form.reset();
	    					window.parent.funcionRecargar();
	    					window.close();
	    				}
	    				
	    			})
	    		}
	    	}
	    	else if(!Ext.isEmpty(numeroAgrupacion)){
	    		if(Ext.isDefined(detalle.getModelInstance().getProxy().getApi().create)){
	    			detalle.getModelInstance().getProxy().extraParams.idGasto = idGasto;
	    			detalle.getModelInstance().getProxy().extraParams.numActivo = null;
	    			detalle.getModelInstance().getProxy().extraParams.numAgrupacion = numeroAgrupacion;
	    			detalle.getModelInstance().save({
	    				success: function(a, operation, c){
	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    				},
	    				failure: function(a, operation){
	    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    				},
	    				callback: function(records, operation, success) {
	    					form.reset();
	    					window.parent.funcionRecargar();
	    					window.close();
	    				}
	    				
	    			})
	    		}
	    	}
    	}
    	else{
    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.activo.gasto.busqueda.campos.vacios"));
    	}
    	
    	
    	
    },
    
   	onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
   		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    var idActivo = record.get("idActivo");
	    me.redirectTo('activos', true);
	    me.getView().fireEvent('abrirDetalleActivo', record);
    	
    },
	onClickBotonCancelarGasto: function(btn) {	
		var me = this,
		window = btn.up('window');
    	window.destroy();
	},
	
	onClickBotonGuardarGasto: function(btn){
		var me =this;
		var window= btn.up('window'),
		form= window.down('formBase');
	
		var success = function(record, operation) {
			me.getView().unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	window.parent.funcionRecargar();
	    	var data = {};
            try {
            	data = Ext.decode(operation._response.responseText);
            }
            catch (e){ };
            
            record.set("id", data.id);
            
	    	window.parent.up('administraciongastosmain').fireEvent('abrirDetalleGasto', record);
	    	
	    	window.destroy();  		
		};
		
		me.onSaveFormularioCompleto(null, form, success);		
	},
	
	onClickBotonIncluirTrabajosGasto: function(btn) {
		
		var me = this;
    	var idGasto = me.getViewModel().get("gasto.id");
    	me.getView().fireEvent('openModalWindow',"HreRem.view.gastos.SeleccionTrabajosGasto",{idGAsto: idGasto, parent: me.getView()});
	}
	

});
