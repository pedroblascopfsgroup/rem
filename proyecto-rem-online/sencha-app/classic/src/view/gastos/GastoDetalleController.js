Ext.define('HreRem.view.gastos.GastoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gastodetalle',
    
    requires: ['HreRem.view.gastos.SeleccionTrabajosGasto','HreRem.view.common.adjuntos.AdjuntarDocumentoGasto',
    	'HreRem.view.administracion.gastos.GastoRefacturadoGrid', 'HreRem.model.LineaDetalleGastoGridModel'],
    
    control: {
    	
    	'selecciontrabajosgastolist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var me = this;
    			var button = grid.up('window').down('button[itemId=btnGuardar]');
    			var disabled = Ext.isEmpty(persistedSelection);
    			button.setDisabled(disabled);    			
    		}
    	},

    	'selecciontasacionesgastolist' : {

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
             	grid.up('form').funcionRecargar();
             	grid.fireEvent("refreshComponent", "gestiongastos");
             },
             afterdelete: function(grid) {
            	grid.getStore().load();
             	grid.fireEvent("refreshComponent", "gestiongastos");
             	grid.disableRemoveButton(true);
             	this.onClickBotonRefrescar();
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
		    	me.recargarVisibilidadGrids(form, record);
	
		    },
		    failure: function(operation) {		    	
		    	form.up("tabpanel").unmask();
		    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
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
		var facturaPrincipalSuplido, abonoCuenta, idGasto;
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones
		if(form.isFormValid() && !form.disableValidation || form.disableValidation) {
//			var fechaMax = new Date();
//			fechaMax.setMonth(fechaMax.getMonth()+1);
//			var fechaDevengo = me.lookupReference('fechaDevengoEspecial').value;
//			var anyoCombobox = me.lookupReference('comboboxfieldFechaEjercicio').lastMutatedValue;
//			var anyoFechaDevengo = fechaDevengo.getFullYear();
//			
//			if(anyoCombobox.indexOf(anyoFechaDevengo) == -1){
//
//				me.fireEvent("errorToast", HreRem.i18n("msg.error.validacion.fechas"));
//
//			}else{
//				

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
			                    var valoresGrid = [];

			                    if(me.getView().lookupReference("gastoRefacturadoGrid") != null && me.getView().lookupReference("gastoRefacturadoGrid").getStore().initialConfig.data != undefined){
				                    for(var i = 0; i < me.getView().lookupReference("gastoRefacturadoGrid").getStore().initialConfig.data.length; i++){
				                    	if(me.getView().lookupReference("gastoRefacturadoGrid").getStore().initialConfig.data[i].gastoRefacturable == true ||
				                    		me.getView().lookupReference("gastoRefacturadoGrid").getStore().initialConfig.data[i].gastoRefacturable == "true"){
				                    			valoresGrid.push(me.getView().lookupReference("gastoRefacturadoGrid").getStore().initialConfig.data[i].idGasto);
				                    	}
				                    }
			                    }
			                    
				                form.getBindRecord().data.gastoRefacturadoGrid=valoresGrid;
				                
				                var params;
				                
				                if(form.getXType() == "datosgeneralesgasto"){
				                	facturaPrincipalSuplido = form.getValues().facturaPrincipalSuplido;
				                	idGasto = me.getViewModel().get("gasto.id");
				                	params = {facturaPrincipalSuplido: facturaPrincipalSuplido};
				                } else if(form.getXType() == "detalleeconomicogasto"){
				                	abonoCuenta = form.down('[name="abonoCuenta"]').value;
				                	params = {abonoCuenta: abonoCuenta};
				                }
				                
				                if(form.getXType() == "datosgeneralesgasto"){
				                	var referenciaEmisor = form.getValues().referenciaEmisor;
				                	var codigoProveedorRem = form.getValues().codigoProveedorRem;
				                	var url = $AC.getRemoteUrl('gastosproveedor/validacionNifEmisorFactura');	
    	
							    	Ext.Ajax.request({
										url: url,
										params: {idGasto: idGasto, referenciaEmisor: referenciaEmisor, codigoProveedorRem: codigoProveedorRem},
										success: function(response, opts) {
											
											var data = {};
											try {
												data = Ext.decode(response.responseText);
												}
											catch (e){ };
											if(data.error != null){
												var msg = "Advertencias:<br/>";
												msg += "<br/>" + data.error + "<br/>";
												msg += "<br/>" + HreRem.i18n("msg.desea.editar.gasto");
												
												me.getView().unmask();
												
												Ext.Msg.show({
											   	title: HreRem.i18n('title.mensaje.confirmacion'),
											   	msg: msg,
											   	buttons: Ext.MessageBox.YESNO,
											   	fn: function(buttonId) {
											   		me.getView().mask(HreRem.i18n("msg.mask.loading"));
											   		if (buttonId == 'yes') {
											   			form.getBindRecord().save({
															params: params,
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
																var comboEmisor = me.getView().lookupReference("comboProveedores");
																var nifEmisor = me.getViewModel().data.gasto.data.nifEmisor;
																comboEmisor.getStore().getProxy().extraParams.nifProveedor = nifEmisor;	
																comboEmisor.getStore().load();
																me.refrescarGasto(form.refreshAfterSave);
																
												            }
														});
											   		}else{
											   			me.refrescarGasto(form.refreshAfterSave);
											   		}
											   		me.getView().unmask();
											   	}
										   	});
												
											} else {
												form.getBindRecord().save({
													params: params,
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
														var comboEmisor = me.getView().lookupReference("comboProveedores");
														var nifEmisor = me.getViewModel().data.gasto.data.nifEmisor;
														comboEmisor.getStore().getProxy().extraParams.nifProveedor = nifEmisor;	
														comboEmisor.getStore().load();
														me.refrescarGasto(form.refreshAfterSave);
														me.getView().unmask();
										            }
												});
											}
											
											
										}
							    	});
				                }else{
				                	form.getBindRecord().save({
										params: params,
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
											var comboEmisor = me.getView().lookupReference("comboProveedores");
											var nifEmisor = me.getViewModel().data.gasto.data.nifEmisor;
											comboEmisor.getStore().getProxy().extraParams.nifProveedor = nifEmisor;	
											comboEmisor.getStore().load();
											me.refrescarGasto(form.refreshAfterSave);
											me.getView().unmask();
							            }
									});
				                }
				                
							}
						//Guardamos múltiples records	
						} else {
							var records = form.getBindRecords();
							var contador = 0;
							me.saveMultipleRecords(contador, records);
						}


//			}
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
		me.afterCargaCombo();
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
		var comboEmisor = me.getView().lookupReference("comboProveedores");
		var nifEmisor = me.getViewModel().data.gasto.data.nifEmisor;
		comboEmisor.getStore().getProxy().extraParams.nifProveedor = nifEmisor;	
		comboEmisor.getStore().load();
		
		if (!activeTab.saveMultiple) {
			if(activeTab && activeTab.getBindRecord && activeTab.getBindRecord()) {
//				activeTab.getForm().clearInvalid();
//				activeTab.getBindRecord().reject();
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
	onClickBotonRefrescar : function(btn) {
		var me = this;

		me.refrescarGasto(true);
	},
	
	refrescarGasto : function(resfrescarPestanya) {
		var me = this, resfrescarPestanya = Ext.isEmpty(resfrescarPestanya) ? false	: resfrescarPestanya, tabPanel = me.getView().down("tabpanel");

		// Marcamos todas los componentes para refrescar, de
		// manera que se vayan actualizando conforme se vayan
		// mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
			if (component.rendered) {
				component.recargar = true;
			}
		});

		// Actualizamos la pestaña actual si tiene función de
		// recargar y el gasto si estamos guardando uno.
		if (!Ext.isEmpty(tabPanel)) {
			var activeTab = tabPanel.getActiveTab();
			if (resfrescarPestanya) {
				if (activeTab.funcionRecargar) {
					activeTab.funcionRecargar();
				}
			}
			var callbackFn = function() {
				me.getView().down("tabpanel").evaluarBotonesEdicion(activeTab);
			};
			me.getView().fireEvent("refrescarGasto", me.getView(), callbackFn);
		}

	},
	
	buscarProveedor: function(field, e){
		var me= this;
		var nifProveedor= field.getValue();
		var data;
		var comboProveedores = me.lookupReference("comboProveedores");

		if(!Ext.isEmpty(nifProveedor)){
			comboProveedores.getStore().getProxy().extraParams.nifProveedor = nifProveedor;	
			comboProveedores.getStore().load();
			if(comboProveedores.inputEl.isVisible()) {
				comboProveedores.expand();
			}
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
		    		nombrePropietarioGasto = field.up('formBase').down('[name=nombrePropietario]'),
		    		chkboxActivoRefacturable = me.lookupReference("checkboxActivoRefacturable");
		    		
			    	if(!Utils.isEmptyJSON(data.data)){
			    		if (CONST.CIF_PROPIETARIO['OMEGA'] == data.data.docIdentificativo) {
			    			me.fireEvent("errorToast", HreRem.i18n("msg.buscador.propietario.no.admitido"));
			    		    buscadorNifPropietario.markInvalid(HreRem.i18n("msg.buscador.propietario.no.admitido"));
			    		} else {
			    			me.getViewModel().set('controlPestanyaGastoRefacturable', data.data);
							var id= data.data.id;
			    		    var nombrePropietario= data.data.nombre;

			    		    if(!Ext.isEmpty(buscadorNifPropietario)) {
			    		    	buscadorNifPropietario.setValue(nifPropietario);
			    		    	
			    		    }
			    		    if(!Ext.isEmpty(nombrePropietarioGasto)) {
			    		    	nombrePropietarioGasto.setValue(nombrePropietario);

				    		}
			    		    //chkboxActivoRefacturable.existePropietario=true;
			    		}
			    	} else {
			    		if(!Ext.isEmpty(nombrePropietarioGasto)) {
			    			//chkboxActivoRefacturable.existePropietario=false;
		    		    	nombrePropietarioGasto.setValue('');
		    		    }
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.propietario"));
		    		    buscadorNifPropietario.markInvalid(HreRem.i18n("msg.buscador.no.encuentra.propietario"));	
		    		    
			    	}
		    		    	 
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}
		    		     
		  });
		
	},
	
	
	onChangeOperacionExenta: function(check,newValue){
		var me = this;

		var operacion = me.lookupReference('cbOperacionExenta');
		var renuncia = me.lookupReference('cbRenunciaExencion');
		var esTipoImpositivo = me.lookupReference('esTipoImpositivo');
		var cuota = me.lookupReference('cbCuota');
		var importeTotal = me.lookupReference('detalleEconomicoImporteTotal');
		if(operacion.getValue()){
			renuncia.setReadOnly(false);
			esTipoImpositivo.setDisabled(true);
			cuota.setDisabled(true);
		}else{			
			esTipoImpositivo.setDisabled(false);
			esTipoImpositivo.allowBlank = false;
			cuota.setDisabled(false);
			cuota.allowBlank = false;
			renuncia.setValue(false);
			renuncia.setReadOnly(true);
		}
		importeTotal.validate();
		operacion.validate();
		renuncia.validate();
		esTipoImpositivo.validate();
		cuota.validate();

	},
	
	onChangeRenunciaExencion: function(field, value){
		var me = this;
		
		var operacion = me.lookupReference('cbOperacionExenta');
		var renuncia = me.lookupReference('cbRenunciaExencion');
		var esTipoImpositivo = me.lookupReference('esTipoImpositivo');
		var cuota = me.lookupReference('cbCuota');
		var importeTotal = me.lookupReference('detalleEconomicoImporteTotal');
		if(operacion.getValue() && !renuncia.getValue()){
			esTipoImpositivo.setDisabled(true);
			cuota.setDisabled(true);
		}else{
			esTipoImpositivo.setDisabled(false);
			esTipoImpositivo.allowBlank = false;
			cuota.setDisabled(false);
			cuota.allowBlank = false;
		}
		importeTotal.validate();
		operacion.validate();
		renuncia.validate();
		esTipoImpositivo.validate();
		cuota.validate();
	},
	

