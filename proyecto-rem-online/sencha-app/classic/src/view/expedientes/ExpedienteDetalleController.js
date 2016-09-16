Ext.define('HreRem.view.expedientes.ExpedienteDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.expedientedetalle',  
    requires: ['HreRem.view.expedientes.NotarioSeleccionado', 'HreRem.view.expedientes.DatosComprador'],
    
    control: {
    	'documentosexpediente gridBase': {
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
		model = null,
		models = null,
		nameModels = null,
		id = me.getViewModel().get("expediente.id");
		form.mask(HreRem.i18n("msg.mask.loading"));
		if(!form.saveMultiple) {	
			model = form.getModelInstance(),
			model.setId(id);
			if(Ext.isDefined(model.getProxy().getApi().read)) {
				// Si la API tiene metodo de lectura (read).
				model.load({
				    success: function(record) {
				    	form.setBindRecord(record);			    	
				    	form.unmask();
				    	if(Ext.isFunction(form.afterLoad)) {
				    		form.afterLoad();
				    	}
				    }
				});
			} else {
				// Si la API no contiene metodo de lectura (read).
				form.setBindRecord(model);			    	
		    	form.unmask();
		    	if(Ext.isFunction(form.afterLoad)) {
		    		form.afterLoad();
		    	}
			}
		} else {
			models = form.getModelsInstance();
			me.cargarTabDataMultiple(form, 0, models, form.records);
		}
	},
	
	cargarTabDataMultiple: function (form,index, models, nameModels) {

		var me = this,
		id = me.getViewModel().get("expediente.id");
		
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

	onSaveFormularioCompleto: function(btn, form) {
		var me = this;
		
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones
		if(form.isFormValid() && form.disableValidation) {

			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);
					
			btn.hide();
			btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
			btn.up('tabbar').down('button[itemId=botoneditar]').show();
			me.getViewModel().set("editing", false);
			
			if (!form.saveMultiple) {
				if(Ext.isDefined(form.getBindRecord().getProxy().getApi().create) || Ext.isDefined(form.getBindRecord().getProxy().getApi().update)) {
					// Si la API tiene metodo de escritura (create or update).
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
					
					form.getBindRecord().save({
						success: function (a, operation, c) {
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							me.getView().unmask();
							me.refrescarExpediente(form.refreshAfterSave);
			            },
				            
			            failure: function (a, operation) {
			            	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							 me.getView().unmask();
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
		me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab());				
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
		
		var me = this;
		me.refrescarExpediente(true);

	},
	
	refrescarExpediente: function(refrescarPestañaActiva) {
		
		var me = this,
		refrescarPestañaActiva = Ext.isEmpty(refrescarPestañaActiva) ? false: refrescarPestañaActiva,
		activeTab = me.getView().down("tabpanel").getActiveTab();		
  		
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
		
		me.getView().fireEvent("refrescarExpediente", me.getView());
		
	},

	onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna){
		var me = this;
		var grid = tableView.up('grid');
		var record = grid.store.getAt(indiceFila);
		
		grid.setSelection(record);
		
		//grid.fireEvent("abriractivo", record);
		me.getView().fireEvent('abrirDetalleActivoPrincipal', record.get('idActivo'));
	},

	abrirFormularioAdjuntarDocumentos: function(grid) {
		
		var me = this,
		idExpediente = me.getViewModel().get("expediente.id");
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoExpediente", {entidad: 'expedientecomercial', idEntidad: idExpediente, parent: grid}).show();
		
	},
	
	borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idExpediente = me.getViewModel().get("expediente.id");

		record.erase({
			params: {idExpediente: idExpediente},
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
		
		config.url=$AC.getWebPath()+"expedientecomercial/bajarAdjuntoExpediente."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.idExpediente=record.get("idExpediente");
		
		me.fireEvent("downloadFile", config);
	},
	
	onListadoTramitesTareasExpedienteDobleClick : function(gridView,record) {
		var me = this;
		
		if(Ext.isEmpty(record.get("fechaFin"))) { // Si la tarea está activa
			me.getView().fireEvent('abrirDetalleTramiteTarea',gridView,record);
		} else {
			me.getView().fireEvent('abrirDetalleTramiteHistoricoTarea',gridView,record);
		}
	},
	
	onCompradoresListDobleClick : function(gridView,record) {
		var me=this,
		idCliente = record.get("id");
		var storeGrid= gridView.store;
//		me.getView().fireEvent('openModalWindow',"HreRem.view.expedientes.DatosComprador", {idComprador: idCliente, modoEdicion: true, storeGrid:storeGrid});
    	Ext.create("HreRem.view.expedientes.DatosComprador", {idComprador: idCliente, modoEdicion: true, storeGrid:storeGrid }).show();

	},

	onHaCambiadoSolicitaFinanciacion: function(combo, value){
		var me = this,
    	disabled = value == 0,
    	entidadFinanciacion = me.lookupReference('entidadFinanciacion');
    	
    	entidadFinanciacion.setDisabled(disabled);
    	entidadFinanciacion.allowBlank = disabled;
    	
    	
    	if(disabled) {
    		entidadFinanciacion.setValue("");
    	}
	},
	
	onHaCambiadoTipoCalculo: function(combo, value){
		var me = this;
		var valorCombo= combo.getValue(),
		porcentajeReserva = me.lookupReference('porcentajeReserva'),
		importeReserva = me.lookupReference('importeReserva'),
		plazoParaFirmar = me.lookupReference('plazoFirmaReserva');
		debugger;
		if(CONST.TIPOS_CALCULO['PORCENTAJE'] == valorCombo){
			me.getViewModel().get('condiciones').set('importeReserva', null);
			porcentajeReserva.setDisabled(false);
			porcentajeReserva.allowBlank= false;
			importeReserva.setDisabled(false)
			importeReserva.setEditable(false);
			importeReserva.allowBlank= true;
			plazoParaFirmar.allowBlank= false;
			plazoParaFirmar.setDisabled(false);
		}
		else if(CONST.TIPOS_CALCULO['FIJO'] == valorCombo){
			me.getViewModel().get('condiciones').set('porcentajeReserva', null);
			porcentajeReserva.setDisabled(true);
			importeReserva.setDisabled(false);
			importeReserva.setEditable(true);
			importeReserva.allowBlank= false;
			plazoParaFirmar.allowBlank= false;
			plazoParaFirmar.setDisabled(false);
		}else{
			me.getViewModel().get('condiciones').set('importeReserva', null);
			me.getViewModel().get('condiciones').set('porcentajeReserva', null);
			me.getViewModel().get('condiciones').set('plazoFirmaReserva', null);			
			porcentajeReserva.setDisabled(true);
			plazoParaFirmar.setDisabled(true);
			
		}	
	},
	
	onHaCambiadoPorcentajeReserva: function(combo, value) {
		
		var me = this,
		importeOferta = parseFloat(me.getViewModel().get('expediente.importe')).toFixed(2),
		importeReserva = null,
		importeReservaField = me.lookupReference('importeReserva'),
		tipoCalculo = me.lookupReference('tipoCalculo').getValue();
		
		if(CONST.TIPOS_CALCULO['PORCENTAJE'] == tipoCalculo) {
			debugger;
			importeReserva = importeOferta * value / 100;
		}
		
		importeReservaField.setValue(importeReserva);
		me.getViewModel().get('condiciones').set('importeReserva', importeReserva);	

	},
	
	onHaCambiadoPlusvalia: function(combo, value){
		var me= this;
		
		porCuentaDe= me.lookupReference('plusvaliaPorCuentaDe');
		
		if(value>0){
			porCuentaDe.setDisabled(false);
			porCuentaDe.allowBlank= false;
		}else{
			porCuentaDe.setDisabled(true);
			porCuentaDe.setValue("");
		}
	},
	
	onHaCambiadoNotaria: function(combo, value){
		var me= this;
		
		notariaPorCuentaDe= me.lookupReference('notariaPorCuentaDe');
		
		if(value>0){
			notariaPorCuentaDe.setDisabled(false);
			notariaPorCuentaDe.allowBlank= false;
		}else{
			notariaPorCuentaDe.setValue("");
			notariaPorCuentaDe.setDisabled(true);
		}
	},
	
	onHaCambiadoCompraVentaOtros: function(combo, value){
		var me= this;
		
		compraventaOtrosPorCuentaDe= me.lookupReference('compraventaOtrosPorCuentaDe');
		
		if(value>0){
			compraventaOtrosPorCuentaDe.setDisabled(false);
			compraventaOtrosPorCuentaDe.allowBlank= false;
		}else{
			compraventaOtrosPorCuentaDe.setValue("");
			compraventaOtrosPorCuentaDe.setDisabled(true);
		}
	},
	
	onHaCambiadoProcedeDescalificacion: function(combo, value){
		var me= this;
		
		procedeDescalificacionPorCuentaDe= me.lookupReference('procedeDescalificacionPorCuentaDe');
		
		if(value==1){
			procedeDescalificacionPorCuentaDe.setDisabled(false);
			procedeDescalificacionPorCuentaDe.allowBlank= false;
		}
		else{
			procedeDescalificacionPorCuentaDe.setValue("");
			procedeDescalificacionPorCuentaDe.setDisabled(true);
		}
	},
	
	onHaCambiadoLicencia: function(combo, value){
		var me= this;
		
		licenciaPorCuentaDe= me.lookupReference('licenciaPorCuentaDe');
		
		if(!Ext.isEmpty(value)){
			licenciaPorCuentaDe.setDisabled(false);
			licenciaPorCuentaDe.allowBlank= false;
		}
		else{
			licenciaPorCuentaDe.setValue("");
			licenciaPorCuentaDe.setDisabled(true);
		}
	},
	
	onHaCambiadoCargasPendientesOtros: function(combo, value){
		var me= this;
		
		cargasPendientesOtrosPorCuentaDe= me.lookupReference('cargasPendientesOtrosPorCuentaDe');
		
		if(value > 0){
			cargasPendientesOtrosPorCuentaDe.setDisabled(false);
			cargasPendientesOtrosPorCuentaDe.allowBlank= false;
		}
		else{
			cargasPendientesOtrosPorCuentaDe.setValue("");
			cargasPendientesOtrosPorCuentaDe.setDisabled(true);
		}
	},

//	Para la búsqueda de Comparecientes en nombre del vendedor	
//		
//	onClickBotonCancelarBusquedaCompareciente: function(btn) {	
//		var me = this,
//		window = btn.up('window');
//    	window.close();
//	},
//	
//	onClickBotonBuscarCompareciente: function(btn){
//		debugger;
//		var me= this;
//		var initialData = {};
//
//		var searchForm = btn.up('formBase');
//		
//		if (searchForm.isValid()) {
//			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
//			
//			Ext.Object.each(criteria, function(key, val) {
//				if (Ext.isEmpty(val)) {
//					delete criteria[key];
//				}
//			});
//			this.lookupReference('listadocomparecientesnombrevendedor').getStore().loadPage(1);
//        }
//		
//	}
	onNotarioDblClick: function(grid, rec){
		var me= this;
		var detalle= Ext.create('HreRem.view.expedientes.NotarioSeleccionado',{grid:grid, notario:rec}).show();
		
	},
	
	onClickBotonCerrarNotarioDetalle: function(btn){
		var me = this,
		window = btn.up('window');
    	window.close();		
	},
	onHaCambiadoIbi: function(combo, value){
		var me= this;
		
		porCuentaDe= me.lookupReference('ibiPorCuentaDe');
		
		if(value>0){
			porCuentaDe.setDisabled(false);
			porCuentaDe.allowBlank= false;
		}else{
			porCuentaDe.setDisabled(true);
			porCuentaDe.setValue("");
		}
	},
	
	onHaCambiadoComunidad: function(combo, value){
		var me= this;
		
		porCuentaDe= me.lookupReference('comunidadPorCuentaDe');
		
		if(value>0){
			porCuentaDe.setDisabled(false);
			porCuentaDe.allowBlank= false;
		}else{
			porCuentaDe.setDisabled(true);
			porCuentaDe.setValue("");
		}
	},
	
	onHaCambiadoAlquilerSuministros: function(combo, value){
		var me= this;
		
		porCuentaDe= me.lookupReference('suministrosPorCuentaDe');
		
		if(value>0){
			porCuentaDe.setDisabled(false);
			porCuentaDe.allowBlank= false;
		}else{
			porCuentaDe.setDisabled(true);
			porCuentaDe.setValue("");
		}
	},
	
	cargarData: function (window) {
		var me = this,
		model = null,
		models = null,
		nameModels = null,
		id = window.idComprador;
		var form= window.down('formBase');
		form.mask(HreRem.i18n("msg.mask.loading"));
		if(!form.saveMultiple) {	
			model = form.getModelInstance(),
			model.setId(id);
			if(Ext.isDefined(model.getProxy().getApi().read)) {
				// Si la API tiene metodo de lectura (read).
				model.load({
				    success: function(record) {
				    	form.setBindRecord(record);			    	
				    	form.unmask();
				    	if(Ext.isFunction(form.afterLoad)) {
				    		form.afterLoad();
				    	}
				    }
				});
			}
		}
	},
	
	onClickBotonModificarComprador: function(btn){
		var me = this,
		window = btn.up("window"),
		form = window.down("form");
		
		form.recordName = "comprador";
		form.recordClass = "HreRem.model.FichaComprador";
		
		var success = function(record, operation) {
			me.getView().unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	window.destroy();
//	    	window.parent.funcionRecargar();
//	    	window.hide();

		};
		
		var failure = function(record, operation) {
			me.getView().unmask();
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    	window.destroy();
//	    	window.parent.funcionRecargar();
//	    	window.hide();

		};

		//En este caso, actualizar
		me.onSaveFormularioCompletoComprador(form, success, failure);
	},
	
	onSaveFormularioCompletoComprador: function(form, success, failure) {
		var me = this,
		datoscom= form.up(),
		storeGrid= datoscom.storeGrid,
		record = form.getBindRecord();
		success = success || function() {
			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			storeGrid.load();
		};
		failure = failure || function() {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			storeGrid.load();
		}; 
		
		if(form.isFormValid()) {
			var idExpedienteComercial = record.get("idExpedienteComercial");

			form.mask(HreRem.i18n("msg.mask.espere"));
			
			record.save({
				params: {idExpedienteComercial: idExpedienteComercial},
			    success: success,
			 	failure: failure,
			    callback: function(record, operation) {
			    	storeGrid.load();
			    	
			    }
			    		    
			});
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	
	},
	
	onCompradoresListClick: function(gridView,record){
		var me=this,
		idCliente = record.get("id"),
		model = Ext.create('HreRem.model.FichaComprador');
		
		var fieldset =  me.lookupReference('estadoPbcCompradoRef');
		fieldset.mask(HreRem.i18n("msg.mask.loading"));
	
		model.setId(idCliente);
		model.load({			
		    success: function(record) {	
		    	me.getViewModel().set("detalleComprador", record);
		    	fieldset.unmask();
		    }
		});
	},
	
	onHaCambiadoDestinoActivo: function(combo, value){
		var me = this,
    	otrosDetallePbc = me.lookupReference('otrosDetallePbc');
    	
    	if(value=='05'){
    		otrosDetallePbc.setDisabled(false);
    		otrosDetallePbc.alloBlank= false;
    	}else{
    		otrosDetallePbc.setValue("");
    		otrosDetallePbc.setDisabled(true);
    	}
	},
	
	onMarcarPrincipalClick: function(grid, rowIndex, colIndex, item, e, rec){
		var me = this;
    	me.gridOrigen = grid;
		
		if (rec.data.titularContratacion != 1) {
			Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.comprador.principal'),
				   msg: HreRem.i18n('msg.confirmar.comprador.principal'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {	
							me.getView().mask();
							var url =  $AC.getRemoteUrl('expedientecomercial/marcarCompradorPrincipal');
							Ext.Ajax.request({
							
							     url: url,
							     params: {
							     			idComprador: rec.data.id,
							     			idExpedienteComercial: rec.data.idExpediente	
							     		}
								
							    ,success: function (a, operation, context) {
					                	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
										me.getView().unmask();
										me.gridOrigen.getStore().load();
					            },
					            
					            failure: function (a, operation, context) {
					            	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
									 me.getView().unmask();
					            }
						     
							});
						}
					}
				});
		}
	}

});