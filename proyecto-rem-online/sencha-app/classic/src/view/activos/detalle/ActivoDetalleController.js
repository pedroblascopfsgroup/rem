Ext.define('HreRem.view.activos.detalle.ActivoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.activodetalle',    
    
    control: {
    	
         'documentosactivo gridBase': {
             abrirFormulario: 'abrirFormularioAdjuntarDocumentos',
             onClickRemove: 'borrarDocumentoAdjunto',
             download: 'downloadDocumentoAdjunto',
             afterupload: function(grid) {
             	grid.getStore().load();
             },
             afterdelete: function(grid) {
             	grid.getStore().load();
             }
         },
         
         'fotoswebactivo': {
         	updateOrdenFotos: 'updateOrdenFotosInterno'
         },
         
         'uxvalidargeolocalizacion': {
         	actualizarCoordenadas: 'actualizarCoordenadas'
         }
         
     },
	
	
	cargarTabData: function (form) {
		var me = this,
		model = null,
		models = null,
		nameModels = null,
		id = me.getViewModel().get("activo.id");
		
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
		id = me.getViewModel().get("activo.id");
		
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
	
	cargarTabDataPresupuestoGrafico: function (form) {
		var me = this,
		model = form.getModelInstance(),
		id = me.getViewModel().get("activo.id");
		
		form.down('cartesian').store.proxy.setExtraParam('idActivo', form.lookupController().getViewModel().get("activo.id"));
    	form.down('cartesian').store.load({

		    callback: function(record) {
		    	form.setBindRecord(record[0]);
		    	form.up("tabpanel").unmask();
		    }
		});
	
	},
	
	onCargasListDobleClick: function (grid, record) {
		
		var me = this,
		form = grid.up("form"),
		model = form.getModelInstance(),
		idCarga = record.get("id"),
		tipoCarga = record.get("tipoCargaDescripcion"),
		fieldsetVisible = "";
		
		if (tipoCarga == 'Registral') {
			fieldsetVisible =  grid.up('form').down('[reference=registral]');
		} else {
			fieldsetVisible =  grid.up('form').down('[reference=economica]');
		}
		
		fieldsetVisible.mask(HreRem.i18n("msg.mask.loading"));
	
		model.setId(idCarga);
		model.load({			
		    success: function(record) {	
		    	form.setBindRecord(record);
		    	fieldsetVisible.unmask();				    	
		    }
		});
		
		
	},
	
	onListadoPropietariosDobleClick: function (grid, record) {
    	var me = this;
    	me.getView().fireEvent('openModalWindow',"HreRem.view.activos.detalle.EditarPropietario", {propietario: record});
	},
	
	
	onTasacionListDobleClick: function (grid, record) {
		
		var me = this,
		form = grid.up("form"),
		model = Ext.create('HreRem.model.ActivoTasacion'),
		idTasacion = record.get("id");
		
		var fieldset =  me.lookupReference('detalleTasacion');
		fieldset.mask(HreRem.i18n("msg.mask.loading"));
	
		model.setId(idTasacion);
		model.load({			
		    success: function(record) {	
		    	me.getViewModel().set("tasacion", record);
		    	fieldset.unmask();
		    }
		});		
	},
	    
   	onSaveFormularioCompleto: function(btn, form) {

		var me = this;
		
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones
		if(form.isFormValid() || form.disableValidation) {

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
							me.refrescarActivo(form.refreshAfterSave);
							me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
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
							 me.refrescarActivo(false);
							 me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
						}
	            },
	            failure: function (a, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.getView().unmask();
	            }
			});		
		}
	},
	
	
	onClickBotonFavoritos: function(btn) {
		
		var me = this,
		textoFavorito = "Activo " + me.getViewModel().get("activo.numActivo");
		btn.updateFavorito(textoFavorito);
			
	},
	
    onNotificacionClick: function(btn){
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
    	me.getView().fireEvent('crearnotificacion',{idActivo: idActivo});
    },
	
    onTramiteClick: function(btn){
    	
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
    	var url = $AC.getRemoteUrl('activo/crearTramite');

		me.getView().mask(HreRem.i18n("msg.mask.loading"));	    	
		
		Ext.Ajax.request({
    		url: url,
    		params: {idActivo: idActivo},
    		
    		success: function(response, opts){
    			me.getViewModel().data.storeTramites.load();
    			if(Ext.decode(response.responseText).errorCreacion)
    				me.fireEvent("errorToast", Ext.decode(response.responseText).errorCreacion); 
    			else
    				me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
//    			Ext.Msg.show({
//        			   title: 'Nuevo trámite',
//        			   msg: 'Trámite creado correctamente',
//        			   buttons: Ext.MessageBox.OK
//    			});
    		},
		 	failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    },
		    callback: function(record, operation) {
    			me.getView().unmask();
		    }
    	});
    },
    
    onClickCrearTrabajo: function (btn) {
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
    	me.getView().fireEvent('openModalWindow',"HreRem.view.trabajos.detalle.CrearTrabajo",{idActivo: idActivo, idAgrupacion: null});
  	    	
    },
    
    onAnyadirPropietarioClick: function (btn) {
    	
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");

    	me.getView().fireEvent('openModalWindow',"HreRem.view.activos.detalle.AnyadirPropietario");
  	    	
    },
        
    onEliminarPropietarioClick: function (btn) {
    	
    	var me = this;
    	var grid = btn.up('fieldsettable').down('#listadoPropietarios');
    
        Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			            var sm = grid.getSelectionModel();
			            sm.getSelection()[0].erase();
			            if (grid.getStore().getCount() > 0) {
			                sm.select(0);
			            }
			        }
			   }
		});
  	    	
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
    

    onHanCambiadoSelect: function(combo, value) {
  
    	var me = this,
    	disabled = value == 0,
    	poblacionAnterior = me.lookupReference('poblacionAnterior'),
    	numRegistroAnterior = me.lookupReference('numRegistroAnterior'),
    	numFincaAnterior = me.lookupReference('numFincaAnterior');

    	poblacionAnterior.setDisabled(disabled);
    	numRegistroAnterior.setDisabled(disabled);
    	numFincaAnterior.setDisabled(disabled);
    	
    	poblacionAnterior.allowBlank = disabled;
    	numRegistroAnterior.allowBlank = disabled;
    	numFincaAnterior.allowBlank = disabled;
    	
    	if(disabled) {
    		poblacionAnterior.setValue("");
    		numRegistroAnterior.setValue("");
    		numFincaAnterior.setValue("");
    	}
    	

    },
    

    onDivisionHorizontalSelect: function(combo, value) {
    	
    	var me = this,
    	disabled = value == 0;

    	if(!Ext.isEmpty(me.lookupReference('datoscomunidadactivo'))) {
	    	me.lookupReference('datoscomunidadactivo').setDisabled(disabled);
    	}
	    
	    me.lookupReference('estadoDivHorizontal').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontalNoInscrita').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontal').allowBlank =disabled;
    	me.lookupReference('estadoDivHorizontalNoInscrita').allowBlank=disabled;

    	if(disabled) {
    		me.lookupReference('estadoDivHorizontal').setValue("");
    		me.lookupReference('estadoDivHorizontalNoInscrita').setValue("");
    	}
    },
    
    onComunidadNoConstituida: function(combo, value) {
    	var me = this,
    	disabled = value == 0 || Ext.isEmpty(value);
    	
    	me.lookupReference('nombreComunidadPropietarios').allowBlank =disabled;
    	me.lookupReference('nifComunidadPropietarios').allowBlank =disabled;
    	
    },
    
    onChangeBloqueo: function (field, newValue, oldValue) {
    	var me = this;
    	
    	if (newValue > 0) {
    		me.lookupReference('bloqueoPrecioFechaIni').setValue($AC.getCurrentDate());
    	} else {
    		me.lookupReference('bloqueoPrecioFechaIni').setValue("");
    		me.lookupReference('gestorBloqueoPrecio').setValue("");
    	}
    },
    
    onDivisionHorizontalAdmisionSelect: function(combo, value) {
    	
    	var me = this,
    	disabled = value == 0;

    	if(!Ext.isEmpty(me.lookupReference('datoscomunidadactivo'))) {
	    	me.lookupReference('datoscomunidadactivo').setDisabled(disabled);
    	}
    	
    	me.lookupReference('estadoDivHorizontalAdmision').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setDisabled(disabled);
    	me.lookupReference('estadoDivHorizontalAdmision').allowBlank =disabled;
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank=disabled;

    	if(disabled) {
    		me.lookupReference('estadoDivHorizontalAdmision').setValue("");
    		me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setValue("");
    	}
    },
    
    onEstadoDivHorizontalSelect: function(combo, value) {
    	
    	var me = this,
    	disabled = (value == 1 || Ext.isEmpty(value)) ;
    	
    	me.lookupReference('estadoDivHorizontalNoInscrita').allowBlank = disabled;
    	me.lookupReference('estadoDivHorizontalNoInscrita').setDisabled(disabled);
    	
    	if(disabled) {    		
    		me.lookupReference('estadoDivHorizontalNoInscrita').setValue("");
    		me.lookupReference('estadoDivHorizontalNoInscrita').allowBlank = true;
    	}
    	
    }, 
    
    onEstadoDivHorizontalAdmisionSelect: function(combo, value) {
    	
    	var me = this,
    	disabled = (value == 1 || Ext.isEmpty(value)) ;

    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank = disabled
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setDisabled(disabled);

    	if(disabled) {
			me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setValue("");
			me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank = true;    		
    	}
    	
    },    
    
    cargaGestores : function(grid){
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
    	grid.getStore().getProxy().setExtraParams({'idActivo':idActivo});    
    	grid.getStore().load();
    },

    
	onChangeTipoGestor: function(cmb){
		var me = this;
		me.lookupReference('usuarioGestor').setDisabled(false);
		var idTipoGestor = cmb.getValue();
		me.lookupReference('usuarioGestor').clearValue();
		
		me.lookupReference('usuarioGestor').getStore().getProxy().setExtraParams({'idTipoGestor':idTipoGestor});    
		me.lookupReference('usuarioGestor').getStore().load();
    	
		//me.getView().fireEvent('onChangeTipoGestor',{idTipoGestor: idTipoGestor});
	},
      
	onChangeTipoTitulo: function(btn,value) {
    	
    	var me = this;
    		
    	me.lookupReference('judicial').setVisible(value == '01');
    	me.lookupReference('judicial').setDisabled(value != '01');
    	me.lookupReference('noJudicial').setVisible(value == '02');
    	me.lookupReference('noJudicial').setDisabled(value != '02');
		me.lookupReference('pdv').setVisible(value == '03');
		me.lookupReference('pdv').setDisabled(value != '03');
    	
    },
    
    onChangeTipoTituloAdmision: function(btn,value) {
    	
    	var me = this;

    	me.lookupReference('judicialAdmision').setVisible(value == '01');
    	me.lookupReference('judicialAdmision').setDisabled(value != '01');
    	me.lookupReference('noJudicialAdmision').setVisible(value == '02');
    	me.lookupReference('noJudicialAdmision').setDisabled(value != '02');
		me.lookupReference('pdvAdmision').setVisible(value == '03');
		me.lookupReference('pdvAdmision').setDisabled(value != '03');
		
    	
    },
    
	onChangeSujetoAExpediente: function(btn,value) {
    	
    	var me = this;

    	if (value == '0') {
    		me.lookupReference('expropiacionForzosa').setVisible(false);
    	} else {
    		me.lookupReference('expropiacionForzosa').setVisible(true);
    	}

    },
    
    onAgregarGestoresClick: function(btn){
		
		var me = this;

    	var url =  $AC.getRemoteUrl('activo/insertarGestorAdicional');
    	var parametros = btn.up("combogestores").getValues();
    	parametros.idActivo = me.getViewModel().get("activo.id");

    	Ext.Ajax.request({
    		
    	     url: url,
    	     params: parametros,

    	     success: function(response, opts) {
  
    	    	 btn.up("gestoresactivo").down("[reference=listadoGestores]").getStore().load();
    	         btn.up("gestoresactivo").down("form").reset();
    	     }
    	 });
    },
	
	onClickBotonEditar: function(btn) {
		
		var me = this;
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		me.getViewModel().set("editing", true);
		
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
		
		Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
		me.getViewModel().set("editing", false);
	},

	onClickBotonCancelarPropietario: function(btn) {		
		btn.up('window').hide();		
	},
	
	onTramitesListDobleClick : function(grid,record) {
    	var me = this;
    	me.getView().fireEvent('abrirDetalleTramite', grid,record);
    },
    
    onComboGestoresClick: function(btn){
		var me = this;
		me.getView().fireEvent('onComboGestoresClick',btn);
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
		me.refrescarActivo(true);

	},
	
	refrescarActivo: function(refrescarPestañaActiva) {
		
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
		
		me.getView().fireEvent("refrescarActivo", me.getView());
		
	},
	
	abrirFormularioAdjuntarDocumentos: function(grid) {
		
		var me = this,
		idActivo = me.getViewModel().get("activo.id");
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumento", {entidad: 'activo', idEntidad: idActivo, parent: grid}).show();
		
	},
	
	borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idActivo = me.getViewModel().get("activo.id");

		record.erase({
			params: {idActivo: idActivo},
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
		
		config.url=$AC.getWebPath()+"activo/bajarAdjuntoActivo."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.idActivo=record.get("idActivo");
		
		me.fireEvent("downloadFile", config);
	},
	
	
	updateOrdenFotosInterno: function(data, record, store) {

		//store.beginUpdate();
		var me = this;
		me.storeGuardado = store;
		me.ordenGuardado = 0;
		me.refrescarGuardado = true;
		var orden = 1;
		var modificados = new Array();
		var contadorModificados = 0;
		for (i=0; i<record.store.getData().items.length;i++) {
			
			if (store.getData().items[i].data.orden != orden) {
				store.getAt(i).data.orden = orden;
				//store.getAt(i).dirty = true;
				/*modificados[contadorModificados] = Ext.util.JSON.encode(store.getAt(i).data);
				modificados[contadorModificados] = Ext.util.JSON.decode(modificados[contadorModificados]);
				contadorModificados++;
				*/
				//FIXME: ¿Poner máscara?
				//me.getView().mask(HreRem.i18n("msg.mask.loading"));
				var url =  $AC.getRemoteUrl('activo/updateFotosById');
    			Ext.Ajax.request({
    			
	    		     url: url,
	    		     params: {
	    		     			id: store.getAt(i).data.id,
	    		     			orden: store.getAt(i).data.orden 	
	    		     		}
	    			
	    		    ,success: function (a, operation, context) {

	                	//me.getStore().load();
	                    //context.store.load();
	                    if (me.ordenGuardado >= me.storeGuardado.getData().items.length && me.refrescarGuardado) {
	                    	me.storeGuardado.load();
	                    	me.refrescarGuardado = false;
	                    	/* //FIXME: ¿Poner máscara?
	                    	Ext.toast({
							     html: 'LA OPERACIÓN SE HA REALIZADO CORRECTAMENTE',
							     width: 360,
							     height: 100,
							     align: 't'
							});*/
							//me.getView().unmask();
	                    }
	                    
	                    
	                    
	                },
	                
	                failure: function (a, operation, context) {
	                	//context.store.load();
	                	  Ext.toast({
						     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
						     width: 360,
						     height: 100,
						     align: 't'									     
						 });
						 me.unmask();
	                }
    		     
				});
				
				
			}
			orden++;
			me.ordenGuardado++;
		}
		
	},
	
	onAddFotoClick: function(grid) {
		
		var me = this,
		idActivo = me.getViewModel().get("activo.id");
    	
    	//Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumento", {entidad: 'activo', idEntidad: idActivo, parent: grid}).show();
		Ext.create("HreRem.view.common.adjuntos.AdjuntarFoto", {idEntidad: idActivo, parent: grid}).show();
		
	},
	
	onDeleteFotoClick: function(btn) {
		
		var me = this;

		Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	
			        	var nodos = btn.up('form').down('dataview').getSelectedNodes();
						var storeTemp = btn.up('form').down('dataview').getStore();
						var idSeleccionados = [];
						for (var i=0; i<nodos.length; i++) {
				
							idSeleccionados[i] = storeTemp.getAt(nodos[i].getAttribute('data-recordindex')).getId();
							
						}
						
						//idActivo = me.getViewModel().get("activo.id");
			    		
			        	var url =  $AC.getRemoteUrl('activo/deleteFotosActivoById');
			    		Ext.Ajax.request({
			    			
			    		     url: url,
			    		     params: {id : idSeleccionados},
			    		
			    		     success: function (a, operation, context) {
                                	
                                	storeTemp.load();

                                    Ext.toast({
									     html: 'LA OPERACIÓN SE HA REALIZADO CORRECTAMENTE',
									     width: 360,
									     height: 100,
									     align: 't'
									 });
									 //me.unmask();
                                },
                                
                                failure: function (a, operation, context) {

                                	  Ext.toast({
									     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
									     width: 360,
									     height: 100,
									     align: 't'									     
									 });
									 //me.unmask();
                                }
			    		     
			    		 });

			        }
			   }
		});
		
	},
	
	onDownloadFotoClick: function(btn) {
		var me = this,
		config = {};
		
		var nodos = btn.up('form').down('dataview').getSelectedNodes();
		if (nodos.length != 0) {
		
			var storeTemp = btn.up('form').down('dataview').getStore();
			
			config.url=$AC.getWebPath()+"activo/getFotoActivoById."+$AC.getUrlPattern();
			config.params = {};
	
			/*for (var i=0; i<nodos.length; i++) {
	
				config.params.idFoto=storeTemp.getAt(nodos[i].getAttribute('data-recordindex')).getId();
				me.fireEvent("downloadFile", config);
				
			}*/
			
			config.params.idFoto=storeTemp.getAt(nodos[0].getAttribute('data-recordindex')).getId();
			
			me.fireEvent("downloadFile", config);
		}
	},
    
    
    // Se deja planteado para fase 2, pero para fase 1 se elimina el botón imprimir.
	onPrintFotoClick: function(btn) {
		
		var me = this;
		
		var nodos = btn.up('form').down('dataview').getSelectedNodes();
		
	    if(nodos) {
	        
	        node = nodos[0];//.getElementsByTagName('img');
			cmp  = me.findComponentByElement(node);
	        
	        html = cmp.container.dom.innerHTML;

	        var win = window.open();
	        win.document.write(html);
	        win.print();
	        win.close();
	    }

	},
	
	// Se deja planteado para fase 2, pero para fase 1 se elimina el botón imprimir.
	findComponentByElement: function(node) {
	    var topmost = document.body,
	        target = node,
	        cmp;
	 
	    while (target && target.nodeType === 1 && target !== topmost) {
	        cmp = Ext.getCmp(target.id);
	 
	        if (cmp) {
	            return cmp;
	        }
	 
	        target = target.parentNode;
	    }
	 
	    return null;
	},
	
	cargarTabFotos: function (form) {

		var me = this,
		idActivo = me.getViewModel().get("activo.id");
		
		me.getViewModel().data.storeFotos.getProxy().setExtraParams({'id':idActivo, tipoFoto: '01'}); 
		me.getViewModel().data.storeFotosTecnicas.getProxy().setExtraParams({'id':idActivo, tipoFoto: '02'}); 
		
		me.getViewModel().data.storeFotos.load();
		me.getViewModel().data.storeFotosTecnicas.load();

	},

	// Funcion para cuando hace click en una fila
    onHistoricoPeticionesActivoDobleClick: function(grid, record) {        
    	var me = this;    	
    	me.abrirDetalleTrabajo(record);   	        	
        	
    },
    
    
	abrirDetalleTrabajo: function(record)  {
    	 var me = this;
    	 me.getView().fireEvent('abrirDetalleTrabajo', record);
    	 
    },
   
	onHistoricoPresupuestosActivoListDobleClick: function(grid,record) {
		grid.up('form').down('[reference=incrementosPresupuesto]').getStore().getProxy().setExtraParams({'idPresupuesto':record.id}); 
		grid.up('form').down('[reference=incrementosPresupuesto]').getStore().load();
	},
	
	
	//FIXME: Funciones para el gráfico de presupuestos. Llevar a otro controlador aparte.
	onAxisLabelRender: function (axis, label, layoutContext) {
        // Custom renderer overrides the native axis label renderer.
        // Since we don't want to do anything fancy with the value
        // ourselves except appending a '%' sign, but at the same time
        // don't want to loose the formatting done by the native renderer,
        // we let the native renderer process the value first.
        return layoutContext.renderer(label) + '%';
    },

    onSeriesTooltipRender: function (tooltip, record, item) {
        var fieldIndex = Ext.Array.indexOf(item.series.getYField(), item.field),
            browser = item.series.getTitle()[fieldIndex];

		var cantidad = 0;
		if (item.field == 'gastadoPorcentaje') {
			cantidad = record.get('gastado');
		} else if (item.field == 'dispuestoPorcentaje') {
			cantidad = record.get('dispuesto');
		} else if (item.field == 'disponiblePorcentaje') {
			cantidad = record.get('disponible');
		}

		tooltip.setHtml(browser + ': ' +
            record.get(item.field) + '%' + ' ( ' + Ext.util.Format.currency(cantidad) + ' )');
        /*tooltip.setHtml(browser + ' on ' + record.get('presupuesto') + ': ' +
            record.get(item.field) + '%');*/
    },

    onColumnRender: function (v) {
        return v + '%';
    },

    onPreview: function () {
        var chart = this.lookupReference('chart');
        chart.preview();
    },
    
    onClickVerificarDireccion: function(btn) {
    	
    	var me = this,
    	geoCodeAddr = null,
    	latLng = {};
    	
    	latLng.latitud = me.getViewModel().get("activo.latitud");
    	latLng.longitud= me.getViewModel().get("activo.longitud");
    	geoCodeAddr = me.getViewModel().get("geoCodeAddr");
    	
    	
    	Ext.create("HreRem.ux.window.geolocalizacion.ValidarGeoLocalizacion", {geoCodeAddr: geoCodeAddr, latLng: latLng,  parent: btn.up("form")}).show();  	
    },
    
    actualizarCoordenadas: function(parent, latitud, longitud) {
    	var me = this;  
    	
    	parent.actualizarCoordenadas(latitud, longitud);
    	
    	
    },
    
    onSearchPropuestasActivoClick: function(btn) {
    	
    	var me = this;
		this.lookupReference('propuestasActivoList').getStore().loadPage(1);
    	
    },
    
    beforeLoadPropuestas: function(store, operation, opts) {
		
		var me = this,		
		searchForm = this.lookupReference('propuestasActivoSearch');
		
		if (searchForm.isValid()) {	
			
			store.getProxy().extraParams = me.getFormCriteria(searchForm);
			store.getProxy().extraParams.idActivo = me.getViewModel().get("activo.id");
			
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
    
    // Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {			
		btn.up('form').getForm().reset();				
	},
	
    onChangeEstadoDisponibilidadComercial: function(field){
    	var me = this;
    	var store = me.getViewModel().getStore('storeEstadoDisponibilidadComercial');
    	if(!store.isLoaded()) {
    		store.load();
    	}
    	if(field.getValue()) {
    		store.on("load", function(){ // Condicionado.
    			field.setValue(store.findRecord('codigo','01').getData().descripcion);
        	});
    	} else {
    		store.on("load", function(){ // No condicionado.
    			field.setValue(store.findRecord('codigo','02').getData().descripcion);
    		});
    	}
    },
    
    getTotalCountDiasPeriodo: function(field) {
		 var me = this;
		 var dias = 0;
		 var store = me.getViewModel().getStore('historicoEstados');
	   	
		 store.on("load", function(){
			 var allRecords = store.getData();
			
			 allRecords.each(function(record) {
				 console.log(record);
				 dias += parseInt(record.getData().diasPeriodo);
			 });
			 field.setValue(dias);
	   	});
	 },
    
    // Esta función es llamada cuando cambia el estado de publicación del activo.
    onChangeEstadoPublicacion: function(field){
    	var me = this;
    	var view = me.getView();
    	var codigo = this.getViewModel().getData().getEstadoPublicacionCodigo;
    	
    	switch (codigo){
    	case "01": // Publicado.
    		view.lookupReference('seccionPublicacionForzada').hide();
    		view.lookupReference('seccionOcultacionForzada').show();
    		view.lookupReference('seccionOcultacionPrecio').show();
    		view.lookupReference('seccionDespublicacionForzada').show();
    		break;
    	case "02": // Publicación forzada.
    		view.lookupReference('seccionPublicacionForzada').show();
    		view.lookupReference('seccionOcultacionForzada').hide();
    		view.lookupReference('seccionOcultacionPrecio').show();
    		view.lookupReference('seccionDespublicacionForzada').hide();
    		break;
    	case "03": // Publicado oculto.
    		view.lookupReference('seccionPublicacionForzada').hide();
    		view.lookupReference('seccionOcultacionForzada').show();
    		view.lookupReference('seccionOcultacionPrecio').show();
    		view.lookupReference('seccionDespublicacionForzada').show();
    		break;
    	case "04": // Publicado con precio oculto.
    		view.lookupReference('seccionPublicacionForzada').hide();
    		view.lookupReference('seccionOcultacionForzada').show();
    		view.lookupReference('seccionOcultacionPrecio').show();
    		view.lookupReference('seccionDespublicacionForzada').show();
    		break;
    	case "05": // Despublicado.
    		view.lookupReference('seccionPublicacionForzada').hide();
    		view.lookupReference('seccionOcultacionForzada').hide();
    		view.lookupReference('seccionOcultacionPrecio').hide();
    		view.lookupReference('seccionDespublicacionForzada').show();
    		break;
    	case "06": // No publicado.
    		view.lookupReference('seccionPublicacionForzada').show();
    		view.lookupReference('seccionOcultacionForzada').hide();
    		view.lookupReference('seccionOcultacionPrecio').hide();
    		view.lookupReference('seccionDespublicacionForzada').hide();
    		break;
    	default: // Por defecto todos se muestran.
    		view.lookupReference('seccionPublicacionForzada').show();
    		view.lookupReference('seccionOcultacionForzada').show();
			view.lookupReference('seccionOcultacionPrecio').show();
			view.lookupReference('seccionDespublicacionForzada').show();
    		break;
    	}
    },
    
    // Esta funcion es llamado cuando algún checkbox del apartado de 'Estados de publicación' es activado
    // y se encarga de permitir tener sólo un checkbox de estado activado. Además, reinicia el estado de
    // los componentes de cada sección que no esté seleccionada.
    onchkbxEstadoPublicacionChange: function(chkbx) {
    	var me = this;
    	if(!chkbx.getValue()){
    		// si el checkbox esta siendo desactivado no hacer nada.
    		return;
    	}
    	var id = chkbx.getId();
    	var view = me.getView();
    	
    	switch (id){
    	case "chkbxpublicacionordinaria":
    		// checkbox.
    		view.lookupReference('chkbxpublicacionforzada').setValue(false);
    		view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		// combobox.
    		view.lookupReference('comboboxpublicacionocultacionprecio').reset();
    		view.lookupReference('comboboxpublicaciondespublicar').reset();
    		view.lookupReference('comboboxpublicacionocultacionforzada').reset();
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	case "chkbxpublicacionforzada":
    		// checkbox.
    		view.lookupReference('chkbxpublicacionordinaria').setValue(false);
    		view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		// combobox.
    		view.lookupReference('comboboxpublicacionocultacionprecio').reset();
    		view.lookupReference('comboboxpublicaciondespublicar').reset();
    		view.lookupReference('comboboxpublicacionocultacionforzada').reset();
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	case "chkbxpublicacionocultarprecio":
    		// checkbox.
    		view.lookupReference('chkbxpublicacionforzada').setValue(false);
    		view.lookupReference('chkbxpublicacionordinaria').setValue(false);
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		// combobox.
    		view.lookupReference('comboboxpublicacionpublicar').reset();
    		view.lookupReference('comboboxpublicaciondespublicar').reset();
    		view.lookupReference('comboboxpublicacionocultacionforzada').reset();
    		break;
    	case "chkbxpublicaciondespublicar":
    		view.lookupReference('chkbxpublicacionforzada').setValue(false);
    		view.lookupReference('chkbxpublicacionordinaria').setValue(false);
    		view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		// combobox.
    		view.lookupReference('comboboxpublicacionpublicar').reset();
    		view.lookupReference('comboboxpublicacionocultacionprecio').reset();
    		view.lookupReference('comboboxpublicacionocultacionforzada').reset();
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	case "chkbxpublicacionocultacionforzada":
    		// checkbox.
    		view.lookupReference('chkbxpublicacionforzada').setValue(false);
    		view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		view.lookupReference('chkbxpublicacionordinaria').setValue(false);
    		// combobox.
    		view.lookupReference('comboboxpublicacionpublicar').reset();
    		view.lookupReference('comboboxpublicacionocultacionprecio').reset();
    		view.lookupReference('comboboxpublicaciondespublicar').reset();
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	default:
    		break;
    	}
    }
});