/*	estaExento: function(get){
     	var me= this;
     	if(get('detalleeconomico.impuestoIndirectoExento')==true || get('detalleeconomico.abonoCuenta')==true){
     		return true;
     	}
     	else{
     		return false;
     	}
     },*/
		
	onChangeImportePrincipalSujeto: function(field, e){
		var me= this;
		if(!Ext.isEmpty(field.getValue())){
			me.lookupReference('importePrincipalNoSujeto').allowBlank= true;
			me.lookupReference('importePrincipalNoSujeto').validate();
		}else{
			me.lookupReference('importePrincipalNoSujeto').allowBlank= false;
			me.lookupReference('importePrincipalNoSujeto').validate();
		}
	},
	
	onChangeImportePrincipalNoSujeto: function(field, e){
		var me= this;
		if(!Ext.isEmpty(field.getValue())){
			me.lookupReference('importePrincipalSujeto').allowBlank= true;
			me.lookupReference('importePrincipalSujeto').validate();
		}else{
			me.lookupReference('importePrincipalSujeto').allowBlank= false;
			me.lookupReference('importePrincipalSujeto').validate();
		}
	},
	
	onChangeFechaTopePago: function(field, value){
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
	
	onChangeFechaPago: function(field, value){
		var me= this,
		fieldImportePagado = me.lookupReference('detalleEconomicoImportePagado');
		var valFechaPago = me.lookupReference('fechaPago').getValue();
		if(!Ext.isEmpty(valFechaPago)){
			fieldImportePagado.setValue(me.calcularImportePagadoTotalGasto());
		}
	},
	
	onChangeImporteTotal: function(field, value) {
		
		var me = this,
		fieldFechaPago = me.lookupReference('fechaPago'),
		fieldImportePagado = me.lookupReference('detalleEconomicoImportePagado'),
		fieldImporteTotal = me.lookupReference('detalleEconomicoImporteTotal'),
		importePagado = Ext.isEmpty(fieldFechaPago.getValue()) ? 0 : value;

		fieldImportePagado.setValue(importePagado);
		fieldImporteTotal.setValue(value);	
		
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
    	var idLinea = me.lookupReference('comboLineasDetalleReferenceAnyadir').getValue();
    	var descripcionLinea = me.lookupReference('comboLineasDetalleReferenceAnyadir').getDisplayValue();
    	var tipoElemento = me.lookupReference('comboElementoAAnyadir').getValue();
    	var idElemento = me.lookupReference('elementoAnyadir').getValue();
    	var campoNumActivo = -1, campoNumAgrupacion = -1, campoNumActivoGenerico = -1, campoNumPromocion = -1;
    	if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_ACTIVO_GENERICO'] != tipoElemento && isNaN(idElemento)){	
    		me.fireEvent("errorToast", "El ID para este tipo de activo solo puede contener números");
    		return;
    	}
    	
    	var url =  $AC.getRemoteUrl('gastosproveedor/fechaDevengoPosteriorFechaTraspaso');
    	window.mask(HreRem.i18n("msg.mask.loading"));
    	if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_ACTIVO'] === tipoElemento){
    		campoNumActivo = idElemento;
    	}else if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_AGRUPACION'] === tipoElemento){
    		campoNumAgrupacion = idElemento;
    	}
    	
    	var dataAnyadir = {idElemento:idElemento, tipoElemento:tipoElemento, idLinea:idLinea};
        var tipoIva = descripcionLinea.includes("IVA");

        if(Ext.isDefined(detalle.getModelInstance().getProxy().getApi().create) 
        	&& (CONST.TIPO_ELEMENTOS_GASTO['CODIGO_ACTIVO'] === tipoElemento || CONST.TIPO_ELEMENTOS_GASTO['CODIGO_AGRUPACION'] === tipoElemento)){
            Ext.Ajax.request({		    			
                url: url,
                params: {
                    idGasto: idGasto, 
                    idActivo: campoNumActivo,
                    idAgrupacion: campoNumAgrupacion
                },	    		
                success: function(response, opts) {
                    
                    var data = {};
                    try {
                        data = Ext.decode(response.responseText);
                    }
                    catch (e){ };
                    
                    if(!Ext.isEmpty(data) && data.fechaDevengoSuperior == "true" && tipoIva) {
                        Ext.Msg.show({
                            title: HreRem.i18n('title.permitir.asociacion.gastoactivo'),
                            msg: HreRem.i18n('msg.asociar.gastoactivo'),
                            buttons: Ext.MessageBox.YESNO,
                            fn: function(buttonId) {
                                if (buttonId == 'yes') {
                                    me.asociarGastoConElementos(dataAnyadir, form, window);
                                }
                                else {
                                    form.reset();
                                    window.unmask();
                                    window.parent.funcionRecargar();
                                    window.close();
                                }
                            }
                        });            
                    }
                    else{
                    	me.asociarGastoConElementos(dataAnyadir, form, window);
                    }
                },
                failure: function(response) {
                    me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                    form.reset();
    				window.parent.funcionRecargar();
    				window.unmask();
    				window.close();
                }
            });
        }else if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_ACTIVO_GENERICO']  === tipoElemento || CONST.TIPO_ELEMENTOS_GASTO['CODIGO_PROMOCION'] === tipoElemento){
        	me.asociarGastoConElementos(dataAnyadir, form, window);
        }else if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_SIN_ACTIVOS']  === tipoElemento){
        	
        	var url =  $AC.getRemoteUrl('gastosproveedor/updateLineaSinActivos');
        	Ext.Ajax.request({		    			
                url: url,
                method: 'GET',
                params: {
                	idLinea: idLinea  
                },	    		
                success: function(response, opts) {
                	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                },
                failure: function(response) {
                    me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
 
                },
                callback: function(records, operation, success) {
    				window.parent.funcionRecargar();
    				window.unmask();
    				window.close()
    			}
        	});
        }else{
        	form.reset();
			window.parent.funcionRecargar();
			window.unmask();
			window.close();
        }
    },
     
    updateGastoByPrinexLBK: function(){
    	me = this;
    	var url =  $AC.getRemoteUrl('gastosproveedor/updateGastoByPrinexLBK');
    	var idGasto = me.getViewModel().get("gasto.id"); 


		Ext.Ajax.request({		    			
	 		url: url,
	   		params: {
	   			idGasto: idGasto
   			},	    		
	    	success: function(response, opts) {
	    		
	    		var data = {};
	            try {
	            	data = Ext.decode(response.responseText);
	            	if(data.success == "true"){
	            		me.refrescarGasto(true);
	            	}
	            	
	            }
	            catch (e){ };
    			
    		
	    		
	    	},
   			failure: function(response) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    }
		});

    	
    },

    asociarGastoConActivos: function(idGasto, numeroActivo, numeroAgrupacion, detalle, form, window) {
    	
    	var me = this;
    	
    	detalle.getModelInstance().getProxy().extraParams.idGasto = idGasto;
		detalle.getModelInstance().getProxy().extraParams.numActivo = numeroActivo;
		detalle.getModelInstance().getProxy().extraParams.numAgrupacion = numeroAgrupacion;
		detalle.getModelInstance().save({
			
			success: function(a, operation, c){
				var data = Ext.decode(operation._response.responseText);
				window.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
				window.up('gastodetalle').down('contabilidadgasto').funcionRecargar();
				if(!Ext.isEmpty(data) && data.success == "true") {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				} else {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
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
				if (numeroActivo != null) window.unmask();
				window.parent.funcionRecargar();
				window.close();
			}
			
		});
    	
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
		
		if(form.isFormValid() && !form.disableValidation || form.disableValidation) {
			// Comprobar si el proveedor está dado de baja para notificarlo.
			var combo = window.lookupReference('comboProveedores');
			var fechaBaja = combo.getSelection().getData().fechaBaja;
			if(!Ext.isEmpty(fechaBaja)) {
				Ext.Msg.show({
					   title: HreRem.i18n('title.mensaje.confirmacion'),
					   msg: HreRem.i18n('msg.desea.crear.proveedor.baja'),
					   buttons: Ext.MessageBox.YESNO,
					   fn: function(buttonId) {
					        if (buttonId == 'yes') {
					        	me.onGuardarGastoComprobarExisteGasto(window, form);
					        }
					   }
	     		});
			} else {
				me.onGuardarGastoComprobarExisteGasto(window, form);
			}
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	},
	
	onGuardarGastoComprobarExisteGasto: function(window, form) {
		var me = this;
		var url =  $AC.getRemoteUrl('gastosproveedor/existeGasto');
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		Ext.Ajax.request({		    			
	 		url: url,
	   		params: form.getBindRecord().getData(),		    		
	    	success: function(response, opts) {
	    		var data = {};
	            try {
	            	data = Ext.decode(response.responseText);
	            }
	            catch (e){ };
	            
	            if(!Ext.isEmpty(data) && data.success == "true") {
	            	
	            	if(data.existeGasto == "true") {
	            		
	            		Ext.Msg.show({
						   title: HreRem.i18n('title.mensaje.confirmacion'),
						   msg: HreRem.i18n('msg.desea.crear.gasto.duplicado'),
						   buttons: Ext.MessageBox.YESNO,
						   fn: function(buttonId) {
						        if (buttonId == 'yes') {
						        	me.onGuardarGasto(window, form);
						        }
						   }
	            		});
	            		
	            	} else if (data.existeGasto == "false") {
	            		me.onGuardarGasto(window, form);
	            	}
	            	
	            } else if (!Ext.isEmpty(data) && data.success == "false"){		            		
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	            }
	    	},
			failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				me.getView().unmask();
			}
		});
	},
	
	onGuardarGasto: function(window, form) {
		var me = this;
		
		var success = function(record, operation) {
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	window.parent.funcionRecargar();
	    	var data = {};
            try {
            	data = Ext.decode(operation._response.responseText);
            }
            catch (e){ };
            
            record.set("id", data.id);
            
	    	window.parent.up('administraciongastosmain').fireEvent('abrirDetalleGasto', record);
	    	
			me.getView().unmask();
	    	window.destroy();  	
		};
		
		me.onSaveFormularioCompleto(null, form, success);
	},
	
	onClickBotonAsignarTrabajosGasto: function(btn) {
		
		var me = this;
    	var gasto = me.getViewModel().get("gasto");
    	Ext.create("HreRem.view.gastos.SeleccionTrabajosGasto",{gasto: gasto, parent: btn.up('formBase')}).show();
	},
	
	onExportClickTrabajos: function(btn){
		var me = this;
		var idGasto = me.getViewModel().get("gasto.id");
		var url =  $AC.getRemoteUrl('gastosproveedor/generateExcelTrabajosGasto');
		
		var config = {};

		var initialData = {idGasto: idGasto};
		var params = Ext.apply(initialData);

		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});

		config.params = params;
		config.url= url;
		
		me.fireEvent("downloadFile", config);		
	},
	
	onExportClickActivos: function(btn){
    	var me = this;
    	var idGasto = me.getViewModel().get("gasto.id");

		var url =  $AC.getRemoteUrl('gastosproveedor/generateExcelElementosGasto');
		
		var config = {};

		var initialData = {idGasto: idGasto};
		var params = Ext.apply(initialData);

		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});

		config.params = params;
		config.url= url;
		
		me.fireEvent("downloadFile", config);		
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
			    idTrabajos.push(trabajo.get("idTrabajo"));
			});		
			grid.mask(HreRem.i18n("msg.mask.loading"));
			
			Ext.Ajax.request({
		    			
			     url: url,
			     params: {idGasto: idGasto, trabajos: idTrabajos},
			
			     success: function(response, opts) {
			    	 var url2 = $AC.getRemoteUrl('gastosproveedor/actualizarParticipacionTrabajosAfterInsert');
			    	 Ext.Ajax.request({
			    			
					     url: url2,
					     params: {idGasto: idGasto},
					
					     success: function(response, opts) {
					    	 
					    	
					    	 grid.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
					         grid.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar();
					         grid.up('gastodetalle').down('activosafectadosgasto').funcionRecargar();
					         grid.up('gastodetalle').down('contabilidadgasto').funcionRecargar();
					         
					         var comboLineas =  grid.up('gastodetalle').down('activosafectadosgasto').down('[reference=comboLineasDetalleReference]');
					         if (comboLineas && comboLineas.getStore()) {
					        	 comboLineas.reset();
						         comboLineas.getStore().load();
					         }
		 	    			 var gridElementos = grid.up('gastodetalle').down('activosafectadosgasto').down('[reference=listadoActivosAfectadosRef]');
					         if(gridElementos && gridElementos.getStore()){
						         gridElementos.getStore().getProxy().setExtraParams({'idLinea':-1});
						         gridElementos.getStore().load();
					         }
					         
					         var gridActivosLbk = grid.up('gastodetalle').down('contabilidadgasto').down('[reference=vImporteGastoLbkGrid]');
					         if(gridActivosLbk && gridActivosLbk.getStore()){
					        	 gridActivosLbk.getStore().getProxy().setExtraParams({'idGasto':idGasto});
					        	 gridActivosLbk.getStore().load();
					         }
					         
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


	onSearchClickTasaciones: function(btn) {
		var me = this;
		this.lookupReference('selecciontasacionesgastolist').getStore().loadPage(1);

	},
	
		// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {

		btn.up('panel').getForm().reset();
			
	},

		// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClickTasaciones: function(btn) {

		btn.up('panel').getForm().reset();

	},
	
	paramLoading: function(store, operation, opts) {
		
		var me = this;
		var searchForm = me.lookupReference('seleccionTrabajosGastoSearch');
		if (searchForm.isValid()) {
			
			var criteria = me.getFormCriteria(searchForm);
			if(!Ext.isEmpty(criteria) && !Ext.isEmpty(criteria.codigoSubtipo)){
				for(var i = 0; i < criteria.codigoSubtipo.length; i++){ 
					if(Ext.isEmpty(criteria.codigoSubtipo[i])){ 
						criteria.codigoSubtipo.splice(i,1)
					}
				}
			}
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},

    paramLoadingTasaciones: function(store, operation, opts) {

        var me = this;
        var searchForm = me.lookupReference('selecciontasacionesgastosearch');
        if (searchForm.isValid()) {

            var criteria = me.getFormCriteria(searchForm);
            if(!Ext.isEmpty(criteria) && !Ext.isEmpty(criteria.codigoSubtipo)){
                for(var i = 0; i < criteria.codigoSubtipo.length; i++){
                    if(Ext.isEmpty(criteria.codigoSubtipo[i])){
                        criteria.codigoSubtipo.splice(i,1)
                    }
                }
            }
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
		    	 var url2 = $AC.getRemoteUrl('gastosproveedor/actualizarParticipacionTrabajosAfterInsert');
		    	 Ext.Ajax.request({
				     url: url2,
				     params: {idGasto: idGasto},
				
				     success: function(response, opts) {
				    	 ventanaSeleccionTrabajos.unmask();		
				         var comboLineas = ventanaSeleccionTrabajos.up('gastodetalle').down('activosafectadosgasto').down('[reference=comboLineasDetalleReference]');
				         ventanaSeleccionTrabajos.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
				         ventanaSeleccionTrabajos.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar();
				         ventanaSeleccionTrabajos.up('gastodetalle').down('contabilidadgasto').funcionRecargar();
				         
				         if (comboLineas && comboLineas.getStore()) {
				        	 comboLineas.reset();
					         comboLineas.getStore().load();
				         }

				         var gridElementos = ventanaSeleccionTrabajos.up('gastodetalle').down('activosafectadosgasto').down('[reference=listadoActivosAfectadosRef]');

				         if(gridElementos &&  gridElementos.getStore()){
					         gridElementos.getStore().getProxy().setExtraParams({'idLinea':-1});
					         gridElementos.getStore().load();
				         }
				        
				         var gridActivosLbk = ventanaSeleccionTrabajos.up('gastodetalle').down('contabilidadgasto').down('[reference=vImporteGastoLbkGrid]');
				         if(gridActivosLbk &&  gridActivosLbk.getStore()){
				        	 gridActivosLbk.getStore().getProxy().setExtraParams({'idGasto':idGasto});
				        	 gridActivosLbk.getStore().load();
				         }
				         
				         ventanaSeleccionTrabajos.destroy();
				         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						 me.refrescarGastoAlIncluirTrabajo(ventanaSeleccionTrabajos.up('gastodetallemain'));
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

	asignarSeleccionTasacionesGasto: function(btn) {

		var me = this,
		ventanaSeleccionTasaciones = btn.up('window'),
		tasaciones = ventanaSeleccionTasaciones.down('selecciontasacionesgastolist').getPersistedSelection(),
		idGasto = ventanaSeleccionTasaciones.gasto.get("id"),
		url =  $AC.getRemoteUrl('gastosproveedor/asignarTasacionesGastos'),
		idTasaciones = [];

		// Recuperamos todos los ids de los trabajos seleccionados
		Ext.Array.each(tasaciones, function(tasaciones, index) {
		    idTasaciones.push(tasaciones.get("idTasacion"));
		});

		ventanaSeleccionTasaciones.mask(HreRem.i18n("msg.mask.loading"));
			Ext.Ajax.request({
		     url: url,
		     params: {idGasto: idGasto, tasaciones: idTasaciones},

		     success: function(response, opts) {
			    ventanaSeleccionTasaciones.unmask();
                ventanaSeleccionTasaciones.destroy();
				me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				me.refrescarGastoAlIncluirTasacion(ventanaSeleccionTasaciones.up('gastodetallemain'));
		     },
		     failure: function(response) {
		     	ventanaSeleccionTasaciones.unmask();
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
	
	refrescarGastoAlIncluirTrabajo: function(view) {	
		var me = this;
		var tabPanel = view.down("tabpanel");

		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(view.query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});

  		if(!Ext.isEmpty(tabPanel)) {	  		
			var activeTab = tabPanel.getActiveTab();

			if(activeTab.funcionRecargar) {
  				activeTab.funcionRecargar();
			}

			var callbackFn = function() {view.down("tabpanel").evaluarBotonesEdicion(activeTab);};
			view.fireEvent("refrescarGasto", view, callbackFn);
  		}
	},

	refrescarGastoAlIncluirTasacion: function(view) {
		var me = this;
		var tabPanel = view.down("tabpanel");

		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(view.query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});

  		if(!Ext.isEmpty(tabPanel)) {
			var activeTab = tabPanel.getActiveTab();

			if(activeTab.funcionRecargar) {
  				activeTab.funcionRecargar();
			}

			var callbackFn = function() {view.down("tabpanel").evaluarBotonesEdicion(activeTab);};
			view.fireEvent("refrescarGasto", view, callbackFn);
  		}
	},
	
	cancelarSeleccionTrabajosGasto: function(btn) {
		btn.up('window').destroy();
	},

	cancelarSeleccionTasacionesGasto: function(btn) {
		btn.up('window').destroy();
	},
	
	onRowDblClickListadoTrabajosGasto: function(view, record) {
		var me = this;
		record.set('id', record.get('idTrabajo'));
		me.getView().fireEvent('abrirDetalleTrabajo', record);
	},
    
	onChangeIban: function(field, value){
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
	
	onChangeRetencionGarantiaAplica: function(field, checked){
		var me= this;
		// Habilitamos/deshabilitamos campos

		me.lookupReference('baseIRPFRetG').setDisabled(!checked);
		me.lookupReference('irpfTipoImpositivoRetG').setDisabled(!checked);
		me.lookupReference('cuotaIRPFRetG').setDisabled(!checked);
		me.lookupReference('comboTipoRetencionRef').setDisabled(!checked);
		me.lookupReference('comboTipoRetencionRef').setAllowBlank(!checked);
		if(!checked){
			me.lookupReference('comboTipoRetencionRef').setValue('');
			me.lookupReference('baseIRPFRetG').setValue('');
			me.lookupReference('irpfTipoImpositivoRetG').setValue(0);
			me.lookupReference('cuotaIRPFRetG').setValue('');
		}
		me.onChangeCuotaRetencionGarantia(checked);
		
		
		
		
	},
	
	onChangeAbonoCuenta: function(field, checked){
		var me= this;


		// Habilitamos/deshabilitamos campos
		me.lookupReference('ibanRef').setDisabled(!checked);
		me.lookupReference('titularCuentaRef').setDisabled(!checked);
		me.lookupReference('nifTitularCuentaRef').setDisabled(!checked);
		
		if(checked){			
			// Desmarcamos el resto de opciones
			me.lookupReference('pagadoConexionBankiaRef').setValue(!checked);
			me.lookupReference('incluirPagoProvisionRef').setValue(!checked);
			me.lookupReference('anticipoRef').setValue(!checked);
			me.lookupReference('fechaPago').setAllowBlank(true);
		} else {
			me.lookupReference('iban1').setValue("");
			me.lookupReference('iban2').setValue("");
			me.lookupReference('iban3').setValue("");
			me.lookupReference('iban4').setValue("");
			me.lookupReference('iban5').setValue("");
			me.lookupReference('iban6').setValue("");
			me.lookupReference('titularCuentaRef').setValue("");
			me.lookupReference('nifTitularCuentaRef').setValue("");
			me.lookupReference('fechaPago').setAllowBlank(true);
		}
		
	},
	
	onChangePagadoBankia: function(field, checked){
		var me= this;

		// Habilitamos/deshabilitamos campos
		me.lookupReference('oficinaRef').setDisabled(!checked);
		me.lookupReference('numeroConexionRef').setDisabled(!checked);
		me.lookupReference('fechaConexionRef').setDisabled(!checked);
			
		if(checked){
			// Desmarcamos el resto de opciones
			me.lookupReference('abonoCuentaRef').setValue(!checked);
			me.lookupReference('incluirPagoProvisionRef').setValue(!checked);
			me.lookupReference('anticipoRef').setValue(!checked);
			me.lookupReference('fechaPago').setAllowBlank(false);
		} else {
			me.lookupReference('oficinaRef').setValue("");
			me.lookupReference('numeroConexionRef').setValue("");
			me.lookupReference('fechaConexionRef').setValue("");
			me.lookupReference('fechaPago').setAllowBlank(true);
		}
	},
	
	onChangePagadoProvision: function(field, checked){
		var me= this;
		
		if(checked){
			me.lookupReference('abonoCuentaRef').setValue(!checked);
			me.lookupReference('pagadoConexionBankiaRef').setValue(!checked);
			me.lookupReference('anticipoRef').setValue(!checked);
			me.lookupReference('fechaPago').setAllowBlank(false);			
		} else {
			me.lookupReference('fechaPago').setAllowBlank(true);
		}
	},
	
	onChangeAnticipo: function(field, checked) {
		
		var me = this;
		
		me.lookupReference('fechaAnticipoRef').setDisabled(!checked);
			
		if(checked){
			// Desmarcamos el resto de opciones
			me.lookupReference('abonoCuentaRef').setValue(!checked);
			me.lookupReference('incluirPagoProvisionRef').setValue(!checked);
			me.lookupReference('pagadoConexionBankiaRef').setValue(!checked);
			me.lookupReference('fechaPago').setAllowBlank(false);
		} else {
			me.lookupReference('fechaAnticipoRef').setValue("");
			me.lookupReference('fechaPago').setAllowBlank(true);
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
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		record.erase({
			params: {idEntidad: idGasto},
            success: function(record, operation) {
            	 me.getView().unmask();
           		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
           		 grid.fireEvent("afterdelete", grid);
            },
            failure: function(record, operation) {
            	  me.getView().unmask();
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
		config.params.nombreDocumento=record.get("nombre").replace(/,/g, "");		
		me.fireEvent("downloadFile", config);
	},
	
    onClickBotonCerrarPestanya: function(btn) {
    	var me = this;
    	me.getView().destroy();
    },
    
    onClickBotonCerrarTodas: function(btn) {
    	var me = this;
    	me.getView().up("tabpanel").fireEvent("cerrarTodas", me.getView().up("tabpanel"));    	

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
	
	},
	
	onClickAutorizar: function(btn) {
    	var me = this;
    	
    	me.getView().mask(HreRem.i18n("msg.mask.loading"));
    	
    	var idGasto = idGasto = me.getViewModel().get("gasto.id");
    	var url = $AC.getRemoteUrl('gastosproveedor/getAvisosSuplidos');	
    	
    	Ext.Ajax.request({
			url: url,
			params: {idGasto: idGasto},
			success: function(response, opts) {
				var data = {};
				try {
					data = Ext.decode(response.responseText);
					}
				catch (e){ };
				if(!Ext.isEmpty(data.msg)){
					me.fireEvent("errorToast", data.msg);
				} else {
					msg = HreRem.i18n('msg.desea.autorizar.gasto');
				}
				me.getView().unmask();	
				Ext.Msg.show({
				   	title: HreRem.i18n('title.mensaje.confirmacion'),
				   	msg: msg,
				   	buttons: Ext.MessageBox.YESNO,
				   	fn: function(buttonId) {
				   		if (buttonId == 'yes') {
					url =  $AC.getRemoteUrl('gastosproveedor/autorizarGasto');		
	
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
	
					Ext.Ajax.request({
				    			
					     url: url,
					     params: {idGasto: idGasto},
					
					     success: function(response, opts) {
					        me.getView().unmask();
					     	var data = {};
				            try {
				               	data = Ext.decode(response.responseText);
				            }
				            catch (e){ };
				            
				            if(data.success === "false") {
					            if (!Ext.isEmpty(data.msg)) {
					               	me.fireEvent("errorToast", data.msg);
					            } else {
					             	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					            }
				            } else {
						         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						         me.refrescarGasto(true);						         
				            }
					     },
					     failure: function(response) {
					     	me.getView().unmask();
				     		var data = {};
			                try {
			                	data = Ext.decode(response.responseText);
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
				   	}});
						
			}
		});
    	
    	
    	
    },
    
    onClickRechazar: function(btn) {
    	
    	var me = this;
    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.rechazar.gasto'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
 				if (buttonId == 'yes') {
 					
 					var combo = Ext.create("HreRem.view.common.ComboBoxFieldBase", {
 						addUxReadOnlyEditFieldPlugin: false, store: {model: 'HreRem.model.ComboBase',proxy: {type: 'uxproxy',remoteUrl: 'generic/getDiccionario',extraParams: {diccionario: 'motivosRechazoHaya'}}}
 					});
 						
					HreRem.Msg.promptCombo(HreRem.i18n('title.motivo.rechazo'),"", function(btn, text){    
					    if (btn == 'ok'){
							
							var url =  $AC.getRemoteUrl('gastosproveedor/rechazarGasto'),		
							idGasto = me.getViewModel().get("gasto.id");		
							me.getView().mask(HreRem.i18n("msg.mask.loading"));
			
							Ext.Ajax.request({
						    			
							     url: url,
							     params: {idGasto: idGasto, motivoRechazo: text},
							
							     success: function(response, opts) {
							        me.getView().unmask();							        
							        var data = {};
						            try {
						               	data = Ext.decode(response.responseText);
						            }
						            catch (e){ };
						            
						            if(data.success === "false") {
							            if (!Ext.isEmpty(data.msg)) {
							               	me.fireEvent("errorToast", data.msg);
							            } else {
							             	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							            }
						            } else {
								         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								         me.refrescarGasto(true);								    
						            }
							     },
							     failure: function(response) {
							     	me.getView().unmask();
						     		var data = {};
					                try {
					                	data = Ext.decode(response.responseText);
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
		    		}, null, null, null, combo);
		        }
		   }
		});
    	
    },
    
/*    onChangeFechaDevengoEspecial: function(calendario){
    	var me = this;
    	var fecha = new Date(calendario.value);
    	var anyo = fecha.getFullYear();
    	var combo = me.lookupReference('comboboxfieldFechaEjercicio');
    	if(combo.getStore().byText.map){
    		combo.value= combo.getStore().byText.map[anyo].id;
    		combo.bindStore(combo.getStore());
    	}else{
    		console.log(HreRem.i18n('msg.info.fecha.devengoEspecial'));
    	}
    },*/
    
    afterCargaCombo: function(){
    	var me = this;    	
    	var fechaActual = new Date();
    	var combobox = me.lookupReference('comboboxfieldFechaEjercicio');
    	if(combobox){
	    	var anyo = combobox.getStore().getAt(0).data.anyo;
	    	var fechaMin = new Date(anyo);
	    	fechaActual.setMonth(fechaActual.getMonth()+1);
	    	fechaField = me.lookupReference('fechaDevengoEspecial');
	    	fechaField.setMinValue(fechaMin);
	    	fechaField.setMaxValue(fechaActual);
    	}
    },
    isLiberbankAndGastosPrinex:function(panel){
    	var me = this;
    	var url = $AC.getRemoteUrl('gastosproveedor/searchActivoCarteraAndGastoPrinex');
    	var gastoHaya = me.getViewModel().get("gasto.numGastoHaya"); 
    	
    	Ext.Ajax.request({
			
		     url: url,
		     params: {numGastoHaya: gastoHaya},
		
		     success: function(response, opts) {
		    	 data = Ext.decode(response.responseText);
		    	 
		    	 	if(data.success == "true"){
		    	 		if(data.data == "true"){
		    	 			panel.up().getLayout().columns=4;
		    				panel.up().getLayout().tdAttrs.width="25%";
		    				panel.lookupController().refrescarGasto();
		    	 		}else{
		    	 			panel.destroy();
		    	 		}
		    	 	}
		     },
		     
		     failure: function(response) {
		     	grid.unmask();
	     		var data = {};
               try {
            	   me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
               }
               catch (e){
            	   me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
               };
              
		     }
	    		     
	    });
    	
		
    	
    	
    },
    
    botonesEdicionGasto: function(estadoGasto, autorizado, rechazado, agrupado,gestoria, tabSeleccionada){
    	var me = this;
		if(tabSeleccionada.xtype=='datosgeneralesgasto' && $AU.userHasFunction('EDITAR_TAB_DATOS_GENERALES_GASTOS') && (
				CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || 
				(CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado) || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado)
		    	|| CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto)){
	    		return true;
    	}
    	
    	if(tabSeleccionada.xtype=='detalleeconomicogasto' && $AU.userHasFunction('EDITAR_TAB_DETALLE_ECONOMICO_GASTOS') && ((CONST.ESTADOS_GASTO['PAGADO']==estadoGasto) ||
    			(CONST.ESTADOS_GASTO['AUTORIZADO']==estadoGasto && gestoria) || /*CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO']==estadoGasto || */
	    		CONST.ESTADOS_GASTO['CONTABILIZADO']==estadoGasto || CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || 
	    		CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado) 
	    		|| (CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado) || CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto)){
    			
    			return true;
    	}
    	
    	if(tabSeleccionada.xtype=='activosafectadosgasto' && $AU.userHasFunction('EDITAR_TAB_ACTIVOS_AFECTADOS_GASTOS') && (
    			CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || 
    			(CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado) || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado)
		    	|| CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto)){
	    		return true;
    	}
    	
    	if(tabSeleccionada.xtype=='contabilidadgasto' && $AU.userHasFunction('EDITAR_TAB_CONTABILIDAD_GASTOS') && (
    			CONST.ESTADOS_GASTO['INCOMPLETO']==estadoGasto || CONST.ESTADOS_GASTO['PENDIENTE']==estadoGasto || CONST.ESTADOS_GASTO['RECHAZADO']==estadoGasto || 
    			(CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado) || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado)
		    	|| CONST.ESTADOS_GASTO['RETENIDO']==estadoGasto)){
    			return true;
    	}
    	
    	if(tabSeleccionada.xtype=='gestiongasto' && $AU.userHasFunction('EDITAR_TAB_GESTION_GASTOS') && (
    			CONST.ESTADOS_GASTO['CONTABILIZADO']!=estadoGasto && CONST.ESTADOS_GASTO['ANULADO']!=estadoGasto && CONST.ESTADOS_GASTO['AUTORIZADO'] != estadoGasto && CONST.ESTADOS_GASTO['AUTORIZADO_PROPIETARIO'] != estadoGasto) 
    			&& (CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']!=estadoGasto || (CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO']==estadoGasto && !autorizado && !agrupado)) 
    			&& (CONST.ESTADOS_GASTO['SUBSANADO']!=estadoGasto || (CONST.ESTADOS_GASTO['SUBSANADO']==estadoGasto && !autorizado))){ 
    	
    			return true;
    	}
    	
    	return false;
    },
    
    buscarGastosRefacturables: function(field, e){
		var me= this;
		var url = $AC.getRemoteUrl('gastosproveedor/getGastosRefacturados');
		
		var gastos= field.getValue();
		var nifPropietario = me.lookupReference("buscadorNifPropietarioField").getValue();
		var destinatarioGastoCodigo = me.getView().down('[name=destinatarioGastoCodigo]');
		var buscadorNifEmisorField = me.lookupReference("buscadorNifEmisorField");
		var nifEmisor = me.lookupReference("comboProveedores");
		var tipoGasto = me.lookupReference("tipoGasto").getValue();
		
		Ext.Ajax
		.request({
			url : url,
			params : {
				gastos : gastos,
				nifPropietario : nifPropietario,
				tipoGasto: tipoGasto
			},
			success : function(response, opts) {
				var data = Ext.decode(response.responseText);
				var gastosRefacturables = data.refacturable;
				var gastosNoRefacturables= data.noRefacturable;
			
				var grid = me.lookupReference("gastoRefacturadoGrid");
				

				var arrayCodVal= new Array();
				
				for(j=0;j < gastosRefacturables.length;j++){				
					var ArrayvaloresCombo=  gastosRefacturables[j].split(',');
					
					var idCombo = j;
					var idGasto= ArrayvaloresCombo[0];
					var gastoRefacturable= true;
					
					arrayCodVal.push({idCombo:idCombo, gastoRefacturable: gastoRefacturable, idGasto: idGasto});
					
				}
				
				var myStore = new Ext.data.Store({
					    fields: ['idCombo','gastoRefacturable', 'idGasto'],
					    idIndex: 0,
					    data: arrayCodVal
					    
				});
				
				grid.setStore(myStore);
				
				destinatarioGastoCodigo.setReadOnly(arrayCodVal.length!=0);
				buscadorNifEmisorField.setReadOnly(arrayCodVal.length!=0);
				nifEmisor.setReadOnly(arrayCodVal.length!=0);
				buscadorNifEmisorField.enableKeyEvents = (arrayCodVal.length==0);
			},
			failure : function(response) {
				me.fireEvent("errorToast", HreRem
						.i18n("msg.operacion.ko"));
			},
			callback : function(options, success,
					response) {
			}

		});
	},
	
	  onClickGuardarGastoRefacturado: function(){
	    	var me = this;

	    	var gastosRefacturables = me.lookupReference('anyadirGastoRefacturado').getValue();	    	
	    	var idGasto = me.getView().idGasto;
	    	var dataModificar = me.getView().grid.lookupController().getView().getViewModel().getData().gasto.getData();
	    	var nifPropietario = me.getView().nifPropietario;
	    	var url = $AC.getRemoteUrl('gastosproveedor/anyadirGastoRefacturable');
	    	
	    		
	    	if(gastosRefacturables == ""){
	    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anyadir.gastos.refacturados")); 
	    	}else{
	    		me.getView().mask(HreRem.i18n("msg.mask.loading"));
	    		Ext.Ajax.request({
			 		url: url,
			   		params: {
			   					idGasto:idGasto,
			   					gastosRefacturables : gastosRefacturables,
			   					nifPropietario : nifPropietario
			   				},
			    		
			    	success: function(response, opts) {
				    	data = Ext.decode(response.responseText);
				    	if(data.success == 'false') {
				    		me.fireEvent("errorToast", data.error);
				    	}	
			    	},
			    	failure: function(response) {	
			    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    		me.getView().unmask();
			    	},
			    	callback: function(options, success, response){
			    		me.getView().grid.getStore().reload();
			    		var datosGeneralesGastos = me.getView().grid.up("gastodetalle").down("[reference=datosgeneralesgastoref]");
			    		var datosDetalleEconomico = me.getView().grid.up("gastodetalle").down("[reference=detalleeconomicogastoref]");
			    		var gridLineaDetalle = me.getView().grid.up("gastodetalle").down("[reference=lineaDetalleGastoGrid]");
			    		gridLineaDetalle.getStore().reload();
			    		me.getViewModel().set("gasto.id",me.getView().idGasto);
			    		me.cargarTabDataCambiarRefacturables(datosGeneralesGastos, gridLineaDetalle);
			    		me.cargarTabData(datosDetalleEconomico);
			    		me.getView().unmask();
				    	me.closeView();
					}
			    		     
			  });
	    		
	    	}
	    	
	    },
	   disableGridGastosRefacturados: function (combo, newValue, oldValue, eOps) {
	    	var me = this;
	    	me.lookupReference("gastoRefacturadoGridExistente").setDisabled(newValue);

	    
	    }, 
	mostrarGastosRefacturables: function() {
		var me = this;
		var form = me.getView().down('formBase');
		var propietario = form.down('[name=nombrePropietario]').getValue();
		if (propietario != "") {
			var control = me.getViewModel().get("controlPestanyaGastoRefacturable");
			var cartera = control.cartera.codigo;
			if (cartera === CONST.CARTERA['SAREB'] || cartera === CONST.CARTERA['BANKIA']) {
				var isGastoPadre = (form.down('[name=destinatarioGastoCodigo]').value===CONST.TIPOS_DESTINATARIO_GASTO['PROPIETARIO'] && 
						form.down('[name=nifEmisor]').value===CONST.PVE_DOCUMENTONIF['HAYA']);
				var isGastoRefacturable = (form.down('[name=destinatarioGastoCodigo]').value===CONST.TIPOS_DESTINATARIO_GASTO['HAYA']);
				form.down('[name=gastosArefacturar]').setDisabled(!isGastoPadre);
				form.down('[name=gastoRefacturadoGrid]').setDisabled(!isGastoPadre);
				form.down('[name=checkboxActivoRefacturable]').setDisabled(!isGastoRefacturable);
				if (!isGastoRefacturable) {
					form.down('[name=checkboxActivoRefacturable]').setValue(false);
				}
			} else {
				form.down('[name=gastosArefacturar]').setDisabled(true);
				form.down('[name=gastoRefacturadoGrid]').setDisabled(true);
				form.down('[name=checkboxActivoRefacturable]').setDisabled(true);
				form.down('[name=checkboxActivoRefacturable]').setValue(false);
			}
		} else {
			form.down('[name=gastosArefacturar]').setDisabled(true);
			form.down('[name=gastoRefacturadoGrid]').setDisabled(true);
			form.down('[name=checkboxActivoRefacturable]').setDisabled(true);
			form.down('[name=checkboxActivoRefacturable]').setValue(false);
		}
	},
	
	onActivateActionsContabilidadTab: function (target) {
		var me=this;
		me.viewBotonesEditar(target);
		me.viewItemsContabilidad();
	},
	
	viewBotonesEditar: function(target){
		var me = this;
		var estadoGasto= me.getViewModel().get('gasto.estadoGastoCodigo');
		var autorizado = me.getViewModel().get('gasto.autorizado');
		var rechazado = me.getViewModel().get('gasto.rechazado');
		var agrupado = me.getViewModel().get('gasto.esGastoAgrupado');
		var gestoria = me.getViewModel().get('gasto.nombreGestoria')!=null;
		target.up('tabpanel').down('tabbar').down('button[itemId=botoneditar]')
			.setVisible(me.botonesEdicionGasto(estadoGasto,autorizado,rechazado,agrupado,gestoria,target));
	},
	
	viewItemsContabilidad: function () {
		var me = this;
		var cartera = me.getViewModel().get('gasto.cartera');
		var subcartera = me.getViewModel().get('gasto.subcartera'); 
		var isDivarian = CONST.CARTERA['CERBERUS'] === cartera
						&& (CONST.SUBCARTERA['DIVARIANARROW'] === subcartera
								|| CONST.SUBCARTERA['DIVARIANREMAINING'] == subcartera || CONST.SUBCARTERA['APPLEINMOBILIARIO'] == subcartera);

		var comboActivable = me.lookupReference('comboActivable');
		var gicPlanVisitas = me.lookupReference('gicPlanVisitas');
		var tipoComisionadoHre = me.lookupReference('tipoComisionadoHre');

		if(cartera == CONST.CARTERA['LIBERBANK']){
		    comboActivable.setHidden(false);
		    gicPlanVisitas.setHidden(false);
		    tipoComisionadoHre.setHidden(false);
		}else if(cartera == CONST.CARTERA['BBVA']){
		    comboActivable.setHidden(false);
		}
	},
	
	onClickGuardarLineaDetalleGasto: function(btn){
    	var me = this;
    	
    	var window = btn.up('[reference=ventanaCrearLineaDetalleGasto]');
		var form = window.down('[reference=crearLineaDetalleGastoForm]');	
		
		if(window.parent.getStore().data != undefined && 
			window.parent.lookupController().getViewModel().getData() != undefined &&
			window.parent.lookupController().getViewModel().getData().esCarteraBakia &&
			window.parent.getStore().data.length > 0){
			
			if(window.idLineaDetalleGasto == null){
				me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.error.anyadir.gasto.linea.detalle.bk"));
				return;
			}
			
		}
		
		var tipoImpositivo = form.getForm().findField('tipoImpositivo').getValue();
		var tipoImpuesto = form.getForm().findField('tipoImpuesto').getValue();
		
		if(tipoImpositivo > 100){
			me.fireEvent("errorToast",  HreRem.i18n("msg.operacion.ko.gasto.tipoImpositivo.mayor.cien"));
    		return;
		}
		if(!me.comprobarImportesRellenosLineaDetalleGasto(window)){
			me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.gasto.linea.detalle.no.importe"));
			return;
		}
		
		if(!Ext.isEmpty(tipoImpositivo) && Ext.isEmpty(tipoImpuesto) && tipoImpositivo != 0){
			me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.gasto.linea.detalle.no.tipo.impositivo"));
			return;
		}
		
		
		if(form.isValid()){
			form.submit({                
				waitMsg: HreRem.i18n('msg.mask.loading'),
                params: {
                	idGasto: window.idGasto,
                	id: window.idLineaDetalleGasto
                },

                success: function(fp, o) {
                	if(o.result.success == "false") {
                		window.fireEvent("errorToast", o.result.errorMessage);
                	}
                	else {
                		window.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                	}
                	
                	if(!Ext.isEmpty(window.parent)) {
                		window.parent.fireEvent("aftercreate", window.parent);
                	}
                	var grid = window.lookupController().getView().down('[reference=lineaDetalleGastoGrid]');
                	grid.getStore().load();
                	window.close();
                	
                	var comboLineas = grid.up('gastodetalle').down('activosafectadosgasto').down('[reference=comboLineasDetalleReference]');
                	grid.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar();
                	grid.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
                	grid.up('gastodetalle').down('activosafectadosgasto').funcionRecargar();
                	grid.up('gastodetalle').down('contabilidadgasto').funcionRecargar();
                	
                	 if (comboLineas &&  comboLineas.getStore()) {
			        	 comboLineas.reset();
				         comboLineas.getStore().load();
			         }
                	
			         var gridElementos = grid.up('gastodetalle').down('activosafectadosgasto').down('[reference=listadoActivosAfectadosRef]');

			         if(gridElementos && gridElementos.getStore()){
				         gridElementos.getStore().getProxy().setExtraParams({'idLinea':-1});
				         gridElementos.getStore().load();
			         }
			         
			         var gridActivosLbk = grid.up('gastodetalle').down('contabilidadgasto').down('[reference=vImporteGastoLbkGrid]');
			         if(gridActivosLbk && gridActivosLbk.getStore()){
			        	 gridActivosLbk.getStore().getProxy().setExtraParams({'idGasto':window.idGasto});
			        	 gridActivosLbk.getStore().load();
			         }
                },
                failure: function(fp, o) {
                	window.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                }
            });
		 
		}else{
			me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.error.anyadir.gasto.linea.detalle.campos"));
		}
    },
    
    comprobarImportesRellenosLineaDetalleGasto: function(window){
    	var hayImporteRelleno = false;
		
		var baseSujeta = window.down('[reference=baseSujeta]').getValue();
		var baseNoSujeta = window.down('[reference=baseNoSujeta]').getValue();
		var recargo = window.down('[reference=recargo]').getValue();
		var interes = window.down('[reference=interes]').getValue();
		var costas = window.down('[reference=costas]').getValue();
		var otros = window.down('[reference=otros]').getValue();
		var provSupl = window.down('[reference=provSupl]').getValue();
		
		
		if(!Ext.isEmpty(baseSujeta) || !Ext.isEmpty(baseNoSujeta) || !Ext.isEmpty(recargo) || !Ext.isEmpty(interes)
				|| !Ext.isEmpty(costas) || !Ext.isEmpty(otros) || !Ext.isEmpty(provSupl)){
			hayImporteRelleno = true;
		}
    	return hayImporteRelleno;
    },
    
    
    onChangeValorImporteTotal: function(){
    	var me=this;
    	var formulario = me.lookupReference('crearLineaDetalleGastoForm').getForm();
    	var importeTotal = me.calcularImporteTotal(formulario);
		
		formulario.findField('importeTotal').setValue(importeTotal);		
    },
    
    onChangeHabilitarTipoRecargo: function(){
    	var me=this;
    	var formulario = me.lookupReference('crearLineaDetalleGastoForm').getForm();
    	var recargo = formulario.findField('recargo').getValue();
    	var tipoRecargo = formulario.findField('tipoRecargo');
    	var importeTotal = me.calcularImporteTotal(formulario);

    	formulario.findField('importeTotal').setValue(importeTotal);
    	
    	if(recargo == null || recargo == undefined || parseFloat(recargo) == 0){
    		tipoRecargo.setDisabled(true);
    	}else{
    		tipoRecargo.setDisabled(false);
    	}
    	
    },
    
    onChangeCuota: function(){
    	var me = this;
    	var formulario = me.lookupReference('crearLineaDetalleGastoForm').getForm();
    	var baseSujeta = formulario.findField('baseSujeta').getValue();
    	var tipoImpositivo = formulario.findField('tipoImpositivo').getValue();
    	var operacionExenta = formulario.findField('operacionExentaImp').getValue();
    	var operacionExentaRenuncia = formulario.findField('esRenunciaExenta').getValue();
    	var disabledOpExenta = false;
    	var cuota = 0;
    	
    	if(Ext.isEmpty(baseSujeta)){
    		formulario.findField('baseSujeta').setValue(0);
    	}
    	if(Ext.isEmpty(tipoImpositivo)){
    		formulario.findField('tipoImpositivo').setValue(0);
    	}
    	
    	if(operacionExenta && !operacionExentaRenuncia){
    		disabledOpExenta = true;
    	}
    	formulario.findField('tipoImpositivo').setDisabled(disabledOpExenta);
    	formulario.findField('cuota').setDisabled(disabledOpExenta);
    	
    	
    	if(tipoImpositivo > 100){
    		ventana = me.lookupReference('ventanaCrearLineaDetalleGasto');
    		ventana.fireEvent("errorToast",  HreRem.i18n("msg.operacion.ko.gasto.tipoImpositivo.mayor.cien"));
    		return;
    	}
    	
    	if(baseSujeta != null && tipoImpositivo != null ){
    		cuota = (baseSujeta * tipoImpositivo )/ 100;
    	}
    	
    	cuota = Number(Math.round(cuota + "e+" + 2)  + "e-" + 2);
    	
    	formulario.findField('cuota').setValue(cuota);
   
    	var importeTotal = me.calcularImporteTotal(formulario);
    	formulario.findField('importeTotal').setValue(importeTotal);
    	
    },
    
    onChangeSubpartida: function(){
    	var me = this;
    	var formulario = me.lookupReference('crearLineaDetalleGastoForm').getForm();
    	var subPartidas = formulario.findField('subPartidas').getValue();
    	formulario.findField('ppBase').setValue(subPartidas);
    },
    
    
    calcularImporteTotal: function (formulario){
    	var me=this;
    	var importeTotal = 0;

    	var baseSujeta = formulario.findField('baseSujeta').getValue()==null?0:formulario.findField('baseSujeta').getValue();
    	var baseNoSujeta = formulario.findField('baseNoSujeta').getValue()==null?0:formulario.findField('baseNoSujeta').getValue();
		var recargo = formulario.findField('recargo').getValue()==null?0:formulario.findField('recargo').getValue();
		var interes = formulario.findField('interes').getValue()==null?0:formulario.findField('interes').getValue();
		var costas = formulario.findField('costas').getValue()==null?0:formulario.findField('costas').getValue();
		var otros = formulario.findField('otros').getValue()==null?0:formulario.findField('otros').getValue();
		var provSupl = formulario.findField('provSupl').getValue()==null?0:formulario.findField('provSupl').getValue();
		var tipoImpositivo = formulario.findField('tipoImpositivo').getValue()==null?0:formulario.findField('tipoImpositivo').getValue();
		var cuota = baseSujeta*tipoImpositivo/100;
		
		var operacionExentaImp = formulario.findField('operacionExentaImp').getValue()==null?0:formulario.findField('operacionExentaImp').getValue();
		var operacionExentaRenuncia = formulario.findField('esRenunciaExenta').getValue()==null?0:formulario.findField('esRenunciaExenta').getValue();
		
		if(baseSujeta != 0){
			importeTotal = importeTotal + baseSujeta;
		}else{
			formulario.findField('baseSujeta').setValue(0);
		}
		if(baseNoSujeta != 0){
			importeTotal = importeTotal + baseNoSujeta;
		}else{
			formulario.findField('baseNoSujeta').setValue(0);
		}
		if(recargo != 0){
			importeTotal = importeTotal + recargo;
		}else{
			formulario.findField('recargo').setValue(0);
		}
		if(interes != 0){
			importeTotal = importeTotal + interes;
		}else{
			formulario.findField('interes').setValue(0);
		}
		if(costas != 0){
			importeTotal = importeTotal + costas;
		}else{
			formulario.findField('costas').setValue(0);
		}
		if(otros != 0){
			importeTotal = importeTotal + otros;
		}else{
			formulario.findField('otros').setValue(0);
		}
		if(provSupl != 0){
			importeTotal = importeTotal + provSupl;
		}else{
			formulario.findField('provSupl').setValue(0);
		}

		if(cuota != 0 && (!operacionExentaImp || (operacionExentaImp && operacionExentaRenuncia))){
			importeTotal = importeTotal + cuota;
		}else{
			formulario.findField('cuota').setValue(0);
		}
		
		return importeTotal;
    },
    
    abrirVentanaModificarLineaDetalle: function(grid, record){
    	var me = this;
    	if(record.getData() == null || record.getData() == undefined){
    		return;
    	}
    	var idGasto = me.getView().getViewModel().get("gasto.id");
		var idLineaDetalleGasto = record.getData().id;
		var selection = record.getData();
		var grid = me.lookupReference('lineaDetalleGastoGrid')

		Ext.create("HreRem.view.gastos.VentanaCrearLineaDetalleGasto",
				{entidad: 'lineaDetalleGasto', idGasto: idGasto, parent:grid, idLineaDetalleGasto: idLineaDetalleGasto, record:selection}).show();
    },
    
    onChangeCuotaRetencionGarantia: function(checked){
    	var me = this;
    	var tipoImpositivo = me.lookupReference('irpfTipoImpositivoRetG').getValue();
    	var base = 0;
    	var cuotaImpDirecto = me.lookupReference('cuotaIRPFImpD').getValue();
    	var cuota = 0;
    	var tipoRetencion = me.lookupReference('comboTipoRetencionRef').getValue();
    	var despues = false;
    	var baseField = me.lookupReference('baseIRPFRetG');
    	var base = me.lookupReference('baseIRPFRetG').getValue();
    	var esLiberbank = me.getViewModel().get('esLiberbank');
    	
    	if(CONST.TIPO_RETENCION['DESPUES'] == tipoRetencion ){
	    	despues = true;
	    }

    	if(checked){     		
    		if (!esLiberbank) {
    			baseField.setReadOnly(true);
    		}
    		
    		if (!esLiberbank || base == null) {
    			if (!me.lookupReference('lineaDetalleGastoGrid').getStore().loading){
    	    		base = me.getImporteRetencionLineasDetalle(me, despues);
    	    	} else {
    	    		base = me.getViewModel().get('detalleeconomico.baseRetG');
    	    	}
    		}
	    
	    	if(tipoImpositivo != null && base != null){
	    		cuota = (tipoImpositivo * base)/100;
	    	}
    	}

    	me.lookupReference('baseIRPFRetG').setValue(base);
		cuota = Number(Math.round(cuota + "e+" + 2)  + "e-" + 2);
    	me.lookupReference('cuotaIRPFRetG').setValue(cuota);

    	me.onChangeCuotaImpuestoDirecto(me,despues);
    },
    
    onChangeCuotaImpuestoDirecto: function(field, value){
    	var me = this;
    	var tipoImpositivo = me.lookupReference('tipoImpositivoIRPFImpD').getValue();
    	var base = me.lookupReference('baseIRPFImpD').getValue();
    	var cuotaRetG = me.lookupReference('baseIRPFRetG').getValue()*me.lookupReference('irpfTipoImpositivoRetG').getValue()/100;
    	var valFechaPago = me.lookupReference('fechaPago').getValue();
    	var cuota = 0;
    	var valorCuota = 0;
    	var tipoImpositivoRetg = me.lookupReference('irpfTipoImpositivoRetG').getValue();
    	var despues;
		var esLiberbank = me.getViewModel().get('esLiberbank');
		
    	if (Number.isNaN(value)){
    		despues = value;
    	}else{
    		despues = (CONST.TIPO_RETENCION['DESPUES'] == me.lookupReference('comboTipoRetencionRef').getValue());
    	}
    	
    	if(tipoImpositivo != null && base != null){
    		cuota = (tipoImpositivo * base)/100;
    	}
    	
    	valorCuota = me.getImporteTotalCuotaIndirecta(me);
    	
    	if(tipoImpositivoRetg != null ){
    		valorCuota = (tipoImpositivoRetg * valorCuota)/100;	
    	}

    	var importeTotal = 0;
		cuota = Number(Math.round(cuota + "e+" + 2)  + "e-" + 2);
    	me.lookupReference('cuotaIRPFImpD').setValue(cuota);
    	
    	if(!me.lookupReference('lineaDetalleGastoGrid').getStore().loading){
    		importeTotal = me.getImporteTotalLineasDetalle(me);
    		importeTotal = importeTotal - Number(Math.round(((tipoImpositivo * base)/100) + "e+" + 2)  + "e-" + 2);
    		importeTotal = Number(Math.round(importeTotal + "e+" + 2)  + "e-" + 2);
    		cuotaRetG = Number(Math.round(cuotaRetG + "e+" + 2)  + "e-" + 2);
    		valorCuota = Number(Math.round(valorCuota + "e+" + 2)  + "e-" + 2);
    		if(cuotaRetG != null && cuotaRetG != undefined ){
    			if(despues == false && esLiberbank ){
    				importeTotal = importeTotal - cuotaRetG - valorCuota ;
    	    	}else{
    	    		importeTotal = importeTotal - cuotaRetG;
				}
				
    		}
    	}else{
    		importeTotal = me.getViewModel().get('detalleeconomico.importeTotal'); 
    	}
    	
		me.lookupReference('importeTotalGastoDetalle').setValue(importeTotal);
		if(!Ext.isEmpty(valFechaPago)){
			me.lookupReference('detalleEconomicoImportePagado').setValue(importeTotal);
    	}
    },
    
    getImporteTotalLineasDetalle: function(me){
    	var importeTotal = 0;
    	if(me.lookupReference('lineaDetalleGastoGrid').getStore() != null && me.lookupReference('lineaDetalleGastoGrid').getStore() != undefined){
    		for(var i = 0; i < me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items.length; i++){
    			importeTotal+= parseFloat(me.calcularImporteTotalLineaDetalle(i));
    		}
    	}
    	
    	return importeTotal;
    },

	calcularImporteTotalLineaDetalle: function(linea){
		var me=this;
		var importeTotal=0;
		
		var baseSujeta = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('baseSujeta')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('baseSujeta'));
    	var baseNoSujeta = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('baseNoSujeta')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('baseNoSujeta'));
		var recargo = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('recargo')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('recargo'));
		var interes = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('interes')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('interes'));
		var costas = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('costas')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('costas'));
		var otros = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('otros')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('otros'));
		var provSupl = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('provSupl')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('provSupl'));
		var tipoImpositivo = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('tipoImpositivo')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('tipoImpositivo'));
		var cuota = baseSujeta*tipoImpositivo/100;
		
		var operacionExentaImp = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('operacionExentaImp')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('operacionExentaImp'));
		var operacionExentaRenuncia = parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('esRenunciaExenta')==null?
							0:me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[linea].get('esRenunciaExenta'));
		
		
		importeTotal = importeTotal + baseSujeta + baseNoSujeta + recargo + interes + costas + otros + provSupl;
		

		if(cuota != null && (!operacionExentaImp || (operacionExentaImp && operacionExentaRenuncia))){
			importeTotal = importeTotal + cuota;
		}
		
		return importeTotal;
	},
    
    onChangeSubtipoGasto: function(){
    	var me = this;
    	var formulario = me.lookupReference('crearLineaDetalleGastoForm');
    	var subtipoGasto = formulario.getForm().findField('subtipoGasto').getValue();
    	var ventana = formulario.up('[reference=ventanaCrearLineaDetalleGasto]');
    	
    	if(ventana.record != null && ventana.record.subtipoGasto != null
    		&& subtipoGasto === ventana.record.subtipoGasto){
    		return;
    	}
    	if(ventana.record != null && ventana.record.subtipoGasto != null){
    		ventana.record.subtipoGasto = subtipoGasto;
    	}
    	
    	if(subtipoGasto != null && subtipoGasto != undefined){
    		ventana.mask(HreRem.i18n("msg.mask.loading"));
    		var url =  $AC.getRemoteUrl('gastosproveedor/calcularCuentasYPartidas');
    		
    		Ext.Ajax.request({		    			
    	 		url: url,
    	 		method: 'GET',
    	   		params: {
    	   			idGasto: ventana.idGasto,
    	   			idLineaDetalleGasto: ventana.idLineaDetalleGasto,
    	   			subtipoGastoCodigo:subtipoGasto
       			},	    		
    	    	success: function(response, opts) {
    	    		
    	    		var data = {};
	            	data = Ext.decode(response.responseText);
	            	
	            	if(data.data != undefined){
	            		me.setCuentasyPartidas(ventana, data.data);	
	            	}

	            	ventana.down('[reference=btnActualizarCuentasYPartidas]').setDisabled(false);
	            	ventana.down('[reference=fieldsetccpp]').setDisabled(false);
	        		ventana.down('[reference=fieldsetImpInd]').setDisabled(false);
	        		ventana.down('[reference=fieldsetImporte]').setDisabled(false);
	        		ventana.down('[reference=fieldsetdetallegastolbk]').setDisabled(false);
	        		ventana.unmask();
    	            	
    	    	},
       			failure: function(response) {
    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		    }
    		});

    	}
    
    },
    
    calcularCuentasYPartidas: function(){
    	var me = this;
    	var formulario = me.lookupReference('crearLineaDetalleGastoForm');
    	var subtipoGasto = formulario.getForm().findField('subtipoGasto').getValue();
    	var ventana = formulario.up('[reference=ventanaCrearLineaDetalleGasto]');
    	
    	if(subtipoGasto != null && subtipoGasto != undefined){
    		ventana.mask(HreRem.i18n("msg.mask.loading"));
    		var url =  $AC.getRemoteUrl('gastosproveedor/calcularCuentasYPartidas');
    		
    		Ext.Ajax.request({		    			
    	 		url: url,
    	 		method: 'GET',
    	   		params: {
    	   			idGasto: ventana.idGasto,
    	   			idLineaDetalleGasto: ventana.idLineaDetalleGasto,
    	   			subtipoGastoCodigo:subtipoGasto
       			},	    		
    	    	success: function(response, opts) {
    	    		
    	    		var data = {};
	            	data = Ext.decode(response.responseText);
	            	
	            	if(data.data != undefined){
	            		me.setCuentasyPartidas(ventana, data.data);
	            	}

	        		ventana.unmask();
    	            	
    	    	},
       			failure: function(response) {
    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		    }
    		});

    	}
    },
    
    setCuentasyPartidas: function(ventana, data){

    	if(!Ext.isEmpty(data.ccBase)){
			ventana.down('[reference=ccBase]').setValue(data.ccBase);
		}
		if(!Ext.isEmpty(data.ppBase)){
			ventana.down('[reference=ppBase]').setValue(data.ppBase);
		}
		if(!Ext.isEmpty(data.ccTasas)){
			ventana.down('[reference=ccTasas]').setValue(data.ccTasas);
		}
		if(!Ext.isEmpty(data.ppTasas)){
			ventana.down('[reference=ppTasas]').setValue(data.ppTasas);
		}
		if(!Ext.isEmpty(!data.ccRecargo)){
			ventana.down('[reference=ccRecargo]').setValue(data.ccRecargo);
		}
		if(!Ext.isEmpty(data.ppRecargo)){
			ventana.down('[reference=ppRecargo]').setValue(data.ppRecargo);
		}
		if(!Ext.isEmpty(data.ccInteres)){
			ventana.down('[reference=ccInteres]').setValue(data.ccInteres);
		}
		if(!Ext.isEmpty(data.ppInteres)){
			ventana.down('[reference=ppInteres]').setValue(data.ppInteres);
		}
		if(!Ext.isEmpty(!data.subcuentaBase)){
			ventana.down('[reference=subcuentaBase]').setValue(data.subcuentaBase);
		}
		if(!Ext.isEmpty(data.apartadoBase)){
			ventana.down('[reference=apartadoBase]').setValue(data.apartadoBase);
		}
		if(!Ext.isEmpty(data.capituloBase)){
			ventana.down('[reference=capituloBase]').setValue(data.capituloBase);
		}
		if(!Ext.isEmpty(!data.subcuentaRecargo)){
			ventana.down('[reference=subcuentaRecargo]').setValue(data.subcuentaRecargo);
		}
		if(!Ext.isEmpty(data.apartadoRecargo)){
			ventana.down('[reference=apartadoRecargo]').setValue(data.apartadoRecargo);
		}
		if(!Ext.isEmpty(data.capituloRecargo)){
			ventana.down('[reference=capituloRecargo]').setValue(data.capituloRecargo);
		}	
		if(!Ext.isEmpty(!data.subcuentaTasa)){
			ventana.down('[reference=subcuentaTasa]').setValue(data.subcuentaTasa);
		}
		if(!Ext.isEmpty(data.apartadoTasa)){
			ventana.down('[reference=apartadoTasa]').setValue(data.apartadoTasa);
		}
		if(!Ext.isEmpty(data.capituloTasa)){
			ventana.down('[reference=capituloTasa]').setValue(data.capituloTasa);
		}	
		if(!Ext.isEmpty(!data.subcuentaIntereses)){
			ventana.down('[reference=subcuentaIntereses]').setValue(data.subcuentaIntereses);
		}
		if(!Ext.isEmpty(data.apartadoIntereses)){
			ventana.down('[reference=apartadoIntereses]').setValue(data.apartadoIntereses);
		}
		if(!Ext.isEmpty(data.capituloIntereses)){
			ventana.down('[reference=capituloIntereses]').setValue(data.capituloIntereses);
		}
		
    },
    
    cargarTabDataCambiarRefacturables: function (form,grid) {
		var me = this,
		id = me.getViewModel().get("gasto.id"),
		model = form.getModelInstance();
		form.up("tabpanel").mask(HreRem.i18n("msg.mask.loading"));	
		
		model.setId(id);
		model.load({
		    success: function(record) {
		    	
		    	form.setBindRecord(record);	
		    	var modificar = false;
		    	if(record.data.estadoModificarLineasDetalleGasto && !record.data.isGastoRefacturadoPorOtroGasto 
	    				&& !record.data.isGastoRefacturadoPadre){
	    			modificar = true;
	    		}
		    	
		    	grid.setTopBar(modificar);
		    	form.up("tabpanel").unmask();
		    },
		    failure: function(operation) {		    	
		    	form.up("tabpanel").unmask();
		    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    }
		});
	},
	
	onChangeComboSuplidos: function(combo, values){
		var me = this;
		
		var comboFacturaPrincipal = me.lookupReference('facturaPrincipalSuplido');
		if(CONST.COMBO_SIN_NO['SI'] == values.getData().codigo){
			comboFacturaPrincipal.setValue(null)
		}
		
	},
	
    onChangeLineaDetalleStore: function(){
    	var me = this;
    	var idLinea = me.lookupReference('comboLineasDetalleReference').getValue();
    	var gridElementos = me.lookupReference('listadoActivosAfectadosRef');
    	
        if(!Ext.isEmpty(gridElementos)){
        	gridElementos.getStore().getProxy().setExtraParams({'idLinea':idLinea});
        	gridElementos.getStore().load();
        }
    	
    	var btnReparto = me.lookupReference('btnReparto');
    	if(idLinea != "-1"){
    		btnReparto.setDisabled(false);    
    	}
    	else{
    		btnReparto.setDisabled(true);
    	}
    	
    },
    
	asignarParticipacionActivos: function(btn) {
		var me = this;
		var idLinea = me.lookupReference('comboLineasDetalleReference').getValue();
		Ext.Msg.show({
			   title: HreRem.i18n('title.mensaje.confirmacion'),
			   msg: HreRem.i18n('msg.modificar.reparto.activos'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	
			        	me.getView().mask(HreRem.i18n("msg.mask.loading"));
			        	var url =  $AC.getRemoteUrl('gastosproveedor/actualizarReparto');
			    		
			    		Ext.Ajax.request({		    			
			    	 		url: url,
			    	 		method: 'POST',
			    	 		params: {
				     			idLinea: idLinea	
				     		},	    		
			    	    	success: function(response, opts) {
			    	    		me.getView().unmask();
						    	data = Ext.decode(response.responseText);
						    	if(data.data == 'true') {
			    	    			var grid = me.lookupReference('listadoActivosAfectadosRef');
				    	    		grid.getStore().load();

				    	    		var gridActivosLbk = grid.up('gastodetalle').down('contabilidadgasto').down('[reference=vImporteGastoLbkGrid]');
					 		        if(gridActivosLbk && gridActivosLbk.getStore()){
					 		        	var idGasto  =  grid.lookupController().getView().getViewModel().get("gasto.id");
					 		        	gridActivosLbk.getStore().getProxy().setExtraParams({'idGasto':idGasto});
					 		        	gridActivosLbk.getStore().load();
					 		        }
			    	    		}
			    	    		else{
			    	    			me.fireEvent("errorToast", HreRem.i18n("msg.error.adquisicion.noactivo"));
			    	    		}	
			    	    	},
			       			failure: function(response) {
			    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    		    }
			    		});
			        	
			        }
			   }
		});
		
	},
	
	asignarParticipacionActivosTrabajo: function(btn) {
		var me = this;
		var idLinea = me.lookupReference('comboLineasDetalleReference').getValue();

    	me.getView().mask(HreRem.i18n("msg.mask.loading"));
    	var url =  $AC.getRemoteUrl('gastosproveedor/actualizarRepartoTrabajo');
		
		Ext.Ajax.request({		    			
	 		url: url,
	 		method: 'POST',
	 		params: {
     			idLinea: idLinea	
     		},	    		
	    	success: function(response, opts) {
	    		me.getView().unmask();
		    	data = Ext.decode(response.responseText);
		    	if(data.data == 'true') {
	    			var grid = me.lookupReference('listadoActivosAfectadosRef');
    	    		grid.getStore().load();
	    		}
	    		else{
	    			me.fireEvent("errorToast", HreRem.i18n("msg.error.adquisicion.noactivo"));
	    		}	
	    	},
   			failure: function(response) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    }
	    		});
		
	},
    
    onEnlaceActivosElementosAfectados: function(tableView, indiceFila, indiceColumna) {
   		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    if(CONST.TIPO_ELEMENTOS_GASTO['CODIGO_ACTIVO'] == record.get("tipoElementoCodigo")){
		    me.redirectTo('activos', true);
		    record.data.numActivo = record.get("idElemento");
		    me.getView().fireEvent('abrirDetalleActivo', record);
	    }	
    },
    onChangeChainedSeleccionarLineaDetalle: function(){
    	var me = this;
    	var elementoAnyadir = me.lookupReference('elementoAnyadir');
    	var comboElementoAAnyadir = me.lookupReference('comboElementoAAnyadir');
    	var comboLineasRefAnyadirVal = me.lookupReference('comboLineasDetalleReferenceAnyadir').getValue();
    	var idGasto = me.getView().idGasto;
    
    	if(!Ext.isEmpty(comboLineasRefAnyadirVal) && comboLineasRefAnyadirVal != "-1"){
	    	comboElementoAAnyadir.setDisabled(false);
	    	elementoAnyadir.setDisabled(false);
	    	comboElementoAAnyadir.getStore().getProxy().setExtraParams({'idGasto':idGasto, 'idLinea': comboLineasRefAnyadirVal});
	    	comboElementoAAnyadir.getStore().load();
    	}
    	
    	
    },
    onChangeSeleccionarLineaDetalle: function(){
    	var me = this;
    	var elementoAnyadir = me.lookupReference('elementoAnyadir').getValue();
    	var comboElementoAAnyadir = me.lookupReference('comboElementoAAnyadir').getValue();
    	var comboLineasRefAnyadir = me.lookupReference('comboLineasDetalleReferenceAnyadir').getValue();
    	var botonGuardar = me.lookupReference('btnGuardarGastoActivo');

    	if(!Ext.isEmpty(comboLineasRefAnyadir) && !Ext.isEmpty(comboElementoAAnyadir) 
    		&& CONST.TIPO_ELEMENTOS_GASTO['CODIGO_SIN_ACTIVOS']  == comboElementoAAnyadir){
    			me.lookupReference('elementoAnyadir').reset();
    			me.lookupReference('elementoAnyadir').setDisabled(true);
    			botonGuardar.setDisabled(false);
    	}else{
    		me.lookupReference('elementoAnyadir').setDisabled(false);
	    	if(Ext.isEmpty(elementoAnyadir) || Ext.isEmpty(comboElementoAAnyadir) || Ext.isEmpty(comboLineasRefAnyadir)){
	    		 botonGuardar.setDisabled(true);
	    	}else{
	    		botonGuardar.setDisabled(false);
	    	}
    	}
    	
    },
    
    asociarGastoConElementos: function(dataAnyadir, form, window){
    	
    	var me = this;
    	var url =  $AC.getRemoteUrl('gastosproveedor/asociarElementosAgastos');
    	Ext.Ajax.request({		    			
             url: url,
             method: 'POST',
             params: {
                 idLinea: dataAnyadir.idLinea, 
                 idElemento: dataAnyadir.idElemento,
                 tipoElemento: dataAnyadir.tipoElemento
             },	    	
			success: function(response, opts){
				data = Ext.decode(response.responseText);

				if(!Ext.isEmpty(data.data)){
					me.fireEvent("errorToast", data.data);
					return;
				}
				window.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar();
				window.up('gastodetalle').down('datosgeneralesgasto').funcionRecargar();
				window.up('gastodetalle').down('contabilidadgasto').funcionRecargar();
				window.up('gastodetalle').down('contabilidadgasto').funcionRecargar();
				
				var idGasto = window.down('anyadirnuevogastoactivodetalle').up().idGasto;
				var gridLineas = window.up('gastodetalle').down('detalleeconomicogasto').down('[reference=lineaDetalleGastoGrid]');
				if(!Ext.isEmpty(gridLineas)){
					gridLineas.getStore().getProxy().setExtraParams({'idGasto':idGasto});
			        gridLineas.getStore().load();
				}
		        
		        var gridActivosLbk = window.up('gastodetalle').down('contabilidadgasto').down('[reference=vImporteGastoLbkGrid]');
		        if(!Ext.isEmpty(gridActivosLbk) && !Ext.isEmpty(gridActivosLbk.getStore())){
		        	gridActivosLbk.getStore().getProxy().setExtraParams({'idGasto':idGasto});
		        	gridActivosLbk.getStore().load();
		        }
			},
			failure: function(a, operation){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			},
			callback: function(records, operation, success) {
				window.unmask();
				window.parent.funcionRecargar();
				window.close();
			}
			
		});
    },

    onChangeCheckboxCodigoSubtipo: function(chkBox, newValue) {
    	
    	var me = this;
    	var searchButton = me.lookupReference("searchButton");

    	if (newValue) {
    		searchButton.setDisabled(false)        		
    	} else {
    		searchButton.setDisabled(true);

    	}
    },
	
	onChangeNumTrabajo: function(field, value){
    	var me = this;
    	var numTrabajo = me.lookupReference('numTrabajo').getValue();
    	var searchButton = me.lookupReference("searchButton");
    	if(numTrabajo!= ''){
    		searchButton.setDisabled(false);    
    	}
    	else{
    		searchButton.setDisabled(true);
    	}
	},

    activateBotonBuscarTasacion: function(field, value){
        var me = this;
        var idTasacion = me.lookupReference('idTasacion').getValue();
        var numActivo = me.lookupReference('numActivo').getValue();
        var idTasacionExt = me.lookupReference('idTasacionExt').getValue();
        var codigoFirmaTasacion = me.lookupReference('codigoFirmaTasacion').getValue();
        var fechaRecepcionTasacion = me.lookupReference('fechaRecepcionTasacion').getValue();
        var searchButton = me.lookupReference("searchButton");
        if(idTasacion != '' || numActivo != '' || idTasacionExt != ''
            || codigoFirmaTasacion != '' || (fechaRecepcionTasacion != null && fechaRecepcionTasacion != '')){
            searchButton.setDisabled(false);
        }
        else{
            searchButton.setDisabled(true);
        }
    },
	
    recargarVisibilidadGrids: function(form, record){
    	if(!Ext.isEmpty(record.data.lineasNoDeTrabajos) && !Ext.isEmpty(form)){
    		var gridT = form.up('gastodetalle').down('datosgeneralesgasto').down('[reference=listadoTrabajosIncluidosFactura]');   	
    		if(!Ext.isEmpty(gridT)){
    			gridT.down('[itemId=addButton]').setHidden(record.data.lineasNoDeTrabajos);
    			gridT.down('[itemId=removeButton]').setHidden(record.data.lineasNoDeTrabajos);
    		}
    	}
    },
	
	calcularImportePagadoTotalGasto: function(){
		var me = this;
    	var tipoImpositivo = me.lookupReference('tipoImpositivoIRPFImpD').getValue();
    	var base = me.lookupReference('baseIRPFImpD').getValue();
    	var cuotaRetG = me.lookupReference('cuotaIRPFRetG').getValue();
    	var cuota = 0;
 
    	if(tipoImpositivo != null && base != null){
    		cuota = (tipoImpositivo * base)/100;
    	}
    	
    	me.lookupReference('cuotaIRPFImpD').setValue(cuota);
    	
    	var importeTotal = me.getImporteTotalLineasDetalle(me);
    	
		importeTotal = importeTotal - parseFloat(cuota);
		 
		if(cuotaRetG != null && cuotaRetG != undefined){
			importeTotal = importeTotal - parseFloat(cuotaRetG);
		}
		
		return importeTotal;
	},
    
    onClickGuardarCuentasYPartidas: function(btn){
    	var me = this;
    	
    	var window = btn.up('[reference=ventanaCrearLineaDetalleGasto]');
		var form = window.down('[reference=crearLineaDetalleGastoForm]');
		
		var url =  $AC.getRemoteUrl('gastosproveedor/saveCuentasPartidasGastoLineaDetalle');
		form.form.url = url;
		form.submit({                
			waitMsg: HreRem.i18n('msg.mask.loading'),
            params: {
            	idGasto: window.idGasto,
            	id: window.idLineaDetalleGasto
            },

            success: function(fp, o) {
            	if(o.result.success == "false") {
            		window.fireEvent("errorToast", o.result.errorMessage);
            	}
            	else {
            		window.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
            	}
            	
            	if(!Ext.isEmpty(window.parent)) {
            		window.parent.fireEvent("aftercreate", window.parent);
            	}
            	var grid = window.lookupController().getView().down('[reference=lineaDetalleGastoGrid]');
            	grid.getStore().load();
            	window.close();
            	
            },
            failure: function(fp, o) {
            	window.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
            }
        });
    },
    
    getImporteRetencionLineasDetalle: function(me, despues){
    	var importeTotal = 0;
    	
		var esLiberbank = me.getViewModel().get('esLiberbank');
    	if(me.lookupReference('lineaDetalleGastoGrid').getStore() != null && me.lookupReference('lineaDetalleGastoGrid').getStore() != undefined){
    		for(var i = 0; i < me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items.length; i++){
    			var baseSujeta = me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('baseSujeta');
    			var baseNoSujeta = me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('baseNoSujeta');
    			var cuota = me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('cuota');
    			
    			if(!Ext.isEmpty(baseSujeta)){				
    				importeTotal+= parseFloat(baseSujeta);
    			}
    			if(!Ext.isEmpty(baseNoSujeta)){
    				importeTotal+= parseFloat(baseNoSujeta);
    			}
    			if(despues && !Ext.isEmpty(cuota) && esLiberbank){  
    				importeTotal+= parseFloat(cuota);
    			}
    		}
    	}
    	
    	return importeTotal;
    },
    
    getImporteTotalCuotaIndirecta: function(me){
		var cuotaTotal = 0;
		
    	if(me.lookupReference('lineaDetalleGastoGrid').getStore() != null && me.lookupReference('lineaDetalleGastoGrid').getStore() != undefined){
    		for(var i = 0; i < me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items.length; i++){	
    			if (me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('baseSujeta') != undefined && me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('tipoImpositivo') != undefined){
    				cuotaTotal+= parseFloat(me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('baseSujeta')*me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('tipoImpositivo')/100);	
    			}
    		}
    	}
    	
    	return cuotaTotal;
    },

    onTasacionesDobleClick : function(grid, record) {
        var me = this;
        me.getView().fireEvent('abrirDetalleActivoPreciosTasacion', record);

    }
});
