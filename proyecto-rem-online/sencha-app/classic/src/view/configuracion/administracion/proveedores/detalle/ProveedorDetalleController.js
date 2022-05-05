Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.ProveedorDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.proveedordetalle',
    
    control: {
    	
        'documentosproveedor gridBase': {
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
    
    abrirFormularioAdjuntarDocumentos: function(grid) {
		var me = this,
		idProveedor = me.getViewModel().get("proveedor.id");
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoProveedor", {entidad: 'proveedores', idEntidad: idProveedor, parent: grid, bloque: '01'}).show();
		
	},
    
	cargarTabData: function (form) {
		var me = this,
		model = form.getModelInstance(),
		id = me.getViewModel().get("proveedor.id");
		
		form.up("tabpanel").mask(HreRem.i18n('msg.mask.loading'));	
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
	
	onChangeChainedCombo: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
		chainedCombo.clearValue("");
		chainedCombo.getStore().load({ 			
			callback: function(records, operation, success) {
   				if(records.length > 0) {
   					chainedCombo.setDisabled(false);
   				} else {
   					chainedCombo.setDisabled(true);
   				}
			}
		});
    },
	
   	onSaveFormularioCompleto: function(form, success) {
		var me = this,
		record = form.getBindRecord();
		success = success || function() {me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));};  
		
		if(form.isFormValid()) {

			form.mask(HreRem.i18n("msg.mask.espere"));
			
			record.save({
				
			    success: success,
			 	failure: function(record, operation) {
			 		data = Ext.decode(operation._response.responseText);
			 		if (!Ext.isEmpty(data.msg)) {
			 			me.fireEvent("errorToast", data.msg);
			 		}
			 		else{
			 			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			 		}
			    },
			    callback: function(record, operation) {
			    	form.unmask();
			    }
			    		    
			});
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	},
	
	onClickBotonEditar: function(btn) {
		var me =this;
		
		me.getViewModel().set("editing", true);

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('component[isReadOnlyEdit]'),
			function (field, index) 
				{ 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
		);
		
	},
    
	onClickBotonGuardar: function(btn) {
		
		var me = this;
		
		var success = function() {
			me.getViewModel().set("editing", false);
			
			Ext.Array.each(btn.up('tabpanel').getActiveTab().query('component[isReadOnlyEdit]'),
							function (field, index) 
								{ 
									field.fireEvent('save');
									field.fireEvent('update');});
									
			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	//me.getView().fireEvent("refreshComponentOnActivate", "fichaproveedor");
			me.onClickBotonRefrescar();
			
		}
		
		
		
		me.onSaveFormularioCompleto(btn.up('tabpanel').getActiveTab(), success);				
	},
	
	onClickBotonCancelar: function(btn) {

		var me = this,
		activeTab = btn.up('tabpanel').getActiveTab();
		
		if(activeTab && activeTab.getBindRecord && activeTab.getBindRecord()) {
			activeTab.getBindRecord().reject();
		}		
		me.getViewModel().set("editing", false);
		
		Ext.Array.each(activeTab.query('component[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('cancel');
							});
	},
    
    /**
     * Función que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la función 
     * funciónRecargar con el código necesario para refrescar los datos.
     */
    onClickBotonRefrescar: function () {
		var me = this,
		activeTab = me.getView().down('proveedoresdetalletabpanel').getActiveTab();
  		
		// Marcamos todos los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar
		if(activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
	},
	
	/**
	 * Función que abre el activo seleccionado del grid cuando es pulsado su icono.
	 */
	onActivosVinculadosClick: function(tableView, indiceFila, indiceColumna) {
    	var me = this;
    	var grid = tableView.up('grid');
    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);

    	me.getView().up().fireEvent('abrirDetalleActivoById', record.get('idActivo'), "Activo " + record.get("numActivo"));
	},
	
	/**
	 * Función que habilita o deshabilita y filtra el combo de Municipio dentro del grid DireccionesDelegacionesList.
	 */
	onChangeProvinciaChainedCombo: function(boundList, record , item , index , e , eOpts) {
		
		if(boundList.xtype === 'combobox' && record.getKey() != 13) {
			return;
		}
    	var me = this;
    	var combo;
    	if(boundList.xtype === 'combobox') {
    		combo = boundList;
    	} else {
    		combo = boundList.up();
    	}
    	var chainedCombo = me.lookupReference(combo.chainedReference);   
    	
    	me.getViewModel().notify();
    	
    	if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
    	}
    	
    	var chainedStore = chainedCombo.getStore();
    	
    	var highlightedIdxValue;
    	if(boundList.xtype === 'boundlist') {
    		highlightedIdxValue = boundList.highlightedItem.attributes.getNamedItem('data-recordindex').nodeValue;
    	}
    	
    	if(!Ext.isEmpty(chainedStore) && (!Ext.isEmpty(highlightedIdxValue) || !Ext.isEmpty(combo.getSelectedRecord()))) {
    		
    		var codigoValue;
    		if(boundList.xtype === 'combobox') {
    			codigoValue = combo.getSelectedRecord().getData().codigo;
    		} else {
    			codigoValue = boundList.getStore().getAt(highlightedIdxValue).getData().codigo;
    		}
    		
    		combo.setValue(codigoValue);
    		chainedStore.clearFilter();
    		chainedStore.filter([{
                filterFn: function(rec){
                    if (rec.getData().codigoProvincia == codigoValue){
                        return true;
                    }
                    return false;
                }
            }]);
    		chainedCombo.setDisabled(false);
    		chainedCombo.validate();
    	}
    	
		if (me.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
    },
    
    /**
     * Función para mostrar un check en color verde o gris según si un usuario es el principal o no.
     */
    onMarcarPrincipalClick: function(grid, rowIndex, colIndex, item, e, rec) {
    	var me = this;
    	me.gridOrigen = grid;
    	var titulo="",message="";
    	if (rec.data.personaPrincipal != 1) {
    		titulo = HreRem.i18n('title.confirmar.persona.marcar.principal');
    		message = HreRem.i18n('msg.confirmar.persona.marcar.principal');
    	}else{
    		titulo = HreRem.i18n('title.confirmar.persona.desmarcar.principal');
    		message = HreRem.i18n('msg.confirmar.persona.desmarcar.principal');
    	}

		Ext.Msg.show({
			title: titulo,
			msg: message,  	
			buttons: Ext.MessageBox.YESNO,
			fn: function(buttonId) {
				if (buttonId == 'yes') {	
					me.getView().mask();
					var url =  $AC.getRemoteUrl('proveedores/setPersonaContactoPrincipal');
					Ext.Ajax.request({
					     url: url,
					     params: {
					     			id: rec.data.id,
					     			proveedorID: rec.data.proveedorID
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

    },
    
    /**
     * Este método es llamado cuando se deselecciona un elemento del grid DireccionesDelegaciones.
     */
    onDireccionesDelegacionesGridDeselect: function(rowModel) {
    	var me = this;
    	if(rowModel.deselectingDuringSelect || rowModel.getLastSelected().dirty) {
    		return;
    	}
    	var gridPersonasContactos = me.lookupReference('personascontactolistref');
    	var gridDireccionesDelegaciones = me.lookupReference('direccionesdelegacioneslistref');
    	var personasContactosStore = gridPersonasContactos.getStore();
    	if(!Ext.isEmpty(personasContactosStore)) {
    		personasContactosStore.getProxy().extraParams = {
				// Se coje el ID de proveedor del view model.
				id: me.getViewModel().getData().proveedor.getData().id
			};
    		
    		personasContactosStore.load();
    	}
    },
    
    /**
     * Este método es llamado cuando se selecciona un elemento del grid DireccionesDelegaciones.
     */
    onDireccionesDelegacionesGridClick: function(grid, record) {
    	var me = this;
    	var gridPersonasContactos = grid.up('proveedoresdetallemain').lookupReference('personascontactolistref');
    	var personasContactosStore = gridPersonasContactos.getStore();
    	if(!Ext.isEmpty(personasContactosStore)) {
    		var selection = grid.getSelection()[0];
    		if(!Ext.isEmpty(selection)){
	    		personasContactosStore.getProxy().extraParams = {
	    			// Se filtra por la delegacion seleccionada y el proveedor del ViewModel.
	    			delegacion: selection.getData().id,
	    			id: me.getViewModel().getData().proveedor.getData().id
				};
	    		
	    		personasContactosStore.load();
	    		
	    		model = Ext.create('HreRem.model.DatosContactoModel');
	    		model.setId(selection.getData().id);
	    		model.load({
	    					success : function(record) {
	    						me.getViewModel().set("datosContacto", record);
	    					}
	    				});
    		}
    	}
    	
    },
    
    /**
     * Función que borra un documento del grid de documentos.
     */
    borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idProveedor = me.getViewModel().get("proveedor.id");

		record.erase({
			params: {idEntidad: idProveedor},
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
	
	/**
	 * Función que descarga un documento del grid de documentos.
	 */
	downloadDocumentoAdjunto: function(grid, record) {
		var me = this,
		config = {};

		config.url=$AC.getWebPath()+"proveedores/bajarAdjuntoProveedor."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.nombreDocumento=record.get("nombre").replace(/,/g, "");
		me.fireEvent("downloadFile", config);
	},

    onTipoProveedorChange: function(combo) {
    	if(combo.getValue() !== CONST.TIPOS_PROVEEDOR['ENTIDAD']) {
    		combo.up('proveedoresdetallemain').lookupReference('dateConstitucionProveedor').reset();
    		combo.up('proveedoresdetallemain').lookupReference('cbLocalizada').reset();
    	}
    },

	onChangeTipoConducta: function(combo) {
    	var me = this,
    	comboCategoria = me.lookupReference(combo.chainedReference),
    	comboNivel = me.lookupReference(comboCategoria.chainedReference);      	
    	me.getViewModel().notify();
    	if(!Ext.isEmpty(comboCategoria.getValue())) {
			comboCategoria.clearValue();
			comboNivel.clearValue();
    	}
		
    	var chainedStore = comboCategoria.getStore();
    	
    	if(!Ext.isEmpty(chainedStore)) {
    		chainedStore.getProxy().extraParams = {
    			'idTipoConducta' : combo.getValue()
    		}
    		
	    	chainedStore.load({
				callback: function(records, operation, success) {
	   				if(!Ext.isEmpty(records) && records.length > 0) {
	   					comboCategoria.setDisabled(false);
						comboCategoria.allowBlank = false;
	   				} else {
	   					comboCategoria.setDisabled(true);
						comboCategoria.allowBlank = true;
	   				}
				}
			});
    	}
    	
		if (me.lookupReference(comboCategoria.chainedReference) != null) {
			var chainedDos = me.lookupReference(comboCategoria.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
    },

	onChangeCategoriaConducta: function(combo) {
    	var me = this,
    	comboNivel = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
    	if(!Ext.isEmpty(comboNivel.getValue())) {
			comboNivel.clearValue();
    	}
		
    	var chainedStore = comboNivel.getStore();
    	
    	if(!Ext.isEmpty(chainedStore)) {
    		chainedStore.getProxy().extraParams = {
    			'idCategoriaConducta' : combo.getValue()
    		}
    		
	    	chainedStore.load({
				callback: function(records, operation, success) {
	   				if(!Ext.isEmpty(records) && records.length > 0) {
	   					comboNivel.setValue(records[0]);
	   					comboNivel.setDisabled(false);
	   				} else {
	   					comboNivel.setDisabled(true);
	   				}
				}
			});
    	}
    	
		if (me.lookupReference(comboNivel.chainedReference) != null) {
			var chainedDos = me.lookupReference(comboNivel.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
    },
    
    abrirFormularioAdjuntarConductas: function(table, rowIndex, colIndex,button, grid) {
		var me = this,
		idConducta = grid.record.id;
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoProveedor", {entidad: 'proveedores', idEntidad: idConducta, parent: table, bloque: '02'}).show();
		
	},
	
	downloadDocumentoConductas: function(table, rowIndex, colIndex,button, grid) {
		var me = this;
    	var url= $AC.getRemoteUrl('activo/getLimiteArchivo');
		var data;
		var record = grid.record.data;
		Ext.Ajax.request({
		     url: url,
		     success: function(response, opts) {
		    	 data = Ext.decode(response.responseText);
		    	 if(data.sucess == "true"){
		    		 var limite = data.limite;
		    		 if(!Ext.isDefined(record.tamanyoAdjunto) || record.tamanyoAdjunto == null || limite == 0  || record.tamanyoAdjunto/1024/1024 <= limite){
		    			 config = {};

						config.url=$AC.getWebPath()+"proveedores/bajarAdjuntoProveedor."+$AC.getUrlPattern();
						config.params = {};
						config.params.id=record.idAdjunto;
						config.params.nombreDocumento=record.adjunto.replace(/,/g, "");
						me.fireEvent("downloadFile", config);
						
		    		 }else{
		    			 table.fireEvent("errorToast", "No se puede descargar ficheros mayores de "+limite+"Mb.");
		    		 }
		    	 }					        		         
		     },
		     failure: function(response) {
		    	 table.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		     }
		 });					                
	},
	
	borrarDocumentoAdjuntoConductas: function(table, rowIndex, colIndex,button, grid) {
		var me = this;
		var record = grid.record.data;
		params = {};
		params.idEntidad = me.getViewModel().get("proveedor.id");
		params.id = record.idAdjunto;
		
		Ext.Ajax.request({
		     url: $AC.getRemoteUrl('proveedores/deleteAdjunto'),
			params: params,
		     success: function(response, opts) {
		    	 data = Ext.decode(response.responseText);
		    	 if(data.success == "true"){
		    		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
           		 	table.store.load();
		    	 }					        		         
		     },
		     failure: function(response) {
		    	 table.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
           		 	table.store.load();
		     }
		 });
	},
    
	cargarTabDataDelegacion: function (form) {
		var me = this;
		var model = form.getModelInstance();
		var grid = form.down('[reference=gridDelegacionesRef]');
		if(Ext.isEmpty(grid.selection)){
			return;
		}
		var id = grid.selection.get('id');
		
		form.up("tabpanel").mask(HreRem.i18n('msg.mask.loading'));	
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
	
	onChangeProvincia: function(combo, value, oldValue, eOpts){
    	var me = this;
    	var comboMunicipio = me.lookupReference('municipioCombo');
    	var storeMunicipio = comboMunicipio.getStore();
    	storeMunicipio.getProxy().extraParams = {
    		codigoProvincia: value
    	};
    	storeMunicipio.load();
    },
    
    onChangeMunicipio: function(combo, value, oldValue, eOpts){
    	var me = this;
    	var comboCodigoPostal = me.lookupReference('codigoPostalCombo');
    	var storeCodigoPostal = comboCodigoPostal.getStore();
    	storeCodigoPostal.getProxy().extraParams = {
    		codigoMunicipio: value
    	};
    	storeCodigoPostal.load();
    }
});