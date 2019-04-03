Ext.define('HreRem.view.expedientes.ExpedienteDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.expedientedetalle',  
    requires: ['HreRem.view.expedientes.NotarioSeleccionado', 'HreRem.view.expedientes.DatosComprador', 
    'HreRem.view.expedientes.DatosClienteUrsus',"HreRem.model.ActivoExpedienteCondicionesModel",
    "HreRem.view.common.adjuntos.AdjuntarDocumentoExpediente", 'HreRem.view.activos.detalle.OpcionesPropagacionCambios',
    'HreRem.view.expedientes.WizardAltaComprador'],
    
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
            	grid.disableRemoveButton(true);
            }
        },
        
        'compradoresexpediente gridBase': {
            onClickRemove: 'borrarComprador',
			download: 'downloadDocumentoAdjuntoGDPR',
            afterdelete: function(grid) {
            	grid.getStore().load();
            }
        },
        'diariogestionesexpediente':{
           	enviarComercializadora:'onClickEnviarComercializadora'
           }
    },

    onRowClickListadoactivos: function(gridView,record){
    	var me = this;
		var viewModel = me.getViewModel();
		var idExpediente = me.getViewModel().get("expediente.id");
		var idActivo = record.data.idActivo;
		var expedienteDeAlquiler = me.getViewModel().get('expediente.tipoExpedienteDescripcion');
		
		viewModel.set("activoExpedienteSeleccionado", record);
		viewModel.notify();
		
		if(me.lookupReference('activoExpedienteMain').down('bloqueosformalizacionlist')){
			me.lookupReference('activoExpedienteMain').down('bloqueosformalizacionlist').getStore().load();
		}
		
		var bloqueado = me.getViewModel().get('expediente.bloqueado');
		if(me.lookupReference('activoExpedienteMain') != undefined){
			me.lookupReference('activoExpedienteMain').bloquearExpediente(me.lookupReference('activoExpedienteMain'),bloqueado);
		}
	
		var tabPanel = me.lookupReference('activoExpedienteMain');
		if(expedienteDeAlquiler == 'Alquiler'){
			tabPanel.setHidden(true);
		} else {
			tabPanel.setHidden(false);
			tabPanel.mask();
		}

		HreRem.model.ActivoExpedienteCondicionesModel.load(idExpediente, {
			params: {idActivo:idActivo,idExpediente:idExpediente},
    		scope: this,
		    success: function(condiciones) {
		    	me.getViewModel().set("condiciones", condiciones);	
		    	tabPanel.unmask();
		    },
		   	failure: function (a, operation) {
		   		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			
	       	}
		});		

		
		HreRem.model.ExpedienteInformeJuridico.load(idExpediente, {
			params: {idActivo: idActivo},
    		scope: this,
		    success: function(informeJuridico) {
		    	viewModel.set("informeJuridico", informeJuridico);	    	
		    	tabPanel.unmask();
		    },
		   	failure: function (a, operation) {
		   		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			
	       	}
		});	
		var panelTanteo = tabPanel.down('activoexpedientetanteo');
		var grid = panelTanteo.down('gridBaseEditableRow');
		if(grid != undefined){
			var store = grid.getStore();
			grid.expand();
			store.loadPage(1)
		}
		
		var panelJuridico = tabPanel.down('activoexpedientejuridico');
		if(panelJuridico != undefined){
			me.cargarTabDataInformeJuridico(panelJuridico,false);
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
				    	var itemsExpedienteForm = form.getForm().getFields().items;
				    	var itemReserva = itemsExpedienteForm.find(function(item){return item.fieldLabel === "Fecha de reserva"});
				    	if(itemReserva != null){
				    		me.tareaDefinicionDeOferta(itemReserva);   
				    	}
				    	form.setBindRecord(record);			    	
				    	form.unmask();
				    	if(Ext.isFunction(form.afterLoad)) {
				    		form.afterLoad();
				    	}
				    }, 		    
				    failure: function(operation) {		    	
				    	form.unmask();
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
	
	cargarTabDataInformeJuridico: function (form,refreshActivoExpediente) {
		var me = this,
		model = null,
		models = null,
		nameModels = null,
		id = me.getViewModel().get("expediente.id");
		var tabPanel = me.lookupReference('activoExpedienteMain');
		// Si la API tiene metodo de lectura (read).
		HreRem.model.ExpedienteInformeJuridico.load(id, {
			params: {idActivo: me.getViewModel().get("activoExpedienteSeleccionado.idActivo")},
		    scope: this,
			success: function(informeJuridico) {
				me.getViewModel().set("informeJuridico", informeJuridico);
				if(!Ext.isEmpty(tabPanel)){
					var panelJ = tabPanel.down('activoexpedientejuridico');
		    		panelJ.down('[reference=fechaEmisionInformeJuridico]').setValue(informeJuridico.get('fechaEmision'));
		    		panelJ.down('[reference=resultadoBloqueoInformeJuridico]').setValue(informeJuridico.get('resultadoBloqueo'));
				}	
				if(refreshActivoExpediente){
					//me.refrescarActivoExpediente(false);
				}
			},
			failure: function (a, operation) {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					
			}
		});
			
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
			            	var data = {};
			                try {
			                	data = Ext.decode(operation._response.responseText);
			                } catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                	// Si recibimos un error controlado, continuamos editando.
			                	Ext.Array.each(form.query('field[isReadOnlyEdit]'),
									function (field, index){field.fireEvent('edit');}
								);
			                	btn.show();
								btn.up('tabbar').down('button[itemId=botoncancelar]').show();
								btn.up('tabbar').down('button[itemId=botoneditar]').hide();
								me.getViewModel().set("editing", true);
			                	
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
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
	
	onSaveFormularioCompletoActivoExpediente: function(btn, form) {
		var me = this;
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones
		if(form.isFormValid() && form.disableValidation) {

			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);
					
			btn.hide();
			me.getViewModel().set("editing", false);
			
			if (!form.saveMultiple) {
				if(Ext.isDefined(form.getBindRecord().getProxy().getApi().create) || Ext.isDefined(form.getBindRecord().getProxy().getApi().update)) {
					// Si la API tiene metodo de escritura (create or update).
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
					form.getBindRecord().save({
						params: {idActivo: me.getViewModel().get("activoExpedienteSeleccionado.idActivo")},
						success: function (a, operation, c) {
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							me.getView().unmask();
							me.refrescarActivoExpediente(form.refreshAfterSave);
			            },
				            
			            failure: function (a, operation) {
			            	var data = {};
			                try {
			                	data = Ext.decode(operation._response.responseText);
			                } catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                	// Si recibimos un error controlado, continuamos editando.
			                	Ext.Array.each(form.query('field[isReadOnlyEdit]'),
									function (field, index){field.fireEvent('edit');}
								);
			                	btn.show();
								btn.up('tabbar').down('button[itemId=botoncancelar]').show();
								btn.up('tabbar').down('button[itemId=botoneditar]').hide();
								me.getViewModel().set("editing", true);
			                	
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
							 me.getView().unmask();
			            }
					});
				}
			//Guardamos múltiples records	
			} else {
				var records = form.getBindRecords();
				var contador = 0;
				me.saveMultipleRecordsActivoExpediente(contador, records);
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
		} else {
			if (contador < records.length) {
				contador++;
				me.saveMultipleRecords(contador, records);
			}
		}
	},
	
	saveMultipleRecordsActivoExpediente: function(contador, records) {
		var me = this;
		
		if(Ext.isDefined(records[contador].getProxy().getApi().create) || Ext.isDefined(records[contador].getProxy().getApi().update)) {
			// Si la API tiene metodo de escritura (create or update).
			records[contador].save({
				params: {idActivo: me.getViewModel().get("activoExpedienteSeleccionado.idActivo")},
				success: function (a, operation, c) {
						contador++;
						
						if (contador < records.length) {
							me.saveMultipleRecords(contador, records);
						} else {
							 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));						
							 me.getView().unmask();
							 me.refrescarActivoExpediente(false);							 
						}
	            },
	            failure: function (a, operation) {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					me.getView().unmask();
	            }
			});		 
		} else {
			if (contador < records.length) {
				contador++;
				me.saveMultipleRecords(contador, records);
			}
		}
	},

	onClickBotonEditar: function(btn) {
		var me = this;
		var url =  $AC.getRemoteUrl('expedientecomercial/getIsExpedienteGencat');

		Ext.Ajax.request({
		     url: url,
		     method: 'POST',
		     params: {idActivo: me.getViewModel().data.expediente.data.idActivo, idExpediente: me.getViewModel().data.expediente.id},
		     success: function(response, opts) {
		    	data = Ext.decode(response.responseText);
		    	if(data.data == "false"){
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();
		me.getViewModel().set("editing", true);		

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		    	}else{
		    		 me.fireEvent("errorToast", HreRem.i18n("msg.no.editable.afectado.gencat"));
		    	}
		    },
		    failure: function (a, operation) {
		    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 	}
		});


	},
    
	onClickBotonGuardar: function(btn) {
		var me = this;	
		me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab());	
	},
	
	onClickBotonGuardarActivoExpediente: function(btn) {
		var me = this;
		/*if(btn.up('tabpanel').getActiveTab().getReference()=="activoexpedientetanteo"){
			me.onSaveFormularioActivoExpedienteTanteo(btn, btn.up('tabpanel').getActiveTab());
		}else{
			me.onSaveFormularioCompletoActivoExpediente(btn, btn.up('tabpanel').getActiveTab());
		}*/
		me.onSaveFormularioCondiciones(btn, btn.up('tabpanel').getActiveTab());
	},
	
	onSaveFormularioActivoExpedienteTanteo: function(btn, form) {
		var me = this;
		if(form.isFormValid()) {
			var formulario= btn.up('tabpanel').getActiveTab().getForm();
			me.getView().mask(HreRem.i18n("msg.mask.loading"));
			var url =  $AC.getRemoteUrl('expedientecomercial/saveTanteo');
			var params={};
			if(formulario.findField("condicionesTransmision")!=null){
				params['condicionesTransmision']= formulario.findField("condicionesTransmision").getValue();
			}
			if(formulario.findField("fechaComunicacion")!=null){
				params['fechaComunicacion']= formulario.findField("fechaComunicacion").getValue();
			}
			if(formulario.findField("fechaRespuesta")!=null){
				params['fechaRespuesta']= formulario.findField("fechaRespuesta").getValue();
			}
			if(formulario.findField("fechaSolicitudVisita")!=null){
				params['fechaSolicitudVisita']= formulario.findField("fechaSolicitudVisita").getValue();
			}
			if(formulario.findField("fechaVisita")!=null){
				params['fechaVisita']= formulario.findField("fechaVisita").getValue();
			}
			if(formulario.findField("fechaFinTanteo")!=null){
				params['fechaFinTanteo']= formulario.findField("fechaFinTanteo").getValue();
			}
			if(formulario.findField("fechaResolucion")!=null){
				params['fechaResolucion']= formulario.findField("fechaResolucion").getValue();
			}
			if(formulario.findField("fechaVencimiento")!=null){
				params['fechaVencimiento']= formulario.findField("fechaVencimiento").getValue();
			}
			if(formulario.findField("codigoTipoResolucion")!=null){
				params['codigoTipoResolucion']= formulario.findField("codigoTipoResolucion").getValue();
			}
			if(formulario.findField("numeroExpediente")!=null){
				params['numeroExpediente']= formulario.findField("numeroExpediente").getValue();
			}
			if(formulario.findField("solicitaVisitaCodigo")!=null){
				params['solicitaVisitaCodigo']= formulario.findField("solicitaVisitaCodigo").getValue();
			}
			var record = form.getBindRecord();
			params['idEntidad']= record.idActivo;
			params['idEntidadPk']= record.ecoId;
			params['id']= record.id;
			Ext.Ajax.request({
			     url: url,
			     params:params,
			     success: function (a, operation, context) {
			    	me.getView().unmask();
			    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
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
			 		me.refrescarActivoExpediente(true);
			 	},
	            failure: function (a, operation, context) {
	            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	            	me.getView().unmask();
	            }
		    });
		}else{
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
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
	
	refrescarExpediente: function(refrescarTabActiva) {
		var me = this,
	    activeTab = null,
	    refrescarTabActiva = Ext.isEmpty(refrescarTabActiva) ? false : refrescarTabActiva;

	    if(!Ext.isEmpty(me.getView().down("tabpanel"))){
	         activeTab = me.getView().down("tabpanel").getActiveTab();
	    }else {
	        activeTab = me.getView().up("tabpanel").getActiveTab();
	    }

		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar 
		if(refrescarTabActiva && activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
		
		me.getView().fireEvent("refrescarExpediente", me.getView());
		
	},
	
	refrescarActivoExpediente: function(refrescarTabActiva) {
		var me = this,
		refrescarTabActiva = Ext.isEmpty(refrescarTabActiva) ? false: refrescarTabActiva,
		activeTab = me.getView().getActiveTab();		
  		
		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar 
		if(refrescarTabActiva && activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
		activeTab.up("expedientedetallemain").fireEvent("refrescarExpediente", activeTab.up("expedientedetallemain"));
		var activoExpedienteMain = activeTab.up('activosexpediente');
		var grid = activoExpedienteMain.down('gridBaseEditableRow');
		if(grid){
			var store = grid.getStore();
			//grid.expand();
			store.loadPage(1)
		}
		
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
			params: {idEntidad: idExpediente},
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
		config.params.nombreDocumento=record.get("nombre");
		me.fireEvent("downloadFile", config);
	},

	downloadDocumentoAdjuntoGDPR: function(grid, record) {
		var url =$AC.getRemoteUrl('expedientecomercial/existeDocumentoGDPR');
		var idPersonaHaya = record.get("idPersonaHaya");
		var idDocAdjunto =  record.get("idDocAdjunto");
		var idDocRestClient = record.get("idDocRestClient");
		var nombreAdjunto = record.get("nombreAdjunto");
		var data;
		var me = this;

		Ext.Ajax.request({
		     url: url,
		     params: {idPersonaHaya : idPersonaHaya , idDocAdjunto : idDocAdjunto , idDocRestClient : idDocRestClient , nombreAdjunto : nombreAdjunto},
		     success: function(response, opts) {
		         data = Ext.decode(response.responseText);
		         if(data.success == "true"){

		            var config = {};
		                config.url=$AC.getWebPath()+"expedientecomercial/bajarAdjuntoExpedienteGDPR."+$AC.getUrlPattern();
		                config.params = {};
		                config.params.idPersonaHaya=record.get("idPersonaHaya");
		                config.params.idExpediente=record.get("idExpediente");
		                config.params.idDocAdjunto = record.get("idDocAdjunto");
		                config.params.idDocRestClient=record.get("idDocRestClient");
		                config.params.nombreAdjunto=record.get("nombreAdjunto");

		                me.fireEvent("downloadFile", config);
		         }else{
                 me.fireEvent("errorToast", data.error);
		         }

		     },
		     failure: function(response) {
		         me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		     }
		 });

	},

	onListadoTramitesTareasExpedienteDobleClick : function(
			gridView, record) {
		var me = this;

		if (Ext.isEmpty(record.get("fechaFin"))) { // Si la
													// tarea
													// está
													// activa
			me.getView().fireEvent('abrirDetalleTramiteTarea',
					gridView, record);
		} else {
			me.getView().fireEvent(
					'abrirDetalleTramiteHistoricoTarea',
					gridView, record);
		}
	},
	
	onCompradoresListDobleClick : function(gridView,record) {
		var me=this,
		codigoEstado= me.getViewModel().get("expediente.codigoEstado"), 
		fechaPosicionamiento = me.getViewModel().get("expediente.fechaPosicionamiento"),
		tipoExpedienteAlquiler = CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"],
		tipoExpedienteVenta = CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"];
		//me.getView().fireEvent("refrescarExpediente", me.getView());
		if((codigoEstado!=CONST.ESTADOS_EXPEDIENTE['VENDIDO'] && me.getViewModel().get('expediente.tipoExpedienteCodigo') === tipoExpedienteVenta)
				||  (me.getViewModel().get('expediente.tipoExpedienteCodigo') === tipoExpedienteAlquiler && Ext.isEmpty(fechaPosicionamiento))){
			var idCliente = record.get("id"),
			expediente= me.getViewModel().get("expediente");
			var storeGrid= gridView.store;
			var edicion = me.getViewModel().get("puedeModificarCompradores");
			var deshabilitarCamposDoc = false;
			if(me.getViewModel().get('expediente.tipoExpedienteCodigo') === tipoExpedienteAlquiler){
				deshabilitarCamposDoc = true;
			}
			var window = me.getView().fireEvent('openModalWindow', "HreRem.view.expedientes.DatosComprador",{idComprador: idCliente, modoEdicion: edicion, storeGrid:storeGrid, expediente: expediente,deshabilitarCamposDoc: deshabilitarCamposDoc });
			
		}
		if (me.getViewModel().get('expediente.tipoExpedienteCodigo') === tipoExpedienteAlquiler && !Ext.isEmpty(fechaPosicionamiento)){
			me.fireEvent("errorToast", "Se ha avanzado la tarea Posicionamiento, no se puede editar los inquilinos");
		}
	},
	esEditableCompradores : function(field){
		var me = this;
		var viewModel = me.getViewModel();
		if(viewModel.get('esCarteraBankia')){
			if ((viewModel.get('expediente.codigoEstado') != CONST.ESTADOS_EXPEDIENTE['FIRMADO']
						&& viewModel.get('expediente.codigoEstado') != CONST.ESTADOS_EXPEDIENTE['VENDIDO'] )
						&& $AU.userHasFunction(['EDITAR_TAB_COMPRADORES_EXPEDIENTES'])){
				field.topBar = true;
				field.down('toolbar').show();
			}else{
				field.topBar = false;
				field.down('toolbar').hide();
			}
		}
	},
	onHaCambiadoSolicitaFinanciacion: function(combo, value){
		var me = this,
    	disabled = value == 0,
    	entidadFinanciacion = me.lookupReference('entidadFinanciacion');
		numExpedienteRiesgo = me.lookupReference('numExpedienteRiesgo');
		comboTipoFinanciacion = me.lookupReference('comboTipoFinanciacion');
    	
    	entidadFinanciacion.setDisabled(disabled);
    	entidadFinanciacion.allowBlank = disabled;
    	
    	
    	if(disabled) {
    		entidadFinanciacion.setValue("");
    		numExpedienteRiesgo.setValue("");
    		comboTipoFinanciacion.setValue("");
    	}
	},
	
	onHaCambiadoTipoCalculo: function(combo, value){
		var me = this;
		var valorCombo= combo.getValue(),
		porcentajeReserva = me.lookupReference('porcentajeReserva'),
		importeReserva = me.lookupReference('importeReserva'),
		plazoParaFirmar = me.lookupReference('plazoFirmaReserva');

		if(CONST.TIPOS_CALCULO['PORCENTAJE'] == valorCombo){
			if(Ext.isEmpty(porcentajeReserva.getValue())){
				me.getViewModel().get('condiciones').set('importeReserva', null);
			}
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
			importeReserva.setValue(null);
			porcentajeReserva.setValue(null);
			plazoParaFirmar.setValue(null);
			porcentajeReserva.setDisabled(true);
			plazoParaFirmar.setDisabled(true);
			importeReserva.setDisabled(true);
			
		}	
	},
	
	onHaCambiadoPorcentajeReserva: function(combo, value) {
		var me = this,
		importeOferta = parseFloat(me.getViewModel().get('expediente.importe')).toFixed(2),
		importeReserva = null,
		importeReservaField = me.lookupReference('importeReserva'),
		tipoCalculo = me.lookupReference('tipoCalculo').getValue();
		
		if(CONST.TIPOS_CALCULO['PORCENTAJE'] == tipoCalculo) {
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
		var me= this,
		
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
	
	cargarDatosComprador: function (window) {
		var me = this,
			model = Ext.create('HreRem.model.FichaComprador'),
			idExpediente = window.expediente.get("id"),
			form = window.down('formBase');
		
		form.mask(HreRem.i18n("msg.mask.loading"));
		
		form.reset(true);
		Ext.Array.each(form.query('component[isReadOnlyEdit]'),
				function (field, index) 
					{ 
						field.setValue(null)
					});
		
		
		model.setId(window.idComprador);
		model.load({
			params: {idExpedienteComercial: idExpediente},
		    success: function(record) {
		    	form.unmask();
		    	form.loadRecord(record);
		    	window.getViewModel().set('comprador', record);
		    	
		    	if(Ext.isFunction(form.afterLoad)) {
		    		form.afterLoad();
		    	}
		    },
		    failure : function(record, operation) {
				console.log("Failure: no ha sido posible cargar los datos del comprador");
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				form.unmask();
			}
		});
	},
	
	cargarDatosCompradorWizard : function(window) {
		var me = this,
		    model = null,
		    id = window.idComprador,
		    idExpediente = window.up().expediente.get("id");
		form = window.getForm();
		window.mask(HreRem.i18n("msg.mask.loading"));

		model = Ext.create('HreRem.model.FichaComprador');//, {
//			id : id,
//			idExpedienteComercial : idExpediente,
//			cesionDatos: form.findField('cesionDatos').getValue(),
//			comunicacionTerceros: form.findField('comunicacionTerceros').getValue(),
//			transferenciasInternacionales: form.findField('transferenciasInternacionales').getValue(),
//			pedirDoc: form.findField('pedirDoc').getValue(),
//			numDocumento: form.findField('numDocumento').getValue(),
//			codTipoDocumento: form.findField('codTipoDocumento').getValue()
//		});

		

		
		model.setId(id);
		model.load({
				params : {
					idExpedienteComercial : idExpediente
//					cesionDatos: form.findField('cesionDatos').getValue(),
//					comunicacionTerceros: form.findField('comunicacionTerceros').getValue(),
//					transferenciasInternacionales: form.findField('transferenciasInternacionales').getValue(),
//					pedirDoc: form.findField('pedirDoc').getValue(),
//					numDocumento: form.findField('numDocumento').getValue(),
//					codTipoDocumento: form.findField('codTipoDocumento').getValue()
				},
				success : function(record) {
					if (Ext.isEmpty(id)) {
						model.setId(undefined);
					}
					window.unmask();
			    	
					form.findField('numDocumento').setReadOnly(true);
					form.findField('codTipoDocumento').setReadOnly(true);
					form.loadRecord(record);
			    	window.getViewModel().set('comprador', record);
				},
				failure : function(record, operation) {
					console.log("Failure: no ha sido posible cargar los datos del comprador.");
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					window.unmask();
				}
		});
		
		// Funcionalidad que permite editar los campos
		Ext.Array.each(window.query('field[isReadOnlyEdit]'),
				function(field, index) {
					field.fireEvent('edit');
					if (index == 0)
						field.focus();
					field.setReadOnly(!window.modoEdicion)
			});
		},

		onClickBotonModificarComprador : function(btn) {
			var me = this, window = btn.up("window"), form = window.down("form"), ventanaWizard = btn.up('wizardaltacomprador');

			form.recordName = "comprador";
			form.recordClass = "HreRem.model.FichaComprador";

			//ventanaWizard.width = Ext.Element.getViewportWidth()/2;
			//ventanaWizard.height = Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight()-100;

			var success = function(record, operation) {
				me.getView().unmask();
				me.fireEvent("infoToast", HreRem
						.i18n("msg.operacion.ok"));
				window.hide();

		};
		
		var failure = function(record, operation) {
			me.getView().unmask();
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    	//window.destroy();

		};

		//En este caso, actualizar
		me.onSaveFormularioCompletoComprador(form, success, failure);
	},
	
	onClickBotonModificarCompradorSinWizard : function(btn) {
		var me = this, window = btn.up("window"), form = window.down("form");

		form.recordName = "comprador";
		form.recordClass = "HreRem.model.FichaComprador";

		var success = function(record, operation) {
			me.getView().unmask();
			me.fireEvent("infoToast", HreRem
					.i18n("msg.operacion.ok"));
			window.hide();

	};
	
	var failure = function(record, operation) {
		me.getView().unmask();
		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    	//window.destroy();

	};

	//En este caso, actualizar
	me.onSaveFormularioCompletoComprador(form, success, failure);
},
	
	onSaveFormularioCompletoComprador: function(form, success, failure) {
		var me = this,
		datoscom = form.up(),
		storeGrid = datoscom.storeGrid;
		form.getForm().updateRecord();
		var record = form.getForm().getRecord();		
		success = success || function() {
			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			storeGrid.load();
		};
		failure = failure || function() {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			storeGrid.load();
		}; 
		
		if(form.isFormValid()) {
			form.mask(HreRem.i18n("msg.mask.espere"));
			
			record.save({
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
	
	onCreateFormularioComprador: function(idExpediente, form, success, failure){
		var me = this;
		var window = btn.up('window');
		
		if(form.isFormValid()) {
			var idExpedienteComercial = idExpediente;
			form.mask(HreRem.i18n("msg.mask.espere"));
			
			if(Ext.isDefined(form.getModelInstance().getProxy().getApi().create)){
	    			form.getModelInstance().getProxy().extraParams.idExpediente = idExpediente;
	    			form.getModelInstance().save({
	    				success: function(a, operation, c){
	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    				},
	    				failure: function(a, operation){
	    					var data = {};
			                try {
			                	data = Ext.decode(operation._response.responseText);
			                } catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
	    				},
	    				callback: function(records, operation, success) {
	    					window.parent.funcionRecargar();
	    					window.close();
	    				}
	    				
	    			})
	    		}
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
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
	tareaDefinicionDeOferta: function(rec){
		var me = this;
		var url =  $AC.getRemoteUrl('expedientecomercial/getTareaDefinicionDeOferta');
		Ext.Ajax.request({
		
		     url: url,
		     params: {
		    	 idExpediente : me.getViewModel().get("expediente.id")
		     		}
			
		    ,success: function (response,a, operation, context) {
		    	var data = {};
		    	try {
		    		data = Ext.decode(response.responseText);
		    	}  catch (e){
		    		
		    	};
		    	 	var label = data.codigo;
		    	 	if(label != "venta" && label != "null"){
		    	 		rec.setVisible(true);
		    	 		rec.setFieldLabel(data.codigo)
		    	 	} else if (label == "null"){
		    	 		rec.setVisible(false);
		    	 	} else if(label == "venta"){
		    	 		rec.setFieldLabel(HreRem.i18n('fieldlabel.fecha.reserva'));
		    	 	}
            },
            
            failure: function (a, operation, context) {
            	rec.setFieldLabel(HreRem.i18n('fieldlabel.fecha.reserva'));
            }
	     
		});
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
	},
	
	onClickConsultaFormalizacionBankia: function(btn) {
		var me = this;
		var tipoRiesgoCodigo = me.lookupReference('comboTipoFinanciacion').getValue();
		var numExpedienteRiesgo = me.lookupReference('numExpedienteRiesgo').getValue();
		var url =  $AC.getRemoteUrl('expedientecomercial/obtencionDatosPrestamo');

		Ext.Ajax.request({
		     url: url,
		     params:  {
		    	 idExpediente : me.getViewModel().get("expediente.id"),
		    	 numExpediente : numExpedienteRiesgo,
		    	 codTipoRiesgo : tipoRiesgoCodigo
		    	 },
		     success: function(response, opts) {
			   var data = {};
			   try {
			   	data = Ext.decode(response.responseText);
			   }  catch (e){
			   	data = {};
			   };			   
			   if(data.success === "true") {
				   	me.lookupReference('formalizacionExpediente').funcionRecargar();
				   	me.getView().unmask();
			   }else {
			   		Utils.defaultRequestFailure(response, opts);
			   }
		     },
		     failure: function(response) {
					Utils.defaultRequestFailure(response, opts);
		     }
   	});
	},
	
	onHaCambiadoFechaInicioFinanciacion: function(field, value, oldValue){
		var me= this;
		var fechaInicioFinanciacion= value;
		var fechaFinFinanciacion= me.lookupReference('fechaFinFinanciacion').value;
		if(!Ext.isEmpty(fechaFinFinanciacion) && !Ext.isEmpty(fechaInicioFinanciacion) && fechaInicioFinanciacion>fechaFinFinanciacion){
			me.fireEvent("errorToast", HreRem.i18n("msg.fechaFin.mayor.Fecha.Inicio"));
			field.setValue('');
		}
		var fieldFechaFinFinanciacion= me.lookupReference('fechaFinFinanciacion');
		fieldFechaFinFinanciacion.setMinValue(fechaInicioFinanciacion);
	},
	
	onHaCambiadoFechaInicioFinanciacionBankia: function(field, value, oldValue){
		var me= this;
		var fechaInicioFinanciacionBankia= value;
		var fechaFinFinanciacionBankia= me.lookupReference('fechaFinFinanciacionBankia').value;
		if(!Ext.isEmpty(fechaFinFinanciacionBankia) && !Ext.isEmpty(fechaInicioFinanciacionBankia) && fechaInicioFinanciacionBankia>fechaFinFinanciacionBankia){
			me.fireEvent("errorToast", HreRem.i18n("msg.fechaFin.mayor.Fecha.Inicio"));
			field.setValue('');
		}
		var fieldFechaFinFinanciacionBankia= me.lookupReference('fechaFinFinanciacionBankia');
		fieldFechaFinFinanciacionBankia.setMinValue(fechaInicioFinanciacionBankia);
	},
	
	onHaCambiadoFechaFinFinanciacion: function(field, value, oldValue){
		var me= this;
		var fechaFinFinanciacion= value;
		var fechaInicioFinanciacion= me.lookupReference('fechaInicioFinanciacion').value;
		if(!Ext.isEmpty(fechaInicioFinanciacion) && !Ext.isEmpty(fechaFinFinanciacion) && fechaInicioFinanciacion>fechaFinFinanciacion){
			me.fireEvent("errorToast", HreRem.i18n("msg.fechaFin.mayor.Fecha.Inicio"));
			field.setValue('');
		}
	},
	
	onHaCambiadoFechaFinFinanciacionBankia: function(field, value, oldValue){
		var me= this;
		var fechaFinFinanciacionBankia= value;
		var fechaInicioFinanciacionBankia= me.lookupReference('fechaInicioFinanciacionBankia').value;
		if(!Ext.isEmpty(fechaInicioFinanciacionBankia) && !Ext.isEmpty(fechaFinFinanciacionBankia) && fechaInicioFinanciacionBankia>fechaFinFinanciacionBankia){
			me.fireEvent("errorToast", HreRem.i18n("msg.fechaFin.mayor.Fecha.Inicio"));
			field.setValue('');
		}
	},
	
	onTipoComisionSelect: function(combo, recordSelected) {
		var me = this;
		var comboTipoProveedor = me.lookupReference('tipoProveedorRef');
		var storeTipoProveedor = comboTipoProveedor.getStore();
		
		// Reiniciar el contenido del combo 'Tipo proveedor'.
		comboTipoProveedor.setValue(null);
		comboTipoProveedor.setRawValue(null);

		// Filtrar contenido del combo 'Tipo proveedor'.
		if(recordSelected.get('codigo') == CONST.ACCION_GASTOS['COLABORACION']) {
			storeTipoProveedor.clearFilter();
			storeTipoProveedor.filter([{
                filterFn: function(rec){
                    if (rec.get('codigo') == CONST.TIPO_PROVEEDOR_HONORARIO['MEDIADOR'] || rec.get('codigo') == CONST.TIPO_PROVEEDOR_HONORARIO['FVD']){
                        return true;
                    }
                    return false;
                }
            }]);
		} else {
			storeTipoProveedor.clearFilter();
		}
		
	},
	
	onSelectComboActivoHonorarios: function(combo, recordSelected) {
		
		var me = this;
		var grid = me.lookupReference('listadohoronarios');
		var record = Ext.isDefined(grid.rowEditing.context) ? grid.rowEditing.context.record : null;
		var importeParticipacionActivo = recordSelected.get("importeParticipacion");
		
		if(Ext.isEmpty(importeParticipacionActivo)) {
			grid.rowEditing.cancelEdit();
			me.fireEvent("errorToast", HreRem.i18n("msg.necesaria.participacion.calculo.honorario"));				
		} else {
			record.set("participacionActivo",importeParticipacionActivo);
		}
		
	},
	
	onHaCambiadoImporteCalculo: function(field, value, oldValue){
		var me= this;
		var tipoCalculoField= me.lookupReference('tipoCalculoHonorario')
		var importeField= me.lookupReference('importeCalculoHonorario')
		var tipoCalculo= me.lookupReference('tipoCalculoHonorario').value;
		var record = Ext.isDefined(me.lookupReference('listadohoronarios').rowEditing.context) ? me.lookupReference('listadohoronarios').rowEditing.context.record : null;

		if(CONST.TIPOS_CALCULO['FIJO'] == tipoCalculo){//importe fijo
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			honorarios.setValue(importeCalculoHonorario);
			importeField.setMaxValue(null);
		}
		
		else if(CONST.TIPOS_CALCULO['PORCENTAJE'] == tipoCalculo){//porcentaje
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			var importeParticipacion = Ext.isEmpty(record) ?  null : record.get("participacionActivo");
			var honorario;
			if(!Ext.isEmpty(record) && Ext.isEmpty(importeParticipacion)) {
				me.fireEvent("errorToast", HreRem.i18n("msg.necesaria.participacion.calculo.honorario"));
			} else {				
				importeParticipacion = parseFloat(importeParticipacion).toFixed(2);
				honorario = (importeParticipacion*importeCalculoHonorario)/100;
				honorarios.setValue(Math.round(honorario * 100) / 100);
				importeField.setMaxValue(100);
			}
			me.fireEvent("log" , "[HONORARIOS: Tipo: "+tipoCalculo+" | Calculo: "+importeCalculoHonorario+" | Participacion: "+importeParticipacion+" | Importe: "+Math.round(honorario * 100) / 100+"]");
		}
		
		else if(CONST.TIPOS_CALCULO['FIJO_ALQ'] == tipoCalculo){//Importe fijo Alquiler
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			honorarios.setValue(importeCalculoHonorario);
			importeField.setMaxValue(null);
		}
		
		else if(CONST.TIPOS_CALCULO['PORCENTAJE_ALQ'] == tipoCalculo){//Porcentaje Alquiler
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			var importeParticipacion = Ext.isEmpty(record) ?  null : record.get("participacionActivo");
			var honorario;
			if(!Ext.isEmpty(record) && Ext.isEmpty(importeParticipacion)) {
				me.fireEvent("errorToast", HreRem.i18n("msg.necesaria.participacion.calculo.honorario"));
			} else {				
				importeParticipacion = parseFloat(importeParticipacion).toFixed(2);
				honorario = ((importeParticipacion*importeCalculoHonorario)/100)*12;
				honorarios.setValue(Math.round(honorario * 100) / 100);
				importeField.setMaxValue(100);
			}
			me.fireEvent("log" , "[HONORARIOS: Tipo: "+tipoCalculo+" | Calculo: "+importeCalculoHonorario+" | Participacion: "+importeParticipacion+" | Importe: "+Math.round(honorario * 100) / 100+"]");
		}
		
		else if(CONST.TIPOS_CALCULO['MENSUALIDAD_ALQ'] == tipoCalculo){//Mensualidad Alquiler
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			var importeParticipacion = Ext.isEmpty(record) ?  null : record.get("participacionActivo");
			var honorario;
			if(!Ext.isEmpty(record) && Ext.isEmpty(importeParticipacion)) {
				me.fireEvent("errorToast", HreRem.i18n("msg.necesaria.participacion.calculo.honorario"));
			} else {				
				importeParticipacion = parseFloat(importeParticipacion).toFixed(2);
				honorario = importeParticipacion*importeCalculoHonorario;
				honorarios.setValue(Math.round(honorario * 100) / 100);
				importeField.setMaxValue(100);
			}
			me.fireEvent("log" , "[HONORARIOS: Tipo: "+tipoCalculo+" | Calculo: "+importeCalculoHonorario+" | Participacion: "+importeParticipacion+" | Importe: "+Math.round(honorario * 100) / 100+"]");
		}/*
		
		else if(tipoCalculo=='Importe fijo'){
			tipoCalculoField.setValue(CONST.TIPOS_CALCULO['FIJO']);
		}
		else if(tipoCalculo=='Porcentaje'){
			tipoCalculoField.setValue(CONST.TIPOS_CALCULO['PORCENTAJE']);
		}*/
		
	},
	
	onHaCambiadoSolicitaReserva: function(combo, value){
		var me= this;
		var carteraCodigo = me.getViewModel().get('expediente.entidadPropietariaCodigo');
		var esCarteraGaleonOZeus =  ('15' == carteraCodigo || '14' == carteraCodigo);
		if(!esCarteraGaleonOZeus && value==1){
			me.lookupReference('tipoCalculo').setDisabled(false);
		}else{
			
			me.lookupReference('tipoCalculo').setDisabled(true);		
			me.lookupReference('tipoCalculo').setValue(null);
		}

	},
	
	onClickBotonCerrarComprador: function(btn){
		var me = this;
		var window = btn.up("window");
		window.hide();
	},

	onClickBotonCancelarWizardComprador : function(btn) {

		var me = this, window = btn.up('window');
		var form1 = window.down('anyadirnuevaofertadocumento');
		var form2 = window.down('datoscompradorwizard');
		var form3 = window.down('anyadirnuevaofertaactivoadjuntardocumento');
		var docCliente = form2.getForm().findField('numDocumento').getValue();
		Ext.Msg.show({
			title : HreRem.i18n('wizard.msg.show.title'),
			msg : HreRem.i18n('wizard.msh.show.text'),
			buttons : Ext.MessageBox.YESNO,
			fn : function(buttonId) {
				if (buttonId == 'yes') {
					var url = $AC.getRemoteUrl('expedientecomercial/deleteTmpClienteByDocumento');
					Ext.Ajax.request({
                         url: url,
                         method : 'POST',
                         params: {docCliente: docCliente},
                         success: function(response, opts) {
                            //me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
                         },
                         failure: function(record, operation) {
                            //me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                         }
                    });

					if (!Ext.isEmpty(form1)) {
						form1.reset();
					}
					/*if (!Ext.isEmpty(form2)) {
						form2.reset();
					}*/
					if (!Ext.isEmpty(form3)) {
						form3.reset();
					}
					
					window.hide();
				}
			}
		});
	},
	
	onClickBotonCrearComprador: function(btn){
		var me = this,
		ventanaDetalle = btn.up().up(),	    
		ventanaWizard = btn.up('wizardaltacomprador'),
		ventanaDatosComprador = ventanaWizard.down("datoscompradorwizard"),
		form = ventanaDatosComprador.getForm();
		form.updateRecord();
		ventanaWizard.height =  Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight()-100;
		ventanaWizard.setY( Ext.Element.getViewportHeight()/2 - ((Ext.Element.getViewportHeight() > 500 ? 500 : Ext.Element.getViewportHeight() -100)/2));
		
		if(ventanaDetalle.config.xtype.indexOf('datoscompradorwizard') >=0){
			var pedirDocValor = ventanaDetalle.getForm().findField('pedirDoc').getValue(),
			comprador = form.getRecord();

			if (pedirDocValor == 'false'){

				if (form.isValid()) {
					var url = $AC.getRemoteUrl('expedientecomercial/getListAdjuntosComprador'),
                    idExpediente = comprador.data.idExpedienteComercial,
                    docCliente = comprador.data.numDocumento;

                    Ext.Ajax.request({
                         url: url,
                         method : 'GET',
                         waitMsg: HreRem.i18n('msg.mask.loading'),
                         params: {docCliente: docCliente, idExpediente: idExpediente},

                         success: function(response, opts) {
                             var data = Ext.decode(response.responseText);
                             if(!Ext.isEmpty(data.data)){
                                 ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('docOfertaComercial').setValue(data.data[0].nombre);
                                 ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').down().down('panel').down('button').show();
                             }
                         },

                         failure: function(record, operation) {
                            me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                         }
                    });

                    ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('cesionDatos').setValue(comprador.data.cesionDatos);
                    ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('comunicacionTerceros').setValue(comprador.data.comunicacionTerceros);
                    ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').getForm().findField('transferenciasInternacionales').setValue(comprador.data.transferenciasInternacionales);
                    
                    if(comprador.data.cesionDatos) {
                    	ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnGenerarDoc]').disable();
                    	ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnSubirDoc]').disable();
                    	ventanaWizard.down('anyadirnuevaofertaactivoadjuntardocumento').down('button[itemId=btnFinalizar]').enable();
                    }
                    
                    var wizard = btn.up().up().up();
                    var layout = wizard.getLayout();
                    layout["next"]();
				}
			}else{
				me.guardarComprador(form, ventanaWizard);
			}

		}else{
			var cesionDatos = ventanaDetalle.getForm().findField('cesionDatos').getValue(),
			comunicacionTerceros = ventanaDetalle.getForm().findField('comunicacionTerceros').getValue(),
			transferenciasInternacionales = ventanaDetalle.getForm().findField('transferenciasInternacionales').getValue();

            ventanaWizard.down('datoscompradorwizard').getForm().findField('cesionDatos').setValue(cesionDatos);
            ventanaWizard.down('datoscompradorwizard').getForm().findField('comunicacionTerceros').setValue(comunicacionTerceros);
            ventanaWizard.down('datoscompradorwizard').getForm().findField('transferenciasInternacionales').setValue(transferenciasInternacionales);

            me.guardarComprador(form, ventanaWizard);      
		}
	},

	guardarComprador: function(form, ventanaWizard) {

		var me = this;
		if (form.isValid()) {
			form.recordName = "comprador";
			form.recordClass = "HreRem.model.FichaComprador";
			form.updateRecord();
			ventanaWizard.mask(HreRem.i18n("msg.mask.espere"));
			var record = form.getRecord();
			record.save({
				success : function(a, operation, c) {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					form.reset();
					ventanaWizard.hide();
				    me.getView().unmask();
					me.refrescarExpediente(true);
				},
				failure : function(a, operation) {
					ventanaWizard.unmask();
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				}
			});


		} else {

			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	},

	abrirFormularioCrearComprador: function(grid) {
		var me = this,
		idExpediente = me.getViewModel().get("expediente.id"),
		codigoEstado = me.getViewModel().get("expediente.codigoEstado"),
		tipoExpedienteCodigo = me.getViewModel().get("expediente.tipoExpedienteCodigo"),
		origen = me.getViewModel().get("expediente.origen"),
		bloqueado = me.getViewModel().get("expediente.bloqueado"),
		tipoOrigenWCOM = CONST.TIPOS_ORIGEN["WCOM"],
		fechaSancion = me.getViewModel().get('expediente.fechaSancion');

		if (!bloqueado) {
			if (CONST.ESTADOS_EXPEDIENTE['VENDIDO'] != codigoEstado) {
				if (CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER'] == tipoExpedienteCodigo) {
					if (tipoOrigenWCOM == origen
							&& !Ext.isEmpty(fechaSancion)) {
						me.fireEvent("errorToast",
								"Expediente con origen WCOM");
						return;
					}
					if (Ext.isEmpty(fechaSancion)) {
						var ventanaCompradores = grid.up().up();
						var expediente = me.getViewModel().get("expediente");
						me.getView().fireEvent('openModalWindow', 'HreRem.view.expedientes.WizardAltaComprador',{
							idExpediente : idExpediente,
							parent : ventanaCompradores,
							expediente : expediente,
							deshabilitarCamposDoc : false
						});
						
						//me.onClickBotonRefrescar();
					} else {
						me.fireEvent("errorToast",
								"Expediente sancionado");
					}
					return;
				}
				if (CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'] == tipoExpedienteCodigo) {
					var ventanaCompradores = grid.up().up();
					var expediente = me.getViewModel().get("expediente");
					me.getView().fireEvent('openModalWindow', 'HreRem.view.expedientes.WizardAltaComprador',{
						idExpediente : idExpediente,
						parent : ventanaCompradores,
						expediente : expediente,
						deshabilitarCamposDoc : false
					});
					//me.onClickBotonRefrescar();
					return;
				}
			} else {
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.expediente.vendido"));
			}
		} else {
			me.fireEvent("errorToast", "Expediente bloqueado");
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
    
    onChangeComboProvincia: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);   

    	me.getViewModel().notify();
    	if(Ext.isEmpty(combo.getValue())) {
			chainedCombo.clearValue();
    	}

		chainedCombo.getStore().load({ 			
			params: {codigoProvincia: combo.getValue()},
			callback: function(records, operation, success) {
   				if(!Ext.isEmpty(records) && records.length > 0) {   					
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

	consultarComiteSancionador: function(btn) {

		var me = this,
		comboComitePropuesto = me.lookupReference('comboComitePropuesto');

		var url =  $AC.getRemoteUrl('expedientecomercial/consultarComiteSancionador');

			me.getView().mask(HreRem.i18n("msg.mask.espere"));
			Ext.Ajax.request({
			     url: url,
			     params:  {idExpediente : me.getViewModel().get("expediente.id")},
			     success: function(response, opts) {
			     	var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }  catch (e){ };
	                
	                if(data.success === "true") {
	                	comboComitePropuesto.setValue(data.codigo);           	
	                }else {
	                	Utils.defaultRequestFailure(response, opts);
	                }
			     },

			     failure: function(response, opts) {
		     		Utils.defaultRequestFailure(response, opts);
			     },

			     callback: function() {
			     	me.getView().unmask();
			     }
	    	});
	},
	
	enviarTitularesUvem: function(btn){
		var me= this;
		var url =  $AC.getRemoteUrl('expedientecomercial/enviarTitularesUvem');
		me.getView().mask(HreRem.i18n("msg.mask.espere"));
		
		Ext.Ajax.request({
			     url: url,
			     params:  {idExpediente : me.getViewModel().get("expediente.id")},
			     success: function(response, opts) {
			     	var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }  catch (e){ };
	                
	                if(data.success === "true") {
	                	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));           	
	                }else {
	                	if(data.errorUvem == "true"){
	                		me.fireEvent("errorToast", data.msg);		
	                	}
	                	else{
	                		Utils.defaultRequestFailure(response, opts);
	                	}
	                }
			     },

		        failure: function(response, opts) {
			        if(data.errorUvem == "true"){
						me.fireEvent("errorToast",
													data.msg);
					} else {
						Utils.defaultRequestFailure(
								response, opts);
					}
				},

				callback : function() {
					me.getView().unmask();
				}
			});
		},

		borrarComprador: function(grid, record) {
			var me = this;
			var idExpediente = me.getViewModel().get("expediente.id");
			var codigoEstado= me.getViewModel().get("expediente.codigoEstado");
			var idComprador= record.get('id');
			var tipoExpedienteCodigo = me.getViewModel().get("expediente.tipoExpedienteCodigo");
			var origen = me.getViewModel().get("expediente.origen");
			var bloqueado = me.getViewModel().get("expediente.bloqueado");
			var fechaSancion = me.getViewModel().get('expediente.fechaSancion');
			var tipoOrigenWCOM = CONST.TIPOS_ORIGEN["WCOM"];
			var llamada = false;

			if(CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'] == tipoExpedienteCodigo) {
				if(!bloqueado) {
					if(CONST.ESTADOS_EXPEDIENTE['VENDIDO']!=codigoEstado) {
						llamada = true;
					} else {
						me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.expediente.vendido"));
					}
				} else {
					me.fireEvent("errorToast", "Expediente bloqueado");
				}
			} else if(CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER'] == tipoExpedienteCodigo) {
				if(tipoOrigenWCOM != origen) {
					if(Ext.isEmpty(fechaSancion)) {
						llamada = true;
					} else {
						me.fireEvent("errorToast","Expediente sancionado");
					}
				} else {
	                me.fireEvent("errorToast","Expediente con origen WCOM");
	            }
			}

			if(llamada == true) {
				record.erase({
					params: {idExpediente: idExpediente, idComprador: idComprador},
		            success: function(record, operation) {
		                me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		                grid.fireEvent("afterdelete", grid);
		                me.onClickBotonRefrescar();
		            },
					failure: function(record, operation) {
		                var data = {};
					    try {
					        data = Ext.decode(operation._response.responseText);
					    }
					    catch (e){ };
				        if (!Ext.isEmpty(data.msg)) {
				            me.fireEvent("errorToast", data.msg);
				        }
				        else {
				            me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				        }
		                grid.fireEvent("afterdelete", grid);
		            }
				});
			}
		},

	enviarHonorariosUvem : function(btn) {
		var me = this;
		var url = $AC.getRemoteUrl('expedientecomercial/enviarHonorariosUvem');
		me.getView().mask(HreRem.i18n("msg.mask.espere"));
		
		Ext.Ajax.request({
			url: url,
			
		    params:  {
		    	idExpediente : me.getViewModel().get("expediente.id")
		    },
		    
		    success: function(response, opts) {
		    	var data = {};
		    	try {
		    		data = Ext.decode(response.responseText);
		    	}  catch (e){ };
               
		    	if(data.success === "true") {
		    		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));           	
		    	}else {
		    		if(data.errorUvem == "true"){
		    			me.fireEvent("errorToast", data.msg);		
		    		}
		    		else{
		    			Utils.defaultRequestFailure(response, opts);
		    		}
		    	}
		     },

		     failure: function(response, opts) {
		    	 if(data.errorUvem == "true"){
		    		 me.fireEvent("errorToast", data.msg);		
		    	 } else {
		    		 Utils.defaultRequestFailure(response, opts);
		    	 }
		     },

		     callback: function() {
		    	 me.getView().unmask();
		     }
		});		
	},
	
	buscarClientesUrsus: function(field, e){
		var me = this;
		var parent = field.up('datoscompradorwizard');
		if(Ext.isEmpty(parent)){
			parent = field.up('datoscompradorwindow');
		}
		var tipoDocumento = field.up('formBase').down(
				'[reference=tipoDocumento]').getValue();
		var numeroDocumento = field.up('formBase').down(
				'[reference=numeroDocumento]').getValue();
		var fichaComprador = field.up('[xtype=formBase]');
		var idExpediente = me.getViewModel().get(
				"expediente.id");
		if (idExpediente == null) {
			idExpediente = fichaComprador.getRecord().get('idExpedienteComercial');
		}

		if (!Ext.isEmpty(tipoDocumento)
				&& !Ext.isEmpty(numeroDocumento)
				&& !Ext.isEmpty(idExpediente)) {
			//var form = parent.down('formBase');
			var fieldClientesUrsus = parent.down('[reference=seleccionClienteUrsus]');
			var store = fieldClientesUrsus.getStore();

			if (Ext.isEmpty(store.getData().items)
					|| fieldClientesUrsus.recargarField) {
				store.removeAll();
				store.getProxy().setExtraParams({
					numeroDocumento : numeroDocumento,
					tipoDocumento : tipoDocumento,
					idExpediente : idExpediente
				});
				store.load({
					callback : function(records, operation, success) {
						if (success) {
							fieldClientesUrsus.recargarField = false;
						} else {
							Utils.defaultRequestFailure(operation.getResponse());
						}
					}
				});
			}
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.ursus.necesita.tipo.documento"));
		}
	},
	
	onNumeroDocumentoChange: function(field, e) {
		var me = this;
		var fieldClientesUrsus = field.up('formBase').down('[reference=seleccionClienteUrsus]');
		var btnDatosClienteUrsus = field.up('formBase').down('[reference=btnVerDatosClienteUrsus]');
		
		fieldClientesUrsus.reset();
		btnDatosClienteUrsus.setDisabled(true);
		fieldClientesUrsus.recargarField = true;
	},
	
	establecerNumClienteURSUS: function(field, e) {
		var me = this;
		var parent = field.up('datoscompradorwizard');
		if(Ext.isEmpty(parent)){
			parent = field.up('formBase');
		}
		var numeroUrsus = parent.down('[reference=seleccionClienteUrsus]').getValue();
	 	var fieldNumeroClienteUrsus = parent.down('[reference=numeroClienteUrsusRef]');
	 	var fieldNumeroClienteUrsusBh = parent.down('[reference=numeroClienteUrsusBhRef]');
	 	var btnDatosClienteUrsus = parent.down('[reference=btnVerDatosClienteUrsus]');
	 	//var fichaComprador= field.up('[xtype=formBase]');
	 	btnDatosClienteUrsus.setDisabled(false);
	 	
	 	if(!Ext.isEmpty(fieldNumeroClienteUrsus)){
	 		fieldNumeroClienteUrsusBh.setValue(numeroUrsus);
	 	}
	 	if(!Ext.isEmpty(fieldNumeroClienteUrsus)){
	 		fieldNumeroClienteUrsus.setValue(numeroUrsus);
	 	}	 	
	 	
	},

	mostrarDetallesClienteUrsus: function(field, newValue ,oldValue ,eOpts){
		var me = this;
		var form = field.up('formBase');
		var url =  $AC.getRemoteUrl('expedientecomercial/buscarDatosClienteNumeroUrsus');
		var numeroUrsus = form.down('[reference=seleccionClienteUrsus]').getValue();
		var parent = field.up('windowBase');
		var idExpediente;
		try{
			idExpediente = form.getRecord().get('idExpedienteComercial');
		}catch(error){
			idExpediente = me.getViewModel().get("expediente.id");
		}
		

		parent.mask(HreRem.i18n("msg.mask.loading"));
		
		Ext.Ajax.request({
		     url: url,
		     params: {numeroUrsus: numeroUrsus, idExpediente: idExpediente},
			 method: 'GET',
		     success: function(response, opts) {
		     	var data = {};
		     	parent.unmask();
		     	try {
		     		data = Ext.decode(response.responseText);
		     	} catch(e) {
		     		data = {};	
		     	}
    		    if (data.success == 'true' && !Utils.isEmptyJSON(data.data)) {
    		    	me.abrirDatosClienteUrsus(data.data, parent);
    		    } else {
    		    	Utils.defaultRequestFailure(response, opts);
    		    }
		     },
		     failure: function(response) {
		    	 parent.unmask();
		    	 Utils.defaultRequestFailure(response, opts);
		     }
		});
	},

	abrirDatosClienteUrsus: function(datosClienteUrsus, parent) {
		var me = this;
		parent.setX(Ext.Element.getViewportWidth() / 40);
		var window = Ext.create('HreRem.view.expedientes.DatosClienteUrsus',{clienteUrsus: datosClienteUrsus});
		parent.add(window);
		window.show();
	},

	onClickBotonCerrarClienteUrsus: function(btn){
		var me = this;
		var window = btn.up("window");
		window.destroy();
	},

	changeComboTipoProveedor: function(combo,value,c){
		var me= this;
		if(combo.getValue()==CONST.TIPOS_PROVEEDOR_EXPEDIENTE['CAT'] || combo.getValue()==CONST.TIPOS_PROVEEDOR_EXPEDIENTE['MEDIADOR_OFICINA']){
			me.lookupReference('proveedorRef').setValue(null);
			me.lookupReference('proveedorRef').setDisabled(true);
		} else {
			me.lookupReference('proveedorRef').setDisabled(false);
		}
	},

	borrarComprador: function(grid, record) {
		var me = this;
		var idExpediente = me.getViewModel().get("expediente.id");
		var codigoEstado= me.getViewModel().get("expediente.codigoEstado");
		var idComprador= record.get('id');
		var tipoExpedienteCodigo = me.getViewModel().get("expediente.tipoExpedienteCodigo");
		var origen = me.getViewModel().get("expediente.origen");
		var bloqueado = me.getViewModel().get("expediente.bloqueado");
		var fechaSancion = me.getViewModel().get('expediente.fechaSancion');
		var tipoOrigenWCOM = CONST.TIPOS_ORIGEN["WCOM"];
		var llamada = false;
		
		if(CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'] == tipoExpedienteCodigo) {
			if(!bloqueado) {
				if(CONST.ESTADOS_EXPEDIENTE['VENDIDO']!=codigoEstado) {
					if (tipoOrigenWCOM != origen) {
						llamada = true;
					} else {
						me.fireEvent("errorToast", "Expediente con origen WCOM");
					}
				} else {
					me.fireEvent("errorToast",HreRem.i18n("msg.operacion.ko.expediente.vendido"));
				}
			} else {
				me.fireEvent("errorToast", "Expediente bloqueado");
			}
		} else if(CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER'] == tipoExpedienteCodigo) {
			if(tipoOrigenWCOM != origen) {
				if(Ext.isEmpty(fechaSancion)) {
					llamada = true;
				} else {
					me.fireEvent("errorToast","Expediente sancionado");
				}
			} else {
            	me.fireEvent("errorToast","Expediente con origen WCOM");
            }
		}
		
		if(llamada == true) {
			record.erase({
				params: {idExpediente: idExpediente, idComprador: idComprador},
	            success: function(record, operation) {
	            	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	            	grid.fireEvent("afterdelete", grid);
	           		me.onClickBotonRefrescar();
	            },
				failure: function(record, operation) {
	            	var data = {};
				    try {
				    	data = Ext.decode(operation._response.responseText);
				    } catch (e){ };
			    	if (!Ext.isEmpty(data.msg)) {
			        	me.fireEvent("errorToast", data.msg);
			        } 
			        else {
			        	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			        }
	                grid.fireEvent("afterdelete", grid);
	            }
			});
		}
	},

	// Este método establece el atributo 'allowBlank' en los campos peticionario y motivo anulación
	// de la ficha del expediente si existe una fecha de anulación.
	onFechaAnulacionChange: function(dateField) {
		var me = this;

		var peticionario = dateField.up('expedientedetallemain').lookupReference('textFieldPeticionario');
		var motivoAnulacion = dateField.up('expedientedetallemain').lookupReference('comboMotivoAnulacion');

		if(Ext.isEmpty(dateField.getValue())) {
			peticionario.allowBlank = true;
			motivoAnulacion.allowBlank = true;
			peticionario.readOnly = true;
			peticionario.editable = false;
		} else {
			peticionario.allowBlank = false;
			motivoAnulacion.allowBlank = false;
			peticionario.readOnly = false;
			peticionario.editable = true;
			
		}
		// Hacer saltar inmediatamente la validación de los campos.
		peticionario.validate();
		motivoAnulacion.validate();
	},

	cargaValorVpo: function() {
		var me = this,
    	disabled = me.lookupReference('comboVpo').getValue() == 0,
    	procedeDescalificacion = me.lookupReference('procedeDescalificacionRef');

		procedeDescalificacion.setDisabled(disabled);
	},

	comprobarCamposFechas: function(editor, gridNfo) {
		var me = this;

		if(editor.isNew) {
			me.lookupReference('fechaAvisoRef').setValue();
			me.lookupReference('fechaPosicionamientoRef').setValue();
			me.lookupReference('horaAvisoRef').setValue();
			me.lookupReference('horaPosicionamientoRef').setValue();
		}
		me.changeFecha(me.lookupReference('fechaAvisoRef'));
		me.changeFecha(me.lookupReference('fechaPosicionamientoRef'));
		me.changeHora(me.lookupReference('horaAvisoRef'));
		me.changeHora(me.lookupReference('horaPosicionamientoRef'));
		
		me.lookupReference('fechaPosicionamientoRef').setDisabled(false);
		me.lookupReference('horaPosicionamientoRef').setDisabled(false);
		me.lookupReference('motivoAplazamientoRef').setDisabled(true);
	},

	comprobarCamposFechasAlquiler: function(editor, gridNfo) {
		var me = this;

		if(editor.isNew) {
			me.lookupReference('fechaFirmaRef').setValue();
			me.lookupReference('horaFirmaRef').setValue();
			me.lookupReference('motivoAplazamientoRef').setValue();
		}
		me.changeFecha(me.lookupReference('fechaFirmaRef'));
		me.changeHora(me.lookupReference('horaFirmaRef'));
		
		me.lookupReference('fechaFirmaRef').setDisabled(false);
		me.lookupReference('horaFirmaRef').setDisabled(false);
		me.lookupReference('lugarFirmaRef').setDisabled(false);
	},
	
	comprobacionesDobleClick: function(editor, gridNfo) {
		var me = this;
		
		if(editor.isNew) {
			me.lookupReference('fechaAvisoRef').setValue();
			me.lookupReference('fechaPosicionamientoRef').setValue();
			me.lookupReference('horaAvisoRef').setValue();
			me.lookupReference('horaPosicionamientoRef').setValue();
		}
		me.changeFecha(me.lookupReference('fechaAvisoRef'));
		me.changeFecha(me.lookupReference('fechaPosicionamientoRef'));
		me.changeHora(me.lookupReference('horaAvisoRef'));
		me.changeHora(me.lookupReference('horaPosicionamientoRef'));
		
		me.lookupReference('fechaPosicionamientoRef').setDisabled(true);
		me.lookupReference('horaPosicionamientoRef').setDisabled(true);
		me.lookupReference('motivoAplazamientoRef').setDisabled(false);
	},

	comprobacionesDobleClickAlquiler: function(editor, gridNfo) {
		var me = this;

		if(editor.isNew) {
			me.lookupReference('fechaFirmaRef').setValue();
			me.lookupReference('horaFirmaRef').setValue();
		}
		me.changeFecha(me.lookupReference('fechaFirmaRef'));
		me.changeHora(me.lookupReference('horaFirmaRef'));
		
		me.lookupReference('fechaFirmaRef').setDisabled(true);
		me.lookupReference('horaFirmaRef').setDisabled(true);
		me.lookupReference('lugarFirmaRef').setDisabled(true);
		me.lookupReference('motivoAplazamientoRef').setDisabled(false);
	},

	onRowClickPosicionamiento:  function(gridView, record) {
		var me = this;  

		if(!Ext.isEmpty(record.get('fechaFinPosicionamiento'))){
			gridView.grid.down('#removeButton').setDisabled(true);
		}
		else{
			gridView.grid.down('#removeButton').setDisabled(false);
		}
		if(!Ext.isEmpty(record.get('idProveedorNotario'))){
			me.getViewModel().set("posicionamSelected", record);
			me.getViewModel().notify();
			me.lookupReference('listadoNotarios').getStore().load();
		}
	},

	onRowClickPosicionamientoAlquiler:  function(gridView, record) {
		var me = this; 
		if(!Ext.isEmpty(record.get('fechaFinPosicionamiento'))){
			gridView.grid.down('#removeButton').setDisabled(true);
		}
		else{
			gridView.grid.down('#removeButton').setDisabled(false);
		}

	},

	changeFecha: function(campoFecha) {
		var me = this,
		referencia = campoFecha.getReference().replace('fecha','hora'),
		campoHora = me.lookupReference(referencia);
		
		if(campoFecha.getValue() != null) {
			if (campoHora.isVisible()) {
				campoHora.setDisabled(false);
				campoHora.allowBlank = false;
				if(campoHora.getValue() == null) {//De esta forma se marca en rojo como obligatorio sin tener que pinchar en el campo
					campoHora.setValue('00:00');
					campoHora.setValue();
				}
			} else {
				campoHora.setValue('00:00');
			}
		}
		else {
			campoHora.setValue();
			campoHora.setDisabled(true);
			campoHora.allowBlank = true;
		}
	},
	
	changeHora: function(campoHora) {
		var me = this;
		if(campoHora.getValue() != null) {
			campoHora.wasValid = false;
			
			//Le metemos la hora a la fecha completa que contiene fecha y hora, que es la que se guardará en bd.
			var fechaHora = me.lookupReference(campoHora.getReference().replace('hora','fechaHora'));
			var fechaRef = campoHora.getReference().replace('hora','fecha')
			
			fechaHora.setValue(me.lookupReference(fechaRef).getValue());
			fechaHora.value.setTime(me.lookupReference(fechaRef).value);
			fechaHora.value.setHours(campoHora.value.getHours());
			fechaHora.value.setMinutes(campoHora.value.getMinutes());
		}
		else
			campoHora.wasValid = true;
	},

	numVisitaIsEditable: function() {
		var me = this,
		campoNumVisita = me.lookupReference('numVistaFromOfertaRef');
		// Si el estado de la visita no es REALIZADA, no debe haber numVisita relacionada
		if(me.lookupReference('comboEstadosVisita').getValue() == "03" )
			campoNumVisita.setDisabled(false);
		else {
			campoNumVisita.setValue();
			campoNumVisita.setDisabled(true);
		}
	},
comprobarObligatoriedadRte: function(){
    	
    	var me = this;
    	var venta = null;
    	if(me.getViewModel().get('expediente.tipoExpedienteCodigo') == null){
    		if (me.getViewModel().data.esOfertaVentaFicha == true){
    			venta = true;
    		}else{
    			venta = false;
    		}
    	}
    	campoProvinciaRte = me.lookupReference('provinciaComboRte');
		campoMunicipioRte = me.lookupReference('municipioComboRte');
		campoDireccion = me.lookupReference('direccion');
		campoProvincia = me.lookupReference('provinciaCombo');
		campoMunicipio = me.lookupReference('municipioCombo');

    	if(me.getViewModel().get('expediente.tipoExpedienteCodigo') == "01" || venta == true){
    		if(me.lookupReference('tipoPersona').getValue() === "2" ) {
    			if(me.lookupReference('pais').getValue() == "28"){
    				if(!Ext.isEmpty(campoProvincia)){
						campoProvincia.allowBlank = false;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = false;
					}					
				}else{
    				if(!Ext.isEmpty(campoProvincia)){
    					campoProvincia.allowBlank = true;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = true;
					}
				}
    			if(me.lookupReference('paisRte').getValue() == "28"){
					if(!Ext.isEmpty(campoProvinciaRte)){
						campoProvinciaRte.allowBlank = false;
					}
					if(!Ext.isEmpty(campoMunicipioRte)){
						campoMunicipioRte.allowBlank = false;
					}
					
				}else{
					if(!Ext.isEmpty(campoProvinciaRte)){
						campoProvinciaRte.allowBlank = true;
					}
					if(!Ext.isEmpty(campoMunicipioRte)){
						campoMunicipioRte.allowBlank = true;
					}
				}
    		}else if (me.lookupReference('tipoPersona').getValue() === "1"){
    			if(me.lookupReference('pais').getValue() == "28"){
    				if(!Ext.isEmpty(campoProvincia)){
    					campoProvincia.allowBlank = false;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = false;
					}
				}else{
    				if(!Ext.isEmpty(campoProvincia)){
    					campoProvincia.allowBlank = true;
					}
    				if(!Ext.isEmpty(campoMunicipio)){
    					campoMunicipio.allowBlank = true;
					}
				}
    			if(!Ext.isEmpty(campoProvinciaRte)){
					campoProvinciaRte.allowBlank = true;
				}
				if(!Ext.isEmpty(campoMunicipioRte)){
					campoMunicipioRte.allowBlank = true;
				}
    		}
    	}
    },

	comprobarObligatoriedadCamposNexos: function() {

		try{
			var me = this;
			
			var venta = null;
	    	if(me.getViewModel().get('expediente.tipoExpedienteCodigo') == null){
	    		if (me.getViewModel().data.esOfertaVentaFicha == true){
	    			venta = true;
	    		}else{
	    			venta = false;
	    		}
	    	}
	    	me.comprobarObligatoriedadRte();
			campoEstadoCivil = me.lookupReference('estadoCivil'),
			campoRegEconomico = me.lookupReference('regimenMatrimonial'),
			campoNumConyuge = me.lookupReference('numRegConyuge'),
			campoTipoConyuge = me.lookupReference('tipoDocConyuge'),
			campoNombreRte = me.lookupReference('nombreRazonSocialRte'),
			campoTipoRte = me.lookupReference('tipoDocumentoRte'),
			campoNumRte = me.lookupReference('numeroDocumentoRte'),
			campoPaisRte = me.lookupReference('paisRte'),
			campoApellidosRte = me.lookupReference('apellidosRte'),	
			campoApellidos = me.lookupReference('apellidos');
			campoDireccion = me.lookupReference('direccion');
			campoProvincia = me.lookupReference('provinciaCombo');
			campoMunicipio = me.lookupReference('municipioCombo');
			campoPais = me.lookupReference('pais');
			//Si el expediente es de tipo alquiler
			if(me.getViewModel().get('expediente.tipoExpedienteCodigo') == "02" || venta == false){
				// Si el tipo de persona es FÍSICA, entonces el campos Estado civil es obligatorio y se habilitan campos dependientes.
				if(me.lookupReference('tipoPersona').getValue() === "1" ) {
					if(!Ext.isEmpty(campoApellidos)){
						campoApellidos.setDisabled(false);
					}
					if(!Ext.isEmpty(campoEstadoCivil)){
						campoEstadoCivil.allowBlank = false;
						//campoEstadoCivil.validate();
						if(campoEstadoCivil.getValue() === "02") {
							// Si el Estado civil es 'Casado', entonces Reg. económico es obligatorio.
							if(!Ext.isEmpty(campoRegEconomico)){
								campoRegEconomico.allowBlank = false;
								//campoRegEconomico.validate();
							}
							if(me.getViewModel().get('esCarteraLiberbank')|| me.getViewModel().get('comprador.entidadPropietariaCodigo') == CONST.CARTERA['LIBERBANK']){
								if(!Ext.isEmpty(campoNumConyuge)){
									campoNumConyuge.allowBlank = false;
									//campoNumConyuge.validate();
								}
								if(!Ext.isEmpty(campoRegEconomico) && !Ext.isEmpty(campoNumConyuge)){
									if(campoRegEconomico.getValue() === "01" || campoRegEconomico.getValue() === "03"){
										campoNumConyuge.allowBlank = false;
										//campoNumConyuge.validate();
									}else if(campoRegEconomico.getValue() === "02" ){
										campoNumConyuge.allowBlank = true;
									}
								}
							}else{
								if(!Ext.isEmpty(campoNumConyuge)){
									campoNumConyuge.allowBlank = true;
								}
							}
						} else {
								campoRegEconomico.setValue("");
								campoRegEconomico.allowBlank = true;
							
								campoTipoConyuge.setValue("");
								campoNumConyuge.setValue("");
								campoNumConyuge.allowBlank = true;
								campoTipoConyuge.allowBlank = true;
							
						}
					}
					
					
				} else {
					//  Si el tipo de persona es 'Jurídica' entonces desactivar los campos dependientes del otro estado.
					if(!Ext.isEmpty(campoEstadoCivil)){
						campoEstadoCivil.allowBlank = true;
					}
					if(!Ext.isEmpty(campoRegEconomico)){
						campoRegEconomico.allowBlank = true;
					}
					if(!Ext.isEmpty(campoApellidos)){
						campoApellidos.setDisabled(true);
					}
				}
		
				// Validar campos para que se muestre o desaparezca la visual roja.
				if(!Ext.isEmpty(campoEstadoCivil)){
					campoEstadoCivil.validate();
				}
				if(!Ext.isEmpty(campoRegEconomico)){
					campoRegEconomico.validate();
				}
				if(!Ext.isEmpty(campoNumConyuge)){
					campoNumConyuge.validate();
				}
			} else {

				//Si el tipo de expediente es de tipo venta
				if(me.lookupReference('tipoPersona').getValue() === "1" ) {
					
					if(!Ext.isEmpty(campoNombreRte)){
						campoNombreRte.allowBlank = true;
					}
					if(!Ext.isEmpty(campoApellidosRte)){
						campoApellidosRte.allowBlank = true;
					}
					if(!Ext.isEmpty(campoTipoRte)){
						campoTipoRte.allowBlank = true;
					}
					if(!Ext.isEmpty(campoNumRte)){
						campoNumRte.allowBlank = true;
					}
					if(!Ext.isEmpty(campoPaisRte)){
						campoPaisRte.allowBlank = true;
					}
					
					if(!Ext.isEmpty(campoApellidos)){
						campoApellidos.setDisabled(false);
						campoApellidos.allowBank = false;
					}
					if(!Ext.isEmpty(campoEstadoCivil)){
						campoEstadoCivil.allowBlank = false;
						//campoEstadoCivil.validate();
						if(campoEstadoCivil.getValue() === "02") {
							// Si el Estado civil es 'Casado', entonces Reg. economica es obligatorio.
							if(!Ext.isEmpty(campoRegEconomico)){
								campoRegEconomico.allowBlank = false;
								//campoRegEconomico.validate();
								campoRegEconomico.setDisabled(false);
								if(campoRegEconomico.getValue() == "01"){
									campoTipoConyuge.allowBlank = false;
									campoNumConyuge.allowBlank = false;
								}else{
									campoTipoConyuge.allowBlank = true;
									campoTipoConyuge.setValue("");
									campoNumConyuge.allowBlank = true;
									campoNumConyuge.setValue("");
								}
							}
							
						} else {							
								campoRegEconomico.setValue("");
								campoRegEconomico.allowBlank = true;							
							
								campoTipoConyuge.setValue("");
								campoNumConyuge.setValue("");
								campoNumConyuge.allowBlank = true;
								campoTipoConyuge.allowBlank = true;
							
						}
					}
					
					
				} else {
					//  Si el tipo de persona es 'Jurídica'
					if(!Ext.isEmpty(campoEstadoCivil)){
						campoEstadoCivil.allowBlank = true;
					}
					if(!Ext.isEmpty(campoRegEconomico)){
						campoRegEconomico.allowBlank = true;
					}
					if(!Ext.isEmpty(campoApellidos)){
						campoApellidos.setDisabled(true);
					}
					
					if(!Ext.isEmpty(campoNombreRte)){
						campoNombreRte.allowBlank = false;
					}
					if(!Ext.isEmpty(campoApellidosRte)){
						campoApellidosRte.allowBlank = false;
					}
					if(!Ext.isEmpty(campoTipoRte)){
						campoTipoRte.allowBlank = false;
					}
					if(!Ext.isEmpty(campoNumRte)){
						campoNumRte.allowBlank = false;
					}
					if(!Ext.isEmpty(campoPaisRte)){
						campoPaisRte.allowBlank = false;
					}
				}
		
				// Validar campos para que se muestre o desaparezca la visual roja.
//				if(!Ext.isEmpty(campoEstadoCivil)){
//					campoEstadoCivil.validate();
//				}
//				if(!Ext.isEmpty(campoRegEconomico)){
//					campoRegEconomico.validate();
//				}
//				if(!Ext.isEmpty(campoNumConyuge)){
//					campoNumConyuge.validate();
//				}
			}
				
		}catch(err) {
			Ext.global.console.log(err);
		}
	},

	validarFechaPosicionamiento: function(value){
		/*var hoy= new Date();
		hoy.setHours(0,0,0,0);
		var from = value.split("/");
		var fechaPosiString = new Date(from[2], from[1] - 1, from[0]);
		var fechaPosiDate= new Date(fechaPosiString);
		
		if(fechaPosiDate<hoy){
			return HreRem.i18n('info.msg.fecha.posicionamiento.mayor.hoy');;
		}
		else{
			return true;
		}*/
		return true;
	
	},
	buscarSucursal: function(field, e){
		var me= this;
		var url =  $AC.getRemoteUrl('proveedores/searchProveedorCodigoUvem');
		var cartera = me.getViewModel().get('reserva.cartera');
		var codSucursal = '';
		var nombreSucursal = '';
		if(cartera == CONST.CARTERA['BANKIA']){
			codSucursal = '2038' + field.getValue();
			nombreSucursal = ' (Oficina Bankia)';
		}else if(cartera == CONST.CARTERA['CAJAMAR']){
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

	onCambioTipoImpuesto: function(combo, value,oldValue, eOpts){
		try{
			if(!Ext.isEmpty(oldValue)){
				var me = this,
		    	tipoAplicable = me.lookupReference('tipoAplicable'),
		    	operacionExenta = me.lookupReference('chkboxOperacionExenta'),
		    	inversionSujetoPasivo = me.lookupReference('chkboxInversionSujetoPasivo'),
		    	renunciaExencion = me.lookupReference('chkboxRenunciaExencion');
		
		
		    	if(CONST.TIPO_IMPUESTO['ITP'] == value) {
		    		tipoAplicable.reset();
		    		tipoAplicable.setDisabled(true);
		    		tipoAplicable.allowBlank = true;
		    		tipoAplicable.setValue(0);
		    		operacionExenta.reset();
		    		operacionExenta.setReadOnly(true);
		    		inversionSujetoPasivo.reset();
		    		inversionSujetoPasivo.setReadOnly(true);
		    		renunciaExencion.reset();
		    		renunciaExencion.setReadOnly(true);
		    	} else {
		    		tipoAplicable.setDisabled(false);
		        	tipoAplicable.allowBlank = false;
		    		operacionExenta.setReadOnly(false);
		    		inversionSujetoPasivo.setReadOnly(false);
		    	}
			}
		}catch(err) {
  			Ext.global.console.log('Error en onCambioTipoImpuesto: '+err)
		}
	},

	onCambioOperacionExenta: function(checkbox, newValue, oldValue, eOpts) {
		if(!Ext.isEmpty(oldValue)){
			var me = this,
			renunciaExencion = me.lookupReference('chkboxRenunciaExencion'),
			tipoAplicable = me.lookupReference('tipoAplicable');
	
			if(newValue == true) {
				tipoAplicable.reset();
				tipoAplicable.allowBlank = true;
				tipoAplicable.setDisabled(true);
				renunciaExencion.setReadOnly(false);
			} else {
				tipoAplicable.setDisabled(false);
				tipoAplicable.allowBlank = false;
				renunciaExencion.reset();
				renunciaExencion.setReadOnly(true);
			}
		}
	},

	onCambioRenunciaExencion: function(checkbox, newValue, oldValue, eOpts) {
		if(!Ext.isEmpty(oldValue)){
			var me = this,
			tipoAplicable = me.lookupReference('tipoAplicable');
	
			if(newValue == false) {
				tipoAplicable.reset();
				tipoAplicable.allowBlank = true;
				tipoAplicable.setDisabled(true);
			} else {
				tipoAplicable.setDisabled(false);
				tipoAplicable.allowBlank = false;
			}
		}
	},
	onCambioCheckPorcentual: function(checkbox, newValue, oldValue, eOpts) {
			var me = this,
			ipc = me.lookupReference('checkboxIPC');
			porcentaje = me.lookupReference('escaladoRentaPorcentaje');
			
			if(newValue) {
				ipc.show();
				porcentaje.show();
			} else {
				ipc.hide();
				porcentaje.hide();
				
			}
	},	
	onCambioCheckRevMercado: function(checkbox, newValue, oldValue, eOpts) {
		var me = this,
		fecha = me.lookupReference('revisionMercadoFecha');
		cadaMes = me.lookupReference('escaladoRentasMeses');
		if(newValue) {
			fecha.show();
			cadaMes.show();
		} else {
			fecha.hide();
			cadaMes.hide();
		}
	},
	onCambioCheckEscaladoFijo: function(checkbox, newValue, oldValue, eOpts) {
		var me = this,
		fijoFecha = me.lookupReference('tipoEscaladoFecha');
		fijoIncremento = me.lookupReference('tipoEscaladoIncremento');
		grid= me.lookupReference('historicoCondicones');
		if(newValue) {
			grid.disableAddButton(false);
		} else {
			grid.disableAddButton(true);
		}
	},
	onCambioInversionSujetoPasivo: function(checkbox, newValue, oldValue, eOpts) {
		if(!Ext.isEmpty(oldValue)){
			var me = this,
			operacionExenta = me.lookupReference('chckboxOperacionExenta'),
	    	renunciaExencion = me.lookupReference('chkboxRenunciaExencion'),
	    	tipoAplicable = me.lookupReference('tipoAplicable');
	
			if(newValue == true) {
				operacionExenta.reset();
				operacionExenta.setReadOnly(true);
				renunciaExencion.reset();
	    		renunciaExencion.setReadOnly(true);
	    		tipoAplicable.reset();
	    		tipoAplicable.setDisabled(true);
	    		tipoAplicable.allowBlank = true;
			} else {
				operacionExenta.setReadOnly(false);
				tipoAplicable.setDisabled(false);
				tipoAplicable.allowBlank = false;
			}
		}
	},
	
	onchkbxEnRevisionChange: function(checkbox, newValue, oldValue, eOpts){
    	var me = this;
    	seguroComentario = me.lookupReference('textareafieldsegurocomentarios');
    	if(newValue == false){
    		seguroComentario.setDisabled(true);
        }  
    	else{
    		seguroComentario.setDisabled(false);
    	}

    	
    },
    
    habilitarcheckrevisionOnChange: function(combo, newValue){
		var me = this;
    	enRevision = me.lookupReference('chkboxEnRevision');
    	seguroComentario = me.lookupReference('textareafieldsegurocomentarios');
    	//Si el estado es pendiente(01), habilitamos el check de revision 
    	if(newValue === '01'){
			enRevision.setDisabled(false);
			enRevision.setReadOnly(false);
        }  
    	else{
    		enRevision.setDisabled(true);
    		seguroComentario.setDisabled(true);
    	}
 	},

	onHaCambiadoFechaResolucion: function( field, newDate, oldDate, eOpts){
		var me = this;
		var resultado= me.lookupReference('comboResultadoTanteoForm');
		if(!Ext.isEmpty(newDate)){
			resultado.allowBlank= false;
		}
		else{
			resultado.allowBlank= true;
		}
	},
	
	onHaCambiadoResultadoTanteo: function(combo, value){
		var me = this;
		var fechaResolucion= me.lookupReference('fechaResolucionForm');
		if(!Ext.isEmpty(value)){
			fechaResolucion.allowBlank= false;
		}
		else{
		 	fechaResolucion.allowBlank= true;
		}
	},
	
	enviarCondicionantesEconomicosUvem: function(btn){
		var me = this;
		var url = $AC.getRemoteUrl('expedientecomercial/enviarCondicionantesEconomicosUvem');
		me.getView().mask(HreRem.i18n("msg.mask.espere"));
		
		Ext.Ajax.request({
			url: url,
			
		    params:  {
		    	idExpediente : me.getViewModel().get("expediente.id")
		    },
		    
		    success: function(response, opts) {
		    	var data = {};
		    	try {
		    		data = Ext.decode(response.responseText);
		    	}  catch (e){ };
               
		    	if(data.success === "true") {
		    		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));           	
		    	}else {
		    		if(data.errorUvem == "true"){
		    			me.fireEvent("errorToast", data.msg);		
		    		}
		    		else{
		    			Utils.defaultRequestFailure(response, opts);
		    		}
		    	}
		     },

		     failure: function(response, opts) {
		    	 if(data.errorUvem == "true"){
		    		 me.fireEvent("errorToast", data.msg);		
		    	 }
		    	 else{
		    		 Utils.defaultRequestFailure(response, opts);
		    	 }
		     },

		     callback: function() {
		    	 me.getView().unmask();
		     }
		});		
	},
	
	onClickGeneraOfertarHojaExcel: function(btn) {
    	var me = this,
		config = {};

		config.params = {};
		config.params.idEco=me.getViewModel().get("datosbasicosoferta.idEco");
		config.params.idOferta=me.getViewModel().get("datosbasicosoferta.idOferta");
		config.url= $AC.getRemoteUrl("ofertas/generateExcelOferta");
		
		Ext.Msg.confirm(
				HreRem.i18n("title.propuesta.oferta"),
				HreRem.i18n("msg.propuesta.oferta"),
				function(btn){
					if (btn == "yes"){
						me.fireEvent("downloadFile", config);
					}
				});
	},

	onClickEnviarMailAprobacion: function(btn) {
		
		var me = this;
		
		Ext.Msg.confirm(
				HreRem.i18n("title.enviar.email.de.aprobacion"),
				HreRem.i18n("msg.enviar.mail.aprobacion"),
				function(btn){
					if (btn == "yes"){
						
						var url = $AC.getRemoteUrl("ofertas/enviarMailAprobacion");
						var parametros = {
								idOferta: me.getViewModel().get("datosbasicosoferta.idEco")
						};
						
						me.getView().mask();
						Ext.Ajax.request({
				    	     url: url,
				    	     params: parametros,
				    	     success: function(response, opts) {
				    	    	 if(Ext.decode(response.responseText).success == "false") {
				    	    		me.fireEvent("errorToast", Ext.decode(response.responseText).errorCode);
				    	    		me.getView().unmask();
				    	         }
				    	    	 else if (Ext.decode(response.responseText).success == "true"){
				    	        	me.getView().unmask();
				    	        	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								 }
				    	     }
				    	 });
						
					}
				}
			);
	},

	onClickGenerarHojaExcel: function(btn) {

    	var me = this,
		config = {};

		config.params = {};
		config.params.numExpediente=me.getViewModel().get("expediente.numExpediente");
		config.url= $AC.getRemoteUrl("operacionventa/operacionVentaPDFByOfertaHRE");

		me.fireEvent("downloadFile", config);		
	},
	
	onClickGenerarFacturaPdf : function(btn) {
		var me = this, config = {};

		config.params = {};
		config.params.numExpediente = me.getViewModel().get(
				"expediente.numExpediente");
		config.url = $AC
				.getRemoteUrl("operacionventa/operacionVentaFacturaPDF");

		me.fireEvent("downloadFile", config);
	},

	onAgregarGestoresClick : function(btn) {

		var me = this;

		var url = $AC
				.getRemoteUrl('expedientecomercial/insertarGestorAdicional');
		var parametros = btn.up("combogestoresexpediente")
				.getValues();
		parametros.idExpediente = me.getViewModel().get(
				"expediente.id");

		Ext.Ajax
				.request({

					url : url,
					params : parametros,

					success : function(response, opts) {
						btn
								.up("gestoresexpediente")
								.down(
										"[reference=listadoGestoresExpediente]")
								.getStore().load();
						btn.up("gestoresexpediente").down(
								"form").reset();
						/*
						 * if(Ext.decode(response.responseText).success ==
						 * "false") { me.fireEvent("errorToast",
						 * HreRem.i18n("msg.activo.gestores.noasignar.tramite.multiactivo")); }
						 */
					}
				});
	},
	onClickBotonCancelar : function(btn) {
		var me = this, activeTab = btn.up('tabpanel')
				.getActiveTab();
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]')
				.hide();
		btn.up('tabbar').down('button[itemId=botoneditar]')
				.show();

		Ext.Array.each(
				activeTab.query('field[isReadOnlyEdit]'),
				function(field, index) {
					field.fireEvent('save');
					field.fireEvent('update');
				});

		if (Ext.isDefined(btn.name)
				&& btn.name === 'firstLevel') {
			me.getViewModel().set("editingFirstLevel", false);
		} else {
			me.getViewModel().set("editing", false);
		}
	},

	onClickBloquearExpediente : function(btn) {

		var me = this;
		var idExpediente = me.getViewModel().get(
				"expediente.id");
		var url = $AC
				.getRemoteUrl('expedientecomercial/bloqueoExpediente');
		var parametros = {
			idExpediente : idExpediente
		};
		me.getView().mask();
		Ext.Ajax
				.request({

					url : url,
					params : parametros,

					success : function(response, opts) {
						if (Ext.decode(response.responseText).success == "false") {
							me
									.fireEvent(
											"errorToast",
											HreRem
													.i18n(Ext
															.decode(response.responseText).errorCode));
							me.getView().unmask();
						} else if (Ext
								.decode(response.responseText).success == "true") {
							me.getView().unmask();
							me.fireEvent("infoToast", HreRem
									.i18n("msg.operacion.ok"));
							me.refrescarExpediente(true);
						}
					}
				});
	},
	sendDesbloquearExpediente : function(btn) {
		var me = this;
		var window = btn.up().up();
		var form = window.down("formBase").getForm();
		var idExpediente = btn.up('desbloquearwindow').idExpediente;
		var url = $AC
				.getRemoteUrl('expedientecomercial/desbloqueoExpediente');
		if (me.validarActivarForm(form)) {
			var parametros = {
				idExpediente : idExpediente,
				motivoCodigo : form.findField("motivo")
						.getValue(),
				motivoDescLibre : form.findField(
						"motivoDescLibre").getValue()
			};
			me.getView().mask();
			Ext.Ajax
					.request({

						url : url,
						params : parametros,

						success : function(response, opts) {
							if (Ext
									.decode(response.responseText).success == "false") {
								me
										.fireEvent(
												"errorToast",
												HreRem
														.i18n(Ext
																.decode(response.responseText).errorCode));
								me.getView().unmask();
							} else if (Ext
									.decode(response.responseText).success == "true") {
								me.getView().unmask();
								me
										.fireEvent(
												"infoToast",
												HreRem
														.i18n("msg.operacion.ok"));
								window.parent
										.funcionReloadExp();
								window.hide();

							}
						}
					});
		} else {
			me.fireEvent("errorToast", HreRem
					.i18n("msg.form.invalido"));
		}
	},
	onClickDesbloquearExpediente : function(btn) {
		var me = this;
		var idExpediente = me.getViewModel().get(
				"expediente.id");
		var ventanaFormalizacion = btn.up().up();
		Ext.create('HreRem.view.expedientes.Desbloquear', {
			idExpediente : idExpediente,
			parent : ventanaFormalizacion
		}).show();
	},
	validarActivarForm : function(form) {
		var motivoCodigo = form.findField("motivo").getValue();
		var motivoDescLibre = form.findField("motivoDescLibre")
				.getValue()
		if (motivoCodigo == undefined || motivoCodigo == "") {
			return false;
		} else if (motivoCodigo == "04"
				&& (motivoDescLibre == undefined || motivoDescLibre == "")) {
			return false;
		} else {
			return true;
		}

	},

	onClickGenerarHojaExcelActivos : function(btn) {
		var me = this, config = {};

		config.params = {};
		config.params.idExpediente = me.getViewModel().get(
				"expediente.id");
		config.url = $AC
				.getRemoteUrl("expedientecomercial/getExcelActivosExpediente");

		me.fireEvent("downloadFile", config);
	},

	validarFechaPosicionamiento : function(value) {
		/*
		 * var hoy= new Date(); hoy.setHours(0,0,0,0); var from =
		 * value.split("/"); var fechaPosiString = new
		 * Date(from[2], from[1] - 1, from[0]); var
		 * fechaPosiDate= new Date(fechaPosiString);
		 *
		 * if(fechaPosiDate<hoy){ return
		 * HreRem.i18n('info.msg.fecha.posicionamiento.mayor.hoy');; }
		 * else{ return true; }
		 */
		return true;

	},
	buscarSucursal : function(field, e) {
		var me = this;
		var url = $AC
				.getRemoteUrl('proveedores/searchProveedorCodigoUvem');
		var cartera = me.getViewModel().get('reserva.cartera');
		var codSucursal = '';
		var nombreSucursal = '';
		if (cartera == CONST.CARTERA['BANKIA']) {
			codSucursal = '2038' + field.getValue();
			nombreSucursal = ' (Oficina Bankia)';
		} else if (cartera == CONST.CARTERA['CAJAMAR']) {
			codSucursal = '3058' + field.getValue();
			nombreSucursal = ' (Oficina Cajamar)'
		}
		var data;
		var re = new RegExp("^[0-9]{8}$");

		Ext.Ajax
				.request({

					url : url,
					params : {
						codigoProveedorUvem : codSucursal
					},

					success : function(response, opts) {
						data = Ext
								.decode(response.responseText);
						var buscadorSucursal = field.up(
								'formBase').down(
								'[name=buscadorSucursales]'), nombreSucursalField = field
								.up('formBase')
								.down('[name=nombreSucursal]');
						if (!Utils.isEmptyJSON(data.data)) {
							var id = data.data.id;
							nombreSucursal = data.data.nombre
									+ nombreSucursal;

							if (re.test(codSucursal)
									&& nombreSucursal != null
									&& nombreSucursal != '') {
								if (!Ext
										.isEmpty(nombreSucursalField)) {
									nombreSucursalField
											.setValue(nombreSucursal);
								}
							} else {
								nombreSucursalField
										.setValue('');
								me
										.fireEvent(
												"errorToast",
												"El código de la Sucursal introducido no corresponde con ninguna Oficina");
							}
						} else {
							if (!Ext
									.isEmpty(nombreSucursalField)) {
								nombreSucursalField
										.setValue('');
							}
							me
									.fireEvent(
											"errorToast",
											HreRem
													.i18n("msg.buscador.no.encuentra.sucursal.codigo"));
							buscadorSucursal
									.markInvalid(HreRem
											.i18n("msg.buscador.no.encuentra.sucursal.codigo"));
						}
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

	onCambioTipoImpuesto : function(combo, value, oldValue,
			eOpts) {
		try {
			if (!Ext.isEmpty(oldValue)) {
				var me = this, tipoAplicable = me
						.lookupReference('tipoAplicable'), operacionExenta = me
						.lookupReference('chkboxOperacionExenta'), inversionSujetoPasivo = me
						.lookupReference('chkboxInversionSujetoPasivo'), renunciaExencion = me
						.lookupReference('chkboxRenunciaExencion');

				if (CONST.TIPO_IMPUESTO['ITP'] == value) {
					tipoAplicable.reset();
					tipoAplicable.setDisabled(true);
					tipoAplicable.allowBlank = true;
					tipoAplicable.setValue(0);
					operacionExenta.reset();
					operacionExenta.setReadOnly(true);
					inversionSujetoPasivo.reset();
					inversionSujetoPasivo.setReadOnly(true);
					renunciaExencion.reset();
					renunciaExencion.setReadOnly(true);
				} else {
					tipoAplicable.setDisabled(false);
					tipoAplicable.allowBlank = false;
					operacionExenta.setReadOnly(false);
					inversionSujetoPasivo.setReadOnly(false);
				}
			}
		} catch (err) {
			Ext.global.console
					.log('Error en onCambioTipoImpuesto: '
							+ err)
		}
	},

	onCambioOperacionExenta : function(checkbox, newValue,
			oldValue, eOpts) {
		if (!Ext.isEmpty(oldValue)) {
			var me = this, renunciaExencion = me
					.lookupReference('chkboxRenunciaExencion'), tipoAplicable = me
					.lookupReference('tipoAplicable');

			if (newValue == true) {
				tipoAplicable.reset();
				tipoAplicable.allowBlank = true;
				tipoAplicable.setDisabled(true);
				renunciaExencion.setReadOnly(false);
			} else {
				tipoAplicable.setDisabled(false);
				tipoAplicable.allowBlank = false;
				renunciaExencion.reset();
				renunciaExencion.setReadOnly(true);
			}
		}
	},

	onCambioRenunciaExencion : function(checkbox, newValue,
			oldValue, eOpts) {
		if (!Ext.isEmpty(oldValue)) {
			var me = this, tipoAplicable = me
					.lookupReference('tipoAplicable');

			if (newValue == false) {
				tipoAplicable.reset();
				tipoAplicable.allowBlank = true;
				tipoAplicable.setDisabled(true);
			} else {
				tipoAplicable.setDisabled(false);
				tipoAplicable.allowBlank = false;
			}
		}
	},
	onCambioCheckPorcentual : function(checkbox, newValue,
			oldValue, eOpts) {
		var me = this, ipc = me.lookupReference('checkboxIPC');
		porcentaje = me
				.lookupReference('escaladoRentaPorcentaje');

		if (newValue) {
			ipc.show();
			porcentaje.show();
		} else {
			ipc.hide();
			porcentaje.hide();

		}
	},
	onCambioCheckRevMercado : function(checkbox, newValue,
			oldValue, eOpts) {
		var me = this, fecha = me
				.lookupReference('revisionMercadoFecha');
		cadaMes = me.lookupReference('escaladoRentasMeses');
		if (newValue) {
			fecha.show();
			cadaMes.show();
		} else {
			fecha.hide();
			cadaMes.hide();
		}
	},
	onCambioCheckEscaladoFijo : function(checkbox, newValue,
			oldValue, eOpts) {
		var me = this, fijoFecha = me
				.lookupReference('tipoEscaladoFecha');
		fijoIncremento = me
				.lookupReference('tipoEscaladoIncremento');
		grid = me.lookupReference('historicoCondicones');
		if (newValue) {
			grid.disableAddButton(false);
		} else {
			grid.disableAddButton(true);
		}
	},

	onchkbxEnRevisionChange : function(checkbox, newValue,
			oldValue, eOpts) {
		var me = this;
		seguroComentario = me
				.lookupReference('textareafieldsegurocomentarios');
		if (newValue == false) {
			seguroComentario.setDisabled(true);
		} else {
			seguroComentario.setDisabled(false);
		}

	},

	habilitarcheckrevisionOnChange : function(combo, newValue) {
		var me = this;
		enRevision = me.lookupReference('chkboxEnRevision');
		seguroComentario = me
				.lookupReference('textareafieldsegurocomentarios');
		// Si el estado es pendiente(01), habilitamos el check
		// de revision
		if (newValue === '01') {
			enRevision.setDisabled(false);
			enRevision.setReadOnly(false);
		} else {
			enRevision.setDisabled(true);
			seguroComentario.setDisabled(true);
		}
	},

	onHaCambiadoFechaResolucion : function(field, newDate,
			oldDate, eOpts) {
		var me = this;
		var resultado = me
				.lookupReference('comboResultadoTanteoForm');
		if (!Ext.isEmpty(newDate)) {
			resultado.allowBlank = false;
		} else {
			resultado.allowBlank = true;
		}
	},

	onHaCambiadoResultadoTanteo : function(combo, value) {
		var me = this;
		var fechaResolucion = me
				.lookupReference('fechaResolucionForm');
		if (!Ext.isEmpty(value)) {
			fechaResolucion.allowBlank = false;
		} else {
			fechaResolucion.allowBlank = true;
		}
	},

	enviarCondicionantesEconomicosUvem : function(btn) {
		var me = this;
		var url = $AC.getRemoteUrl('expedientecomercial/enviarCondicionantesEconomicosUvem');
		me.getView().mask(HreRem.i18n("msg.mask.espere"));

		Ext.Ajax.request({
					url : url,
					params : {idExpediente : me.getViewModel().get("expediente.id")},
					success : function(response, opts) {
						var data = {};
						try {
							data = Ext.decode(response.responseText);
						} catch (e) {};

						if (data.success === "true") {
							me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						} else {
							if (data.errorUvem == "true") {
								me.fireEvent("errorToast",data.msg);
							} else {
								Utils.defaultRequestFailure(response, opts);
							}
						}
					},

					failure : function(response, opts) {
						if (data.errorUvem == "true") {
							me.fireEvent("errorToast",data.msg);
						} else {
							Utils.defaultRequestFailure(response, opts);
						}
					},

					callback : function() {
						me.getView().unmask();
					}
				});
	},

	onClickGeneraOfertarHojaExcel : function(btn) {
		var me = this, config = {};

		config.params = {};
		config.params.idOferta = me.getViewModel().get(
				"datosbasicosoferta.idOferta");
		config.url = $AC
				.getRemoteUrl("ofertas/generateExcelOferta");

		Ext.Msg.confirm(HreRem.i18n("title.propuesta.oferta"),HreRem.i18n("msg.propuesta.oferta"),
		 function(btn) {
			if (btn == "yes") {

				me.fireEvent("downloadFile", config);
			}
		});
	},

	onClickEnviarMailAprobacion : function(btn) {
		var me = this;

		Ext.Msg.confirm(HreRem.i18n("title.enviar.email.de.aprobacion"),HreRem.i18n("msg.enviar.mail.aprobacion"),
			function(btn) {
				if (btn == "yes") {
					var url = $AC.getRemoteUrl("ofertas/enviarMailAprobacion");
					var parametros = {
						idOferta : me.getViewModel().get("datosbasicosoferta.idOferta")
					};

					me.getView().mask();
					Ext.Ajax.request({
						url : url,
						params : parametros,
						success : function(
								response,opts) {
							if (Ext.decode(response.responseText).success == "false") {
								me.fireEvent("errorToast",Ext.decode(response.responseText).errorCode);
								me.getView().unmask();
							} else if (Ext.decode(response.responseText).success == "true") {
								me.getView().unmask();
								me.fireEvent("infoToast",HreRem.i18n("msg.operacion.ok"));
							}
						}
					});
				}
			});
	},

	onClickEnviarEmailAsegurador : function(btn) {
		var me = this;

		Ext.Msg.confirm(HreRem.i18n("title.enviar.email.a.la.aseguradora"),HreRem.i18n("msg.header.enviar.mail.a.la.aseguradora"),
			function(btn) {
				if (btn == "yes") {
					var url = $AC.getRemoteUrl("expedientecomercial/enviarCorreoAsegurador");
					var parametros = {
						idExpediente : me.getViewModel().get('expediente.id')
					};

					me.getView().mask();
					Ext.Ajax.request({
						url : url,
						params : parametros,
						success : function(response,opts) {
							console.log("success");
							if (Ext.decode(response.responseText).success == "false") {
								me.fireEvent("errorToast",Ext.decode(response.responseText).errorCode);
								me.getView().unmask();
							} else if (Ext.decode(response.responseText).success == "true") {
								me.getView().unmask();
								me.fireEvent("infoToast",HreRem.i18n("msg.operacion.ok"));
							}
						},
						failure : function(
								response,
								opts) {
							me.getView().unmask();
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						}
					});
				}
			});
	},

	onClickEnviarComercializadora: function(rec){
		var me = this;
		var url = $AC.getRemoteUrl('expedientecomercial/enviarCorreoComercializadora');
		var idExpediente = me.getViewModel().get('expediente.id');
		var observacion = rec.getData().observacion

		Ext.Ajax.request({
		    url: url,
		    params: {
                cuerpoEmail: observacion,
                idExpediente: idExpediente
            }
		   ,success: function (a, operation, context) {
               	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				me.getView().unmask();
           },
           failure: function (a, operation, context) {
           	 	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				me.getView().unmask();
           }
		});
	},

	onChangeRevision: function(checkbox, newVal, oldVal) {
		var me = this;
		var scoringComentarios= me.lookupReference('scoringComentarios');
		if(checkbox.checked){
			scoringComentarios.setDisabled(false);
		} else {
			scoringComentarios.setDisabled(true);
		}
	},
	
	onDisableMotivoRechazo: function(checkbox, newVal, oldVal) {
		var me = this;
		var estado = me.getViewModel().get('scoring.comboEstadoScoring');
		var scoringMotivoRechazo = me.lookupReference('scoringMotivoRechazo');
		var scoringCheckEnRevision = me.lookupReference('scoringCheckEnRevision');
				
		if(estado == "Rechazado" ) {
			scoringMotivoRechazo.setDisabled(false);
			scoringMotivoRechazo.setReadOnly(true);
			scoringCheckEnRevision.setDisabled(true);
			scoringCheckEnRevision.setReadOnly(true);
		} else if (estado == "Aprobado"){ //	estado == "Aprobado || estado == En tramite"
			scoringMotivoRechazo.setDisabled(true);
			scoringMotivoRechazo.setReadOnly(true);
			scoringCheckEnRevision.setDisabled(true);
			scoringCheckEnRevision.setReadOnly(true);
		} else {
			scoringMotivoRechazo.setDisabled(true);
		}
	},
	
	sinContraoferta: function(checkbox, newVal, oldVal){
		var me = this;
	
		return false;
	},

	enlaceAbrirTrabajo: function(button) {
		
		var me = this,		
		idTrabajo =  me.getViewModel().get("expediente.idTrabajo");

		if(!Ext.isEmpty(idTrabajo)){
			me.getView().fireEvent('abrirDetalleTrabajoById', idTrabajo, null, button.reflinks);
		}
	},
	
	onClickEnviarGestionLlaves: function(button){
		var me = this;

		Ext.Msg.confirm(
			HreRem.i18n("title.enviar.email.de.gestion.llaves"),
			HreRem.i18n("msg.enviar.email.gestion.llaves"),
			function(btn){
				if (btn == "yes"){
					var url = $AC.getRemoteUrl("expedientecomercial/enviarCorreoGestionLlaves");
					var parametros = {
							idExpediente : me.getViewModel().get('expediente.id')
					};
					
					me.getView().mask(HreRem.i18n("msg.mask.loading")); 
					Ext.Ajax.request({
				   	    url: url,
				   	    params: parametros,
				   	    success: function(response, opts) {
				   	   		if(Ext.decode(response.responseText).success == "false") {
						   	   	me.fireEvent("errorToast", Ext.decode(response.responseText).errorCode);
						   	   	me.getView().unmask();
				   	        } else if (Ext.decode(response.responseText).success == "true"){
					   	       	me.getView().unmask();
					   	       	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				   	        }
				   	    },
				   	    failure: function(response, opts){
				   	    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				   	    	me.getView().unmask();
				   	    }
					});
				}					
			}			
		);		
	},
    
    onChangeCarencia: function(checkbox, newValue, oldValue, eOpts) {
		if(!Ext.isEmpty(oldValue)){
			var me = this,
			meses = me.lookupReference('mesesCarencia'),
			importe = me.lookupReference('importeCarencia');
	
			if(newValue == true) {
				meses.setDisabled(false);
				importe.setDisabled(false);
			} else {
				meses.setDisabled(true);
				importe.setDisabled(true);
			}
		}
	},
	
	onClickSaveMasivosCondiciones: function(btn) {
		var me = this,
    	window = btn.up("window"),
    	jsonData = window.config.jsonData,
    	grid = me.lookupReference("listaActivos"),
    	radioGroup = me.lookupReference("opcionesPropagacion"),
    	formActivo = window.form,
    	activosSeleccionados = grid.getSelectionModel().getSelection(),
    	opcionPropagacion = radioGroup.getValue().seleccion,
    	cambios =  window.propagableData,
    	targetGrid = window.targetGrid;

		me.fireEvent("log", cambios);
		jsonFinal = {};
		jsonFinal.id = jsonData.ecoId;
		//var jsonData = {idEntidad: idActivo, posesionInicial: posesionInicial, situacionPosesoriaCodigo: situacionPosesoriaCodigo, estadoTitulo: estadoTitulo};
		if(!Ext.isEmpty(jsonData)) {
			if(!Ext.isEmpty(jsonData.estadoTitulo)) {
				jsonFinal.estadoTitulo = jsonData.estadoTitulo;
			}

			if(!Ext.isEmpty(jsonData.posesionInicial)) {
				jsonFinal.posesionInicial = jsonData.posesionInicial;
			}


			if(!Ext.isEmpty(jsonData.situacionPosesoriaCodigo)) {
				jsonFinal.situacionPosesoriaCodigo = jsonData.situacionPosesoriaCodigo;
			}

			if(!Ext.isEmpty(jsonData.eviccion)) {
				jsonFinal.eviccion = jsonData.eviccion;
			}

			if(!Ext.isEmpty(jsonData.viciosOcultos)) {
				jsonFinal.viciosOcultos = jsonData.viciosOcultos;
			}
		}

    	listaAct = [];

    	switch (opcionPropagacion) {

			case "1":
				jsonFinal.activos = [jsonData.idEntidad];
				break;

			case "2":
			case "3":
				jsonFinal.activos=activosSeleccionados[0].data.idActivo;
				for(i = 1;  i < activosSeleccionados.length; i++) {
					jsonFinal.activos = jsonFinal.activos +","+activosSeleccionados[i].data.idActivo
				}
				break;

			case "4":
				if (activosSeleccionados.length == 0) {
			    	me.fireEvent("errorToast", HreRem.i18n("msg.no.activos.seleccionados"));
			    	return false;
		    	} else {
		    		for(i = 0; i < activosSeleccionados.length; i++) {
						listaAct[i] = activosSeleccionados[i].data.idActivo;
					}
					jsonFinal.activos = listaAct;
		    	}
				break;
		}

    	var url = $AC.getRemoteUrl('expedientecomercial/saveActivosExpedienteCondiciones');
		me.getView().mask(HreRem.i18n("msg.mask.espere"));

		Ext.Ajax.request({
			url: url,

		    params: jsonFinal,

		    success: function(response, opts) {
		    	var data = {};
		    	try {
		    		data = Ext.decode(response.responseText);
		    	}  catch (e){ };

		    	if(data.success === "true") {
		    		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		    		me.getView().unmask();
		    		window = btn.up('window');
		        	window.close();

		    	}else {
		    		if(data.errorUvem == "true"){
		    			me.fireEvent("errorToast", data.msg);
		    		}
		    		else{
		    			Utils.defaultRequestFailure(response, opts);
		    		}
		    	}
		     },

		     failure: function(response, opts) {
		    	 if(data.errorUvem == "true"){
		    		 me.fireEvent("errorToast", data.msg);
		    	 }
		    	 else{
		    		 Utils.defaultRequestFailure(response, opts);
		    	 }
		     },

		     callback: function() {
		    	 me.getView().unmask();
		     }
		});

	},

	onSaveFormularioCondiciones: function(btn, form) {
		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones.
		if(form.isFormValid() || form.disableValidation) {

			Ext.Array.each(form.query('field[isReadOnlyEdit]'),
				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
			);

			//Ocultar los botones de guardar y cancelar y mostrar el botón de editar.
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

			if (form.xtype == 'activoexpedientejuridico') { //TODO Retirar toda esta cinta aislante y hacer las propagaciones bien
				var id = me.getViewModel().get("expediente.id");
				var idActivo = me.getViewModel().get("activoExpedienteSeleccionado.idActivo");
				var url = $AC.getRemoteUrl('expedientecomercial/saveFechaEmisionInfJuridico');
				var jsonFinal = {};
				jsonFinal.id = id;
				jsonFinal.idActivo = idActivo;
				if (form.getForm().findField('fechaEmision') != null)
					jsonFinal.fechaEmision = form.getForm().findField('fechaEmision').getValue();
				Ext.Ajax.request({
					url: url,
					method: 'POST',
					params: jsonFinal,
					success: function (response, opts) {
						me.getView().unmask();
					},
					failure: function (a, operation, context) {
		            	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						 me.getView().unmask();
		            }
				});
			} else {
				var idExpediente 	= me.getViewModel().get("expediente.id");
				var url 			= $AC.getRemoteUrl('expedientecomercial/getActivosPropagables');
				Ext.Ajax.request({

				    url: url,
					method : 'POST',

				    params: { idExpediente: idExpediente },


				    success: function (response, opts) {

						// Obtener jsondata para guardar activo
						var idActivo 					=	me.getViewModel().get("activoExpedienteSeleccionado.idActivo");
						var posesionInicial 			=	me.getViewModel().get("condiciones.posesionInicial");
						var situacionPosesoriaCodigo 	=	me.getViewModel().get("condiciones.situacionPosesoriaCodigo");
						var estadoTitulo 				=	me.getViewModel().get("condiciones.estadoTitulo");
						var eviccion 				=	me.getViewModel().get("condiciones.eviccion");
						var viciosOcultos 				=	me.getViewModel().get("condiciones.viciosOcultos");

						var jsonData = {eviccion: eviccion, viciosOcultos: viciosOcultos, idEntidad: idActivo, ecoId: idExpediente, posesionInicial: posesionInicial, situacionPosesoriaCodigo: situacionPosesoriaCodigo, estadoTitulo: estadoTitulo};

		    			var activosPropagables = [];
		    			var data = null;

		                try {
		                		data = Ext.decode(response.responseText).data;
		                		activosPropagables = data;
		                } catch (e){ };

		    			var tabData = me.createTabData(form);
		    			var tabPropagableData = null;

		    			if(activosPropagables.length > 0)
		    			{
		    				var activo;
		    				//Encontramos el activo seleccionado en la pestaña condiciones
		    				for(var i = 0; i < activosPropagables.length; i++) {
		    					if(activosPropagables[i].idActivo == idActivo) {
		    						activo = activosPropagables[i];
		    					}
		    				}
		 	                //var activo = activosPropagablesAux.splice(activosPropagablesAux.findIndex(function(activo){return activo.activoId == me.getViewModel().get("activoExpedienteSeleccionado.idActivo")}),1)[0];
		    				tabPropagableData = me.createFormPropagableData(form, tabData);
		    				//if (!Ext.isEmpty(tabPropagableData))
		    				{


		    					// Abrimos la ventana de selección de activos
		    					var ventanaOpcionesPropagacionCambios = Ext.create("HreRem.view.expedientes.OpcionesPropagacionCambiosExpedientes", {
		    						form: form,
		    						activoActual: activo,
		    						activos: activosPropagables,
		    						tabData: tabData,
		    						jsonData: jsonData,
		    						propagableData: tabPropagableData}).show();
		       					me.getView().add(ventanaOpcionesPropagacionCambios);
		       					me.getView().unmask();
		    				}
		    			}

		    			me.getView().unmask();
		            },

		            failure: function (a, operation, context) {
		            	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						 me.getView().unmask();
		            }

				});
			}


		} else {
			me.getView().unmask();
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));

		}

	},

	createTabData: function(form) {

    	var me = this,
    	tabData = {};

    	tabData.id = me.getViewModel().get("activoExpedienteSeleccionado.idActivo");
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
    		camposPropagables[name] = record.get("camposPropagables"); // ¿CAMBIAR?
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
	        	  me.manageToastJsonResponse(me, record.responseText);
	        	  me.propagarCambios(window, activosSeleccionados, record.responseText);
	            /*me.propagarCambios(window, activosSeleccionados);*/
	          } else {
	            window.destroy();
	            me.manageToastJsonResponse(me, record.responseText);
	            /*me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));*/
	            me.getView().unmask();
	            me.refrescarActivoExpediente(formActivo.refreshAfterSave);

	            me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
	          }
	        };

	        me.saveActivo(window.tabData, successFn);

	      } else {

	        var successFn = function(record, operation) {
	          if (activosSeleccionados.length > 0) {
	        	  me.manageToastJsonResponse(me, record.responseText);
	        	  me.propagarCambios(window, activosSeleccionados, record.responseText);
	            /*me.propagarCambios(window, activosSeleccionados);*/
	          } else {
	            window.destroy();
	            me.manageToastJsonResponse(me, record.responseText);
	            /*me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));*/
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
		            /*me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));*/
		            me.manageToastJsonResponse(me, record.responseText);
		            me.getView().unmask();
		            me.getView().fireEvent("refreshComponentOnActivate", "container[reference=tabBuscadorActivos]");
		        };
		        me.saveActivo(me.createTabDataCondicionesEspecificas(activosSeleccionados, window.tabData), successFn);
			}
	    }
	     window.mask("Guardando activos 1 de " + (activosSeleccionados.length));
	},

	saveActivo: function(jsonData, successFn) { //saveActivoExpedienteCondiciones
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

	propagarCambios: function(window, activos, jsonResponse) {
    	var me = this,
    	grid = window.down("grid"),
    	propagableData = window.propagableData,
    	numTotalActivos = grid.getSelectionModel().getSelection().length,
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
				me.manageToastJsonResponse(me,response.responseText);
				me.propagarCambios(window, activos,response.responseText);
			};

			window.mask("Guardando activos "+ numActivoActual +" de " + numTotalActivos);
			me.saveActivo(propagableData, successFn);

    	} else {
    		Ext.ComponentQuery.query('opcionespropagacioncambios')[0].destroy();
			me.getView().unmask();
    		return false;
    	}
    },

	onChangeBonificacion: function(checkbox, newValue, oldValue, eOpts) {
			var me = this,
			meses = me.lookupReference('mesesBonificacion'),
			importe = me.lookupReference('importeBonificacion');
	
			if(newValue == true) {
				meses.setDisabled(false);
				importe.setDisabled(false);
			} else {
				meses.setDisabled(true);
				importe.setDisabled(true);
			}
	},
	
	onChangeRepercutibles: function(checkbox, newValue, oldValue, eOpts){
		if(!Ext.isEmpty(oldValue)){
			var me = this,
			comentarios = me.lookupReference('textareafieldcondicioncomentariosgastos');
	
			if(newValue == true) {
				comentarios.setDisabled(false);
			} else {
				comentarios.setDisabled(true);
			}
		}
	},

	manageToastJsonResponse : function(scope,jsonData) {
		if (!Ext.isEmpty(scope)) {
			if (this.fireEvent) {
				scope = this;
			} else {
				scope = Ext.GlobalEvents;
			}
		}

		if (!Ext.isEmpty(jsonData)) {
			var data = JSON.parse(jsonData);

			if (data.success !== null && data.success !== undefined && data.success === "false") {
				scope.fireEvent("errorToast", data.msgError);
			} else {
				scope.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			}
		} else {
			scope.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		}
	},

    onClickCancelarPropagarCambios: function(btn) {
    	var me = this,
    	window = btn.up("window");
    	window.destroy();
    	me.refrescarActivoExpediente(false);
	},



	onClickAbrirExpedienteComercial: function() {

    	var me = this;
    	var expediente = me.getViewModel().data.expediente;
    	var numOfertaOrigen = expediente.data.idOfertaAnterior;
    	var data;
    	var url =  $AC.getRemoteUrl('expedientecomercial/getExpedienteByIdOferta');
    	Ext.Ajax.request({
		     url: url,
		     method: 'POST',
		     params: {numOferta: numOfertaOrigen},
		     success: function(response, opts) {
		    	data = Ext.decode(response.responseText);
		    	if(data.data){
		    		me.getView().up('activosmain').fireEvent('abrirDetalleExpedienteOferta', data.data);
		    	}
		    	else {
		    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    	}

		    },

		     failure: function (a, operation) {
		 				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 	}
	 });
  },
	
	esObligatorio: function(){
		
    	var me = this;
    	var venta = null;
    	if(me.getViewModel().get('expediente.tipoExpedienteCodigo') == null){
    		if (me.getViewModel().data.esOfertaVentaFicha == true){
    			venta = true;
    		}else{
    			venta = false;
    		}
    	}
    	if(me.getViewModel().get('expediente.tipoExpedienteCodigo') == "01" || venta == true){
    		return false;
    	}else{
    		return true;
    	}
    },
    
    
    
    comprobarFormato: function() {
    	
		var me = this;
		valueComprador = me.lookupReference('nuevoCompradorNumDoc');
		valueConyuge = me.lookupReference('numRegConyuge');
		valueRte = me.lookupReference('numeroDocumentoRte');
		
		if(me.lookupReference('tipoPersona').getValue() === "1"){
			if(valueComprador != null){
				if(me.lookupReference('tipoDocumentoNuevoComprador').value == "01" || me.lookupReference('tipoDocumentoNuevoComprador').value == "15"
					|| me.lookupReference('tipoDocumentoNuevoComprador').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueComprador.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 return true;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "02"){

					var texto=valueComprador.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			             return true; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueComprador.value = valueComprador.value.toLowerCase();

				    if(!expr.test (valueComprador.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
				    	return false;
				    }else{
				    	return true;
				    }

				}else{
					return true;
				}
			}else if(valueConyuge != null){
				if(me.lookupReference('tipoDocConyuge').value == "01" || me.lookupReference('tipoDocConyuge').value == "15"
					|| me.lookupReference('tipoDocConyuge').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueConyuge.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 return true;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocConyuge').value == "02"){
					var texto=valueConyuge.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			             return true; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocConyuge').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueConyuge.value = valueConyuge.value.toLowerCase();

				    if(!expr.test (valueConyuge.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
				    	return false;
				    }else{
				    	return true;
				    }

				}else{
					return true;
				}
			}
		}else{
			
			if(valueComprador != null){
				if(me.lookupReference('tipoDocumentoNuevoComprador').value == "01" || me.lookupReference('tipoDocumentoNuevoComprador').value == "15"
					|| me.lookupReference('tipoDocumentoNuevoComprador').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueComprador.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 return true;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "02"){

					var texto=valueComprador.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			             return true; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueComprador.value = valueComprador.value.toLowerCase();

				    if(!expr.test (valueComprador.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
				    	return false;
				    }else{
				    	return true;
				    }

				}else{
					return true;
				}
			}else if(valueRte != null){
				
				if(me.lookupReference('tipoDocumentoRte').value == "01" || me.lookupReference('tipoDocumentoRte').value == "15"
					|| me.lookupReference('tipoDocumentoRte').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueRte.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 return true;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocumentoRte').value == "02"){
					
					var texto=valueRte.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			             return true; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocumentoRte').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueRte.value = valueRte.value.toLowerCase();

				    if(!expr.test (valueRte.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
				    	return false;
				    }else{
				    	return true;
				    }

				}else{
					return true;
				}
			}
			
		}
			
			
	},
	
comprobarFormatoModificar: function() {
    	
		var me = this;
		valueComprador = me.lookupReference('nuevoCompradorNumDoc');
		valueConyuge = me.lookupReference('numRegConyuge');
		valueRte = me.lookupReference('numeroDocumentoRte');
		validaciones = 0;
		
		if(me.lookupReference('tipoPersona').getValue() === "1"){
			if(valueComprador != null){
				if(me.lookupReference('tipoDocumentoNuevoComprador').value == "01" || me.lookupReference('tipoDocumentoNuevoComprador').value == "15"
					|| me.lookupReference('tipoDocumentoNuevoComprador').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueComprador.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 validaciones = validaciones + 1;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "02"){

					var texto=valueComprador.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			        	 validaciones = validaciones + 1; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueComprador.value = valueComprador.value.toLowerCase();

				    if(!expr.test (valueComprador.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
				    	validaciones = validaciones + 1;
				    }else{
				    	return true;
				    }

				}else{
					validaciones = validaciones + 1;
				}
			}
			
			if(valueConyuge != null){
				if(me.lookupReference('tipoDocConyuge').value == "01" || me.lookupReference('tipoDocConyuge').value == "15"
					|| me.lookupReference('tipoDocConyuge').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueConyuge.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 validaciones = validaciones + 1;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocConyuge').value == "02"){
					var texto=valueConyuge.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			        	 validaciones = validaciones + 1; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocConyuge').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueConyuge.value = valueConyuge.value.toLowerCase();

				    if(!expr.test (valueConyuge.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.conyuge.incorrecto"));
				    	return false;
				    }else{
				    	validaciones = validaciones + 1;
				    }

				}else{
					validaciones = validaciones + 1;
				}
			}
			
			if(validaciones == 2){
				return true;
			}
		}else{
			
			if(valueComprador != null){
				if(me.lookupReference('tipoDocumentoNuevoComprador').value == "01" || me.lookupReference('tipoDocumentoNuevoComprador').value == "15"
					|| me.lookupReference('tipoDocumentoNuevoComprador').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueComprador.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 validaciones = validaciones + 1;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "02"){

					var texto=valueComprador.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			        	 validaciones = validaciones + 1; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocumentoNuevoComprador').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueComprador.value = valueComprador.value.toLowerCase();

				    if(!expr.test (valueComprador.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.comprador.incorrecto"));
				    	return false;
				    }else{
				    	validaciones = validaciones + 1;
				    }

				}else{
					return true;
				}
			}
			
			if(valueRte != null){
				
				if(me.lookupReference('tipoDocumentoRte').value == "01" || me.lookupReference('tipoDocumentoRte').value == "15"
					|| me.lookupReference('tipoDocumentoRte').value == "03"){

					 var validChars = 'TRWAGMYFPDXBNJZSQVHLCKET';
					 var nifRexp = /^[0-9]{8}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var nieRexp = /^[XYZ]{1}[0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKET]{1}$/i;
					 var str = valueRte.value.toString().toUpperCase();

					 if (!nifRexp.test(str) && !nieRexp.test(str)){
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
						 return false;
					 }

					 var nie = str
					     .replace(/^[X]/, '0')
					     .replace(/^[Y]/, '1')
					     .replace(/^[Z]/, '2');

					 var letter = str.substr(-1);
					 var charIndex = parseInt(nie.substr(0, 8)) % 23;

					 if (validChars.charAt(charIndex) === letter){
						 validaciones = validaciones + 1;
					 }else{
						 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
						 return false;
					 }

				}else if(me.lookupReference('tipoDocumentoRte').value == "02"){
					
					var texto=valueRte.value;
			        var pares = 0; 
			        var impares = 0; 
			        var suma; 
			        var ultima; 
			        var unumero; 
			        var uletra = new Array("J", "A", "B", "C", "D", "E", "F", "G", "H", "I"); 
			        var xxx; 
			         
			        texto = texto.toUpperCase(); 
			         
			        var regular = new RegExp(/^[ABCDEFGHKLMNPQS]\d\d\d\d\d\d\d[0-9,A-J]$/g); 
			         	if (!regular.exec(texto)) {
			         		me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
							return false;		
						}
	   
			         ultima = texto.substr(8,1); 
			 
			         for (var cont = 1 ; cont < 7 ; cont ++){ 
			             xxx = (2 * parseInt(texto.substr(cont++,1))).toString() + "0"; 
			             impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			             pares += parseInt(texto.substr(cont,1)); 
			         } 
			         
			         xxx = (2 * parseInt(texto.substr(cont,1))).toString() + "0"; 
			         impares += parseInt(xxx.substr(0,1)) + parseInt(xxx.substr(1,1)); 
			          
			         suma = (pares + impares).toString(); 
			         unumero = parseInt(suma.substr(suma.length - 1, 1)); 
			         unumero = (10 - unumero).toString(); 
			         if(unumero == 10){
			        	 unumero = 0; 
			         }
			          
			         if ((ultima == unumero) || (ultima == uletra[unumero])) {
			        	 validaciones = validaciones + 1; 
			         }else{
			        	 me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
						 return false;	
			         }
				}else if(me.lookupReference('tipoDocumentoRte').value == "04"){
					
				    var expr = /^[a-z]{3}[0-9]{6}[a-z]?$/i;

				    valueRte.value = valueRte.value.toLowerCase();

				    if(!expr.test (valueRte.value)){
				    	me.fireEvent("errorToast", HreRem.i18n("msg.numero.documento.rte.incorrecto"));
				    	return false;
				    }else{
				    	validaciones = validaciones + 1;
				    }

				}else{
					validaciones = validaciones + 1;
				}
			}
			
			if(validaciones == 2){
				return true;
			}
			
		}
			
			
	}

});