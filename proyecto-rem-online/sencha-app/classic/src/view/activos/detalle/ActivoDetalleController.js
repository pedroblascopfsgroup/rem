
Ext.define('HreRem.view.activos.detalle.ActivoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.activodetalle',  
    requires: ['HreRem.view.activos.detalle.AnyadirEntidadActivo' , 'HreRem.view.activos.detalle.CargaDetalle',
    "HreRem.view.activos.detalle.OpcionesPropagacionCambios"],
    
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
         },
         
         'datoscomunidadactivo gridBase': {
             abrirFormulario: 'abrirFormularioAnyadirEntidadActivo',
             afterupload: function(grid) {
             	grid.getStore().load();
             },
             afterdelete: function(grid) {
             	grid.getStore().load();
             }
         },
         
         'cargasactivo gridBase': {         	abrirFormulario: 'abrirFormularioAnyadirCarga',
         	onClickRemove: 'onClickRemoveCarga',
         	onClickPropagation :  'onClickPropagation' 
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
				    success: function(record,b,c,d) {
				    	form.setBindRecord(record);			    	
				    	form.unmask();
				    	if(Ext.isFunction(form.afterLoad)) {
				    		form.afterLoad();
				    	}
				    },
				    failure: function(operation) {		    	
				    	form.up("tabpanel").unmask();
				    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
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
	
	onListadoPropietariosDobleClick: function (grid, record) {
    	var me = this
    	
    	var activo = me.getViewModel().get('activo'),
 		idActivo= activo.get('id');
    	var ventana = Ext.create("HreRem.view.activos.detalle.EditarPropietario", {propietario: record, activo: activo});
    	
 		grid.up('activosdetallemain').add(ventana);
		ventana.show();
	},	
	
	onTasacionListClick: function (grid, record) {
		
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
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones.
		if(form.isFormValid() || form.disableValidation) {
			
			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);
			
			if(!Ext.isEmpty(btn)) {
				btn.hide();
				btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
				btn.up('tabbar').down('button[itemId=botoneditar]').show();
				
				if(Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
		 			me.getViewModel().set("editingFirstLevel", false);
		 		} else {
		 			me.getViewModel().set("editing", false);
		 		}
			}
			// Obtener jsondata para guardar activo
			var tabData = me.createTabData(form);
			if(tabData.models != null){
				if (tabData.models[0].name == "datosregistrales"){
					record = form.getBindRecord();
					var fechaInscripcionReg = record.get("fechaInscripcionReg");
					if  ((typeof fechaInscripcionReg) == 'string') {						
						var from = fechaInscripcionReg.split("/");
						fechaInscripcionReg = new Date(from[2], from[1] - 1, from[0])
    				}
					if(fechaInscripcionReg != null){
						//tabData.models[0].data.fechaInscripcionReg = new Date(fechaInscripcionReg);
					}
				} else if (tabData.models[0].name == "informecomercial"){
					record = form.getBindRecord();
					if(record != null){
						if(record.infoComercial != null){
							tabData.models[0].data.valorEstimadoVenta = record.infoComercial.data.valorEstimadoVenta;
							tabData.models[0].data.valorEstimadoRenta = record.infoComercial.data.valorEstimadoRenta;
						}
					}
				}
			}
			
			var idActivo;
			
			if(	   tabData.models[0].name == "activohistoricoestadopublicacion"
				|| tabData.models[0].name == "cargasactivo"
				|| tabData.models[0].name == "activocondicionantesdisponibilidad"
				|| tabData.models[0].name == "activotrabajo"
				|| tabData.models[0].name == "activotrabajosubida"
				|| tabData.models[0].name == "activotramite"
				){
				idActivo = tabData.models[0].data.idActivo;
			} else {
				idActivo = tabData.models[0].data.id;
			}
			
			me.checkActivosToPropagate(idActivo, form, tabData);
			
		} else {
			me.getView().unmask();
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
			
		}
		
	},
	
   	onSaveFormularioCompletoDistribuciones: function(btn, form) {
		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones.
		if(form.isFormValid() || form.disableValidation) {
	
			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);

			// Obtener jsondata para guardar activo
			var numPlanta =  me.lookupReference('comboNumeroPlantas').getValue();
			var tipoHabitaculoCodigo =  me.lookupReference('comboTipoHabitaculo').getValue();
			var superficie =  me.lookupReference('superficie').getValue();
			var cantidad =  me.lookupReference('cantidad').getValue();
			var idActivo = me.getViewModel().get("activo.id");

			var jsonData = {idEntidad: idActivo, numPlanta : numPlanta, tipoHabitaculoCodigo : tipoHabitaculoCodigo, superficie : superficie, cantidad : cantidad};
			
			
			var successFn = function(response, eOpts) {
				if(Ext.decode(response.responseText).success == "false") {
					me.fireEvent("errorToast", HreRem.i18n("msg.error.anyadir.distribucion.vivienda"));
				}
				else {
					storeTemp.load();
					me.refrescarActivo(true);
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				}
								
			}
			me.saveDistribucion(jsonData, successFn);
			
			
		} else {
			me.getView().unmask();
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
			
		}
		
	},
	
	saveMultipleRecords: function(contador, records, form) {
		var me = this;
		
		if(records[contador] != null && (Ext.isDefined(records[contador].getProxy().getApi().create) || Ext.isDefined(records[contador].getProxy().getApi().update))) {
			// Si la API tiene metodo de escritura (create or update).
			
			records[contador].save({
				success: function (a, operation, c) {
						contador++;
						
						if (contador < records.length) {
							me.saveMultipleRecords(contador, records, form);
						} else {
							 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));						
							 me.getView().unmask();
							 me.refrescarActivo(form.refreshAfterSave);
							 me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
						}
	            },
	            failure: function (a, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.getView().unmask();
	            }
			});		
		} else {
			// Si la API no contiene metodo de escritura (create or update).
			contador++;
			
			if (contador < records.length) {
				me.saveMultipleRecords(contador, records, form);
			} else {
				 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));						
				 me.getView().unmask();
				 me.refrescarActivo(form.refreshAfterSave);
				 me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
			}
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
    		},
		 	failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    },
		    callback: function(record, operation) {
    			me.getView().unmask();
		    }
    	});
    },
    
    onTramitePublicacionClick: function(btn){
    	
    	var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
    	var url = $AC.getRemoteUrl('activo/crearTramitePublicacion');

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
    		},
		 	failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    },
		    callback: function(record, operation) {
    			me.getView().unmask();
    			me.onClickBotonRefrescar();
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
    	
    	var me = this;
    	disabled = (value == 1 || Ext.isEmpty(value)) ;

    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank = disabled
    	me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setDisabled(disabled);

    	if(disabled) {
			me.lookupReference('estadoDivHorizontalNoInscritaAdmision').setValue("");
			me.lookupReference('estadoDivHorizontalNoInscritaAdmision').allowBlank = true;    		
    	}
    	
    },    
    
    onChangeProvincia: function(combo, value, oldValue, eOpts){
    	var me = this;
    	me.getViewModel().get('activo').set('asignaGestPorCambioDeProv', false);
    	if(value != oldValue){
    		var me = this;
    		me.getViewModel().get('activo').set('asignaGestPorCambioDeProv', true);
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
    	         
    	         if(Ext.decode(response.responseText).success == "false") {
					me.fireEvent("errorToast", HreRem.i18n(Ext.decode(response.responseText).errorCode));
					//me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    	         }
    	     },
    	     failure: function (a, operation, context) {
           	  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
           }
    	 });
    },
    
    onChkbxMuestraHistorico: function(chkbx, checked) {
    	
    	var me = this;
    	
    	var grid = chkbx.up('gestoresactivo').down("gestoreslist");
    	var store = me.getViewModel().get("storeGestoresActivos");
    	
    	var prox = store.getProxy();
    	var _idActivo = prox.getExtraParams().idActivo;
    	var _incluirGestoresInactivos = checked;
    	
    	prox.setExtraParams({
    		"idActivo": _idActivo, 
    		"incluirGestoresInactivos": _incluirGestoresInactivos
    	});
    	store.load();
    	
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
		if(Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
 			me.getViewModel().set("editingFirstLevel", true);
 		} else {
 			me.getViewModel().set("editing", true);
 		}
	},

	onSaveFormularioCompletoTabComercial: function(btn, form){
		var me = this;
		if(me.lookupReference('dtFechaVenta').value != null && (me.getViewModel().get('comercial.situacionComercialCodigo') != CONST.SITUACION_COMERCIAL['VENDIDO'])){
			Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.modificar.venta.externa.activo'),
			   msg: HreRem.i18n('msg.confirmar.modificar.venta.externa.activo'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {
			        	me.onSaveFormularioCompleto(btn, form);
			        }
			   }
		});
		}else{
		// Se ha de confirmar la modificaciÃ³n.
			Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.modificar.venta.activo'),
				   msg: HreRem.i18n('msg.confirmar.modificar.venta.activo'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {
				        	me.onSaveFormularioCompleto(btn, form);
				        }
				   }
			});
		}
	},

	onClickBotonGuardar: function(btn) {
		var me = this;
		var form = btn.up('tabpanel').getActiveTab();

		// Ejecución especial si la pestaña es 'Comercial'.
		if("comercialactivo" == form.getXType()) {
			me.onSaveFormularioCompletoTabComercial(btn, form);
		} else {
			me.onSaveFormularioCompleto(btn, form);
		}
	},

	onClickBotonCancelar: function(btn) {
		var me = this,
		activeTab = btn.up('tabpanel').getActiveTab();

		if (!activeTab.saveMultiple) {
			if(activeTab && activeTab.getBindRecord && activeTab.getBindRecord()) {
				me.onClickBotonRefrescar();
				
			}
		} else {
			
			var records = activeTab.getBindRecords();
			
			for (i=0; i<records.length; i++) {
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

		if(Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
 			me.getViewModel().set("editingFirstLevel", false);
 		} else {
 			me.getViewModel().set("editing", false);
 		}
	},

	onClickBotonCancelarPropietario: function(btn) {		
		
		var window = btn.up('window');
		var padre = window.floatParent;
		var tab = padre.down('tituloinformacionregistralactivo');
		tab.funcionRecargar();
		
		btn.up('window').hide();
	},
	
	onClickBotonGuardarPropietario: function(btn) {		
		var me = this;	
		var url =  $AC.getRemoteUrl('activo/updateActivoPropietarioTab');
		form= btn.up('window').down('formBase').getForm();
		formulario= btn.up('window').down('formBase');
		var window = btn.up('window');
		var padre = window.floatParent;
		var tab = padre.down('tituloinformacionregistralactivo');
		
		var propietario = me.getViewModel().get('propietario');
		var activo = me.getViewModel().get('activo');
		
		var params={};
		params["idActivo"]=activo.get('id');
		params["idPropietario"]= propietario.get('id');
		params['porcPropiedad']=form.findField("porcPropiedad").getValue();
		params['tipoGradoPropiedadCodigo']=form.findField("tipoGradoPropiedad").getValue();
		params['tipoPersonaCodigo']=form.findField("tipoPersona").getValue();
		params['nombre']=form.findField("nombre").getValue();
		params['tipoDocIdentificativoCodigo']=form.findField("tipoDoc").getValue();
		params['docIdentificativo']=form.findField("numDoc").getValue();
		params['direccion']=form.findField("direccion").getValue();
		params['provinciaCodigo']=form.findField("provincia").getValue();
		params['localidadCodigo']=form.findField("localidad").getValue();
		params['codigoPostal']=form.findField("codigoPostal").getValue();
		params['telefono']=form.findField("telefono").getValue();
		params['email']=form.findField("email").getValue();
		params['tipoPropietario']=form.findField("tipoPropietario").getValue();
		params['nombreContacto']=propietario.get('nombreContacto');
		params['telefono1Contacto']=propietario.get('telefono1Contacto');
		params['telefono2Contacto']=propietario.get('telefono2Contacto');
		params['emailContacto']=propietario.get('emailContacto');
		params['provinciaContactoCodigo']=propietario.get('provinciaContactoCodigo');
		params['localidadContactoCodigo']=propietario.get('localidadContactoCodigo');
		params['codigoPostalContacto']=propietario.get('codigoPostalContacto');
		params['direccionContacto']=propietario.get('direccionContacto');
		params['observaciones']=propietario.get('observaciones');
		
		if(formulario.isFormValid()){
		Ext.Ajax.request({
		     url: url,
		     params:params,
		     success: function (a, operation, context) {
		    	 btn.up('window').hide();
		    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		    	tab.funcionRecargar();
           },
           failure: function (a, operation, context) {
           	  Ext.toast({
				 html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
				 width: 360,
				 height: 100,
				 align: 't'									     
			  });
           }
	    });
		}else  {
			me.fireEvent("errorToast", 'Porfavor, revise los campos obligatorios');
		}
	},
	
	onClickBotonAnyadirPropietario: function(btn) {		
		var me = this;	
		var url =  $AC.getRemoteUrl('activo/createActivoPropietarioTab');
		form= btn.up('window').down('formBase').getForm();
		formulario= btn.up('window').down('formBase');
		var window = btn.up('window');
		var padre = window.floatParent;
		var tab = padre.down('tituloinformacionregistralactivo');
		
 		var activo = me.getViewModel().get('activo');	
 		var propietario = me.getViewModel().get('propietario');
 		
		var params={"idActivo":activo.get('id')};
		params['porcPropiedad']=form.findField("porcPropiedad").getValue();
		params['tipoGradoPropiedadCodigo']=form.findField("tipoGradoPropiedad").getValue();
		params['tipoPersonaCodigo']=form.findField("tipoPersona").getValue();
		params['nombre']=form.findField("nombre").getValue();
		params['tipoDocIdentificativoCodigo']=form.findField("tipoDoc").getValue();
		params['docIdentificativo']=form.findField("numDoc").getValue();
		params['direccion']=form.findField("direccion").getValue();
		params['provinciaCodigo']=form.findField("provincia").getValue();
		params['localidadCodigo']=form.findField("localidad").getValue();
		params['codigoPostal']=form.findField("codigoPostal").getValue();
		params['telefono']=form.findField("telefono").getValue();
		params['email']=form.findField("email").getValue();
		params['tipoPropietario']="Copropietario";

		porc = params.porcPropiedad;
		grado = params.tipoGradoPropiedadDescripcion;
		nombre = params.nombre;
		params['nombreContacto']=propietario.nombreContacto;
		params['telefono1Contacto']=propietario.telefonoContacto1;
		params['telefono2Contacto']=propietario.telefonoContacto2;
		params['emailContacto']=propietario.emailContacto;
		params['provinciaContactoCodigo']=propietario.provinciaContactoCodigo;
		params['localidadContactoCodigo']=propietario.localidadContactoCodigo;
		params['codigoPostalContacto']=propietario.codigoPostalContacto;
		params['direccionContacto']=propietario.direccionContacto;
		params['observaciones']=propietario.observacionesContacto;
		
		if(formulario.isFormValid()){
			Ext.Ajax.request({
			     url: url,
			     params:params,
			     success: function (a, operation, context) {
			    	 btn.up('window').hide();
			    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			    	tab.funcionRecargar();
	           },
	           failure: function (a, operation, context) {
	           	  Ext.toast({
					 html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
					 width: 360,
					 height: 100,
					 align: 't'									     
				  });
	           }
		    });
		}else  {
			me.fireEvent("errorToast", 'Porfavor, revise los campos obligatorios');
		}
		
	},
	
	onTramitesListDobleClick : function(grid,record) {
    	var me = this;
    	//HREOS-846 Si el activo esta fuera del perimetro Haya, no debe poder abrir tramites desde el activo
    	if(me.getViewModel().get('activo').get('incluidoEnPerimetro')=="false") {
    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.activo.fuera.perimetro.abrir.tramite.ko"));
   		}
    	else {
    		me.getView().fireEvent('abrirDetalleTramite', grid,record);
		}
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
     * FunciÃ³n que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la funciÃ³n 
     * funciÃ³nRecargar con el cÃ³digo necesario para refrescar los datos.
     */
	onClickBotonRefrescar: function (btn) {
		var me = this;
		me.refrescarActivo(true);

	},
	
	refrescarActivo: function(refrescarPestanyaActiva) {
		var me = this,
		refrescarPestanyaActiva = Ext.isEmpty(refrescarPestanyaActiva) ? false: refrescarPestanyaActiva,
		activeTab = me.getView().down("tabpanel").getActiveTab();		
  		
		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene funciÃ³n de recargar 
		if(refrescarPestanyaActiva && activeTab.funcionRecargar) {
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
		var me = this,
		idActivo = me.getViewModel().get("activo.id");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		record.erase({
			params: {idEntidad: idActivo},
            success: function(record, operation) {
            	 grid.fireEvent("afterdelete", grid);
           		 me.getView().unmask();
           		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
            },
            failure: function(record, operation) {
				 grid.fireEvent("afterdelete", grid);
				 me.getView().unmask();
                 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
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
		config.params.nombreDocumento=record.get("nombre");
		me.fireEvent("downloadFile", config);
	},
	
	
	updateOrdenFotosInterno: function(data, record, store) {

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
				
				//FIXME: Â¿Poner mÃ¡scara?
				//me.getView().mask(HreRem.i18n("msg.mask.loading"));
				var url =  $AC.getRemoteUrl('activo/updateFotosById');
    			Ext.Ajax.request({
    			
	    		     url: url,
	    		     params: {
	    		     			id: store.getAt(i).data.id,
	    		     			orden: store.getAt(i).data.orden 	
	    		     		}
	    			
	    		    ,success: function (a, operation, context) {

	                    if (me.ordenGuardado >= me.storeGuardado.getData().items.length && me.refrescarGuardado) {
	                    	me.storeGuardado.load();
	                    	me.refrescarGuardado = false;
	                    	/* //FIXME: Â¿Poner mÃ¡scara?
	                    	Ext.toast({
							     html: 'LA OPERACIÃN SE HA REALIZADO CORRECTAMENTE',
							     width: 360,
							     height: 100,
							     align: 't'
							});*/
							//me.getView().unmask();
	                    }
	                    
	                    
	                    
	                },
	                
	                failure: function (a, operation, context) {
	                	  Ext.toast({
						     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÃN',
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
			    		
			        	var url =  $AC.getRemoteUrl('activo/deleteFotosActivoById');
			    		Ext.Ajax.request({
			    			
			    		     url: url,
			    		     params: {id : idSeleccionados},
			    		
			    		     success: function (a, operation, context) {
                                	
                                	storeTemp.load();

                                	var data = Ext.decode(a.responseText);
                                	if(data.success == "true"){
                                		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                                	}else{
                                		me.fireEvent("errorToast", data.error);
                                	}
                                	
                                },
                                
                                failure: function (a, operation, context) {

                                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
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
			
			config.params.idFoto=storeTemp.getAt(nodos[0].getAttribute('data-recordindex')).getId();
			
			me.fireEvent("downloadFile", config);
		}
	},
    
    
    // Se deja planteado para fase 2, pero para fase 1 se elimina el botÃ³n imprimir.
	onPrintFotoClick: function(btn) {
		
		var me = this;
		
		var nodos = btn.up('form').down('dataview').getSelectedNodes();
		
	    if(nodos) {
	        
	        node = nodos[0];
			cmp  = me.findComponentByElement(node);
	        
	        html = cmp.container.dom.innerHTML;

	        var win = window.open();
	        win.document.write(html);
	        win.print();
	        win.close();
	    }

	},
	
	// Se deja planteado para fase 2, pero para fase 1 se elimina el botÃ³n imprimir.
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
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		
		me.getViewModel().data.storeFotos.getProxy().setExtraParams({'id':idActivo, tipoFoto: '01'}); 
		me.getViewModel().data.storeFotosTecnicas.getProxy().setExtraParams({'id':idActivo, tipoFoto: '02'}); 
		
		me.getViewModel().data.storeFotos.on('load',function(){
			me.getViewModel().data.storeFotosTecnicas.load();
		});
		
		me.getViewModel().data.storeFotosTecnicas.on('load',function(){
			me.getView().unmask();
		});
		me.getViewModel().data.storeFotos.load();	

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
	
	
	//FIXME: Funciones para el grÃ¡fico de presupuestos. Llevar a otro controlador aparte.
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

    	latLng.latitud = me.getViewModel().get("informeComercial.latitud");
    	latLng.longitud= me.getViewModel().get("informeComercial.longitud");
    	geoCodeAddr = me.getViewModel().get("geoCodeAddr");
    	
    	Ext.create("HreRem.ux.window.geolocalizacion.ValidarGeoLocalizacion", {geoCodeAddr: geoCodeAddr, latLng: latLng,  parent: btn.up("form")}).show();  	
    },
    
    // Este mÃ©todo comprueba si el municipio es 'Barcelona, Madrid, Valencia o Alicante/Alacant'.
    checkDistrito: function(combobox) {
    	var me = this;
    	var view = me.getView();
    	var distrito = combobox.getRawValue();
    	
    	// Comprobar distrito y mostrar u ocultar el textfield de distrito.
    	if(Ext.isEmpty(distrito)) {
    		view.lookupReference('fieldlabelDistrito').hide();
    	} else if(distrito === 'Valencia'){
    		view.lookupReference('fieldlabelDistrito').show();
    	} else if(distrito === 'Barcelona') {
    		view.lookupReference('fieldlabelDistrito').show();
    	} else if(distrito === 'Madrid') {
    		view.lookupReference('fieldlabelDistrito').show();
    	} else if(distrito === 'Alicante/Alacant') {
    		view.lookupReference('fieldlabelDistrito').show();
    	} else {
    		view.lookupReference('fieldlabelDistrito').hide();
    	}
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

    // Funcion que se ejecuta al hacer click en el botÃ³n limpiar
	onCleanFiltersClick: function(btn) {
		btn.up('form').getForm().reset();
	},

    // Esta funciÃ³n es llamada cuando cambia el estado de publicaciÃ³n del activo.
    onChangeEstadoPublicacion: function(field){
    	var me = this;
    	var view = me.getView();
    	var codigo = me.getViewModel().getData().getEstadoPublicacionCodigo;

    	switch (codigo){
    	case "01": // Publicado.
    		view.lookupReference('seccionPublicacionForzada').hide();
    		view.lookupReference('seccionOcultacionForzada').show();
    		view.lookupReference('seccionOcultacionPrecio').show();
    		view.lookupReference('seccionDespublicacionForzada').show();
    		break;
    	case "02": // PublicaciÃ³n forzada.
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
    	case "07": // Publicado forzado con precio oculto.
    		view.lookupReference('seccionPublicacionForzada').show();
    		view.lookupReference('seccionOcultacionForzada').hide();
    		view.lookupReference('seccionOcultacionPrecio').show();
    		view.lookupReference('seccionDespublicacionForzada').hide();
    		break;
    	default: // Por defecto se trata como No Publicado.
    		view.lookupReference('seccionPublicacionForzada').show();
			view.lookupReference('seccionOcultacionForzada').hide();
			view.lookupReference('seccionOcultacionPrecio').hide();
			view.lookupReference('seccionDespublicacionForzada').hide();
    		break;
    	}
    },
    
    // Esta funcion es llamada cuando algÃºn checkbox del apartado de 'Estados de publicaciÃ³n' es activado
    // y se encarga de permitir tener sÃ³lo un checkbox de estado activado. AdemÃ¡s, reinicia el estado de
    // los componentes de cada secciÃ³n que no estÃ© seleccionada.
    onchkbxEstadoPublicacionChange: function(chkbx) {
    	var me = this;
    	var id = chkbx.getReference();
    	var view = me.getView();

    	if(!chkbx.getValue()){
    		// Si el checkbox esta siendo desactivado, tan sÃ³lo resetear conenido textbox de la propia secciÃ³n del checkbox.
    		// Si el checkbox es de la secciÃ³n de publicaciÃ³n, no hacer nada.
    		switch (id){
    		case "chkbxpublicacionordinaria":
    			view.lookupReference('textfieldpublicacionpublicar').reset();
    			view.lookupReference('textfieldpublicacionpublicar').setAllowBlank(true);
    			break;
    		case "chkbxpublicacionforzada":
    			view.lookupReference('textfieldpublicacionpublicar').reset();
    			view.lookupReference('textfieldpublicacionpublicar').setAllowBlank(true);
    			break;
        	case "chkbxpublicacionocultarprecio":
        		// textfield.
        		view.lookupReference('textfieldpublicacionocultacionprecio').reset();
    			view.lookupReference('textfieldpublicacionocultacionprecio').setAllowBlank(true);
        		// textarea.
        		view.lookupReference('textareapublicacionocultacionprecio').reset();
        		break;
        	case "chkbxpublicaciondespublicar":
        		// checkbox.
        		view.lookupReference('chkbxpublicacionforzada').setValue(me.chkbxPublicacionForzadaLastState);
        		view.lookupReference('chkbxpublicacionordinaria').setValue(me.chkbxPublicacionOrdinariaLastState);
        		// textfield.
        		view.lookupReference('textfieldpublicaciondespublicar').reset();
        		view.lookupReference('textfieldpublicaciondespublicar').setAllowBlank(true);
        		break;
        	case "chkbxpublicacionocultacionforzada":
        		// textfield.
        		view.lookupReference('textfieldpublicacionocultacionforzada').reset();
				view.lookupReference('textfieldpublicacionocultacionforzada').setAllowBlank(true);
        		break;
        	default:
        		break;
        	}
    		return;
    	}

    	switch (id){
    	case "chkbxpublicacionordinaria":
    		// checkbox.
    		//view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		//view.lookupReference('chkbxpublicacionforzada').setValue(false);
    		// textfield.
    		//view.lookupReference('textfieldpublicacionocultacionprecio').reset();
    		view.lookupReference('textfieldpublicaciondespublicar').reset();
    		view.lookupReference('textfieldpublicacionocultacionforzada').reset();
    		view.lookupReference('textfieldpublicacionpublicar').reset();
    		//view.lookupReference('textfieldpublicacionocultacionprecio').setAllowBlank(true);
    		view.lookupReference('textfieldpublicaciondespublicar').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionocultacionforzada').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionpublicar').setAllowBlank(false);
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	case "chkbxpublicacionforzada":
    		// checkbox.
    		view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		//view.lookupReference('chkbxpublicacionordinaria').setValue(false);
    		// textfield.
    		view.lookupReference('textfieldpublicacionocultacionprecio').reset();
    		view.lookupReference('textfieldpublicaciondespublicar').reset();
    		view.lookupReference('textfieldpublicacionocultacionforzada').reset();
    		view.lookupReference('textfieldpublicacionocultacionprecio').setAllowBlank(true);
    		view.lookupReference('textfieldpublicaciondespublicar').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionocultacionforzada').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionpublicar').setAllowBlank(false);
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	case "chkbxpublicacionocultarprecio":
    		// checkbox.
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		// textfield.
    		view.lookupReference('textfieldpublicacionpublicar').reset();
    		view.lookupReference('textfieldpublicaciondespublicar').reset();
    		view.lookupReference('textfieldpublicacionocultacionforzada').reset();
    		view.lookupReference('textfieldpublicacionocultacionprecio').setAllowBlank(false);
    		view.lookupReference('textfieldpublicaciondespublicar').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionocultacionforzada').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionpublicar').setAllowBlank(true);
    		break;
    	case "chkbxpublicaciondespublicar":
    		me.chkbxPublicacionForzadaLastState = view.lookupReference('chkbxpublicacionforzada').getValue();
    		view.lookupReference('chkbxpublicacionforzada').setValue(false);
    		me.chkbxPublicacionOrdinariaLastState = view.lookupReference('chkbxpublicacionordinaria').getValue();
    		view.lookupReference('chkbxpublicacionordinaria').setValue(false);
    		view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicacionocultacionforzada').setValue(false);
    		// textfield.
    		view.lookupReference('textfieldpublicacionpublicar').reset();
    		view.lookupReference('textfieldpublicacionocultacionprecio').reset();
    		view.lookupReference('textfieldpublicacionocultacionforzada').reset();
    		view.lookupReference('textfieldpublicacionocultacionprecio').setAllowBlank(true);
    		view.lookupReference('textfieldpublicaciondespublicar').setAllowBlank(false);
    		view.lookupReference('textfieldpublicacionocultacionforzada').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionpublicar').setAllowBlank(true);
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	case "chkbxpublicacionocultacionforzada":
    		// checkbox.
    		view.lookupReference('chkbxpublicacionocultarprecio').setValue(false);
    		view.lookupReference('chkbxpublicaciondespublicar').setValue(false);
    		// textfield.
    		view.lookupReference('textfieldpublicacionpublicar').reset();
    		view.lookupReference('textfieldpublicacionocultacionprecio').reset();
    		view.lookupReference('textfieldpublicaciondespublicar').reset();
    		view.lookupReference('textfieldpublicacionocultacionprecio').setAllowBlank(true);
    		view.lookupReference('textfieldpublicaciondespublicar').setAllowBlank(true);
    		view.lookupReference('textfieldpublicacionocultacionforzada').setAllowBlank(false);
    		view.lookupReference('textfieldpublicacionpublicar').setAllowBlank(true);
    		// textarea.
    		view.lookupReference('textareapublicacionocultacionprecio').reset();
    		break;
    	default:
    		break;
    	}
    },
    
    // Esta funciÃ³n es llamada cuando cambia el estado del combo 'otro' en los
    // condicionantes de la publicaciÃ³n del activo. Muestra u oculta el Ã¡rea de
    // texto que muestra el condicionante 'otro'.
    onChangeComboOtro: function(combo) {
    	var me = this;
    	var view = me.getView();

    	if(combo.getValue() === '0'){
    		view.lookupReference('fieldtextCondicionanteOtro').allowBlank=true;
    		view.lookupReference('fieldtextCondicionanteOtro').setValue('');
    		view.lookupReference('fieldtextCondicionanteOtro').hide();
    	} else {
    		view.lookupReference('fieldtextCondicionanteOtro').show();
    		view.lookupReference('fieldtextCondicionanteOtro').allowBlank=false;
    		view.lookupReference('fieldtextCondicionanteOtro').isValid();
    	}
    },
    
    onClickAbrirExpedienteComercial: function(grid, rowIndex, colIndex) {
    	
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	me.getView().fireEvent('abrirDetalleExpediente', record);
    	
    },
    
    onEnlaceTrabajoClick: function(grid, rowIndex, colIndex) {
    	
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	record.data.id=record.data.idTrabajo;
    	me.getView().fireEvent('abrirDetalleTrabajo', record);
    	
    },
    
    onEnlaceTramiteClick: function(grid, rowIndex, colIndex) {
    	
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	me.getView().fireEvent('abrirDetalleTramite', grid, record);	
    },
    
    onClickBotonCancelarOferta: function(btn) {	
		var me = this,
		window = btn.up('window');
    	window.close();
	},
	
	onClickBotonGuardarOferta: function(btn){
		var me =this;
		var window= btn.up('window'),
		form= window.down('formBase');
		var success = function(record, operation) {
			form.unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	//window.parent.funcionRecargar();
	    	window.parent.up('activosdetalle').lookupController().refrescarActivo(true);
	    	window.destroy();    
		};
		me.onSaveFormularioCompletoOferta(form, success);
	},
	
	onChkbxOfertasAnuladas: function(chkbox, checked){
    	var me = this;
    	var grid = chkbox.up('ofertascomercialactivo').down("ofertascomercialactivolist");
    	var store = me.getViewModel().get("storeOfertasActivo");
    	
    	var prox = store.getProxy();
    	var _id = prox.getExtraParams().id;
    	var _incluirOfertasAnuladas = checked;
    	
    	prox.setExtraParams({
    		"id": _id, 
    		"incluirOfertasAnuladas": _incluirOfertasAnuladas
    	});
    	store.load();
	},
	
	// Este mÃ©todo copia los valores de los campos de 'Datos Mediador' a los campos de 'Datos admisiÃ³n'.
	onClickCopiarDatosDelMediador: function(btn) {
		var me =this;
		var view = me.getView();

		view.lookupReference('tipoActivoAdmisionInforme').setValue(view.lookupReference('tipoActivoMediadorInforme').getValue());
		view.lookupReference('subtipoActivoComboAdmisionInforme').setValue(view.lookupReference('subtipoActivoComboMediadorInforme').getValue());
		view.lookupReference('tipoViaAdmisionInforme').setValue(view.lookupReference('tipoViaMediadorInforme').getValue());
		view.lookupReference('nombreViaAdmisionInforme').setValue(view.lookupReference('nombreViaMediadorInforme').getValue());
		view.lookupReference('numeroAdmisionInforme').setValue(view.lookupReference('numeroMediadorInforme').getValue());
		view.lookupReference('escaleraAdmisionInforme').setValue(view.lookupReference('escaleraMediadorInforme').getValue());
		view.lookupReference('plantaAdmisionInforme').setValue(view.lookupReference('plantaMediadorInforme').getValue());
		view.lookupReference('puertaAdmisionInforme').setValue(view.lookupReference('puertaMediadorInforme').getValue());
		view.lookupReference('codPostalAdmisionInforme').setValue(view.lookupReference('codPostalMediadorInforme').getValue());
		view.lookupReference('municipioComboAdmisionInforme').setValue(view.lookupReference('municipioComboMediadorInforme').getValue());
		view.lookupReference('poblacionalAdmisionInforme').setValue(view.lookupReference('poblacionalMediadorInforme').getValue());
		view.lookupReference('provinciaComboAdmisionInforme').setValue(view.lookupReference('provinciaComboMediadorInforme').getValue());
		view.lookupReference('latitudAdmisionInforme').setValue(view.lookupReference('latitudmediador').getValue());
		view.lookupReference('longitudAdmisionInforme').setValue(view.lookupReference('longitudmediador').getValue());
		
	},
	
	onSaveFormularioCompletoOferta: function(form, success) {
		var me = this;
		record = form.getBindRecord();
		success = success || function() {me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));};  

		if(form.isFormValid()) {

			form.mask(HreRem.i18n("msg.mask.espere"));

			record.save({
			    success: success,
			 	failure: function(record, operation) {
			 		var response = Ext.decode(operation.getResponse().responseText);
			 		if(response.success === "false" && Ext.isDefined(response.msg)) {
						me.fireEvent("errorToast", Ext.decode(operation.getResponse().responseText).msg);
						form.unmask();
					} else {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				 		form.unmask();
					}
			    }

			});
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
		
	},
	
	onActivosVinculadosClick: function(tableView, indiceFila, indiceColumna) {
    	var me = this;
    	var grid = tableView.up('grid');
    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);

    	me.getView().fireEvent('abrirDetalleActivo', record.get('idActivo'), "Activo " + record.get("numActivo"));
	},
	
	// Este mÃ©todo comprueba si el campo fechaHasta o UsuarioBaja tiene datos, lo que supone que el registro
	// ya se encuentra dado de baja y no se permite volver a dar de baja.
	onGridCondicionesEspecificasRowClick: function(grid , record , tr , rowIndex) {
		if(!Ext.isEmpty(record.getData().fechaHasta) || !Ext.isEmpty(record.getData().usuarioBaja)){
			grid.up().disableRemoveButton(true);
		}
	},
	
	//MÃ©todo para borrar/anular un precio vigente sin guardar en el Historico
	onDeletePrecioVigenteClick: function(tableView, indiceFila, indiceColumna) {

    	var me = this;
    	var grid = tableView.up('grid');

    	var idPrecioVigente = grid.store.getAt(indiceFila).get('idPrecioVigente');
		
		if(idPrecioVigente != null) {
			grid.mask(HreRem.i18n("msg.mask.espere"));
		
			Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.borrado.precio.vigente'),
			   msg: HreRem.i18n('msg.confirmar.borrado.precio.vigente'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {

			        if (buttonId == 'yes') {
			        	
			        	var storeTemp = grid.getStore();
			        	
			        	var url =  $AC.getRemoteUrl('activo/deletePrecioVigenteSinGuardadoHistorico');
			    		Ext.Ajax.request({
			    			
							url: url,
							params: {idPrecioVigente : idPrecioVigente},
							
							success: function (response,opts) {
								
								if(Ext.decode(response.responseText).success == "false") {
									me.fireEvent("errorToast", HreRem.i18n("msg.error.borrar.precio.vigente"));
								}
								else {
									storeTemp.load();
									me.refrescarActivo(true);
									me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								}
								
							},
                                
                            failure: function (a, operation, context) {

                            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                            }
			    		     
			    		 });
					}

		        }
	        });
			grid.unmask();
		}
		else {
			me.fireEvent("infoToast", HreRem.i18n("msg.info.seleccionar.precio"));
		}

	},
	
	// MÃ©todo que es llamado cuando se solicita la tasaciÃ³n del activo desde Bankia.
	onClickSolicitarTasacionBankia: function(btn) {
		var me = this;
    	var idActivo = me.getViewModel().get("activo.id");
    	var url = $AC.getRemoteUrl('activo/solicitarTasacion');

		me.getView().mask(HreRem.i18n("msg.mask.loading"));	    	
		
		Ext.Ajax.request({
    		url: url,
    		params: {idActivo : idActivo},
    		
    		success: function(response, opts){
    			var obj = Ext.decode(response.responseText);
    		    if (obj.success == 'true') {
    		    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
        			btn.up('tasacionesactivo').funcionRecargar();
        			me.getView().unmask();
    		    } else {
    		    	Utils.defaultRequestFailure(response, opts);
    		    }
    		    
    		},
    		
		 	failure: function(response, opts) {
		 		Utils.defaultRequestFailure(response, opts);
		    }
    	});
	},
	
	onVisitasListDobleClick: function(grid,record,tr,rowIndex) {        	       
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	
    	Ext.create('HreRem.view.comercial.visitas.VisitasComercialDetalle',{detallevisita: record}).show();
    	
        	
    },
    
   	onClickBotonCerrarDetalleVisita: function(btn) {
		var me = this,
		window = btn.up('window');
    	window.close();
	},
	
	onProveedoresListClick: function(gridView, record){
//		var me=this,
//		idCliente = record.get("id"),
//		model = Ext.create('HreRem.model.FichaComprador');
//		
//		var fieldset =  me.lookupReference('estadoPbcCompradoRef');
//		fieldset.mask(HreRem.i18n("msg.mask.loading"));
//	
//		model.setId(idCliente);
//		model.load({			
//		    success: function(record) {	
//		    	me.getViewModel().set("detalleComprador", record);
//		    	fieldset.unmask();
//		    }
//		});
		var me=this;
		idProveedor= record.get('id');
		idActivo= record.get('idActivo');
		gridView.up('form').down('[reference=listadogastosref]').getStore().getProxy().setExtraParams({'idActivo': idActivo,'idProveedor': idProveedor});
		gridView.up('form').down('[reference=listadogastosref]').getStore().load();
		
		
	},
	
	// Función que abre la pestaña de proveedor.
   abrirPestanyaProveedor: function(tableView, indiceFila, indiceColumna){
   		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    
	    if(!Ext.isEmpty(record.get('idProveedor'))){
	    	var idProveedor = record.get("idProveedor");
	    	record.data.id= idProveedor;
	    	me.getView().fireEvent('abrirDetalleProveedor', record);
	    }
	    else if(!Ext.isEmpty(record.get('id'))){
	    	var codigoProveedor = record.get('codigoProveedorRem');
	    	record.data.codigo = codigoProveedor;
	    	me.getView().fireEvent('abrirDetalleProveedor', record);
	    }
   },
   
   	onClickAbrirGastoProveedor: function(grid, record){
		var me = this;
		record.setId(record.data.idGasto);
		
    	me.getView().fireEvent('abrirDetalleGasto', record);
		
	},
	
	onClickAbrirGastoProveedorIcono: function(tableView, indiceFila, indiceColumna){
		var me = this;
		
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    if(!Ext.isEmpty(record.get('id'))){
//	   		me.redirectTo('activos', true);
	    	record.setId(record.data.idGasto);
	    	me.getView().fireEvent('abrirDetalleGasto', record);
	    }
	},

	//Este mÃ©todo obtiene los valores de las fechas fin e inicio de la fila que se estÃ¡ editando y comprueba las validaciones oportunas.
	validateFechas: function(datefield, value){
		var me = this;
		var grid = me.lookupReference('gridPreciosVigentes');
		if(Ext.isEmpty(grid)){ return true;}
		var selected = grid.getSelectionModel().getSelection();
		// Obtener columnas automÃ¡ticamente por 'dataindex = fechaFin' y 'dataindex = fechaInicio'.
		var fechaFinActualRow = grid.columns[Ext.Array.indexOf(Ext.Array.pluck(grid.columns, 'dataIndex'), 'fechaFin')];
		var fechaInicioActualRow = grid.columns[Ext.Array.indexOf(Ext.Array.pluck(grid.columns, 'dataIndex'), 'fechaInicio')];

		if(!Ext.isEmpty(selected)) {
			// Almacenar la fila selecciona para cuando estÃ© siendo editada.
			grid.codigoTipoPrecio = selected[0].getData().codigoTipoPrecio;
		}

		// Constantes.
		var tipoMinimoAutorizado = '04';
		var tipoAprobadoVentaWeb = '02';
		var tipoAprobadoRentaWeb = '03';
		var tipoDescuentoAprobado = '07';
		var tipoDescuentoPublicadoWeb = '13';

		// Recogemos los valores actuales del grid y los mismos almacenados en el store segÃºn casos.
		var fechaInicioMinimo = fechaInicioActualRow.getEditor().value;
		var fechaInicioExistenteMinimo = grid.getStore().findRecord('codigoTipoPrecio', tipoMinimoAutorizado).getData().fechaInicio;
		var fechaFinMinimo = grid.getStore().findRecord('codigoTipoPrecio', tipoMinimoAutorizado).getData().fechaFin;
		var fechaFinAprobadoVentaWeb = fechaFinActualRow.getEditor().value;
		var fechaFinExistenteAprobadoVentaWeb = grid.getStore().findRecord('codigoTipoPrecio', tipoAprobadoVentaWeb).getData().fechaFin;
		var fechaInicioAprobadoVentaWeb = fechaInicioActualRow.getEditor().value;
		var fechaInicioExistenteAprobadoVentaWeb = grid.getStore().findRecord('codigoTipoPrecio', tipoAprobadoVentaWeb).getData().fechaInicio;
		var fechaInicioDescuentoAprobado = fechaInicioActualRow.getEditor().value;
		var fechaInicioExistenteDescuentoAprobado = grid.getStore().findRecord('codigoTipoPrecio', tipoDescuentoAprobado).getData().fechaInicio;
		var fechaFinDescuentoAprobado = fechaFinActualRow.getEditor().value;
		var fechaFinExistenteDescuentoAprobado = grid.getStore().findRecord('codigoTipoPrecio', tipoDescuentoAprobado).getData().fechaFin;
		var fechaInicioDescuentoPublicadoWeb = fechaInicioActualRow.getEditor().value;
		var fechaFinDescuentoPublicadoWeb = fechaFinActualRow.getEditor().value;
		var fechaInicioExistenteDescuentoPublicadoWeb= grid.getStore().findRecord('codigoTipoPrecio', tipoDescuentoPublicadoWeb).getData().fechaInicio;
		var fechaFinExistenteDescuentoPublicadoWeb= grid.getStore().findRecord('codigoTipoPrecio', tipoDescuentoPublicadoWeb).getData().fechaFin;

		var codTipoPrecio = grid.codTipoPrecio;

		switch(codTipoPrecio) {
			case tipoMinimoAutorizado:
				if(datefield.dataIndex === 'fechaInicio') {
					// La fecha de inicio
					if(Ext.isEmpty(fechaInicioMinimo)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					} else {
						if(fechaInicioMinimo > new Date()) {
							// Ha de ser menor o igual a hoy
							return HreRem.i18n('info.datefield.begin.date.today.msg.validacion');
						}
					}
				}
				return true;
			case tipoAprobadoVentaWeb: // La fecha de fin de aprobado venta(web) debe ser menor o igual a la fecha fin mÃ­nimo.
				if(datefield.dataIndex === 'fechaFin') {
					// La fecha de fin
					if(Ext.isEmpty(fechaFinMinimo) || Ext.isEmpty(fechaFinAprobadoVentaWeb)) {
						// Si la fecha contra la que compara o la misma no estÃ¡n definidas, se valida positivo.
						return true;
					}
					if(fechaFinAprobadoVentaWeb > fechaFinMinimo) {
						// Ha de ser menor o igual a la fecha fin mÃ­nimo.
						return HreRem.i18n('info.fecha.fin.aprobadoVentaWeb.msg.validacion');
					}
				} else {
					// La fecha de inicio
					if(!Ext.isEmpty(fechaInicioExistenteMinimo)) {
						// Si la fecha inicio mÃ­nimo estÃ¡ definida
						if(!Ext.isEmpty(fechaInicioAprobadoVentaWeb) && fechaInicioAprobadoVentaWeb < fechaInicioExistenteMinimo) {
							// Si la propia fecha estÃ¡ definida, ha de ser mayor o igual que la fecha inicio mÃ­nimo
							return HreRem.i18n('info.datefield.begin.date.pav.msg.validacion');
						}
					}
				}
				return true;
			case tipoDescuentoAprobado:
				if(datefield.dataIndex === 'fechaFin') {
					// La fecha de fin
					if(Ext.isEmpty(fechaFinDescuentoAprobado)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if(!Ext.isEmpty(fechaFinExistenteDescuentoPublicadoWeb) && fechaFinExistenteDescuentoPublicadoWeb > fechaFinDescuentoAprobado) {
						// Ha de ser menor o igual que la fecha fin aprobado venta web
						return HreRem.i18n('info.datefield.end.date.pdw2.msg.validacion');
					}
				} else {
					// La fecha de inicio
					if(Ext.isEmpty(fechaInicioDescuentoAprobado)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if(!Ext.isEmpty(fechaInicioExistenteDescuentoPublicadoWeb) && fechaInicioExistenteDescuentoPublicadoWeb < fechaInicioDescuentoAprobado) {
						// Ha de ser mayor o igual que la fecha inicio aprobado venta web
						return HreRem.i18n('info.datefield.begin.date.pdw2.msg.validacion');
					}
				}
				return true;
			case tipoDescuentoPublicadoWeb:
				if(datefield.dataIndex === 'fechaFin') {
					// La fecha de fin
					if(Ext.isEmpty(fechaFinDescuentoPublicadoWeb)) {
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if(!Ext.isEmpty(fechaInicioExistenteDescuentoAprobado) && fechaInicioDescuentoPublicadoWeb < fechaInicioExistenteDescuentoAprobado) {
						// Ha de ser mayor o igual que la fecha fin descuento aprobado, si existe
						return HreRem.i18n('info.datefield.begin.date.pdw.msg.validacion');
					}
					if(!Ext.isEmpty(fechaFinExistenteDescuentoAprobado) && fechaFinExistenteDescuentoAprobado < fechaFinDescuentoPublicadoWeb) {
						// Ha de ser mayor o igual que la fecha fin aprobado venta web, si existe
						return HreRem.i18n('info.datefield.end.date.descuento.web');
					}
				} else {
					// La fecha de inicio
					if(Ext.isEmpty(fechaInicioDescuentoPublicadoWeb)){
						// No puede estar vacÃ­a
						return HreRem.i18n('info.fecha.precios.msg.validacion');
					}
					if(!Ext.isEmpty(fechaFinExistenteDescuentoAprobado) && fechaInicioDescuentoPublicadoWeb < fechaInicioExistenteDescuentoAprobado) {
						// Ha de ser menor o igual que la fecha inicio descuento aprobado, si existe
						return HreRem.i18n('info.datefield.begin.date.pdw.msg.validacion');
					}
//					if(!Ext.isEmpty(fechaFinExistenteAprobadoVentaWeb) && fechaInicioDescuentoPublicadoWeb > fechaFinExistenteAprobadoVentaWeb) {
//						// Ha de ser menor o igual que la fecha inicio aprobado venta web, si existe
//						return HreRem.i18n('info.datefield.begin.date.pdw.msg.validacion.dos');
//					}
				}
				return true;
			default:
				return true;
		}
	},

	// Este mÃ©todo obtiene el valor del campo importe que se estÃ¡ editando y comprueba las validaciones oportunas.
  // comprueba las validaciones oportunas.
	validatePreciosVigentes: function(value) {
		var me = this;
		var grid = me.lookupReference('gridPreciosVigentes');
		if(Ext.isEmpty(grid)){ return true;}
		var selected = grid.getSelectionModel().getSelection();
		// Obtener columna automÃ¡ticamente por 'dataindex = importe'.
		var importeActualColumn = grid.columns[Ext.Array.indexOf(Ext.Array.pluck(grid.columns, 'dataIndex'), 'importe')];

		if(!Ext.isEmpty(selected)) {
			// Almacenar la fila selecciona para cuando estÃ© siendo editada.
			grid.codTipoPrecio = selected[0].getData().codigoTipoPrecio;
		}

		// Constantes.
		var tipoMinimoAutorizado = '04';
		var tipoAprobadoVentaWeb = '02';
		var tipoAprobadoRentaWeb = '03';
		var tipoDescuentoAprobado = '07';
		var tipoDescuentoPublicadoWeb = '13';
		
		// Recogemos los valores actuales del grid
		var importeMinimo = parseFloat(grid.getStore().findRecord('codigoTipoPrecio', tipoMinimoAutorizado).getData().importe);
		var importeDescuentoAprobado = parseFloat(grid.getStore().findRecord('codigoTipoPrecio', tipoDescuentoAprobado).getData().importe);
		var importeDecuentoPublicadoWeb = parseFloat(grid.getStore().findRecord('codigoTipoPrecio', tipoDescuentoPublicadoWeb).getData().importe);
		var importeAprobadoVentaWeb = parseFloat(grid.getStore().findRecord('codigoTipoPrecio', tipoAprobadoVentaWeb).getData().importe);

		var codTipoPrecio = grid.codTipoPrecio;

		switch(codTipoPrecio) {
		case tipoMinimoAutorizado: // MÃ­nimo <= Aprobado venta web.

			var importeActualMinimo = importeActualColumn.getEditor().value; 
			
			if(!Ext.isEmpty(importeActualMinimo) && !Ext.isEmpty(importeAprobadoVentaWeb) && (importeActualMinimo > importeAprobadoVentaWeb)) {
				return HreRem.i18n('info.precio.importe.minimo.msg.validacion');
			}
			return true;
			
		case tipoDescuentoAprobado: // Descuento aprobado <= Descuento web <= Aprobado venta web

			var importeActualDescuentoAprobado = importeActualColumn.getEditor().value;

			if(!Ext.isEmpty(importeActualDescuentoAprobado) && !Ext.isEmpty(importeDecuentoPublicadoWeb) && (importeActualDescuentoAprobado > importeDecuentoPublicadoWeb)){
				return HreRem.i18n('info.precio.importe.descuentoAprobado.msg.validacion');
			}
//
//			if(!Ext.isEmpty(importeActualDescuentoAprobado) && !Ext.isEmpty(importeAprobadoVentaWeb) && (importeActualDescuentoAprobado > importeAprobadoVentaWeb)){
//				return HreRem.i18n('info.precio.importe.descuentoAprobado.msg.validacion');
//			}

			return true;

		case tipoDescuentoPublicadoWeb: // Descuento aprobado <= Descuento Web <= Aprobado venta web.

			var importeActualDescuentoWeb = importeActualColumn.getEditor().value;

			if(!Ext.isEmpty(importeActualDescuentoWeb) && !Ext.isEmpty(importeDescuentoAprobado) && (importeActualDescuentoWeb < importeDescuentoAprobado)) {
				return HreRem.i18n('info.precio.importe.descuentoPublicadoWeb.msg.validacion');
			}

//			if(!Ext.isEmpty(importeActualDescuentoWeb) && !Ext.isEmpty(importeAprobadoVentaWeb) && (importeActualDescuentoWeb > importeAprobadoVentaWeb)) {
//				return HreRem.i18n('info.precio.importe.descuentoPublicadoWeb.msg.validacion');
//			}

			return true;

		case tipoAprobadoVentaWeb: // MÃ­nimo <= Aprobado venta web.

			var importeActualAprobadoVentaWeb = importeActualColumn.getEditor().value;

			if(!Ext.isEmpty(importeActualAprobadoVentaWeb) && !Ext.isEmpty(importeMinimo) && (importeActualAprobadoVentaWeb < importeMinimo)) {
				return HreRem.i18n('info.precio.importe.aprobadoVenta.msg.validacion');
			}

//			if(!Ext.isEmpty(importeActualAprobadoVentaWeb) && !Ext.isEmpty(importeDescuentoAprobado) && (importeActualAprobadoVentaWeb < importeDescuentoAprobado)) {
//				return HreRem.i18n('info.precio.importe.aprobadoVenta.msg.validacion');
//			}

//			if(!Ext.isEmpty(importeActualAprobadoVentaWeb) && !Ext.isEmpty(importeDecuentoPublicadoWeb) && (importeActualAprobadoVentaWeb < importeDecuentoPublicadoWeb)) {
//				return HreRem.i18n('info.precio.importe.aprobadoVenta.msg.validacion');
//			}

			return true;

		default:
			return true;
		}
	},

	// Este mÃ©todo desmarca el checkbox de formalizar cuando el checkbox de comercializar se desmarca.
	onChkbxPerimetroChange: function(chkbx) {
		var me = this;
		var ref = chkbx.getReference();

		// Si se quita comercializar, hay que quitar tambien los datos de formalizacion en perimetro
		var chkbxPerimetroComercializar = me.lookupReference('chkbxPerimetroComercializar');
		var textFieldPerimetroComer = me.lookupReference('textFieldPerimetroComer');
		var comboMotivoPerimetroComer = me.lookupReference('comboMotivoPerimetroComer');
		var chkbxFormalizar = me.lookupReference('chkbxPerimetroFormalizar');
		var textFieldFormalizar = me.lookupReference('textFieldPerimetroFormalizar');
		var textFieldPerimetroGestion = me.lookupReference('textFieldPerimetroGestion');
		
		switch(ref){
		case 'chkbxPerimetroComercializar':
			if(!Ext.isEmpty(chkbxPerimetroComercializar.getValue()) && chkbxPerimetroComercializar.getValue()) {
				comboMotivoPerimetroComer.reset();
				textFieldPerimetroComer.reset();
			} else {
				textFieldPerimetroComer.reset();
				chkbxFormalizar.setValue(false);
				textFieldFormalizar.reset();
			}
			break;

		case 'chkbxPerimetroGestion':
			textFieldPerimetroGestion.reset();
			break;
			
		case 'chkbxPerimetroFormalizar':
			if(chkbxFormalizar.getValue() && !chkbxPerimetroComercializar.getValue()) {
				chkbxFormalizar.setValue(false);
				me.fireEvent("errorToast", HreRem.i18n("msg.error.perimetro.desmarcar.formalizar.con.comercializar.activado"));
			}
			else {
				textFieldFormalizar.reset();
			}
			break;
		default:
			break;
		}
	},

	abrirFormularioAnyadirEntidadActivo: function(grid) {
		var me = this;
		idActivo = me.getViewModel().get("activo.id");		
    	Ext.create("HreRem.view.activos.detalle.AnyadirEntidadActivo", {parent: grid, idActivo: idActivo}).show();	
	},

	onClickBotonCancelarEntidad: function(btn){
		var me = this,
		window = btn.up('window');
		var form= window.down('formBase');
		form.reset();
    	window.destroy();
	},

	buscarProveedor: function(field, e){
		var me= this;
		var url =  $AC.getRemoteUrl('gastosproveedor/searchProveedorCodigoByTipoEntidad');
		var codigoUnicoProveedor= field.getValue();
		var codigoTipoProveedor= CONST.TIPOS_PROVEEDOR['ENTIDAD'];
		var data;
		var nifEmisorField = field.up('formBase').down('[name=nifProveedor]');
		nombreProveedorField = field.up('formBase').down('[name=nombreProveedor]'),
		subtipoProveedorField = field.up('formBase').down('[name=subtipoProveedorField]');

		if(!Ext.isEmpty(codigoUnicoProveedor)){
			Ext.Ajax.request({
			    			
				url: url,
			    params: {codigoUnicoProveedor : codigoUnicoProveedor, codigoTipoProveedor: codigoTipoProveedor},
			    success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
			    	if(!Utils.isEmptyJSON(data.data)){
			    		var id= data.data.id;
			    		var nombreProveedor= data.data.nombreProveedor;
			    		var nifProveedor= data.data.nifProveedor;
			    		var subtipoProveedorDescripcion= data.data.subtipoProveedorDescripcion;
			    		    	 	
			    		if(!Ext.isEmpty(nifEmisorField)) {
			    			nifEmisorField.setValue(nifProveedor);
			    		}	    		    	 	
			    		if(!Ext.isEmpty(nombreProveedorField)) {
			    		    nombreProveedorField.setValue(nombreProveedor);
			    		}
			    		if(!Ext.isEmpty(subtipoProveedorField)) {
			    		    subtipoProveedorField.setValue(subtipoProveedorDescripcion);
			    		}			
			    	}
			    	else{
			    		if(!Ext.isEmpty(nombreProveedorField)) {
			    		    nombreProveedorField.setValue('');
			    		}
			    		if(!Ext.isEmpty(nifEmisorField)) {
			    		    nifEmisorField.setValue('');
			    		}
			    		if(!Ext.isEmpty(subtipoProveedorField)) {
			    			subtipoProveedorField.setValue('');
			    		}
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.proveedor.codigo"));
			    	}
			    },
			    failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    },
			    callback: function(options, success, response){
			    }
			});
		}
		else{
			nombreProveedorField.setValue('');
			nifEmisorField.setValue('');
			subtipoProveedorField.setValue('');
		}
	},
	
	onClickBotonGuardarEntidad: function(btn){
		var me= this;
		var window= btn.up('window'),
		form= window.down('formBase');
//		var success = function (a, operation, c) {
//					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
//					me.getView().unmask();
//					me.refrescarGasto(btn.up('tabpanel').getActiveTab().refreshAfterSave);
//		};
		
		me.onSaveFormularioCompletoActivoIntegrado(null, form);				
	},
	
	onSaveFormularioCompletoActivoIntegrado: function(btn, form){
		var me = this;
		var window = form.up('window');
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones.
		if(form.isFormValid() || form.disableValidation) {
			
			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);
			
			if(!Ext.isEmpty(btn)) {
				btn.hide();
				btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
				btn.up('tabbar').down('button[itemId=botoneditar]').show();
				
				if(Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
		 			me.getViewModel().set("editingFirstLevel", false);
		 		} else {
		 			me.getViewModel().set("editing", false);
		 		}
			}
		
			if (!form.saveMultiple) {
				
				
				if(Ext.isDefined(form.getBindRecord().getProxy().getApi().create)){
					form.getBindRecord().getProxy().extraParams.idActivo = form.down('field[name=idActivo]').getValue();
				}
				
				if(form.getBindRecord() != null && (Ext.isDefined(form.getBindRecord().getProxy().getApi().create) || Ext.isDefined(form.getBindRecord().getProxy().getApi().update))) {
					// Si la API tiene metodo de escritura (create or update).
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
					
					form.getBindRecord().save({
						success: function (a, operation, c) {
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							me.getView().unmask();
							form.reset();
							window.parent.up('datoscomunidadactivo').funcionRecargar();
							window.close();
			            },
				            
			            failure: function (a, operation) {
			            	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							 me.getView().unmask();
			            }
					});
				}
			//Guardamos mÃºltiples records	
			} else {
				var records = form.getBindRecords();
				var contador = 0;
				me.saveMultipleRecords(contador, records, form);
			}
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
		
	},
	
	onRetenerPagosChange: function(combo,a,b){
		var me= this;
		var form= combo.up('formBase');
		var motivoRetencionField= form.down('[name=motivoRetencion]');
		var fechaInicioRetencionField= form.down('[name=fechaInicioRetencion]');
		
		if(!combo.getValue()){
				motivoRetencionField.reset()
				fechaInicioRetencionField.reset();
				motivoRetencionField.setDisabled(true);
				fechaInicioRetencionField.setDisabled(true);
		}else{
			motivoRetencionField.setDisabled(false);
			fechaInicioRetencionField.setDisabled(false);
		}
	},
	
	onEntidadesListDobleClick: function(gridView,record){
		var me= this;
		var idActivoIntegrado= record.get('id');
		var idActivo = me.getViewModel().get("activo.id");	
		var storeGrid= gridView.store;
	    Ext.create("HreRem.view.activos.detalle.AnyadirEntidadActivo", {idActivoIntegrado: idActivoIntegrado,idActivo: idActivo,parent: gridView, modoEdicion: true, storeGrid:storeGrid}).show();

	},
	
	cargarDatosActivoIntegrado: function(window){
		var me = this,
		model = null,
		models = null,
		nameModels = null,
		id = window.idActivoIntegrado;
		
		if(!Ext.isEmpty(id)){
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
					    },
					    failure: function(record){
					    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
							me.getView().unmask();
					    }
					});
				}
			}
		}
		
		var form= window.down('formBase');
		form.setBindRecord(Ext.create('HreRem.model.ActivoIntegrado'));
		window.down('field[name=idActivo]').setValue(window.idActivo);
			        	
		Ext.Array.each(window.down('form').query('field[isReadOnlyEdit]'),
			function (field, index) 
				{ 								
					field.fireEvent('edit');
					if(index == 0) field.focus();
				}
		);
	},
	
	beforeLoadLlaves: function(store, operation, opts) {
		var me = this,
		idActivo = this.getViewModel().get('activo').id;
		me.lookupReference('movimientosllavelistref').disableAddButton(true);
		
		if(idActivo != null) {
			store.getProxy().extraParams = {idActivo: idActivo};	
			
			return true;
		}
	},
	
	onLlavesListClick: function(grid, record) {
		var me = this;
		
		me.lookupReference('fieldsetmovimientosllavelist').expand();	
		me.lookupReference('movimientosllavelistref').getStore().loadPage(1);
		
		if(!Ext.isEmpty(record.id))
			me.lookupReference('movimientosllavelistref').disableAddButton(false);
	},
	
	beforeLoadMovimientosLlave: function(store, operation, opts) {

		var me = this;		
		if(!Ext.isEmpty(me.getViewModel().get('llaveslistref').selection)) {
			var idLlave = me.getViewModel().get('llaveslistref').selection.id;
			
			if(idLlave != null && Ext.isNumber(parseInt(idLlave))) {
				store.getProxy().extraParams = {idLlave: idLlave};	
				
				return true;
			}
		}
		else {
			store.getProxy().extraParams = {idActivo: this.getViewModel().get('activo').id};
			me.lookupReference('movimientosllavelistref').disableAddButton(true);
			return true;
		}
	},
	
	onClickEditRowMovimientosLlaveList: function(editor, context, eOpts) {
		var me = this;

		if(context.rowIdx == 0) {
			var idLlave = me.getViewModel().get('llaveslistref').selection.id;
			context.record.data.idLlave = idLlave;
		}
	},
	
	//Llamar desde cualquier GridEditableRow, y asÃ­ se desactivaran las ediciones.
	quitarEdicionEnGridEditablePorFueraPerimetro: function(grid,record) {
		var me = this; 
		
		if(me.getViewModel().get('activo').get('incluidoEnPerimetro')=="false") {
			grid.setTopBar(false);
			grid.editOnSelect = false;
		}
	},
	
	// Este mÃ©todo filtra los anyos de construcciÃ³n y rehabilitaciÃ³n de una vivienda
	// de modo que si el value es '0' lo quita. Es una medida de protecciÃ³n al v-type
	// por que en la DB estÃ¡n establecidos a 0 todos los activos.
	onAnyoChange: function(field) {
		if(!Ext.isEmpty(field.getValue()) && field.getValue() === '0') {
			field.setValue('');
		}
	},
    
    ocultarChkPublicacionOrdinaria: function(record) {
    	var me = this,
    	ocultar = !me.getViewModel().get('activo').get('isPublicable'),
    	chkbxpublicacionordinaria = me.lookupReference('chkbxpublicacionordinaria');

    	chkbxpublicacionordinaria.setHidden(ocultar);
    },
    
    valdacionesEdicionLlavesList: function(editor, grid) {
    	var me = this,
    	textMotivo = me.lookupReference('motivoIncompletoRef'),
    	comboCompleto = me.lookupReference('cbColCompleto');
    	
    	if(editor.isNew) {
    		comboCompleto.setValue();
    		textMotivo.setValue();
    	}
    	
    	var activar = comboCompleto.getValue() == "0" && textMotivo.getValue()!=null;
    	me.activarDesactivarCampo(textMotivo,activar);
    	
    	var mostrarObligatoriedad = comboCompleto.getValue() == "0" && (textMotivo.getValue()==null || textMotivo.getValue() == "");
    	me.vaciarCampoMostrarRojoObligatoriedad(textMotivo,mostrarObligatoriedad, comboCompleto.getValue() == "1" )

    },
    
    //Activa o desactiva el campo
    activarDesactivarCampo: function(campo, activar) {
    	
    	if(activar) {
    		campo.setDisabled(false);
    		campo.allowBlank = false;
    	}
    	else {
    		campo.setValue();
    		campo.setDisabled(true);
    		campo.allowBlank = true;
    		
    	}
    },
    
    //Este mÃ©todo se usa para marcar en rojo el campo en primera instancia, o vaciar su contenido
    vaciarCampoMostrarRojoObligatoriedad: function(campo, mostrarObligatoriedad, vaciarCampo) {
    	if(mostrarObligatoriedad) {
    		campo.setValue(' ');
    		campo.setValue();
    	}
    	else if(vaciarCampo)
    		campo.setValue();
    },

    // Este mÃ©todo es llamado cuando se pulsa el botÃ³n 'ver' del ID de visita en el detalle de una oferta
    // y abre un pop-up con informaciÃ³n sobre la visita.
    onClickMostrarVisita: function(btn) {
    	var me = this;
    	var model = me.getViewModel().get('detalleOfertaModel');

    	if(Ext.isEmpty(model)) {
    		return;
    	}

    	var numVisita = model.get('numVisitaRem');

    	if(Ext.isEmpty(numVisita)) {
    		return;
    	}

    	me.getView().mask(HreRem.i18n("msg.mask.loading"));

		Ext.Ajax.request({
    		url: $AC.getRemoteUrl('visitas/getVisitaById'),
    		params: {numVisitaRem: numVisita},
    		
    		success: function(response, opts){
    			var record = JSON.parse(response.responseText);
    			if(record.success === 'true') {
    				var ventana = Ext.create('HreRem.view.comercial.visitas.VisitasComercialDetalle',{detallevisita: record});
    				me.getView().add(ventana);
    				ventana.show();
    			} else {
    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    			}
    		},
		 	failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    },
		    callback: function(record, operation) {
    			me.getView().unmask();
		    }
    	});
    },

    // Este mÃ©todo es llamado cuando se selecciona una oferta del listado de ofertas del activo.
    // Obtiene el ID de la oferta y carga sus detalles en la secciÃ³n 'Detalle ofertas'.
    onOfertaListClick: function (grid, record) {
		var me = this,
		form = grid.up("form"),
		model = Ext.create('HreRem.model.DetalleOfertaModel'),
		idOferta = null;
		var activo = me.getViewModel().get('activo');
		idActivo= activo.get('id');

		if(!Ext.isEmpty(grid.selection)){
			idOferta = record.get("idOferta");
		}

		var fieldset =  me.lookupReference('detalleOfertaFieldsetref');
		fieldset.mask(HreRem.i18n("msg.mask.loading"));

		// Cargar grid 'ofertantes'.
		var storeOfertantes = me.getViewModel().getData().storeOfertantesOfertaDetalle;
		storeOfertantes.getProxy().getExtraParams().ofertaID = idOferta;
		storeOfertantes.load({
			success: function(record) {	
				me.lookupReference('ofertanteslistdetalleofertaref').refresh();
		    }
		});

		// Cargar grid 'honorarios'.
		var storeHonorarios = me.getViewModel().getData().storeHonorariosOfertaDetalle;
		storeHonorarios.getProxy().getExtraParams().idOferta = idOferta;
		storeHonorarios.getProxy().getExtraParams().idActivo = idActivo;
		
		storeHonorarios.load({
			success: function(record) {	
				me.lookupReference('honorarioslistdetalleofertaref').refresh();
		    }
		});

		// Cargar el modelo de los detalles de oferta.
		model.setId(idOferta);
		model.load({			
		    success: function(record) {	
		    	me.getViewModel().set("detalleOfertaModel", record);
		    	fieldset.unmask();
		    }
		});		
	},
	
	// Este mÃ©todo abre el activo o agrupaciÃ³n asociado a la oferta en el grid de ofertas del activo.
	onClickAbrirActivoAgrupacion: function(tableView, indiceFila, indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    if(Ext.isEmpty(record.get('idAgrupacion'))){
	    	var idActivo = record.get("idActivo");
	   		me.redirectTo('activos', true);
	    	me.getView().fireEvent('abrirDetalleActivoOfertas', record);
	    }
	    else{
	    	var idAgrupacion = record.get("idAgrupacion");
	    	me.getView().fireEvent('abrirDetalleActivoOfertas', record);
	    }
	
	},
	onClickBotonGuardarInfoFoto: function(btn){
		var me = this;
		var tienePrincipal = false;
		btn.up('tabpanel').mask();
		form= btn.up('tabpanel').getActiveTab().getForm();
		var fotosActuales = btn.up('tabpanel').getActiveTab().down('dataview').getStore().data.items;
		for (i=0; i < fotosActuales.length; i++) {
			if(form.getValues().id != fotosActuales[i].data.id && form.getValues().principal){
				console.log(i+" id"+fotosActuales[i].data.id)
				console.log(i+" es princpal ?"+fotosActuales[i].data.principal)
				console.log(i+" interior exterior ? "+fotosActuales[i].data.interiorExterior)
				if (fotosActuales[i].data.principal == 'true' && form.getValues().interiorExterior.toString() == fotosActuales[i].data.interiorExterior){
					tienePrincipal = true;
	            	break;
	            }
			}
		}
		if(!tienePrincipal){
			var url =  $AC.getRemoteUrl('activo/updateFotosById');
			var tienePrincipal = false;
			var params={"id":form.findField("id").getValue()};
			if(form.findField("nombre")!=null){
				params['nombre']= form.findField("nombre").getValue();
			}
			if(form.findField("principal")!=null){
				params['principal']= form.findField("principal").getValue();
			}
			if(form.findField("interiorExterior")!=null){
				params['interiorExterior']= form.findField("interiorExterior").getValue();
			}
			if(form.findField("orden")!=null){
				params['orden']= form.findField("orden").getValue();
			}
			if(form.findField("descripcion")!=null){
				params['descripcion']= form.findField("descripcion").getValue();
			}
			if(form.findField("fechaDocumento")!=null){
				params['fechaDocumento']= form.findField("fechaDocumento").getValue();
			}
	
	       Ext.Ajax.request({
			     url: url,
			     params:params,
			     success: function (a, operation, context) {
			    	btn.up('tabpanel').unmask();
			    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			    	me.onClickBotonRefrescar();
			    	btn.hide();
			 		btn.up('tabbar').down('button[itemId=botonguardar]').hide();
			 		btn.up('tabbar').down('button[itemId=botoneditar]').show();
			 		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
							function (field, index) 
								{ 
									field.fireEvent('save');
									field.fireEvent('update');});
			 		if(Ext.isDefined(btn.name) && btn.name === 'firstLevel') {
			 			me.getViewModel().set("editingFirstLevel", false);
			 		} else {
			 			me.getViewModel().set("editing", false);
			 		}
	            },
	            failure: function (a, operation, context) {
	            	  Ext.toast({
					     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN',
					     width: 360,
					     height: 100,
					     align: 't'									     
					 });
	            	  btn.up('tabpanel').unmask();
	            }
		    });
		}else{
			me.fireEvent("errorToast", "Ya dispone de una foto principal");
			btn.up('tabpanel').unmask();
		}
	},

	onClickMostrarPrescriptorVisita: function(btn) {
		var me = this;
		var record = btn.up('visitascomercialdetalle').getViewModel().get('detallevisita');
		var codigoProveedor = record.codigoPrescriptorREM;
		var titulo = 'Proveedor '+codigoProveedor;
		var idProveedor = record.idPrescriptorREM;

    	me.getView().fireEvent('abrirDetalleProveedorDirectly', idProveedor, titulo);
	},

	onClickMostrarCustodioVisita: function(btn) {
		var me = this;
		var record = btn.up('visitascomercialdetalle').getViewModel().get('detallevisita');
		var codigoProveedor = record.codigoCustodioREM;
		var titulo = 'Proveedor '+codigoProveedor;
		var idProveedor = record.idCustodioREM;

    	me.getView().fireEvent('abrirDetalleProveedorDirectly', idProveedor, titulo);
	},
	
	onRenderCargasList: function(grid) {
		var me = this,
		//isCarteraCajamar = me.getViewModel().get("activo.isCarteraCajamar"),
		items = grid.getDockedItems('toolbar[dock=top]');
		if (items.length > 0){
			items[0].setVisible(true);
		}
	},

	onCargasListDobleClick: function (grid, record) {
		var me = this;

		Ext.create("HreRem.view.activos.detalle.CargaDetalle", {carga: record, parent: grid.up("form"), modoEdicion: true}).show();
	},

	abrirFormularioAnyadirCarga: function(grid) {
		var me = this,
		record = Ext.create("HreRem.model.ActivoCargas");
		record.set("idActivo", me.getViewModel().get("activo.id"));
		Ext.create("HreRem.view.activos.detalle.CargaDetalle", {carga: record, parent: grid.up("form")}).show();		
	},
    
    onClickRemoveCarga: function(grid, record) {
    	
    	var me = this,
		idCarga = record.get("idActivoCarga");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		record.erase({
			params: {idActivoCarga: idCarga},
            success: function(record, operation) {
           		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
           		 me.getView().unmask();
           		 grid.getStore().load();
            },
            failure: function(record, operation) {
                 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                 me.getView().unmask();
                 grid.getStore().load();
            }
            
        });
    },

  onClickPropagation : function(btn) {
    var me = this;
    //var activosPropagables = me.getViewModel().get("activo.activosPropagables") || [];
    var idActivo = btn.up('tabpanel').getActiveTab().getBindRecord().activo.id,
    url = $AC.getRemoteUrl('activo/getActivosPropagables'),
    form = btn.up('form');
    
    form.mask(HreRem.i18n("msg.mask.espere"));
    
	Ext.Ajax.request({
		url: url,
		method : 'POST',
		params: {idActivo: idActivo},
		
		success: function(response, opts){
			
			form.unmask();
			var activosPropagables = Ext.decode(response.responseText).data.activosPropagables;
			var tabPropagableData = null;
			if(me.getViewModel() != null){
				if(me.getViewModel().get('activo') != null){
					if(me.getViewModel().get('activo').data != null){
						me.getViewModel().get('activo').data.activosPropagables = activosPropagables;
					}
				}
			}
						
		var activo = activosPropagables.splice(activosPropagables.findIndex(function(activo) {
	              return activo.activoId == me.getViewModel().get("activo.id");
	            }), 1)[0];
	    var grid = btn.up().up();

	    // Abrimos la ventana de selección de activos
	    var ventanaOpcionesPropagacionCambios = Ext.create("HreRem.view.activos.detalle.OpcionesPropagacionCambios", {
	          form : null,
	          activoActual : activo,
	          activos : activosPropagables,
	          tabData : grid.getSelection()[0].data,
	          propagableData : null,
	          targetGrid: grid.targetGrid
	        }).show();
	    	    
	    	me.getView().add(ventanaOpcionesPropagacionCambios);
		},
	 	failure: function(record, operation) {
	 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
	    }
	});
  	},

	onClickBotonCancelarCarga: function(btn) { 
		var me = this;
		var window = btn.up('window');
		
		window.parent.funcionRecargar();
		window.destroy();
		
	},
	
	onClickBotonGuardarCarga: function(btn) {
		
		var me = this,
		form = me.lookupReference("formDetalleCarga"),
		window = form.up('window'),
		record = form.getBindRecord();

		if(form.isFormValid()) {

			form.mask(HreRem.i18n("msg.mask.espere"));

			record.save({
			    success: function(record, operation) {
			    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					form.unmask();
					window.parent.funcionRecargar();
					window.destroy();
			    },
			 	failure: function(record, operation) {
			 		var response = Ext.decode(operation.getResponse().responseText);
			 		if(response.success === "false" && Ext.isDefined(response.msg)) {
						me.fireEvent("errorToast", Ext.decode(operation.getResponse().responseText).msg);
					} else {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					}
					form.unmask();
			    }

			});
		} else {		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
		
		
	},
	buscarPrescriptor: function(field, e){
		
		var me= this;
		var url =  $AC.getRemoteUrl('proveedores/searchProveedorCodigo');
		var codPrescriptor = field.getValue();
		var data;
		var re = new RegExp("^((04$))|^((18$))|^((28$))|^((29$))|^((31$))|^((37$))|^((30$))|^((35$))|^((23$))|^((38$)).*$");

		
		Ext.Ajax.request({
		    			
		 		url: url,
		   		params: {codigoUnicoProveedor : codPrescriptor},
		    		
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
		    		var buscadorPrescriptor = field.up('formBase').down('[name=buscadorPrescriptores]'),
		    		nombrePrescriptorField = field.up('formBase').down('[name=nombrePrescriptor]');
		    		
			    	if(!Utils.isEmptyJSON(data.data)){
						var id= data.data.id;
						var tipoProveedorCodigo = data.data.tipoProveedor.codigo;
						
		    		    var nombrePrescriptor= data.data.nombre;
		    		    
		    		    if(re.test(tipoProveedorCodigo)){
			    		    if(!Ext.isEmpty(buscadorPrescriptor)) {
			    		    	buscadorPrescriptor.setValue(codPrescriptor);
			    		    }
			    		    if(!Ext.isEmpty(nombrePrescriptorField)) {
			    		    	nombrePrescriptorField.setValue(nombrePrescriptor);
	
				    		}
		    		    }else{
		    		    	nombrePrescriptorField.setValue('');
		    				me.fireEvent("errorToast", "El cÃ³digo del Proveedor introducido no es un Prescriptor");
		    			}
			    	} else {
			    		if(!Ext.isEmpty(nombrePrescriptorField)) {
			    			nombrePrescriptorField.setValue('');
		    		    }
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.proveedor.codigo"));
			    		buscadorPrescriptor.markInvalid(HreRem.i18n("msg.buscador.no.encuentra.proveedor.codigo"));		    		    
			    	}		    		    	 
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}   		     
		});		
	},
	
	buscarSucursal: function(field, e){

		var me= this;
		var url =  $AC.getRemoteUrl('proveedores/searchProveedorCodigoUvem');
		var carteraBankia = me.view.up().lookupController().getViewModel().get('activo.isCarteraBankia');
		var carteraCajamar = me.view.up().lookupController().getViewModel().get('activo.isCarteraCajamar');
		var codSucursal = '';
		var nombreSucursal = '';
		if(carteraBankia){
			codSucursal = '2038' + field.getValue();
			nombreSucursal = ' (Oficina Bankia)';
		}else if(carteraCajamar){
			codSucursal = '3058' + field.getValue();
			nombreSucursal = ' (Oficina Cajamar)'
		}
		var data;
		var re = new RegExp("^[0-9]{8}$");
		
		Ext.Ajax.request({
		    			
		 		url: url,
		   		params: {codigoProveedorUvem : codSucursal},
		    		
		    	success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
		    		var buscadorSucursal = field.up('formBase').down('[name=buscadorSucursales]'),
		    		nombreSucursalField = field.up('formBase').down('[name=nombreSucursal]');

			    	if(!Utils.isEmptyJSON(data.data)){
						var id= data.data.id;
		    		    nombreSucursal = data.data.nombre + nombreSucursal;
		    		    
		    		    if(re.test(codSucursal) && nombreSucursal != null && nombreSucursal != ''){
			    		    if(!Ext.isEmpty(nombreSucursalField)) {
			    		    	nombreSucursalField.setValue(nombreSucursal);	
				    		}
		    		    }else{
		    		    	nombreSucursalField.setValue('');
		    				me.fireEvent("errorToast", "El código de la Sucursal introducido no corresponde con ninguna Oficina");
		    			}
			    	} else {
			    		if(!Ext.isEmpty(nombreSucursalField)) {
			    			nombreSucursalField.setValue('');
		    		    }
			    		me.fireEvent("errorToast", HreRem.i18n("msg.buscador.no.encuentra.sucursal.codigo"));
			    		buscadorSucursal.markInvalid(HreRem.i18n("msg.buscador.no.encuentra.sucursal.codigo"));		    		    
			    	}		    		    	 
		    	},
		    	failure: function(response) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	},
		    	callback: function(options, success, response){
				}   		     
		});		
	},
	onChangeFechasMinimaMovimientosLlaveList: function() {
		var me = this;
		var dateDevolucion = me.lookupReference('datefieldDevolucion');
		var dateEntrega = me.lookupReference('datefieldEntrega');
		
		me.setFechaMinimaDevolucionMovimientoLlave(dateEntrega.getValue(),dateDevolucion);
	},
	
	comprobarFechasMinimasMovimientosLlaveList: function(editor, context, eOpts) {
		var me = this;
		var fila = context.view.getStore().getData().items[context.rowIdx].getData();	
		var dateDevolucion = me.lookupReference('datefieldDevolucion');
		
		me.setFechaMinimaDevolucionMovimientoLlave(fila.fechaEntrega,dateDevolucion);
	},
	
	// Establece fecha mÃ­nima en DevoluciÃ³n en funciÃ³n de la fecha de Entrega
	setFechaMinimaDevolucionMovimientoLlave: function(valorFecha, dateDevolucion) {
		
		if(!Ext.isEmpty(valorFecha)) {
			dateDevolucion.setDisabled(false);
			dateDevolucion.setMinValue(valorFecha);
		}
		else {
			dateDevolucion.setDisabled(true);
			dateDevolucion.setValue();
		}
	},
	
	
	onChkbxRevisionDeptoCalidadChange: function(btn) {
	    	var me = this;
	    	var nomGestorCalidad = me.lookupReference('nomGestorCalidad');
			var fechaRevisionCalidad = me.lookupReference('fechaRevisionCalidad');
			
	    	if(!btn.value){
	    		nomGestorCalidad.reset();
		    	fechaRevisionCalidad.reset();
	    	}else{
	    		nomGestorCalidad.setValue($AU.getUser().userName);
	    		fechaRevisionCalidad.setValue(new Date());
	    	}

	},
	
	onChangeEstadoCargaCombo: function(combo){
		var me = this;
		var fechaCancelacionRegistral =  me.lookupReference('fechaCancelacionRegistral');
		if(CONST.SITUACION_CARGA['CANCELADA']==combo.getSelection().get('codigo')){
				fechaCancelacionRegistral.allowBlank = false;
		}
		else{
			fechaCancelacionRegistral.allowBlank = true;
			if(!Ext.isEmpty(fechaCancelacionRegistral.getValue())){
				fechaCancelacionRegistral.setValue('');
			}
		}
	},
	

	onChangeEstadoEconomicoCombo: function(combo){
		var me = this;
		var fechaCancelacionEconomica =  me.lookupReference('fechaCancelacionEconomica');
		if(CONST.SITUACION_CARGA['CANCELADA']==combo.getSelection().get('codigo')){
				fechaCancelacionEconomica.allowBlank = false;
		}
		else{
			fechaCancelacionEconomica.allowBlank = true;
			if(!Ext.isEmpty(fechaCancelacionEconomica.getValue())){
				fechaCancelacionEconomica.setValue('');
			}
		}
	},


	saveActivo: function(jsonData, successFn) {
		var me = this,
		url =  $AC.getRemoteUrl('activo/saveActivo');
		
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		
		successFn = successFn || Ext.emptyFn
			
		
		if(Ext.isEmpty(jsonData)) {
			me.fireEvent("log", "Obligatorio jsonData para guardar el activo");
		} else {
		
			Ext.Ajax.request({
				method : 'POST',
				url: url,
				jsonData: Ext.JSON.encode(jsonData),
				success: successFn,
			 	failure: function(response, opts) {
			 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    }			    
			});
		}
	},
	
	saveDistribucion: function(jsonData, successFn) {
		
		var me = this,
		url =  $AC.getRemoteUrl('activo/createDistribucionFromRem');
		
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		
		successFn = successFn || Ext.emptyFn
			
		if(Ext.isEmpty(jsonData)) {
			me.fireEvent("log", "Obligatorio jsonData para guardar el activo");
		} else {
			Ext.Ajax.request({
				method : 'POST',
				url: url,
				params: {numPlanta: jsonData.numPlanta, cantidad: jsonData.cantidad, superficie: jsonData.superficie, idActivo: jsonData.idEntidad, tipoHabitaculoCodigo: jsonData.tipoHabitaculoCodigo},
				success: successFn,
			 	failure: function(response, opts) {
			 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    }			    
			});
		}
	},

	onClickGuardarPropagarCambios: function(btn) {
    	var me = this,
    	window = btn.up("window"),
    	grid = me.lookupReference("listaActivos"),
    	radioGroup = me.lookupReference("opcionesPropagacion"),
    	formActivo = window.form,
    	activosSeleccionados = grid.getSelectionModel().getSelection(),
    	opcionPropagacion = radioGroup.getValue().seleccion,
    	cambios =  window.propagableData,
    	targetGrid = window.targetGrid;

		me.fireEvent("log", cambios);
		
    	if (opcionPropagacion == "4" &&  activosSeleccionados.length == 0) {
	    	me.fireEvent("errorToast", HreRem.i18n("msg.no.activos.seleccionados"));
	    	return false;
    	}
    	
	    // Si estamos modificando una pestaña con formulario
	    if (Ext.isEmpty(targetGrid)) {
	    	
	      if (!Ext.isEmpty(formActivo)) {	
	        var successFn = function(record, operation) {
	          if (activosSeleccionados.length > 0) {
	            me.propagarCambios(window, activosSeleccionados);
	          } else {
	            window.destroy();
	            me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	            me.getView().unmask();
	            me.refrescarActivo(formActivo.refreshAfterSave);
	            me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
	          }
	        };
	
	        me.saveActivo(window.tabData, successFn);
	
	      } else {
	
	        var successFn = function(record, operation) {
	          if (activosSeleccionados.length > 0) {
	            me.propagarCambios(window, activosSeleccionados);
	          } else {
	            window.destroy();
	            me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	            me.getView().unmask();
	            me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
	          }
	        };
	
	        me.saveActivo(window.tabData, successFn);
	
	      }
	    } else {
			if(targetGrid=='mediadoractivo') {
				
		        var successFn = function(record, operation) {
		            window.destroy();
		            me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		            me.getView().unmask();
		            me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
		        };
		        me.saveActivo(me.createTabDataHistoricoMediadores(activosSeleccionados), successFn);
			} else if(targetGrid=='condicionesespecificas') {

		        var successFn = function(record, operation) {
		            window.destroy();
		            me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		            me.getView().unmask();
		            me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
		        };
		        me.saveActivo(me.createTabDataCondicionesEspecificas(activosSeleccionados, window.tabData), successFn);
			}
	    }
	     window.mask("Guardando activos 1 de " + (activosSeleccionados.length + 1));
	},
    
    onClickCancelarPropagarCambios: function(btn) {
    	var me = this,
    	window = btn.up("window");    	
    	
    	window.destroy();
    	
    	me.onClickBotonRefrescar();
    },
    	
    
	/**
	 * Replica una operación ya realizada sobre un activo, utilizando el array de activos que recibe y llamandose recursivamente hasta que no quedan activos .
	 * @param {} config - url y parametros comunes para guardar(datos modificados y tab) 
	 * @param {} activos
	 * @return {Boolean}
	 */
    propagarCambios: function(window, activos) {
    	
    	var me = this,
    	grid = window.down("grid"),
    	propagableData = window.propagableData,
    	numTotalActivos = grid.getSelectionModel().getSelection().length + 1,
    	targetGrid = window.targetGrid,
    	numActivoActual = numTotalActivos;

    	if (activos.length>0) {
    		var activo = activos.shift();
    		
    		numActivoActual = numTotalActivos - activos.length;
    		
    		if (Ext.isEmpty(targetGrid)) {
    			propagableData.id = activo.get("activoId");
    		} else {
    			if(targetGrid=='mediadoractivo') {
    				propagableData = me.createTabDataHistoricoMediadores(activos);
    				// Los lanzamos todos de golpe sin necesidad de iterar
    				activos = [];
    			}
    		}

    		var successFn = function(response, opts){
				// Lanzamos el evento de refrescar el activo por si está abierto.
				me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], activo.get("activoId"));
				me.propagarCambios(window, activos);
			};

			window.mask("Guardando activos "+ numActivoActual +" de " + numTotalActivos);
			me.saveActivo(propagableData, successFn);

    	} else {
    		Ext.ComponentQuery.query('opcionespropagacioncambios')[0].destroy();
    		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			me.getView().unmask();
    		return false;
    	}
    },
    
    createTabData: function(form) {
    	
    	var me = this,
    	tabData = {};
    	
    	tabData.id = me.getViewModel().get("activo.id");
    	tabData.models = [];
    	
    	if(form.saveMultiple) {
    		var types = form.records; 
    		Ext.Array.each(form.getBindRecords(), function(record, index) {
    			var model = me.createModelToSave(record, types[index]);
	    		if(!Ext.isEmpty(model)) {
	    			tabData.models.push(model);
	    		}
    		});
    		
    	} else {
    		var type = form.recordName; 
    		var model = me.createModelToSave(form.getBindRecord(), type);
    		if(!Ext.isEmpty(model)) {
    			tabData.models.push(model);
    		}
    	}
    	
    	if(tabData.models.length > 0) {
    		return tabData;
    			
    	} else {
    		return null;
    	}
    },
    
  createTabDataHistoricoMediadores : function(list) {
    var me = this, tabData = {};
    tabData.id = me.getViewModel().get("activo.id");
    tabData.models = [];

    Ext.Array.each(list, function(record, index) {
          var model = {};
          model.name = 'mediadoractivo';
          model.type = 'activo';
          model.data = {};
          model.data.idActivo = record.data.activoId;
          tabData.models.push(model);
        });
    return tabData;
  },

  	createTabDataCondicionesEspecificas : function(listadoActivos, data) {
	    var me = this, tabData = {};
	    tabData.id = me.getViewModel().get("activo.id");
	    tabData.models = [];

	    Ext.Array.each(listadoActivos, function(record, index) {
	          var model = {};
	          model.name = 'condicionesespecificas';
	          model.type = 'activo';
	          model.data = {texto: data.texto};
	          model.data.idActivo = record.data.activoId;
	          tabData.models.push(model);
	        });
	    return tabData;
	},

    createModelToSave: function(record, type) {
    	
    	var me = this;
    	var model = null;
    	if (Ext.isDefined(record.getProxy().getApi().update)) { 
    		model = {};
    		model.name= record.getProxy().getExtraParams().tab;
    		model.type= type;
    		model.data= record.getProxy().getWriter().getRecordData(record);
    	} 
    	
    	return model;
    		
    },
    
    createFormPropagableData: function(form, tabData) {
    	
    	var me = this,
    	propagableData=null,
    	camposPropagables = [],
    	dirtyFieldsModel =  [],
    	propagableData = [];
    	
    	var records = [],
    	models = [];
    	
    	if(form.saveMultiple) {
    		records = records.concat(form.getBindRecords()) 
    	} else {
    		records.push(form.getBindRecord());
    	}
    	
    	Ext.Array.each(records, function(record, index) {
    		var name = record.getProxy().getExtraParams().tab;
    		camposPropagables[name] = record.get("camposPropagables");    		
    	}); 

    	Ext.Array.each(tabData.models, function(model, index) {
    		var data = {},
    		modelHasData = false;
    		Ext.Array.each(camposPropagables[model.name], function(campo, index){
    			if(Ext.isDefined(model.data[campo])) {
    				data[campo] = model.data[campo];
    				modelHasData=true;
    			}
    		});
    		
    		if(modelHasData) {
    			model.data=data;
    			models.push(model);	
    		}
    		
    	});	
    	
    	if(models.length>0) {
    		propagableData = {};
    		propagableData.models = models
    	}
	
    	return propagableData;
    },
    
    onClickBotonGuardarMotivoRechazo: function(btn){
    	var me = this;
    	
    	var window = btn.up('window');
    	
    	var grid = window.gridOfertas;
    	var record = window.getViewModel().get('ofertaRecord');
    	
		if (grid.isValidRecord(record)) {				
			
    		record.save({

                params: {
                    idEntidad: Ext.isEmpty(grid.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(grid.idPrincipal),
                    esAnulacion: true
                },
                success: function (a, operation, c) {																			
					grid.saveSuccessFn();
				},
                
				failure: function (a, operation) {
                	grid.saveFailureFn(operation);
              	
                },
    			callback: function() {
                	grid.unmask();
                	grid.getStore().load();
                }
            });	                            
    		grid.disableAddButton(false);
    		grid.disablePagingToolBar(false);
    		grid.getSelectionModel().deselectAll();
// TODO: Encontrar la manera de realizar esto que me ha obligado a 
// duplicar este save del record y en este punto "editor" es indefinido
//    		editor.isNew = false;
		} else {
		   grid.getStore().load(); 	
		}
    	
		window.close();
    	
    },
	
    onClickBotonCancelarMotivoRechazo: function(btn) {	
		var me = this,
		window = btn.up('window');

		window.gridOfertas.getStore().load();
    	window.close();

	},
    
	onClickBotonCancelarDistribucion: function(btn){
    	var me = this,
		window = btn.up('window');
    	window.gridDistribuciones.getStore().load();
    	window.close();	
    },
	
	onClickBotonGuardarDistribucion: function(btn){
    	var me = this,
		window = btn.up('window');
    	var form = window.down('formBase');
    	me.onSaveFormularioCompletoDistribuciones(null, form);
		window.gridDistribuciones.up('informecomercialactivo').funcionRecargar()
    	window.close();
    	
    },
    
    onGridImpuestosActivoRowClick: function(grid , record , tr , rowIndex){
    	grid.up().disableRemoveButton(false);
    },
    
    onImpuestosActivoDobleClick: function(grid,record,tr,rowIndex) {        	       
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    },
    
	checkActivosToPropagate: function(idActivo, form, tabData){
		var me = this,
		url =  $AC.getRemoteUrl('activo/getActivosPropagables');
		Ext.Ajax.request({
    		url: url,
			method : 'POST',
    		params: {idActivo: idActivo},
    		
    		success: function(response, opts){
    			var activosPropagables = Ext.decode(response.responseText).data.activosPropagables;
				var tabPropagableData = null;
				
				if(me.getViewModel() != null){
					if(me.getViewModel().get('activo') != null){
						if(me.getViewModel().get('activo').data != null){
							me.getViewModel().get('activo').data.activosPropagables = activosPropagables;
						}
					}
				}
				
				if(activosPropagables.length > 0) {
			
					tabPropagableData = me.createFormPropagableData(form, tabData);	
					if (!Ext.isEmpty(tabPropagableData)) {
						// sacamos el activo actual del listado
						var activo = activosPropagables.splice(activosPropagables.findIndex(function(activo){return activo.activoId == me.getViewModel().get("activo.id")}),1)[0];
				
						// Abrimos la ventana de selección de activos
						var ventanaOpcionesPropagacionCambios = Ext.create("HreRem.view.activos.detalle.OpcionesPropagacionCambios", {form: form, activoActual: activo, activos: activosPropagables, tabData: tabData, propagableData: tabPropagableData}).show();
							me.getView().add(ventanaOpcionesPropagacionCambios);
							me.getView().unmask();
							return false;
					}
				}
			
				var successFn = function(response, eOpts) {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					me.getView().unmask();
					me.refrescarActivo(form.refreshAfterSave);
					me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
				}
				me.saveActivo(tabData, successFn);
    		},
		 	failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    }
    	});
		
	}
    
});