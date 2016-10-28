Ext.define('HreRem.view.gastos.GastoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gastodetalle',
    
    requires: ['HreRem.view.gastos.SeleccionTrabajosGasto','HreRem.view.common.adjuntos.AdjuntarDocumentoGasto'],
    
    control: {
    	
    	'selecciontrabajosgastolist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var me = this;
    			var button = grid.up('window').down('button[itemId=btnGuardar]');
    			var disabled = Ext.isEmpty(persistedSelection);
    			button.setDisabled(disabled);    			
    		}
    	},
    	
    	'documentosgasto gridBase': {
             abrirFormulario: 'abrirFormularioAdjuntarDocumentos',
             onClickRemove: 'borrarDocumentoAdjunto',
             download: 'downloadDocumentoAdjunto',
             afterupload: function(grid) {
             	grid.getStore().load();
             },
             afterdelete: function(grid) {
             	grid.getStore().load();
             }
         }
    	
    },

    
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
		refrescarPestañaActiva = Ext.isEmpty(refrescarPestañaActiva) ? false: refrescarPestañaActiva;
		
		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar 
		if(refrescarPestañaActiva) {
			var activeTab = me.getView().down("tabpanel").getActiveTab();
			if(activeTab.funcionRecargar) {
  				activeTab.funcionRecargar();
			}
		}
		
	},
	
	buscarProveedor: function(field, e){
		var me= this;
		var url =  $AC.getRemoteUrl('gastosproveedor/searchProveedorCodigo');
		var codigoUnicoProveedor= field.getValue();
		var data;
		
		if(!Ext.isEmpty(codigoUnicoProveedor)){
			Ext.Ajax.request({
			    			
			    		     url: url,
			    		     params: {codigoUnicoProveedor : codigoUnicoProveedor},
			    		
			    		     success: function(response, opts) {
			    		    	 var data = Ext.decode(response.responseText);
			    		    	 var emisorGastoField = field.up('formBase').down('[name=docIdentificativo]');
			    		    	 buscadorCodigoRemEmisor = field.up('formBase').down('[name=buscadorCodigoRemEmisorField]'),
			    		    	 nombreEmisorGasto = field.up('formBase').down('[name=nombreEmisor]'),
			    		    	 codigoEmisorGasto = field.up('formBase').down('[name=codigoEmisor]');
			    		    	 
			    		    	 
			    		    	 if(!Utils.isEmptyJSON(data.data)){
			    		    	 	var id= data.data.id;
			    		    	 	var nombreEmisor= data.data.nombre;
			    		    	 	var codigoEmisor= data.data.codProveedorUvem;	
			    		    	 	var nifEmisor= data.data.docIdentificativo;
			    		    	 	
			    		    	 	if(!Ext.isEmpty(emisorGastoField)) {
			    		    	 		emisorGastoField.setValue(nifEmisor);
			    		    	 	}
			    		    	 	
			    		    	 	if(!Ext.isEmpty(buscadorCodigoRemEmisor)) {
			    		    	 		buscadorCodigoRemEmisor.setValue(codigoUnicoProveedor);
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
		}
		
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
			me.lookupReference('importePrincipalNoSujeto').validate();
		}else{
			me.lookupReference('importePrincipalNoSujeto').allowBlank= false;
			me.lookupReference('importePrincipalNoSujeto').validate();
		}
	},
	
	onCambiaImportePrincipalNoSujeto: function(field, e){
		var me= this;
		if(!Ext.isEmpty(field.getValue())){
			me.lookupReference('importePrincipalSujeto').allowBlank= true;
			me.lookupReference('importePrincipalSujeto').validate();
		}else{
			me.lookupReference('importePrincipalSujeto').allowBlank= false;
			me.lookupReference('importePrincipalSujeto').validate();
		}
	},
	
	onHaCambiadoFechaTopePago: function(field, value){
		/*var me= this;
		var fechaPago= me.lookupReference('fechaPago').getValue();
		if(!Ext.isEmpty(me.lookupReference('destinatariosPago'))){
			if(fechaPago<value){
				me.lookupReference('destinatariosPago').setDisabled(false);
				me.lookupReference('destinatariosPago').allowBlank= false;
			}else{
				me.lookupReference('destinatariosPago').setDisabled(true);
				me.lookupReference('destinatariosPago').allowBlank= true;
			}
		}*/
	},
	
	onHaCambiadoFechaPago: function(field, value){
		/*var me= this;
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
		}*/
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
	
	onClickBotonAsignarTrabajosGasto: function(btn) {
		
		var me = this;
    	var gasto = me.getViewModel().get("gasto");
    	Ext.create("HreRem.view.gastos.SeleccionTrabajosGasto",{gasto: gasto, parent: btn.up('formBase')}).show();
	},
	
	onClickBotonDesasignarTrabajosGasto: function(btn) {
		
		var me = this,
		form = btn.up('form'),		
		grid = btn.up('grid'),
		trabajos = grid.getSelection(),
		url =  $AC.getRemoteUrl('gastosproveedor/desasignarTrabajos'),	
		idGasto = me.getViewModel().get("gasto.id"),
		idTrabajos = [];
		
		if(!Ext.isEmpty(trabajos)) {
			// Recuperamos todos los ids de los trabajos seleccionados
			Ext.Array.each(trabajos, function(trabajo, index) {
			    idTrabajos.push(trabajo.get("id"));
			});		
			
			grid.mask(HreRem.i18n("msg.mask.loading"));
			
			Ext.Ajax.request({
		    			
			     url: url,
			     params: {idGasto: idGasto, trabajos: idTrabajos},
			
			     success: function(response, opts) {
			         grid.unmask();		         
			         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		        	 me.refrescarGasto(true);
			     },
			     
			     failure: function(response) {
			     	grid.unmask();
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
			     }
		    		     
		    });
		}
	},
	
	
	onSearchClick: function(btn) {
		
		var me = this;
		this.lookupReference('seleccionTrabajosGastoList').getStore().loadPage(1);
        
	},
	
		// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {

		btn.up('panel').getForm().reset();
			
	},
	
	paramLoading: function(store, operation, opts) {
		
		var me = this;
		
		var searchForm = me.lookupReference('seleccionTrabajosGastoSearch');
		if (searchForm.isValid()) {
			
			var criteria = me.getFormCriteria(searchForm);
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},
	
	getFormCriteria: function(form) {
    	
    	var me = this, initialData = {};
    	
		var criteria = Ext.apply(initialData, form ? form.getValues() : {});
		
		Ext.Object.each(criteria, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete criteria[key];
			}
		});

		return criteria;
	},
	
	asignarSeleccionTrabajosGasto: function(btn) {
		
		var me = this,
		ventanaSeleccionTrabajos = btn.up('window'),
		trabajos = ventanaSeleccionTrabajos.down('selecciontrabajosgastolist').getPersistedSelection(),
		idGasto = ventanaSeleccionTrabajos.gasto.get("id"),
		url =  $AC.getRemoteUrl('gastosproveedor/asignarTrabajos'),		
		idTrabajos = [];
		
		// Recuperamos todos los ids de los trabajos seleccionados
		Ext.Array.each(trabajos, function(trabajo, index) {
		    idTrabajos.push(trabajo.get("id"));
		});

		ventanaSeleccionTrabajos.mask(HreRem.i18n("msg.mask.loading"));

		Ext.Ajax.request({
	    			
		     url: url,
		     params: {idGasto: idGasto, trabajos: idTrabajos},
		
		     success: function(response, opts) {
		         ventanaSeleccionTrabajos.unmask();		         
		         ventanaSeleccionTrabajos.destroy();
		         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		         ventanaSeleccionTrabajos.parent.funcionRecargar();
		         
		     },
		     failure: function(response) {
		     	ventanaSeleccionTrabajos.unmask();
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
		     }
	    		     
	    });
	},
	
	cancelarSeleccionTrabajosGasto: function(btn) {
		btn.up('window').destroy();
	},
	
	onRowDblClickListadoTrabajosGasto: function(view, record) {
		var me = this;
		record.set('id', record.get('idTrabajo'));
		me.getView().fireEvent('abrirDetalleTrabajo', record);
	},
    
	haCambiadoIban: function(field, value){
		var me= this;
		
		var ibanfield= me.lookupReference('iban');
		var iban1= me.lookupReference('iban1').getValue();
		var iban2= me.lookupReference('iban2').getValue();
		var iban3= me.lookupReference('iban3').getValue();
		var iban4= me.lookupReference('iban4').getValue();
		var iban5= me.lookupReference('iban5').getValue();
		var iban6= me.lookupReference('iban6').getValue();
		
		ibanfield.setValue(iban1+iban2+iban3+iban4+iban5+iban6);
		
	},
	
	haCambiadoAbonoCuenta: function(field, value){
		var me= this;
		if(value){
			me.lookupReference('ibanRef').setDisabled(false);
			me.lookupReference('titularCuentaRef').setDisabled(false);
			me.lookupReference('nifTitularCuentaRef').setDisabled(false);
//			
			me.lookupReference('pagadoConexionBankiaRef').setValue(false);
			me.lookupReference('incluirPagoProvisionRef').setValue(false);
			me.lookupReference('oficinaRef').setDisabled(true);
			me.lookupReference('numeroConexionRef').setDisabled(true);
			
			
			
		}
		else{
			me.lookupReference('titularCuentaRef').setDisabled(true);
			me.lookupReference('nifTitularCuentaRef').setDisabled(true);
			me.lookupReference('ibanRef').setDisabled(true);
		}
		
	},
	
	haCambiadoPagadoBankia: function(field, value){
		var me= this;
		if(value){
			me.lookupReference('oficinaRef').setDisabled(false);
			me.lookupReference('numeroConexionRef').setDisabled(false);
//			
			me.lookupReference('abonoCuentaRef').setValue(false);
			me.lookupReference('incluirPagoProvisionRef').setValue(false);
			me.lookupReference('titularCuentaRef').setDisabled(true);
			me.lookupReference('nifTitularCuentaRef').setDisabled(true);
			me.lookupReference('ibanRef').setDisabled(true);
			

		}
		else{
			me.lookupReference('oficinaRef').setDisabled(true);
			me.lookupReference('numeroConexionRef').setDisabled(true);

		}
	},
	
	haCambiadoPagadoProvision: function(field, value){
		var me= this;
		if(value){
			me.lookupReference('abonoCuentaRef').setValue(false);
			me.lookupReference('pagadoConexionBankiaRef').setValue(false);
			me.lookupReference('titularCuentaRef').setDisabled(true);
			me.lookupReference('nifTitularCuentaRef').setDisabled(true);
			me.lookupReference('ibanRef').setDisabled(true);
			me.lookupReference('oficinaRef').setDisabled(true);
			me.lookupReference('numeroConexionRef').setDisabled(true);
			
		}
		else{

		}
	},
	
	haCambiadoReembolsarPagoTercero: function(field, value){
		var me= this;
		if(value){
			me.lookupReference('fieldSetSuplido').setDisabled(false);
			me.lookupReference('incluirPagoProvisionRef').setDisabled(false);
			me.lookupReference('abonoCuentaRef').setDisabled(false);
//			me.lookupReference('ibanRef').setDisabled(false);
			me.lookupReference('pagadoConexionBankiaRef').setDisabled(false);
			
		}
		else{
			me.lookupReference('fieldSetSuplido').setDisabled(true);
//			me.lookupReference('ibanRef').setDisabled(true);
			me.lookupReference('abonoCuentaRef').setValue(false);
			me.lookupReference('pagadoConexionBankiaRef').setValue(false);
			me.lookupReference('incluirPagoProvisionRef').setValue(false);
		}
	},
	
	abrirFormularioAdjuntarDocumentos: function(grid) {
		
		var me = this,
		idGasto = me.getViewModel().get("gasto.id");
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoGasto", {entidad: 'gastos', idEntidad: idGasto, parent: grid}).show();
		
	},
	
	borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idGasto = me.getViewModel().get("gasto.id");

		record.erase({
			params: {idGasto: idGasto},
            success: function(record, operation) {
           		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
           		 grid.fireEvent("afterdelete", grid);
            },
            failure: function(record, operation) {
                  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                  grid.fireEvent("afterdelete", grid);
            }
            
        });	
	},
	
	downloadDocumentoAdjunto: function(grid, record) {
		var me = this,
		config = {};
		
		config.url=$AC.getWebPath()+"gastosproveedor/bajarAdjuntoGasto."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.idGasto=record.get("idGasto");
		
		me.fireEvent("downloadFile", config);
	},
	
	buscarGasto: function(field, e){
		var me= this;
		var url =  $AC.getRemoteUrl('gastosproveedor/searchGastoNumHaya');
		var numeroGastoHaya= field.getValue();
		var proveedorEmisor = field.up('formBase').down('[name=buscadorCodigoRemEmisorField]').getValue();
		var destinatario = field.up('formBase').down('[name=destinatarioField]').getValue();
		var data;
		
		if(!Ext.isEmpty(numeroGastoHaya) && !Ext.isEmpty(proveedorEmisor) && !Ext.isEmpty(destinatario)){
			if(!Ext.isEmpty(proveedorEmisor) && !Ext.isEmpty(destinatario)){
				Ext.Ajax.request({
				    			
				    		     url: url,
				    		     params: {numeroGastoHaya : numeroGastoHaya, proveedorEmisor: proveedorEmisor, destinatario: destinatario},
				    		
				    		     success: function(response, opts) {
				    		    	 var data = Ext.decode(response.responseText);
				    		    	 var numeroGastoAbonado = field.up('formBase').down('[name=numGastoAbonado]');
				    		    	 var idGastoAbonadoField = field.up('formBase').down('[name=idGastoAbonado]');
				    		    	 
				    		    	 
				    		    	 if(!Utils.isEmptyJSON(data.data)){
				    		    	 	var id= data.data.id;
				    		    	 	idGastoAbonadoField.setValue(id);
				    		    	 	me.fireEvent("infoToast", HreRem.i18n("msg.buscador.encuentra.gasto"));
				    		    	 }
				    		    	 else{
				    		    	 	
				    		    	 	if(!Ext.isEmpty(numeroGastoAbonado)) {
				    		    	 		numeroGastoAbonado.setValue('');
				    		    	 	}
				    		    	 	me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.gasto"));
				    		    	 }
				    		    	 
				    		     },
				    		     failure: function(response) {
									me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				    		     },
				    		     callback: function(options, success, response){
				    		     }
				});
			}else{
				me.fireEvent("errorToast", HreRem.i18n("msg.buscador.gasto.faltan.campos"));
			}
		}
	
	}

});
