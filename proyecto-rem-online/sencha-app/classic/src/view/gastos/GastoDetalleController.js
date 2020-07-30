Ext.define('HreRem.view.gastos.GastoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.gastodetalle',
    
    requires: ['HreRem.view.gastos.SeleccionTrabajosGasto','HreRem.view.common.adjuntos.AdjuntarDocumentoGasto','HreRem.view.administracion.gastos.GastoRefacturadoGrid'],
    
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
										var comboEmisor = me.getView().lookupReference("comboProveedores");
										var nifEmisor = me.getViewModel().data.gasto.data.nifEmisor;
										comboEmisor.getStore().getProxy().extraParams.nifProveedor = nifEmisor;	
										comboEmisor.getStore().load();
										me.refrescarGasto(form.refreshAfterSave);
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

		tabPanel = me.getView().down("tabpanel");
		var activeTab = tabPanel.getActiveTab();
		if (activeTab.xtype == "activosafectadosgasto"
		&& CONST.CARTERA["LIBERBANK"] === me.getViewModel().get("gasto.cartera")) {
			me.updateGastoByPrinexLBK();
		}
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
		fieldImportePagado = me.lookupReference('detalleEconomicoImportePagado'),
		importePagado = Ext.isEmpty(value) ? 0 : me.getViewModel().get("calcularImporteTotalGasto");
		fieldImportePagado.setValue(importePagado);
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
    	var url =  $AC.getRemoteUrl('gastosproveedor/fechaDevengoPosteriorFechaTraspaso');
    	window.mask(HreRem.i18n("msg.mask.loading"));
	
    	if(!Ext.isEmpty(detalle.getBindRecord())){
    		
    		var  viewModelDetalle = btn.up("[xtype=gastodetalle]").lookupViewModel();
    		if(!Ext.isEmpty(viewModelDetalle)){
    			//var gasto_fechaDevengo = viewModelDetalle.data.gasto.get('fechaEmision');
    			var gasto_codigoImpuestoIndirecto = viewModelDetalle.data.gasto.get('codigoImpuestoIndirecto');
    		}
    		
	    	var numeroActivo= detalle.getBindRecord().numActivo;
	    	var numeroAgrupacion= detalle.getBindRecord().numAgrupacion;
	    	
	    	if(!Ext.isEmpty(numeroActivo) && !Ext.isEmpty(numeroAgrupacion)){
	    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.activo.gasto.busqueda.no.posible"));
	    		form.reset();
				window.unmask();
				window.parent.funcionRecargar();
				window.close();
	    	}
	    	else if(!Ext.isEmpty(numeroActivo)){
	    		if(Ext.isDefined(detalle.getModelInstance().getProxy().getApi().create)){
	    			
	    			Ext.Ajax.request({		    			
	    		 		url: url,
	    		   		params: {
	    		   			idGasto: idGasto, 
	    		   			idActivo: numeroActivo,
	    		   			idAgrupacion: -1
    		   			},	    		
	    		    	success: function(response, opts) {
	    		    		
	    		    		var data = {};
	    		            try {
	    		            	data = Ext.decode(response.responseText);
	    		            }
	    		            catch (e){ };
	    		    		
	    		    		if (CONST.TIPO_IMPUESTO['IVA'] == gasto_codigoImpuestoIndirecto) {
	    		    			
	    		    			if(!Ext.isEmpty(data) && data.fechaDevengoSuperior == "true") {
	    		    				
	    		    				Ext.Msg.show({
		    		         			   title: HreRem.i18n('title.permitir.asociacion.gastoactivo'),
		    		         			   msg: HreRem.i18n('msg.asociar.gastoactivo'),
		    		         			   buttons: Ext.MessageBox.YESNO,
		    		         			   fn: function(buttonId) {
		    		         			        if (buttonId == 'yes') {
		    		         			        	me.asociarGastoConActivos(idGasto, numeroActivo, null, detalle, form, window);
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
	    		    			else {
	    		    				me.asociarGastoConActivos(idGasto, numeroActivo, null, detalle, form, window);
	    		    				
	    		    			}
	    	    				
	    	    			}
	    	    			else {
	    	    				
	    	    				if(!Ext.isEmpty(data) && !(data.fechaDevengoSuperior == "true")) {
	    	    					
	    	    					me.asociarGastoConActivos(idGasto, numeroActivo, null, detalle, form, window);
	    	    					
	    	    				}
	    	    				else {
	    	    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    	    					form.reset();
    		    					window.unmask();
    		    					window.parent.funcionRecargar();
    		    					window.close();
	    	    				}
	    	    				
	    	    				
	    	    			}
	    		    		
	    		    	},
    		   			failure: function(response) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    		    }
	    			});
	    		}
	    	}
	    	else if(!Ext.isEmpty(numeroAgrupacion)){
	    		if(Ext.isDefined(detalle.getModelInstance().getProxy().getApi().create)){
	    			
	    			Ext.Ajax.request({
	    				
	    		 		url: url,
	    		   		params: {
	    		   			idGasto: idGasto, 
	    		   			idActivo: -1,
	    		   			idAgrupacion: numeroAgrupacion
    		   			},	    		
	    		    	success: function(response, opts) {
	    		    		
	    		    		var data = {};
	    		            try {
	    		            	data = Ext.decode(response.responseText);
	    		            }
	    		            catch (e){ };
	    		    			
    		    			if(!Ext.isEmpty(data) && data.fechaDevengoSuperior == "true") {
    		    				
    		    				Ext.Msg.show({
	    		         			   title: HreRem.i18n('title.permitir.asociacion.gastoactivo'),
	    		         			   msg: HreRem.i18n('msg.asociar.gastoagrupacion'),
	    		         			   buttons: Ext.MessageBox.YESNO,
	    		         			   fn: function(buttonId) {
	    		         				   
	    		         			        if (buttonId == 'yes') {
	    		         			        	
	    		         			        	me.asociarGastoConActivos(idGasto, null, numeroAgrupacion, detalle, form, window);
	    		         			        	
	    		         			        }
	    		         			        else {
	    		         			        	form.reset();
		         		    					window.parent.funcionRecargar();
		         		    					window.close(); 
	    		         			        }
	    		         			        
	    		         			        
	    		         			   }
	    		     			});
    		    				
	    		            }
    		    			else {
    		    				
    		    				me.asociarGastoConActivos(idGasto, null, numeroAgrupacion, detalle, form, window);
    		    				
    		    			}
	    		    	},
    		   			failure: function(response) {
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    		    }
	    			});
	    		}
	    	}
    	}
    	else{
    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.activo.gasto.busqueda.campos.vacios"));
    		form.reset();
			window.unmask();
			window.parent.funcionRecargar();
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
	    	}
		});
	},
	
	onGuardarGasto: function(window, form) {
		var me = this;
		
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
		var url =  $AC.getRemoteUrl('gastosproveedor/generateExcelActivosGasto');
		
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
				 me.refrescarGastoAlIncluirTrabajo(ventanaSeleccionTrabajos.up('gastodetallemain'));
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
	
	cancelarSeleccionTrabajosGasto: function(btn) {
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
    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.autorizar.gasto'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		        if (buttonId == 'yes') {
					var url =  $AC.getRemoteUrl('gastosproveedor/autorizarGasto'),		
					idGasto = me.getViewModel().get("gasto.id");		
	
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
		
		Ext.Ajax
		.request({
			url : url,
			params : {
				gastos : gastos,
				nifPropietario : nifPropietario
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
	    	var nifPropietario = me.getView().nifPropietario;
	    	var url = $AC.getRemoteUrl('gastosproveedor/anyadirGastoRefacturable');
	    	
	    	
	    	
	    	if(gastosRefacturables == ""){
	    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anyadir.gastos.refacturados")); 
	    	}else{
	    	
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
			    	},
			    	callback: function(options, success, response){
			    		me.getView().grid.getStore().reload();
			    		var datosGeneralesGastos = me.getView().grid.up("gastodetalle").down("[reference=datosgeneralesgastoref]");
			    		var datosDetalleEconomico = me.getView().grid.up("gastodetalle").down("[reference=detalleeconomicogastoref]");
			    		me.getViewModel().set("gasto.id",me.getView().idGasto);
			    		me.cargarTabData(datosGeneralesGastos);
			    		me.cargarTabData(datosDetalleEconomico);
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

		if(cartera == CONST.CARTERA['LIBERBANK']){
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
			
			me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.error.anyadir.gasto.linea.detalle.bk"));
			return;
		}
		
		var tipoImpositivo = form.getForm().findField('tipoImpositivo').getValue();
		
		if(tipoImpositivo > 100){
			me.fireEvent("errorToast",  HreRem.i18n("msg.operacion.ko.gasto.tipoImpositivo.mayor.cien"));
    		return;
		}
		if(!me.comprobarImportesRellenosLineaDetalleGasto(window)){
			me.fireEvent("errorToast", HreRem.i18n("msg.fieldlabel.gasto.linea.detalle.no.importe"));
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
                	grid.up('gastodetalle').down('detalleeconomicogasto').funcionRecargar()

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
    	
    	formulario.findField('cuota').setValue(cuota);
   
    	var importeTotal = me.calcularImporteTotal(formulario);
    	formulario.findField('importeTotal').setValue(importeTotal);
    	
    },
    
    calcularImporteTotal: function (formulario){
    	var me=this;
    	var importeTotal = 0;

    	var baseSujeta = formulario.findField('baseSujeta').getValue();
    	var baseNoSujeta = formulario.findField('baseNoSujeta').getValue();
		var recargo = formulario.findField('recargo').getValue();
		var interes = formulario.findField('interes').getValue();
		var costas = formulario.findField('costas').getValue();
		var otros = formulario.findField('otros').getValue();
		var provSupl = formulario.findField('provSupl').getValue();
		var cuota = formulario.findField('cuota').getValue();
		var operacionExentaImp = formulario.findField('operacionExentaImp').getValue();
		var operacionExentaRenuncia = formulario.findField('esRenunciaExenta').getValue();
		
		if(baseSujeta != null){
			importeTotal = importeTotal + baseSujeta;
		}
		if(baseNoSujeta != null){
			importeTotal = importeTotal + baseNoSujeta;
		}
		if(recargo != null){
			importeTotal = importeTotal + recargo;
		}
		if(interes != null){
			importeTotal = importeTotal + interes;
		}
		if(costas != null){
			importeTotal = importeTotal + costas;
		}
		if(otros != null){
			importeTotal = importeTotal + otros;
		}
		if(provSupl != null){
			importeTotal = importeTotal + provSupl;
		}

		if(cuota != null && (!operacionExentaImp || (operacionExentaImp && operacionExentaRenuncia))){
			importeTotal = importeTotal + cuota;
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
    
    onChangeCuotaRetencionGarantia: function(field, value){
    	var me = this;
    	var tipoImpositivo = me.lookupReference('tipoImpositivoIRPFRetG').getValue();
    	var base = me.lookupReference('baseIRPFRetG').getValue();
    	var cuotaImpDirecto = me.lookupReference('cuotaIRPFImpD').getValue();
    	var cuota = 0;
    	
    	if(tipoImpositivo != null && base != null){
    		cuota = (tipoImpositivo * base)/100;
    	}
    	
    	me.lookupReference('cuotaIRPFRetG').setValue(cuota);
    	
    	var importeTotal = me.getImporteTotalLineasDetalle(me);
    	
    	importeTotal = importeTotal - cuota;
    	 
    	if(cuotaImpDirecto != null && cuotaImpDirecto != undefined){
    		importeTotal = importeTotal - cuotaImpDirecto;
    	}

    	me.lookupReference('importeTotalGastoDetalle').setValue(importeTotal);

    },
    
    onChangeCuotaImpuestoDirecto: function(field, value){
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
    	
		importeTotal = importeTotal - cuota;
		 
		if(cuotaRetG != null && cuotaRetG != undefined){
			importeTotal = importeTotal - cuotaRetG;
		}
		
		me.lookupReference('importeTotalGastoDetalle').setValue(importeTotal);	 
    },
    
    recalcularImporteTotal: function(me){
    	var cuotaRetG = me.lookupReference('cuotaIRPFRetG').getValue();
    	var cuotaImpDirecto = me.lookupReference('cuotaIRPFImpD').getValue();
    	var importeTotal = me.getImporteTotalLineasDetalle(me);
    	
    	if(cuotaRetG != null || cuotaRetG != undefined){
    		importeTotal = importeTotal - cuotaRetG;
    	}
    	
    	if(cuotaImpDirecto != null || cuotaImpDirecto != undefined){
    		importeTotal = importeTotal - cuotaImpDirecto;
    	}
    	
    	return importeTotal;
    	
    },
    
    getImporteTotalLineasDetalle: function(me){
    	var importeTotal = 0;
    	if(me.lookupReference('lineaDetalleGastoGrid').getStore() != null && me.lookupReference('lineaDetalleGastoGrid').getStore() != undefined){
    		for(var i = 0; i < me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items.length; i++){
    			importeTotal+= me.lookupReference('lineaDetalleGastoGrid').getStore().getData().items[i].get('importeTotal');
    		}
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
	            		if(data.data.ccBase != undefined){
	            			ventana.down('[reference=ccBase]').setValue(data.data.ccBase);
	            		}
	            		if(data.data.ppBase != undefined){
	            			ventana.down('[reference=ppBase]').setValue(data.data.ppBase);
	            		}
	            		if(data.data.ccTasas != undefined){
	            			ventana.down('[reference=ccTasas]').setValue(data.data.ccTasas);
	            		}
	            		if(data.data.ppTasas != undefined){
	            			ventana.down('[reference=ppTasas]').setValue(data.data.ppTasas);
	            		}
	            		if(data.data.ccRecargo != undefined){
	            			ventana.down('[reference=ccRecargo]').setValue(data.data.ccRecargo);
	            		}
	            		if(data.data.ppRecargo != undefined){
	            			ventana.down('[reference=ppRecargo]').setValue(data.data.ppRecargo);
	            		}
	            		if(data.data.ccInteres != undefined){
	            			ventana.down('[reference=ccInteres]').setValue(data.data.ccInteres);
	            		}
	            		if(data.data.ppInteres != undefined){
	            			ventana.down('[reference=ppInteres]').setValue(data.data.ppInteres);
	            		}
	            	}
	            	
	            	ventana.down('[reference=fieldsetccpp]').setDisabled(false);
	        		ventana.down('[reference=fieldsetImpInd]').setDisabled(false);
	        		ventana.down('[reference=fieldsetImporte]').setDisabled(false);
	        		ventana.unmask();
    	            	
    	    	},
       			failure: function(response) {
    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    		    }
    		});

    	}
    
    }
});
