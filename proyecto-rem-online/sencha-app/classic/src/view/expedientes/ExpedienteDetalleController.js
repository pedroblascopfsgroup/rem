Ext.define('HreRem.view.expedientes.ExpedienteDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.expedientedetalle',  
    requires: ['HreRem.view.expedientes.NotarioSeleccionado', 'HreRem.view.expedientes.DatosComprador', 
    'HreRem.view.expedientes.DatosClienteUrsus',"HreRem.model.ActivoExpedienteCondicionesModel",
    "HreRem.view.common.adjuntos.AdjuntarDocumentoExpediente"],
    
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
            afterdelete: function(grid) {
            	grid.getStore().load();
            }
        }
    },
    
   
    
    onRowClickListadoactivos: function(gridView,record){
    	var me = this;
		var viewModel = me.getViewModel();
		var idExpediente = me.getViewModel().get("expediente.id");
		var idActivo = record.data.idActivo;
		
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
		tabPanel.setHidden(false);
		tabPanel.mask();

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
			                }
			                catch (e){ };
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
			btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
			btn.up('tabbar').down('button[itemId=botoneditar]').show();
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
			                }
			                catch (e){ };
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
	
	onClickBotonGuardarActivoExpediente: function(btn) {
		var me = this;
		if(btn.up('tabpanel').getActiveTab().getReference()=="activoexpedientetanteo"){
			me.onSaveFormularioActivoExpedienteTanteo(btn, btn.up('tabpanel').getActiveTab());
		}else{
			me.onSaveFormularioCompletoActivoExpediente(btn, btn.up('tabpanel').getActiveTab());
		}
						
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
		refrescarTabActiva = Ext.isEmpty(refrescarTabActiva) ? false: refrescarTabActiva,
		activeTab = me.getView().down("tabpanel").getActiveTab();		
  		
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
	
	onListadoTramitesTareasExpedienteDobleClick : function(gridView,record) {
		var me = this;
		
		if(Ext.isEmpty(record.get("fechaFin"))) { // Si la tarea está activa
			me.getView().fireEvent('abrirDetalleTramiteTarea',gridView,record);
		} else {
			me.getView().fireEvent('abrirDetalleTramiteHistoricoTarea',gridView,record);
		}
	},
	
	onCompradoresListDobleClick : function(gridView,record) {
		var me=this;
		var codigoEstado= me.getViewModel().get("expediente.codigoEstado");
		if(codigoEstado!=CONST.ESTADOS_EXPEDIENTE['VENDIDO']){
			var idCliente = record.get("id"),
			expediente= me.getViewModel().get("expediente");
			var storeGrid= gridView.store;
			var edicion = me.getViewModel().get("puedeModificarCompradores");
		    Ext.create("HreRem.view.expedientes.DatosComprador", {idComprador: idCliente, modoEdicion: edicion, storeGrid:storeGrid, expediente: expediente }).show();
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

//	Para la búsqueda de Comparecientes en nombre del vendedor	
//		
//	onClickBotonCancelarBusquedaCompareciente: function(btn) {	
//		var me = this,
//		window = btn.up('window');
//    	window.close();
//	},
//	
//	onClickBotonBuscarCompareciente: function(btn){
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
	//Forma antigua de datos comprador
	cargarDatosComprador: function (window) {
		var me = this,
		model = null,
		models = null,
		nameModels = null,
		id = window.idComprador,
		idExpediente = window.expediente.get("id");
		if(!Ext.isEmpty(id)){
			var form= window.down('formBase');
			form.mask(HreRem.i18n("msg.mask.loading"));
			if(!form.saveMultiple) {	
				model = form.getModelInstance(),
				model.setId(id);
				if(Ext.isDefined(model.getProxy().getApi().read)) {
					// Si la API tiene metodo de lectura (read).
					model.load({
						params: {idExpedienteComercial: idExpediente},
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
		}
		else{
			var form= window.down('formBase');
			form.setBindRecord(Ext.create('HreRem.model.FichaComprador'));		
		}
	},
	
	cargarDatosCompradorWizard: function(window){ 
		var me = this;
		//carga datos comprador
		var model = null,
		models = null,
		nameModels = null,
		id = window.idComprador,
		idExpediente = window.up().expediente.get("id");
		if(!Ext.isEmpty(id)){
			var form= window.down('formBase');
			form.mask(HreRem.i18n("msg.mask.loading"));
			if(!form.saveMultiple) {	
				model = form.getModelInstance(),
				model.setId(id);
				if(Ext.isDefined(model.getProxy().getApi().read)) {
					// Si la API tiene metodo de lectura (read).
					model.load({
						params: {idExpedienteComercial: idExpediente},
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
		}else{
			window.setBindRecord(Ext.create('HreRem.model.FichaComprador'));		
		}
		//Funcionalidad que permite editar los campos
		Ext.Array.each(window.query('field[isReadOnlyEdit]'),
				function (field, index) 
					{ 								
						field.fireEvent('edit');
						if(index == 0) field.focus();
						field.setReadOnly(!window.modoEdicion)
						
					}
			);
		

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
			var numeroClienteUrsus = record.get("numeroClienteUrsus");
			var nombreRazonSocial = record.get("nombreRazonSocial");
			var apellidos = record.get("apellidos");
			var direccion = record.get("direccion");
			var telefono1 = record.get("telefono1");
			var telefono2 = record.get("telefono2");
			var codigoPostal = record.get("codigoPostal");
			var email = record.get("email");
			
			var documentoConyuge = record.get("documentoConyuge");
			var relacionHre = record.get("relacionHre");
			
			var numDocumentoRte = record.get("numDocumentoRte");
			var nombreRazonSocialRte = record.get("nombreRazonSocialRte");
			var apellidosRte = record.get("apellidosRte");
			var direccionRte = record.get("direccionRte");
			var telefono1Rte = record.get("telefono1Rte");
			var telefono2Rte = record.get("telefono2Rte");
			var codigoPostalRte = record.get("codigoPostalRte");
			var emailRte = record.get("emailRte");
			
			
			form.mask(HreRem.i18n("msg.mask.espere"));
			
			record.save({
				params: {idExpedienteComercial: idExpedienteComercial,
						 numeroClienteUrsus:		numeroClienteUrsus,
						 direccion: direccion,
						 nombreRazonSocial: nombreRazonSocial,
						 apellidos: apellidos,
						 telefono1: telefono1,
						 telefono2: telefono2,
						 codigoPostal: codigoPostal,
						 email: email,
						 documentoConyuge: documentoConyuge,
						 relacionHre: relacionHre,
						 numDocumentoRte: numDocumentoRte,
						 nombreRazonSocialRte: nombreRazonSocialRte,
						 apellidosRte: apellidosRte,
						 direccionRte: direccionRte,
						 telefono1Rte: telefono1Rte,
						 telefono2Rte: telefono2Rte,
						 codigoPostalRte: codigoPostalRte,
						 emailRte: emailRte},
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
			                }
			                catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
	    				},
	    				callback: function(records, operation, success) {
//	    					form.reset();
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
				honorarios.setValue(honorario);
				importeField.setMaxValue(100);
			}
			me.fireEvent("log" , "[HONORARIOS: Tipo: "+tipoCalculo+" | Calculo: "+importeCalculoHonorario+" | Participacion: "+importeParticipacion+" | Importe: "+honorario+"]");
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
		if(value==1){
			me.lookupReference('tipoCalculo').setDisabled(false);
		}else{
			
			me.lookupReference('tipoCalculo').setDisabled(true);			
			me.lookupReference('tipoCalculo').setValue(null);
		
		}
		
	
	},
	
	onClickBotonCerrarComprador: function(btn){
		var me = this;
		var window = btn.up("window");
		window.destroy();
	},
	
	onClickBotonCrearComprador: function(btn){
		var me = this;	
		var idExpediente = btn.up('datoscompradorwindow').idExpediente;
		var window = btn.up().up();
		var form = window.down("formBase");

		if(form.isFormValid()) {
			form.mask(HreRem.i18n("msg.mask.espere"));
			
			if(Ext.isDefined(form.getModelInstance().getProxy().getApi().create)){
	    			form.getModelInstance().getProxy().extraParams.idExpediente = idExpediente;
	    			form.getBindRecord().save({
	    				success: function(a, operation, c){
	    					me.getView().unmask();
	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    					form.reset();
	    					window.parent.funcionRecargar();
	    					window.hide();
	    					me.getView().fireEvent("refrescarExpediente", me.getView());
	    				},
	    				failure: function(a, operation){
	    					me.getView().unmask();
							me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	    					form.reset();
	    					window.parent.funcionRecargar();
	    					window.hide();
	    				}
	    			})
	    		}
		} else {
		
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	},

	abrirFormularioCrearComprador: function(grid) {
		var me = this,
		idExpediente = me.getViewModel().get("expediente.id"),
		codigoEstado= me.getViewModel().get("expediente.codigoEstado");
		bloqueado = me.getViewModel().get("expediente.bloqueado");
		if(!bloqueado){		
			if(CONST.ESTADOS_EXPEDIENTE['VENDIDO']!=codigoEstado){
				var ventanaCompradores= grid.up().up();
				var expediente= me.getViewModel().get("expediente");
				//Esta es la forma antigua que se ha sustituido por el wizard
				//Ext.create('HreRem.view.expedientes.DatosComprador',{idExpediente: idExpediente, parent: ventanaCompradores, expediente: expediente}).show();
				Ext.create('HreRem.view.expedientes.WizardAltaComprador',{idExpediente: idExpediente, parent: ventanaCompradores, expediente: expediente}).show();
				me.onClickBotonRefrescar();
			}
			else{
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.expediente.vendido"));
			}
		}else{
			me.fireEvent("errorToast","Expediente bloqueado");
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
	
	enviarHonorariosUvem: function(btn){
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
	
	buscarClientesUrsus: function(field, e){
		var me = this;
		var parent = field.up('datoscompradorwindow');
		var tipoDocumento= field.up('formBase').down('[reference=tipoDocumento]').getValue();
		var numeroDocumento= field.up('formBase').down('[reference=numeroDocumento]').getValue();
		var fichaComprador= field.up('[xtype=formBase]');
		var idExpediente = me.getViewModel().get("expediente.id");
		if(idExpediente == null){
			idExpediente = fichaComprador.getBindRecord().get('idExpedienteComercial');
		}
		
		if(!Ext.isEmpty(tipoDocumento) && !Ext.isEmpty(numeroDocumento) && !Ext.isEmpty(idExpediente)) {
			var form = parent.down('formBase');
    	 	var fieldClientesUrsus = form.down('[reference=seleccionClienteUrsus]');
    	 	var store = fieldClientesUrsus.getStore();
    	 	
    	 	if(Ext.isEmpty(store.getData().items) || fieldClientesUrsus.recargarField) {
    	 		store.removeAll();
    	 		store.getProxy().setExtraParams({numeroDocumento: numeroDocumento, tipoDocumento: tipoDocumento, idExpediente: idExpediente});    
        	 	store.load({
        	 		callback: function(records, operation, success) {
				        if(success) {
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
		var numeroUrsus = field.up('formBase').down('[reference=seleccionClienteUrsus]').getValue();
	 	var fieldNumeroClienteUrsus = field.up('formBase').down('[reference=numeroClienteUrsusRef]');
	 	var fieldNumeroClienteUrsusBh = field.up('formBase').down('[reference=numeroClienteUrsusBhRef]');
	 	var btnDatosClienteUrsus = field.up('formBase').down('[reference=btnVerDatosClienteUrsus]');
	 	var fichaComprador= field.up('[xtype=formBase]');
	 	var esBH = fichaComprador.getBindRecord().get('esBH');
	 	btnDatosClienteUrsus.setDisabled(false);
	 	
	 	if(esBH=="true"){
	 		fieldNumeroClienteUrsusBh.setValue(numeroUrsus);
	 	}else{
	 		fieldNumeroClienteUrsus.setValue(numeroUrsus);
	 	} 	
	},

	mostrarDetallesClienteUrsus: function(field, newValue ,oldValue ,eOpts){
		var me = this;
		var url =  $AC.getRemoteUrl('expedientecomercial/buscarDatosClienteNumeroUrsus');
		var numeroUrsus = field.up('formBase').down('[reference=seleccionClienteUrsus]').getValue();
		var fichaComprador= field.up('[xtype=formBase]');
		var idExpediente = fichaComprador.getBindRecord().get('idExpedienteComercial');
		var parent = field.up('datoscompradorwindow');

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
		idExpediente = me.getViewModel().get("expediente.id"),
		codigoEstado= me.getViewModel().get("expediente.codigoEstado"),
		idComprador= record.get('id');
		bloqueado = me.getViewModel().get("expediente.bloqueado");
		if(!bloqueado){
				if(CONST.ESTADOS_EXPEDIENTE['VENDIDO']!=codigoEstado){
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
				else{
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.expediente.vendido"));
				}
		}else{
			me.fireEvent("errorToast", "Expediente bloqueado");
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

	changeFecha: function(campoFecha) {
		var me = this,
		referencia = campoFecha.getReference().replace('fecha','hora'),
		campoHora = me.lookupReference(referencia);

		if(campoFecha.getValue() != null) {
			campoHora.setDisabled(false);
			campoHora.allowBlank = false;
			if(campoHora.getValue() == null) {//De esta forma se marca en rojo como obligatorio sin tener que pinchar en el campo
				campoHora.setValue('00:00');
				campoHora.setValue();
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

	comprobarObligatoriedadCamposNexos: function() {
		
		var me = this,
		campoEstadoCivil = me.lookupReference('estadoCivil'),
		campoRegEconomico = me.lookupReference('regimenMatrimonial'),
		campoNumConyuge = me.lookupReference('numRegConyuge'),
		campoApellidos = me.lookupReference('apellidos');
		// Si el tipo de persona es FÍSICA, entonces el campos Estado civil es obligatorio y se habilitan campos dependientes.
		if(me.lookupReference('tipoPersona').getValue() === "1" ) {
			//campoEstadoCivil.setDisabled(false);
			//campoRegEconomico.setDisabled(false);
			//campoNumConyuge.setDisabled(false);
			campoApellidos.setDisabled(false);
			campoEstadoCivil.allowBlank = false;
			campoEstadoCivil.validate();
			if(campoEstadoCivil.getValue() === "02") {
				// Si el Estado civil es 'Casado', entonces Reg. económico es obligatorio.
				campoRegEconomico.allowBlank = false;
				campoRegEconomico.validate();
				if(me.getViewModel().get('esCarteraLiberbank')|| me.getViewModel().get('comprador.entidadPropietariaCodigo') == CONST.CARTERA['LIBERBANK']){
					campoNumConyuge.allowBlank = false;
					campoNumConyuge.validate();
					if(campoRegEconomico.getValue() === "01" || campoRegEconomico.getValue() === "03"){
						campoNumConyuge.allowBlank = false;
						campoNumConyuge.validate();
					}else if(campoRegEconomico.getValue() === "02" ){
						campoNumConyuge.allowBlank = true;
					}
				}else{
					campoNumConyuge.allowBlank = true;
				}
				//campoRegEconomico.setDisabled(false);
				//campoNumConyuge.setDisabled(false);
			} else {
				campoRegEconomico.allowBlank = true;
				campoNumConyuge.allowBlank = true;
				//campoRegEconomico.reset();
				//campoNumConyuge.reset();
				//campoRegEconomico.setDisabled(true);
				//campoNumConyuge.setDisabled(true);
			}
		} else {
			//  Si el tipo de persona es 'Jurídica' entonces desactivar los campos dependientes del otro estado.
			campoEstadoCivil.allowBlank = true;
			campoRegEconomico.allowBlank = true;
			campoApellidos.setDisabled(true);
			//campoEstadoCivil.reset();
			//campoRegEconomico.reset();
			//campoNumConyuge.reset();
			//campoEstadoCivil.setDisabled(true);
			//campoRegEconomico.setDisabled(true);
			//campoNumConyuge.setDisabled(true);
		}

		// Validar campos para que se muestre o desaparezca la visual roja.
		campoEstadoCivil.validate();
		campoRegEconomico.validate();
		campoNumConyuge.validate();
	},

	onClickGenerarHojaExcel: function(btn) {

    	var me = this,
		config = {};

		config.params = {};
		config.params.numExpediente=me.getViewModel().get("expediente.numExpediente");
		config.url= $AC.getRemoteUrl("operacionventa/operacionVentaPDFByOfertaHRE");

		me.fireEvent("downloadFile", config);		
	},
	
	onClickGenerarFacturaPdf: function(btn) {
		var me = this,
		config = {};

		config.params = {};
		config.params.numExpediente=me.getViewModel().get("expediente.numExpediente");
		config.url= $AC.getRemoteUrl("operacionventa/operacionVentaFacturaPDF");

		me.fireEvent("downloadFile", config);		
	},
	
	onAgregarGestoresClick: function(btn){
		
		var me = this;

    	var url =  $AC.getRemoteUrl('expedientecomercial/insertarGestorAdicional');
    	var parametros = btn.up("combogestoresexpediente").getValues();
    	parametros.idExpediente = me.getViewModel().get("expediente.id");

    	Ext.Ajax.request({
    		
    	     url: url,
    	     params: parametros,

    	     success: function(response, opts) {
    	    	 btn.up("gestoresexpediente").down("[reference=listadoGestoresExpediente]").getStore().load();
    	         btn.up("gestoresexpediente").down("form").reset();
    	         /*
    	         if(Ext.decode(response.responseText).success == "false") {
					me.fireEvent("errorToast", HreRem.i18n("msg.activo.gestores.noasignar.tramite.multiactivo"));
    	         }*/
    	     }
    	 });
    },
	onClickBotonCancelar: function(btn) {
		var me = this,
		activeTab = btn.up('tabpanel').getActiveTab();
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
    
    onClickBloquearExpediente: function(btn) {

    	var me = this;
    	var idExpediente = me.getViewModel().get("expediente.id");
    	var url =  $AC.getRemoteUrl('expedientecomercial/bloqueoExpediente');
    	var parametros = {idExpediente : idExpediente};
    	me.getView().mask();
    	Ext.Ajax.request({
    		
    	     url: url,
    	     params: parametros,

    	     success: function(response, opts) {
    	    	 if(Ext.decode(response.responseText).success == "false") {
    	    		me.fireEvent("errorToast", HreRem.i18n(Ext.decode(response.responseText).errorCode));
    	    		me.getView().unmask();
    	         }else if (Ext.decode(response.responseText).success == "true"){
    	        	me.getView().unmask();
    	        	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	 				me.refrescarExpediente(true);	
				 }
    	     }
    	 });		
	},
	sendDesbloquearExpediente: function(btn) {
		var me = this;
		var window = btn.up().up();
		var form = window.down("formBase").getForm();
		var idExpediente = btn.up('desbloquearwindow').idExpediente;
    	var url =  $AC.getRemoteUrl('expedientecomercial/desbloqueoExpediente');
    	if(me.validarActivarForm(form)) {
    		var parametros = {idExpediente : idExpediente,motivoCodigo : form.findField("motivo").getValue(),motivoDescLibre : form.findField("motivoDescLibre").getValue()};
    		me.getView().mask();
	    	Ext.Ajax.request({
	    		
	    	     url: url,
	    	     params: parametros,
	
	    	     success: function(response, opts) {
	    	    	 if(Ext.decode(response.responseText).success == "false") {
	    	    		me.fireEvent("errorToast", HreRem.i18n(Ext.decode(response.responseText).errorCode));
	    	    		me.getView().unmask();
	    	         }else if (Ext.decode(response.responseText).success == "true"){
	    	        	me.getView().unmask();
	    	        	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	        	window.parent.funcionReloadExp();
	    	        	window.hide();
						
					 }
	    	     }
	    	 });	
    	}else{
    		me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
    	}
	},
	onClickDesbloquearExpediente: function(btn) {
		var me = this;
		var idExpediente = me.getViewModel().get("expediente.id");
		var ventanaFormalizacion= btn.up().up();
		Ext.create('HreRem.view.expedientes.Desbloquear',{idExpediente: idExpediente,parent: ventanaFormalizacion}).show();    	
	},
	validarActivarForm: function(form){
		var motivoCodigo = form.findField("motivo").getValue();
		var motivoDescLibre = form.findField("motivoDescLibre").getValue()
		if(motivoCodigo == undefined || motivoCodigo == ""){
			return false;
		}else if(motivoCodigo =="04" && (motivoDescLibre == undefined || motivoDescLibre =="")){
			return false;
		}else{
			return true;
		}
		
	},
	
	onClickGenerarHojaExcelActivos: function(btn) {
    	var me = this,
		config = {};

		config.params = {};
		config.params.idExpediente=me.getViewModel().get("expediente.id");
		config.url= $AC.getRemoteUrl("expedientecomercial/getExcelActivosExpediente");

		me.fireEvent("downloadFile", config);		
	},
	
	validarFechaPosicionamiento: function(value){
		var hoy= new Date();
		hoy.setHours(0,0,0,0);
		var from = value.split("/");
		var fechaPosiString = new Date(from[2], from[1] - 1, from[0]);
		var fechaPosiDate= new Date(fechaPosiString);
		
		if(fechaPosiDate<hoy){
			return HreRem.i18n('info.msg.fecha.posicionamiento.mayor.hoy');;
		}
		else{
			return true;
		}
	
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

	onCambioInversionSujetoPasivo: function(checkbox, newValue, oldValue, eOpts) {
		if(!Ext.isEmpty(oldValue)){
			var me = this,
			operacionExenta = me.lookupReference('chkboxOperacionExenta'),
	    	renunciaExencion = me.lookupReference('chkboxRenunciaExencion'),
	    	tipoAplicable = me.lookupReference('tipoAplicable');
	
			if(newValue == true) {
				operacionExenta.reset();
				operacionExenta.setReadOnly(true);
				renunciaExencion.reset();
	    		renunciaExencion.setReadOnly(true);
	    		tipoAplicable.reset();
	    		tipoAplicable.allowBlank = true;
	    		tipoAplicable.setDisabled(true);
			} else {
				operacionExenta.setReadOnly(false);
				tipoAplicable.allowBlank = false;
				tipoAplicable.setDisabled(false);
			}
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
	}
});