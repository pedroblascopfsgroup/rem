Ext.define('HreRem.view.expedientes.ExpedienteDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.expedientedetalle',  
    requires: [
		'HreRem.view.expedientes.NotarioSeleccionado', 'HreRem.view.expedientes.DatosClienteUrsus','HreRem.model.ActivoExpedienteCondicionesModel',
		'HreRem.view.common.adjuntos.AdjuntarDocumentoExpediente', 'HreRem.view.activos.detalle.OpcionesPropagacionCambios',
		'HreRem.view.common.WizardBase','HreRem.view.expedientes.wizards.comprador.SlideDatosComprador', 'HreRem.view.expedientes.wizards.comprador.SlideDocumentoIdentidadCliente', 
		'HreRem.view.expedientes.wizards.comprador.SlideAdjuntarDocumento', 'HreRem.view.expedientes.editarAuditoriaDesbloqueo'
	],
    
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
            onClickActivate: 'activarComprador',
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
		if(!Ext.isEmpty(panelTanteo)){
			var grid = panelTanteo.down('gridBaseEditableRow');
			if(grid != undefined){
				var store = grid.getStore();
				grid.expand();
				store.loadPage(1)
			}
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
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
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
				    	me.getView().unmask();
				    	if(Ext.isFunction(form.afterLoad)) {
				    		form.afterLoad();
				    	}						
				    }, 		    
				    failure: function(operation) {		    	
				    	me.getView().unmask();
				    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
				    }
				});
			} else {
				// Si la API no contiene metodo de lectura (read).
				form.setBindRecord(model);			    	
		    	me.getView().unmask();
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
						me.getView().unmask();				
					}
			    },			            
				failure: function (a, operation) {
					 me.getView().unmask();
				}
			});
		} else {
			// Si la API no contiene metodo de lectura (read).
			me.getViewModel().set(nameModels[index], models[index]);
	    	index++;
					
			if (index < models.length) {							
				me.cargarTabDataMultiple(form, index, models, nameModels);
			} else {	
				me.getView().unmask();				
			}
		}
	
	},

	onSaveFormularioCompleto: function(btn, form) {
		var me = this;
		var tipoBulkAdvisoryNote;
		//disableValidation: Atributo para indicar si el guardado del formulario debe aplicar o no, las validaciones
		if(!Ext.isEmpty(me.getViewModel().data.datosbasicosoferta)){
			tipoBulkAdvisoryNote = me.getViewModel().data.datosbasicosoferta.data.tipoBulkAdvisoryNote;
		}

		if(form.isFormValid() || form.disableValidation) {
			var cumplenCondicionesCampos = this.hacerCamposObligatorios(form);
			if(!cumplenCondicionesCampos){
				me.getView().unmask();
				return;
			}

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
						params : {tipoBulkAdvisoryNote: tipoBulkAdvisoryNote},
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
			//me.onClickBotonRefrescar();

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
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
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
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
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
		     params: {idExpediente: me.getViewModel().data.expediente.id},
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
		var activeTab = btn.up('tabpanel').getActiveTab();
		if(activeTab.xtype == "datosbasicosoferta"){
			me.getView().mask(HreRem.i18n("msg.mask.loading"));
			var url =  $AC.getRemoteUrl('expedientecomercial/esOfertaDependiente');
			var numOfertaPrin = me.getViewModel().data.datosbasicosoferta.data.numOferPrincipal;
			var nuevoNumOferta = me.getViewModel().data.datosbasicosoferta.data.nuevoNumOferPrincipal;
			var cloForm = me.getViewModel().data.datosbasicosoferta.data.claseOfertaCodigo;
			var numOferta = ((numOfertaPrin != null) ? numOfertaPrin : nuevoNumOferta);
			
			
			Ext.Ajax.request({
			
			     url: url,
			     params: { numOferta: numOferta }
			    ,success: function (response, opts) {
			         data = Ext.decode(response.responseText);
			         
			         if(cloForm == "02"){
			         if(data.success == "true" && data.error == "false"){
				    		Ext.Msg.show({
								   title: HreRem.i18n('title.confirmar.oferta.principal'),
								   msg: HreRem.i18n('msg.confirmar.oferta.principal'),
								   buttons: Ext.MessageBox.YESNO,
								   fn: function(buttonId) {
								   
								        if (buttonId == 'yes') {	
								        	me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab());
										}else{
											 me.getView().unmask();
										}
									}
							});
			    		
			    	} else if (data.success == "false" && data.error == "false") {
			    		me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab());
			    	} else if (data.success == "false" && data.error == "true") {
			    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.oferta.inexistente"));
					 	me.getView().unmask();		    		
			    	}
			    	} else {
				        me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab());
				    }
	            },
	            
	            failure: function (a, operation, context) {
	            	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					 me.getView().unmask();
					 activeTab.funcionRecargar();
	            }
		     
			});
			
			
		}else {
			me.onSaveFormularioCompleto(btn, btn.up('tabpanel').getActiveTab());
		}
			
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
		
		if (Ext.isDefined(btn.name)
				&& btn.name === 'firstLevel') {
			me.getViewModel().set("editingFirstLevel", false);
		} else {
			me.getViewModel().set("editing", false);
		}
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
  			if(component.rendered && "datosbasicosexpediente".indexOf(component.reference) <0) {
  				component.recargar=true;
  			}else {
  				component.recargar=false;
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
		refrescarTabActiva = Ext.isEmpty(refrescarTabActiva) ? false: refrescarTabActiva;
		var activeTab = me.getView().getActiveTab();		
  		
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
		config.params.nombreDocumento=record.get("nombre").replace(/,/g, "");
		me.fireEvent("downloadFile", config);
	},

	downloadDocumentoAdjuntoGDPR: function(grid, record) {
		var url =$AC.getRemoteUrl('expedientecomercial/existeDocumentoGDPR');
		var idPersonaHaya = record.get("idPersonaHaya");
		var idDocAdjunto =  record.get("idDocAdjunto");
		var idDocRestClient = record.get("idDocRestClient");
		var nombreAdjunto = record.get("nombreAdjunto").replace(/,/g, "");
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
		                config.params.nombreAdjunto=record.get("nombreAdjunto").replace(/,/g, "");

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
	
	onCompradoresListDobleClick: function(gridView, record) { 
		var me = this,
        codigoEstado = me.getViewModel().get('expediente.codigoEstado'),
        tipoExpedienteCodigo = me.getViewModel().get('expediente.tipoExpedienteCodigo'),
        fechaPosicionamiento = me.getViewModel().get('expediente.fechaPosicionamiento'),
        viewPortWidth = Ext.Element.getViewportWidth(),
        viewPortHeight = Ext.Element.getViewportHeight(),
        tipoExpedienteAlquiler = CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER'],
        tipoExpedienteVenta = CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'],
		tipoExpedienteAlquilerNoComercial = CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER_NO_COMERCIAL'],
		bloqueado =  me.getViewModel().get('expediente.bloqueado');
        var viewModel = me.getViewModel();
        if(bloqueado){
        	me.fireEvent('errorToast', HreRem.i18n('msg.warning.expediente.bloqueado'));
        	return;
        }

        var editarCompradores;

		if (codigoEstado != CONST.ESTADOS_EXPEDIENTE['VENDIDO']
		        || $AU.userHasFunction(['EDITAR_TAB_COMPRADORES_EXPEDIENTES'])) {
			editarCompradores = true;
		} else {
			editarCompradores = !me.getViewModel().get('expediente').data.tieneReserva;
		}

		if(( editarCompradores && tipoExpedienteCodigo === tipoExpedienteVenta) ||  (tipoExpedienteCodigo === tipoExpedienteAlquiler && Ext.isEmpty(fechaPosicionamiento))
				|| (tipoExpedienteCodigo === tipoExpedienteAlquilerNoComercial)) {
			var idCliente = record.get('id'),
				expediente= me.getViewModel().get('expediente'),
				storeProblemasVenta = me.getViewModel().get('storeProblemasVenta'),
				edicion = me.getViewModel().get('puedeModificarCompradores'),
				wizardTitle = HreRem.i18n('title.windows.datos.comprador');

			if(tipoExpedienteCodigo === tipoExpedienteAlquiler) {
				wizardTitle = HreRem.i18n('title.windows.datos.inquilino');
			}

			var wizard = Ext.create('HreRem.view.common.WizardBase',
				{
					slides: [
						'slidedatoscomprador',
						'slideadjuntardocumento'
					],
					title: wizardTitle,
					expediente: expediente,
					visualizar: true,
					storeProblemasVenta: storeProblemasVenta,
					idComprador: idCliente,
					modoEdicion: edicion,
					width: viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth / 1.5,
					height: viewPortHeight > 500 ? 500 : viewPortHeight - 100,
					x: viewPortWidth / 2 - ((viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth /1.5) / 2),
					y: viewPortHeight / 2 - ((viewPortHeight > 500 ? 500 : viewPortHeight - 100) / 2)
				}
			).show();
		}

		if (tipoExpedienteCodigo === tipoExpedienteAlquiler && !Ext.isEmpty(fechaPosicionamiento)) {
			me.fireEvent('errorToast', HreRem.i18n('msg.warning.no.se.puede.editar.inquilino'));
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
		var me = this;
    	var disabled = value == 0;
    	var esBankia = me.getViewModel().get("expediente.esBankia");
    	
		comboEntidadFinancieraCodigo = me.lookupReference('comboEntidadFinancieraCodigo');
		labelCapitalConcedido = me.lookupReference('capitalCondedidoRef');
		labelNumeroExpediente = me.lookupReference('numeroExpedienteRef');
		comboTipoFinanciacion = me.lookupReference('tipoFinanciacionRef');

    	    	
    	comboEntidadFinancieraCodigo.setDisabled(disabled);
    	comboEntidadFinancieraCodigo.allowBlank = disabled; 	

    	if(disabled) {
    		comboEntidadFinancieraCodigo.setValue("");
    		labelCapitalConcedido.setValue("");
    		labelNumeroExpediente.setValue("");
    		comboTipoFinanciacion.reset();
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
			importeReservaField.setValue(importeReserva);
			me.getViewModel().get('condiciones').set('importeReserva', importeReserva);
		}

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
	

	onClickBotonModificarCompradorSinWizard : function(btn) {
		var me = this, window = btn.up("window"), form = window.down("form");
		me.comprobarObligatoriedadCamposNexos();
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
		
		//if (rec.data.titularContratacion != 1) {
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
		//}
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
				   me.lookupReference('cncyCapitalConcedidoBnk').setValue(data.data);
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
	
	onHaCambiadoImporteCalculo: function(field, value, oldValue){
		var me= this;
		var tipoCalculoField= me.lookupReference('tipoCalculoHonorario')
		var importeField= me.lookupReference('importeCalculoHonorario')
		var tipoCalculo= me.lookupReference('tipoCalculoHonorario').value;
		var importeOferta = parseFloat(me.getViewModel().get('expediente.importe')).toFixed(2);

		if(CONST.TIPOS_CALCULO['FIJO'] == tipoCalculo){//importe fijo
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			honorarios.setValue(importeCalculoHonorario);
			importeField.setMaxValue(null);
		}
		
		else if(CONST.TIPOS_CALCULO['PORCENTAJE'] == tipoCalculo){//porcentaje
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			var honorario;
			
			honorario = (importeOferta*importeCalculoHonorario)/100;
			honorarios.setValue(Math.round(honorario * 100) / 100);
			importeField.setMaxValue(100);
			
			me.fireEvent("log" , "[HONORARIOS: Tipo: "+tipoCalculo+" | Calculo: "+importeCalculoHonorario+" | Importe Oferta: "+importeOferta+" | Importe: "+Math.round(honorario * 100) / 100+"]");
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
			var honorario;
			
			honorario = ((importeOferta*importeCalculoHonorario)/100)*12;
			honorarios.setValue(Math.round(honorario * 100) / 100);
			importeField.setMaxValue(100);

			me.fireEvent("log" , "[HONORARIOS: Tipo: "+tipoCalculo+" | Calculo: "+importeCalculoHonorario+" | Importe Oferta: "+importeOferta+" | Importe: "+Math.round(honorario * 100) / 100+"]");
		}
		
		else if(CONST.TIPOS_CALCULO['MENSUALIDAD_ALQ'] == tipoCalculo){//Mensualidad Alquiler
			var honorarios= me.lookupReference('honorarios');
			var importeCalculoHonorario= me.lookupReference('importeCalculoHonorario').value;
			var honorario;
			
			honorario = importeOferta*importeCalculoHonorario;
			honorarios.setValue(Math.round(honorario * 100) / 100);
			importeField.setMaxValue(100);

			me.fireEvent("log" , "[HONORARIOS: Tipo: "+tipoCalculo+" | Calculo: "+importeCalculoHonorario+" | Importe Oferta: "+importeOferta+" | Importe: "+Math.round(honorario * 100) / 100+"]");
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
		var tipoCalculo = me.lookupReference('tipoCalculo');
		var esCarteraGaleonOZeus =  ('15' == carteraCodigo || '14' == carteraCodigo);
		if(!esCarteraGaleonOZeus && value==1){
			tipoCalculo.setDisabled(false);
			tipoCalculo.allowBlank = false;
		}else{
			tipoCalculo.setDisabled(true);		
			tipoCalculo.setValue(null);
			tipoCalculo.allowBlank = true;
		}
	},
	
	onClickBotonCerrarComprador: function(btn){
		var me = this;
		var window = btn.up("window");
		window.hide();
	},

	abrirFormularioCrearComprador: function(grid) {
		var me = this;
		
		if(me.getViewModel().get('expediente.esBankia') && me.getViewModel().get('expediente.bloqueado')){
			me.fireEvent('errorToast', HreRem.i18n('msg.warning.expediente.bloqueado'));
			return;
		}
		
		if(me.getViewModel().get('expediente.bloqueado') && !$AU.userIsRol(CONST.PERFILES['HAYASUPER']) && !$AU.userIsRol(CONST.PERFILES['SUPER_EDITA_COMPRADOR'])) {
			me.fireEvent('errorToast', HreRem.i18n('msg.warning.expediente.bloqueado'));
			return;
		}

		if(CONST.ESTADOS_EXPEDIENTE['VENDIDO'] === me.getViewModel().get('expediente.codigoEstado') && !$AU.userIsRol(CONST.PERFILES['HAYASUPER']) && !$AU.userIsRol(CONST.PERFILES['SUPER_EDITA_COMPRADOR'])) {
			me.fireEvent('errorToast', HreRem.i18n('msg.operacion.ko.expediente.vendido'));
			return;
		}

		var tipoExpedienteCodigo = me.getViewModel().get('expediente.tipoExpedienteCodigo'),
			fechaSancion = me.getViewModel().get('expediente.fechaSancion'),
			expediente = me.getViewModel().get('expediente'),
			viewPortWidth = Ext.Element.getViewportWidth(),
			viewPortHeight = Ext.Element.getViewportHeight(),
			wizardTitle = HreRem.i18n('wizard.comprador.title');

		if (CONST.TIPOS_EXPEDIENTE_COMERCIAL['ALQUILER'] == tipoExpedienteCodigo) {
			if (CONST.TIPOS_ORIGEN['WCOM'] === me.getViewModel().get('expediente.origen') && !Ext.isEmpty(fechaSancion)) {
				me.fireEvent('errorToast', HreRem.i18n('msg.warning.expediente.origen.wcom'));
				return;
			}

			if (!Ext.isEmpty(fechaSancion)) {
				me.fireEvent('errorToast', HreRem.i18n('msg.warning.expediente.sancionado'));
				return;
			}

			wizardTitle = HreRem.i18n('wizard.inquilino.title');
		}

		Ext.create('HreRem.view.common.WizardBase',
			{
				slides: [
					'slidedocumentoidentidadcliente',
					'slidedatoscomprador',
					'slideadjuntardocumento'
				],
				title: wizardTitle,
				expediente: expediente,
				modoEdicion: true,
				width: viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth / 1.5,
				height: viewPortHeight > 500 ? 500 : viewPortHeight - 100,
				x: viewPortWidth / 2 - ((viewPortWidth > 1370 ? viewPortWidth / 2 : viewPortWidth /1.5) / 2),
    			y: viewPortHeight / 2 - ((viewPortHeight > 500 ? 500 : viewPortHeight - 100) / 2)
			}
		).show();
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
    
	onChangeComboEntidadFinanciera: function(combo, nValue, oValue, eOps) {
		var me = this;
		var esBankia = me.getViewModel().get("expediente.esBankia");
		var valorComboEsBankia = CONST.COMBO_ENTIDAD_FINANCIERA['BANKIA'];
		var valorComboEsOtros = CONST.COMBO_ENTIDAD_FINANCIERA['OTRA_ENTIDAD_CAIXA'];
		var disabled = nValue == 0;
    	    	  	
		numExpedienteRiesgo = me.lookupReference('numExpedienteRiesgo');
		comboTipoFinanciacion = me.lookupReference('comboTipoFinanciacion');  
		cncyCapitalConcedidoBnk = me.lookupReference('cncyCapitalConcedidoBnk');
		labelCapitalConcedido = me.lookupReference('capitalCondedidoRef');
		labelNumeroExpediente = me.lookupReference('numeroExpedienteRef');
		comboTipoFinanciacionRef = me.lookupReference('tipoFinanciacionRef');
		otraEntidadFinanciera = me.lookupReference('otraEntidadFinancieraRef');

		if (!(nValue == me.getViewModel().data.financiacion.data.entidadFinancieraCodigo)){
			labelCapitalConcedido.setValue("");
    		labelNumeroExpediente.setValue("");
    		comboTipoFinanciacionRef.reset();
    		numExpedienteRiesgo.setValue("");
    		comboTipoFinanciacion.reset();
		}
		
 
    	if(nValue == valorComboEsBankia) {
    		numExpedienteRiesgo.allowBlank = false;
    		comboTipoFinanciacion.allowBlank = false;
    		cncyCapitalConcedidoBnk.allowBlank = false;
    	}
    	
    	if(disabled) {
    		numExpedienteRiesgo.setValue("");
    		comboTipoFinanciacion.setValue("");
    		comboEntidadFinancieraCodigo.setValue("");
    		labelNumeroExpediente.setValue("");
    		comboTipoFinanciacion.reset();
    	}    	
    	if (nValue == valorComboEsOtros) {
    		otraEntidadFinanciera.setEditable(true);
    		otraEntidadFinanciera.setDisabled(false);
    		otraEntidadFinanciera.allowBlank = false;
    	}else{
    		otraEntidadFinanciera.setEditable(false);
    		otraEntidadFinanciera.setDisabled(true);
    		otraEntidadFinanciera.allowBlank = true;
    		otraEntidadFinanciera.setValue("");
    	}
	},
	
	changeOfrPrincipalOrDep: function (combo, value, oldValue, eOpts, recarga){
		var me = this;
			
		var form = combo.up('form');
		var numOferPrincipal = form.getBindRecord().data.numOferPrincipal;
		var checkImporteTotal = form.down('field[name=importeTotal]');
		var checkNumOferPrin = form.down('field[name=numOferPrincipal]');
		var checkNuevoNumOferPrin = form.down('field[name=nuevoNumOferPrincipal]');
		
		if(recarga) oldValue = value;
		
		if(CONST.DD_CLASE_OFERTA['PRINCIPAL'] == value){
			checkImporteTotal.setVisible(true);
			checkNumOferPrin.setVisible(false);
			checkNuevoNumOferPrin.setVisible(false);
			
		} else if(CONST.DD_CLASE_OFERTA['DEPENDIENTE'] == value){
			
			if(CONST.DD_CLASE_OFERTA['DEPENDIENTE'] != oldValue){
				
				if(!Ext.isEmpty(numOferPrincipal) && Ext.isEmpty(oldValue)){
					
					checkNumOferPrin.setVisible(true);
					checkNuevoNumOferPrin.setVisible(false);
				}else{
				
					if(!Ext.isEmpty(numOferPrincipal)){
						checkNumOferPrin.setVisible(true);
						checkNuevoNumOferPrin.setVisible(false);
					}else{
						checkNumOferPrin.setVisible(false);
						checkNuevoNumOferPrin.setVisible(true);
					}		
					
				}
				checkImporteTotal.setVisible(false);
			} else{
				checkImporteTotal.setVisible(false);
				checkNumOferPrin.setVisible(true);
				checkNuevoNumOferPrin.setVisible(false);
			}
		} else{
			checkImporteTotal.setVisible(false);
			checkNumOferPrin.setVisible(false);
			checkNuevoNumOferPrin.setVisible(false);
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

		var permite = this.permiteContinuarPorEstadoExpediente(btn);
		
		if(!permite){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.estado.expediente.no.valido"));	
			activeTab = btn.up('tabpanel').getActiveTab();
			activeTab.funcionRecargar();
			me.getView().unmask();
			return permite;
		}
		
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
				if(!bloqueado || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPER_EDITA_COMPRADOR'])) {
					if(CONST.ESTADOS_EXPEDIENTE['VENDIDO']!=codigoEstado || $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['SUPER_EDITA_COMPRADOR'])) {
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
	
	onClickBotonCerrarClienteUrsus: function(btn){
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
		
		var estadoExpediente = me.getView().getViewModel().getData().expediente.getData().codigoEstado;
		var bloqueado = me.getView().getViewModel().getData().expediente.getData().bloqueado;
		var estadosNoAnyadir = [CONST.ESTADOS_EXPEDIENTE['VENDIDO'],CONST.ESTADOS_EXPEDIENTE['FIRMADO']];
		
		if(estadosNoAnyadir.includes(estadoExpediente) || bloqueado || gridNfo.rowIdx != 0) {
			return false;
		}
		
		var estadoValidacionBC = gridNfo.record.data.validacionBCPosi;
	
		if (estadoValidacionBC == CONST.ESTADO_VALIDACION_BC['CODIGO_NO_ENVIADA'] || estadoValidacionBC == CONST.ESTADO_VALIDACION_BC['CODIGO_APROBADA_BC']){								
			me.lookupReference('motivoAplazamientoRef').setDisabled(false);
		}else{    			
			me.lookupReference('motivoAplazamientoRef').setDisabled(true);
		}
		
		if(editor.isNew) {
			me.lookupReference('fechaPosicionamientoRef').setValue();
			me.lookupReference('horaAvisoRef').setValue();
			me.lookupReference('horaPosicionamientoRef').setValue();
			me.lookupReference('motivoAplazamientoRef').setDisabled(true);
		}
		me.changeFecha(me.lookupReference('fechaPosicionamientoRef'));
		me.changeHora(me.lookupReference('horaAvisoRef'));
		me.changeHora(me.lookupReference('horaPosicionamientoRef'));
		
		me.lookupReference('fechaPosicionamientoRef').setDisabled(false);
		me.lookupReference('horaPosicionamientoRef').setDisabled(false);
	},

	comprobarCamposFechasAlquiler: function(editor, gridNfo) {
		var me = this;

		if(editor.isNew) {
			me.lookupReference('fechaFirmaRef').setValue();
			me.lookupReference('horaFirmaRef').setValue();
			me.lookupReference('motivoAplazamientoRef').setValue();
		}
		me.changeFecha(me.lookupReference('fechaFirmaRef'));
		//me.changeHora(me.lookupReference('horaFirmaRef'));
		
		me.lookupReference('fechaFirmaRef').setDisabled(false);
		me.lookupReference('horaFirmaRef').setDisabled(false);
		me.lookupReference('lugarFirmaRef').setDisabled(false);
	},
	
	comprobacionesDobleClick: function(editor, gridNfo) {
		var me = this;

        if(editor.up().up().up().getBindRecord().esBankia){
		    me.lookupReference('motivoAplazamientoBcRef').allowBlank = false;
		    me.lookupReference('motivoAplazamientoBcRef').isValid()
        }
	},

	comprobacionesDobleClickAlquiler: function(editor, gridNfo) {
		var me = this;

		if(editor.up().up().up().getBindRecord().esBankia){
          me.lookupReference('motivoAplazamientoBcRef').allowBlank = false;
          me.lookupReference('motivoAplazamientoBcRef').isValid();
        }

	},

	changeMotivoAplazamientoAlquiler: function(combo, newValue){
	var me = this;

    me.lookupReference('motivoAplazamientoBcRef').isValid();

	},

	quitarAllowBlankMotivoAplazamientoAlquiler: function(grid) {
		var me = this;

		if(grid.up().up().getBindRecord().esCarteraBankia){
          me.lookupReference('motivoAplazamientoBcRef').allowBlank = true;
          me.lookupReference('motivoAplazamientoBcRef').isValid();
        }

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
		campoNumContacto = me.lookupReference('numContactoFromOfertaRef');
		// Si el estado de la visita no es REALIZADA, no debe haber numVisita relacionada
		if(me.lookupReference('comboEstadosVisita').getValue() == "03" ){
			campoNumVisita.setDisabled(false);
			campoNumContacto.setDisabled(false);
		}else {
			campoNumVisita.setValue();
			campoNumVisita.setDisabled(true);
			campoNumContacto.setValue();
			campoNumContacto.setDisabled(true);
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

	comprobarObligatoriedadCamposNexos: function(field, newValue, oldValue) {

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
	    	var form = me.getViewModel().getView().down("form");
	    	
	    	me.comprobarObligatoriedadRte();
	    	var comprador;
	    	if(!Ext.isEmpty(form.getViewModel())){
	    		comprador = form.getViewModel().get('comprador');
	    	}else{
	    		comprador = me.getViewModel().get('comprador');
	    	}
			var codTipoPersona = me.lookupReference('tipoPersona'),
			campoNombre = me.lookupReference('nombreRazonSocial'),
			campoPorcionCompra = me.lookupReference('porcionCompra'),
	    	campoEstadoCivil = me.lookupReference('estadoCivil'),
			campoRegEconomico = me.lookupReference('regimenMatrimonial'),
			campoNumConyuge = me.lookupReference('numRegConyuge'),
			campoTipoConyuge = me.lookupReference('tipoDocConyuge'),
			campoNombreRte = me.lookupReference('nombreRazonSocialRte'),
			campoTipoRte = me.lookupReference('tipoDocumentoRte'),
			campoNumRte = me.lookupReference('numeroDocumentoRte'),
			campoPaisRte = me.lookupReference('paisRte'),
			campoApellidosRte = me.lookupReference('apellidosRte'),	
			campoApellidos = me.lookupReference('apellidos'),
			campoDireccion = me.lookupReference('direccion'),
			campoProvincia = me.lookupReference('provinciaCombo'),
			campoMunicipio = me.lookupReference('municipioCombo'),
			campoPais = me.lookupReference('pais'),
			campoRelacionHre = me.lookupReference('relacionHre'),
			campoAntDeudor = me.lookupReference('antiguoDeudor'),
			campoRelAntDeudor = me.lookupReference('relacionAntDeudor'),
			campoNombreRazonSocialRte = me.lookupReference('nombreRazonSocialRte'),
			campoDireccionRte = me.lookupReference('direccionRte'),
			campoPovinciaRte = me.lookupReference('provinciaComboRte'),
			campoTelefono1Rte = me.lookupReference('telefono1Rte'),
			campoTelefono2Rte = me.lookupReference('telefono2Rte'),
			campoCodigoPostalRte = me.lookupReference('codigoPostalRte'),
			campoEmailRte = me.lookupReference('emailRte');
			//Si el expediente es de tipo alquiler
			if(me.getViewModel().get('expediente.tipoExpedienteCodigo') == "02" || venta == false){
				if(!Ext.isEmpty(codTipoPersona.getValue())){
					// Si el tipo de persona es FÍSICA, entonces el campos Estado civil es obligatorio y se habilitan campos dependientes.
					if(codTipoPersona.getValue() === "1") {
						if(!Ext.isEmpty(campoApellidos)){
							campoApellidos.setDisabled(false);
						}
						if(!Ext.isEmpty(campoEstadoCivil)){
							campoEstadoCivil.allowBlank = false;
							if(!Ext.isEmpty(campoEstadoCivil.getValue())){
								if(campoEstadoCivil.getValue() === "02") {
									// Si el Estado civil es 'Casado', entonces Reg. económico es obligatorio.
									if(!Ext.isEmpty(campoRegEconomico)){
										campoRegEconomico.allowBlank = false;
									}
									if(me.getViewModel().get('esCarteraLiberbank')|| me.getViewModel().get('comprador.entidadPropietariaCodigo') == CONST.CARTERA['LIBERBANK']){
										if(!Ext.isEmpty(campoNumConyuge)){
											campoNumConyuge.allowBlank = false;
										}
										if(!Ext.isEmpty(campoRegEconomico) && !Ext.isEmpty(campoNumConyuge)){
											if(!!Ext.isEmpty(campoRegEconomico.getValue())){
												if(campoRegEconomico.getValue() === "01" || campoRegEconomico.getValue() === "03"){
													campoNumConyuge.allowBlank = false;
													campoTipoConyuge.allowBlank = false;
												}else if(campoRegEconomico.getValue() === "02" ){
													campoNumConyuge.allowBlank = true;
													campoTipoConyuge.allowBlank = true;
													if(!Ext.isEmpty(campoNumConyuge.getValue())){
														campoTipoConyuge.allowBlank = false;
													}
												}
											}
										}
									}else{
										if(!Ext.isEmpty(campoNumConyuge)){
											campoNumConyuge.allowBlank = true;
											campoTipoConyuge.allowBlank = true;
											if(!Ext.isEmpty(campoNumConyuge.getValue())){
												campoTipoConyuge.allowBlank = false;
											}
										}
									}
								} else {
										campoRegEconomico.allowBlank = true;
										campoNumConyuge.allowBlank = true;
										campoTipoConyuge.allowBlank = true;
										campoRegEconomico.setValue();
										if(campoEstadoCivil.getValue() === "01") {
											campoTipoConyuge.setValue();
											campoNumConyuge.setValue();
										}else{
											if(!Ext.isEmpty(campoNumConyuge.getValue())){
												campoTipoConyuge.allowBlank = false;
											}
										}
									
								}
							}
						
						}
						campoTipoRte.setValue();						
						campoNumRte.setValue();
						campoNombreRazonSocialRte.setValue();
						campoApellidosRte.setValue();
						campoDireccionRte.setValue();
						campoPovinciaRte.setValue();
						campoTelefono1Rte.setValue();
						campoTelefono2Rte.setValue();
						campoMunicipioRte.setValue();
						campoCodigoPostalRte.setValue();
						campoEmailRte.setValue();
						campoPaisRte.setValue(null);
						campoPais.setValue(null);
						
						
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
						campoEstadoCivil.setValue();						
						campoRegEconomico.setValue();
						campoTipoConyuge.setValue();
						campoNumConyuge.setValue();
						campoRelacionHre.setValue();
						campoAntDeudor.setValue();
						campoRelAntDeudor.setValue();
						
						if(campoPaisRte.value == null){
							campoPaisRte.setValue("28");
						}
						
						if(campoPais.value == null){
							campoPais.setValue("28");
						}	
					}
				}
			} else {
				if(!Ext.isEmpty(codTipoPersona.getValue())){
					//Si el tipo de expediente es de tipo venta
					if(codTipoPersona.getValue() === "1") {
						
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
							campoPaisRte.setValue(null);
						}
						
						if(!Ext.isEmpty(campoApellidos)){
							campoApellidos.setDisabled(false);
							campoApellidos.allowBank = false;
						}
						if(!Ext.isEmpty(campoEstadoCivil)){
							campoEstadoCivil.allowBlank = false;
							if(!Ext.isEmpty(campoEstadoCivil.getValue())){
								if(campoEstadoCivil.getValue() === "02") {
									// Si el Estado civil es 'Casado', entonces Reg. economica es obligatorio.
									if(!Ext.isEmpty(campoRegEconomico)){
										campoRegEconomico.allowBlank = false;
										campoRegEconomico.setDisabled(false);
										if(!Ext.isEmpty(campoRegEconomico.getValue())){
											if(campoRegEconomico.getValue() === "01"){
												campoTipoConyuge.allowBlank = false;
												campoNumConyuge.allowBlank = false;
											}else{
												campoTipoConyuge.allowBlank = true;
												campoNumConyuge.allowBlank = true;
												if(!Ext.isEmpty(campoNumConyuge.getValue())){
													campoTipoConyuge.allowBlank = false;
												}												
											}
										}
									}
									
								} else {
										campoRegEconomico.allowBlank = true;	
										campoNumConyuge.allowBlank = true;
										campoTipoConyuge.allowBlank = true;
										campoRegEconomico.setValue();	
										if(campoEstadoCivil.getValue() === "01") {
											campoTipoConyuge.setValue();
											campoNumConyuge.setValue();
										}else{
											if(!Ext.isEmpty(campoNumConyuge.getValue())){
												campoTipoConyuge.allowBlank = false;
											}
										}
										
									
								}						
							}						
						}
						campoPais.setValue(null);
					} else {
						//  Si el tipo de persona es 'Jurídica'
						if(!Ext.isEmpty(campoEstadoCivil)){
							campoEstadoCivil.allowBlank = true;
						}
						if(!Ext.isEmpty(campoRegEconomico)){
							campoRegEconomico.allowBlank = true;
						}
						if(!Ext.isEmpty(campoTipoConyuge)){
							campoTipoConyuge.allowBlank = true;
						}
						if(!Ext.isEmpty(campoNumConyuge)){
							campoNumConyuge.allowBlank = true;
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
						}else if(campoPaisRte.value == null){
							campoPaisRte.setValue("28");
						}
						campoEstadoCivil.setValue();						
						campoRegEconomico.setValue();
						campoTipoConyuge.setValue();
						campoNumConyuge.setValue();
						campoRelacionHre.setValue();
						campoAntDeudor.setValue();
						campoRelAntDeudor.setValue();
						
						if(campoPais.value == null){
							campoPais.setValue("28");
						}
					}
				}
				if(!Ext.isEmpty(field) && Ext.isEmpty(newValue)){
					field.setValue();
				}
				codTipoPersona.validate();
				campoPorcionCompra.validate();
				campoNombre.validate();
		    	campoEstadoCivil.validate();
				campoRegEconomico.validate();
				campoNumConyuge.validate();
				campoTipoConyuge.validate();
				campoNombreRte.validate();
				campoTipoRte.validate();
				campoNumRte.validate();
				campoPaisRte.validate();
				campoApellidosRte.validate();	
				campoApellidos.validate();
				campoDireccion.validate();
				campoProvincia.validate();
				campoMunicipio.validate();
				campoPais.validate();
				form.recordName = "comprador";
				form.recordClass = "HreRem.model.FichaComprador";

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
	    	var esBankia = me.getViewModel().get("expediente.esBankia");
	    	var tipoExpedienteCodigo = me.getViewModel().get('expediente.tipoExpedienteCodigo');
	    	if (esBankia && CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'] == tipoExpedienteCodigo) {
	    		if(newValue == true) {
					/*operacionExenta.reset();
					operacionExenta.setReadOnly(true);*/
					renunciaExencion.reset();
		    		renunciaExencion.setReadOnly(true);
		    		renunciaExencion.setDisabled(true);
		    		tipoAplicable.reset();
		    		tipoAplicable.setDisabled(true);
		    		tipoAplicable.allowBlank = true;
				} else {
					//operacionExenta.setReadOnly(false);
					tipoAplicable.setDisabled(false);
					tipoAplicable.allowBlank = false;
		    		renunciaExencion.setReadOnly(false);
		    		renunciaExencion.setDisabled(false);
		    		renunciaExencion.allowBlank = false;					
		    		
				}
	    	}else{
	    		if (CONST.TIPOS_EXPEDIENTE_COMERCIAL['VENTA'] == tipoExpedienteCodigo) {
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
	    	}			
		}
	},
	onCambioGrupoImpuesto: function(combo, value, oldValue, eOpts){
			var me = this,			
	    	renunciaExencion = me.lookupReference('chkboxRenunciaExencion'),
	    	tipoAplicable = me.lookupReference('tipoAplicable');
			
			var esVenta = me.getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"];
			if(esVenta){
		    	var esBankia = me.getViewModel().get("expediente.esBankia");
		    	if (esBankia) {
		    		renunciaExencion.setDisabled(true);
		    		if (CONST.TIPO_GRUPO_IMPUESTO['CODIGO_TASA_CERO'] == value) {
		    			renunciaExencion.setDisabled(false);
		    			renunciaExencion.reset();
		    		}else{
		    			tipoAplicable.setDisabled(false);
		    			tipoAplicable.allowBlank = false;
		    		}
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
	onClickGenerarPdfPropuestaAprobacionOferta : function(btn) {
		var me = this, config = {};

		config.params = {};
		config.params.numExpediente = me.getViewModel().get(
				"expediente.numExpediente");
		config.url = $AC
				.getRemoteUrl("operacionventa/generarPdfPropuestaAprobacionOferta");

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
	onClickDescargaPlantillaExcel : function(btn) {
		var me = this;
		var config = {};
		config.params = {};
		config.params.idExpediente = me.getViewModel().get(
				"expediente.id");
		config.url = $AC
				.getRemoteUrl("expedientecomercial/getExcelPlantillaDistribucionPrecios");

		me.fireEvent("downloadFile", config);
	},
	onClickAdvisoryNoteExpediente : function(btn) {
		var me = this;
		
		var url =  $AC.getRemoteUrl('expedientecomercial/getAdvisoryNoteExpediente');

		var config = {};
		config.params = {};
		config.params.idExpediente=me.getViewModel().get('expediente.id');
		config.url= url;
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

	onCambioTipoImpuesto : function(combo, value, oldValue, eOpts) {
		try {
			if (!Ext.isEmpty(value)) {
				if(!Ext.isEmpty(value.data)){
					value = value.get('codigo');
				}
				var me = this, 
				tipoAplicable = me.lookupReference('tipoAplicable'), 
				operacionExenta = me.lookupReference('chkboxOperacionExenta'), 
				inversionSujetoPasivo = me.lookupReference('chkboxInversionSujetoPasivo'), 
				renunciaExencion = me.lookupReference('chkboxRenunciaExencion'),
				grupoImpuesto = me.lookupReference('grupoImpuestoRef'),
				tributosPropiedad= me.lookupReference('chkboxTributosPropiedad');
				
				var esVenta = me.getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"];
				if(esVenta){
			    	var esBankia = me.getViewModel().get("expediente.esBankia");
			    	if(!esBankia){
			    		grupoImpuesto.setDisabled(true);
			    	}
		    		if(CONST.TIPO_IMPUESTO['ITP'] == value){
		    			tipoAplicable.reset();	    				
		    			inversionSujetoPasivo.reset();
		    			tributosPropiedad.reset();
		    			renunciaExencion.reset();
		    			
		    			tipoAplicable.setDisabled(true);
		    			renunciaExencion.setDisabled(true);
		    			//tributosPropiedad.setDisabled(true);
		    			inversionSujetoPasivo.setDisabled(true);
		    			
		    			if(esBankia){
		    				grupoImpuesto.clearValue();
		    				grupoImpuesto.setDisabled(true);
		    			}
		    			
		    		}else{
		    			
		    			tributosPropiedad.allowBlank = false;
		    			tipoAplicable.allowBlank = false;
		    			renunciaExencion.allowBlank=false;
		    			inversionSujetoPasivo.allowBlank=false;
		    			
		    			tributosPropiedad.validate();
		    			renunciaExencion.validate();
		    			inversionSujetoPasivo.validate();
		    			
		    			tipoAplicable.setDisabled(false);
		    			tributosPropiedad.setDisabled(false);
		    			renunciaExencion.setDisabled(false);
		    			inversionSujetoPasivo.setDisabled(false);
		    			
		    			if(esBankia){
			    			grupoImpuesto.allowBlank = false;
			    			grupoImpuesto.setDisabled(false);
			    			tipoAplicable.setDisabled(false);
			    			tipoAplicable.setDisabled(false);
			    			inversionSujetoPasivo.setDisabled(false);
			    			renunciaExencion.setDisabled(false);
			    			tributosPropiedad.setDisabled(false);
		    			}
		    		}
				}
			}
		} catch (err) {
			Ext.global.console.log('Error en onCambioTipoImpuesto: '+ err)
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
			var me = this, 
			tipoAplicable = me.lookupReference('tipoAplicable');
			var esBankia = me.getViewModel().get("expediente.esBankia");
			
			if (esBankia) {
				if (newValue == true) {
					tipoAplicable.reset();
					tipoAplicable.allowBlank = false;
					tipoAplicable.setDisabled(false);
				}else{
					tipoAplicable.reset();
					tipoAplicable.allowBlank = true;
					tipoAplicable.setDisabled(true);
				}
			}else{
				if (newValue == false) {
					tipoAplicable.reset();
					tipoAplicable.allowBlank = true;
					tipoAplicable.setDisabled(true);
				} else {
					tipoAplicable.setDisabled(false);
					tipoAplicable.allowBlank = false;
				}
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
			meses = checkbox.up('[xtype=fieldset]').down('[name=mesesCarencia]');
			importe = checkbox.up('[xtype=fieldset]').down('[name=importeCarencia]');
	
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
			var me = this;

			var meses = checkbox.up('[xtype=fieldset]').down('[name=mesesBonificacion]');
			var importe = checkbox.up('[xtype=fieldset]').down('[name=importeBonificacion]');
			var disabled;
			
			if(newValue == true) {
				disabled = false;
			} else {
				disabled = true;
			}
			
			if(me.getViewModel().get('esCarteraBankia') != true){
			    meses.setDisabled(disabled);
            }
			
			importe.setDisabled(disabled);
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
			
			
	},
	
	validarCompradores: function(btn) {
	
		var me = this;
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		var permite = this.permiteContinuarPorEstadoExpediente(btn);
		
		if(!permite){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.estado.expediente.no.valido"));	
			activeTab = btn.up('tabpanel').getActiveTab();
			activeTab.funcionRecargar();
			me.getView().unmask();
			return permite;
		}
		

		var url =$AC.getRemoteUrl('expedientecomercial/getComprobarCompradores');
		Ext.Ajax.request({
		     url: url,
		     params: {idExpediente : me.getViewModel().get("expediente.id")},
		     success: function (response, opts) {
		    	 data = Ext.decode(response.responseText);
		    	 if(data.data == "true"){
		    		 me.fireEvent("errorToast", HreRem.i18n("msg.algun.comprador.ha.cambiado"));
		    		
			     }else{
			    	 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			     }
		 		me.refrescarExpediente(true);
		 		me.getView().unmask();
		 	},
           failure: function (a, operation, context) {
           	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
           	me.getView().unmask();
           }
	    });
	},

comprobarFormatoModificar: function() {
		var me = this;
		valueComprador = me.lookupReference('numeroDocumento');
		valueConyuge = me.lookupReference('numRegConyuge');
		valueRte = me.lookupReference('numeroDocumentoRte');
		validaciones = 0;
		
		if(me.lookupReference('tipoPersona').getValue() === "1"){
			if(valueComprador != null){
				if(me.lookupReference('tipoDocumento').value == "01" || me.lookupReference('tipoDocumento').value == "15"
					|| me.lookupReference('tipoDocumento').value == "03"){

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

				}else if(me.lookupReference('tipoDocumento').value == "02"){

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
				if(me.lookupReference('tipoDocumento').value == "01" || me.lookupReference('tipoDocumento').value == "15"
					|| me.lookupReference('tipoDocumento').value == "03"){

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

				}else if(me.lookupReference('tipoDocumento').value == "02"){

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
			
	},

	onClickGenerarListadoDeActivos : function(btn) {
		var me = this, config = {};

		config.params = {};
		config.params.idExpediente = me.getViewModel().get("expediente.id");
		config.url = $AC.getRemoteUrl("expedientecomercial/exportarListadoActivosOfertaPrincipal");

		me.fireEvent("downloadFile", config);
	},
	
	onClickBtnDevolverReserva: function(btn){
		var me = this,
		model = me.getView().getViewModel().get('expediente');
		var win = Ext.create('Ext.window.Window', {
    		title: 'Devolver Reserva',
    		height: 150,
    		width: 700,
    		modal: true,
    		model: model,
    		renderTo: me.getView().body,
    		layout: 'fit',
    		items:{
    			xtype: 'form',
    			id: 'devolucionForm',
    			layout: {
    				type: 'hbox', 
    				pack: 'center', 
    				align: 'center' 
    			},
    			items:[
        			{
        				xtype: 'datefield',
        				id: 'fechaDevolucion',
        				name: 'fechaDevolucion',
        				reference: 'fechaDevolucion',
        				fieldLabel: 'Fecha Devolución'
        			}
        		],
        		border: false,
        		buttonAlign: 'center',
        		buttons: [
        			  {
        				  text: 'Aceptar',
        				  formBind: true,
        				  handler: function(){
        					  var campoFecha = win.down('[reference=fechaDevolucion]');
        					  win.model.set('estadoDevolucionCodigo', '02');
        					  win.model.set('fechaDevolucionEntregas', campoFecha.getValue());
        					  win.model.save();
        					  win.close();
        				  }
        			  },
        			  {
        				  text: 'Cancelar', 
        				  handler: function(){
        					  win.close();
        				  }
        			  }
        		]
    		}
    	});

    	win.show();
	},
	doCalculateTitleByComite: function () {
		var me = this;
		var url =  $AC.getRemoteUrl('expedientecomercial/doCalculateComiteByExpedienteId');
		var fechaResolucionCmp = me.lookupReference("fechaResolucionCES"),
		importeContraOfertaCmp = me.lookupReference("importeContraOfertaCES"),
		fechaRespuestaCmp = me.lookupReference("fechaResupuestaCES"),
		importeContraofertaOfertanteCmp = me.lookupReference("importeContraofertaOfertanteCES");
		Ext.Ajax.request({
		     url: url,
		     method: 'GET',
		     params: {idExpediente: me.getViewModel().data.expediente.id},
		     success: function(response) {
		    	data = Ext.decode(response.responseText);
		    	var codigoComite = data.data;
		    	if(CONST.COMITE_SANCIONADOR['CODIGO_HAYA_REMAINING'] === codigoComite || CONST.COMITE_SANCIONADOR['CODIGO_HAYA_APPLE'] === codigoComite){
		    		fechaResolucionCmp.setFieldLabel( HreRem.i18n('fieldlabel.fecha.resolucion.comite.haya'));
		    		importeContraOfertaCmp.setFieldLabel( HreRem.i18n('fieldlabel.importe.contraoferta.comite.haya'));
		    		fechaRespuestaCmp.setFieldLabel( HreRem.i18n('fieldlabel.fecha.respuesta.ofertante.comite.haya'));
		    		importeContraofertaOfertanteCmp.setFieldLabel( HreRem.i18n('fieldlabel.importe.contraoferta.ofertante.comite.haya'));
		    	}else{
		    		fechaResolucionCmp.setFieldLabel(HreRem.i18n('fieldlabel.fecha.resolucion.advisory'));
		    		importeContraOfertaCmp.setFieldLabel(HreRem.i18n('fieldlabel.importe.contraoferta.advisory'));
		    		fechaRespuestaCmp.setFieldLabel( HreRem.i18n('fieldlabel.fecha.respuesta.ofertante.advisory'));
		    		importeContraofertaOfertanteCmp.setFieldLabel( HreRem.i18n('fieldlabel.importe.contraoferta.ofrtante.advisory'));
		    	}
		    		
		    },
		    failure: function () {
		    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		 	}
		});
		
	},
	
	onComiteChange: function(field, newValue, oldValue) {		
		
		var me = this,
		fechaResolucionCmp = me.lookupReference("fechaResolucionCES"),
		importeContraOfertaCmp = me.lookupReference("importeContraOfertaCES"),
		fechaRespuestaCmp = me.lookupReference("fechaResupuestaCES"),
		importeContraofertaOfertanteCmp = me.lookupReference("importeContraofertaOfertanteCES");
		
		if(CONST.COMITE_SANCIONADOR['CODIGO_HAYA_REMAINING'] === newValue || CONST.COMITE_SANCIONADOR['CODIGO_HAYA_APPLE'] === newValue){
		    		fechaResolucionCmp.setFieldLabel( HreRem.i18n('fieldlabel.fecha.resolucion.comite.haya'));
		    		importeContraOfertaCmp.setFieldLabel( HreRem.i18n('fieldlabel.importe.contraoferta.comite.haya'));
		    		fechaRespuestaCmp.setFieldLabel( HreRem.i18n('fieldlabel.fecha.respuesta.ofertante.comite.haya'));
		    		importeContraofertaOfertanteCmp.setFieldLabel( HreRem.i18n('fieldlabel.importe.contraoferta.ofertante.comite.haya'));
		   	}else{
		    		fechaResolucionCmp.setFieldLabel(HreRem.i18n('fieldlabel.fecha.resolucion.advisory'));
		    		importeContraOfertaCmp.setFieldLabel(HreRem.i18n('fieldlabel.importe.contraoferta.advisory'));
		    		fechaRespuestaCmp.setFieldLabel( HreRem.i18n('fieldlabel.fecha.respuesta.ofertante.advisory'));
		    		importeContraofertaOfertanteCmp.setFieldLabel( HreRem.i18n('fieldlabel.importe.contraoferta.ofrtante.advisory'));
		    	}
		
	},
	
	editarAuditoriaDesbloqueo: function(viewChained){
		var expediente = this.getViewModel().get("expediente.id");
		var window = Ext.create("HreRem.view.expedientes.editarAuditoriaDesbloqueo",{expediente: expediente, viewChained: viewChained}).show();
	},
	
	comprobarProcesoAsincrono: function(tabPanel, view) {			
		var me= this;
		view.mask("Cargando...");
		var url = $AC.getRemoteUrl('tramitacionofertas/checkProceso');						
		var idExpediente = me.getViewModel().getData().expediente.id;	
		Ext.Ajax.request({
	    		url: url,
	    		params: {idExpediente: idExpediente},
	    		success: function(response, opts){
	    			var data = Ext.decode(response.responseText);
					Ext.suspendLayouts();
					if(tabPanel.getActiveTab().xtype == 'ofertaexpediente'){
						tabPanel = tabPanel.getActiveTab();
					}
	    			if((data.conFormalizacion != undefined || data.conFormalizacion != null) && data.conFormalizacion === "true"){
						view.procesado = true;
						tabPanel.down("[itemId=botoneditar]").enable();	
						tabPanel.getActiveTab().unmask();				
						
	    			}else{
						view.procesado = false;	
						tabPanel.down("[itemId=botoneditar]").disable();
						tabPanel.getActiveTab().mask("...Tramitando...");
					}
					Ext.resumeLayouts();
					view.unmask();
	    		}
	   	});	   	
	},
	
	onSelectedRow: function(grid, record, index){
		me = this;		
		if(!Ext.isEmpty(record) && !Ext.isEmpty(me.view.down('[reference=activateButton]'))) {
			var esCompradorActivo = !record.data.borrado; 
	    	me.view.down('[reference=activateButton]').setDisabled(esCompradorActivo);		
		}
	},
	
	onDeselectedRow: function(grid, record, index){
		me = this;				
		if (!Ext.isEmpty(me.view.down('[reference=activateButton]'))) {
    		me.view.down('[reference=activateButton]').setDisabled(true); 
		}		
	},
	
	activarComprador: function(grid, record) {
		me = this;		
		if(!Ext.isEmpty(record)){
			var url = $AC.getRemoteUrl('expedientecomercial/activarCompradorExpediente');
			grid.mask();
			Ext.Ajax.request({
	  		    url: url,
	  		    params: {
	  		    	idCompradorExpediente : record.data.id,
	  		     	idExpediente : record.data.idExpediente
	  		     	},	  		
	  		    success: function(response, opts) {	  		    	
	  		     	var data = Ext.decode(response.responseText);	  		     	
	  		     	if(data.success){
						me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						me.view.down('[reference=activateButton]').setDisabled(true);
						grid.getStore().load();
	  		     	}else{
	  		     		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	  		     	}	  		     	
		 			grid.unmask();		 			
		    	},
	 		    failure: function (a, operation) {
	 				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	 				grid.unmask();
	 		    }
	 		    
			});		
		}		
	},
	
	onClickGeneraFichaComercialHojaExcel: function(btn) {
				var me = this, config = {};
		
				config.params = {
						"id" : [ me.getViewModel().get("expediente.numExpediente") ],
						"reportCode" : 'FichaComercial'
				};
				config.url= $AC.getRemoteUrl("ofertas/generateReport");
				
				me.fireEvent("downloadFile", config);
			},
	
	onClickGenerarFichaComercial: function(btn) {
		
		var me = this;
		var correo = me.getViewModel().get("datosbasicosoferta.correoGestorBackoffice");
		
    	Ext.Msg.show({
		    title: HreRem.i18n("title.generar.ficha.activo"),
		    message: HreRem.i18n("msg.generar.ficha.comercial.envio") + " " + correo + " " + HreRem.i18n("msg.generar.ficha.comercial.lista"), 
		    buttons: Ext.Msg.OK,
		    icon: Ext.Msg.INFO,
		    fn: function(btn) {
		        if (btn === 'ok') {
					var url = $AC.getRemoteUrl("ofertas/enviarCorreoFichaComercialThread");
					var parametros = {
							id : [ me.getViewModel().get("expediente.numExpediente") ],
							reportCode : 'FichaComercial'
					};
					
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
					Ext.Ajax.request({
			    	     url: url,
			    	     method: 'POST',
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
			    	     },
			    	     failure: function (a, operation) {
			    	    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    	    	 me.getView().unmask();
			    	     }
			    	 });
		        }
		    }
		});  
	},
	
	sacarBulk: function(btn){
		var me = this,
		form = btn.up('formBase'),
		bulk = me.getViewModel().get('datosbasicosoferta.idAdvisoryNote');
		url = $AC.getRemoteUrl('expedientecomercial/sacarBulk');
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		Ext.Msg.show({
		   title: 'Excluir del Bulk',
		   msg: 'Está apunto de excluir la oferta del Bulk "'+bulk+'"</br>¿Está de acuerdo?',
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		   
		        if (buttonId == 'yes') {			        	

					Ext.Ajax.request({
			  		    url: url,
			  		    params: {
			  		     	idExpediente : me.getViewModel().data.expediente.id
			  		     	},	  		
			  		    success: function(response, opts) {	  		    	
			  		     	var data = Ext.decode(response.responseText);
			  		     	if(data.success){
								me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								form.funcionRecargar();
			  		     	}else{
			  		     		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			  		     	}	  		     	
				 			me.getView().unmask();		 			
				    	},
			 		    failure: function (a, operation) {
			 				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			 				me.getView().unmask();
			 		    }
				 		    
					});
				}else{
					 me.getView().unmask();
				}
			}
		});
		
	},
	
	onClickBotonCancelarAuditoria: function(btn){
		var me = this;
		test = btn.up('window');
		test.close();
		test.destroy();
	},
	
	onClickBotonGuardarAuditoria: function(btn){
		var me =this;
		var url = $AC.getRemoteUrl('expedientecomercial/insertarRegistroAuditoriaDesbloqueo');
		var view = btn.up('window');
		var user = $AU.getUser().userId;
		var comentario = view.items.items[0].items.items[0].value;
		var expediente = view.expediente;
		
		if ( comentario.length > 0 ) {
			me.getView().mask(HreRem.i18n("msg.mask.espere"));
			
			Ext.Ajax.request({
				url: url,
			    params:  {
			    	expedienteId : expediente,
			    	comentario: comentario,
			    	usuId: user
			    },
			    
			    success: function(response, opts) {
			    	
			    	var data = {};
			    	try {
			    		data = Ext.decode(response.responseText);
			    	}  catch (e){ 
			    		console.log( e );
			    	}
	               
			    	if(data.success === "true") {
			    		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			    		view.viewChained.habilitarGrid();
			    		me.onClickBotonCancelarAuditoria(btn);
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
			     }
			});	
		} else {
			 me.fireEvent("errorToast", "El comentario no puede estar vac&iacute;o");
		}
	},
	checkVisibilidadBotonAuditoriaDesbloqueo: function( viewModel ) {
		var me = this;
		var url = $AC.getRemoteUrl('expedientecomercial/getCierreEconomicoFinalizado');
		var expedienteId = viewModel.get('expediente.id')
		var btn = me.lookupReference("botonAuditoriaDesbloqueo");
		var usuariosValidos = $AU.userIsRol(CONST.PERFILES['HAYASUPER']) || $AU.userIsRol(CONST.PERFILES['PERFGCONTROLLER']);
		var listadoHonorarios = me.lookupReference("listadohoronarios");
		if ( usuariosValidos ){
			Ext.Ajax.request({
				url: url,
				method: 'GET',
			    params:  {
			    	expedienteId : expedienteId
			    },
			    success: function(response, opts) {
			    	try {
			    		data = Ext.decode(response.responseText);
				    	if(data.success === "true" && data.data === "true") {
				    		listadoHonorarios.setDisabledAddBtn(true);
				    		listadoHonorarios.setDisabledDeleteBtn(true);
				    		btn.setVisible(true)
				    	}
			    	}  catch (e){ 
			    		console.log( e );
			    	}
			     },
			     failure: function(response, opts) {
		    		 Utils.defaultRequestFailure(response, opts);
			     }
			});	
		}
	},

	contrasteListas: function(btn){
		var me= this;
		var url =  $AC.getRemoteUrl('expedientecomercial/contrasteListas');
		var numOferta = me.getViewModel().data.datosbasicosoferta.getData().numOferta;
		var idExpediente = me.getViewModel().get("expediente.id");
		me.getView().mask(HreRem.i18n("msg.mask.espere"));
		
		Ext.Ajax.request({
			     url: url,
			     params:  {numOferta : numOferta , idExpediente: idExpediente},
			     success: function(response, opts) {
			    	 data = Ext.decode(response.responseText);
			    	 if ( data.data )
			    		 data = data.data;
			    	 
			    	 statusMessage = {
			    			 "status" : null,
			    			 "message": null
			    	 };
			    	 
			    	 if ("true" == data.success) {
			    		 statusMessage.status = "infoToast";
			    		 statusMessage.message = HreRem.i18n("msg.operacion.ok");
			    	 } else {
			    		 statusMessage.status = "errorToast";
			    		 statusMessage.message = data.descError 
			    		 							&& data.descError.length > 0 ?
			    		 									data.descError : HreRem.i18n("msg.operacion.ko");
			    	 }
			    	 
			    	 me.fireEvent(statusMessage.status ,statusMessage.message);
			     },
	        failure: function(response, opts) {
					me.fireEvent("errorToast",data.msg);
			},

			callback : function() {
				me.getView().unmask();
				me.refrescarExpediente(true);
			}
		});
	},
		lanzarDatosPbc: function(btn){
    		//TODO
    		var me= this;
    		var url =  $AC.getRemoteUrl('expedientecomercial/lanzarDatosPbc');
    		var numOferta = me.getViewModel().data.datosbasicosoferta.getData().numOferta;
    		me.getView().mask(HreRem.i18n("msg.mask.espere"));

    		Ext.Ajax.request({
    			     url: url,
    			     params:  {numOferta : numOferta},
    			     success: function(response, opts) {
    			    	 data = Ext.decode(response.responseText);
    			    	 if ( data.data )
    			    		 data = data.data;

    			    	 statusMessage = {
    			    			 "status" : null,
    			    			 "message": null
    			    	 };

    			    	 if ("true" == data.success) {
    			    		 statusMessage.status = "infoToast";
    			    		 statusMessage.message = HreRem.i18n("msg.operacion.ok");
    			    	 } else {
    			    		 statusMessage.status = "errorToast";
    			    		 statusMessage.message = data.descripcion
    			    		 							&& data.descripcion.length > 0 ?
    			    		 									data.descripcion : HreRem.i18n("msg.operacion.ko");
    			    	 }

    			    	 me.fireEvent(statusMessage.status ,statusMessage.message);
    			     },
    	        failure: function(response, opts) {
    					me.fireEvent("errorToast",data.msg);
    			},
    			callback : function() {
    				me.getView().unmask();
    				me.refrescarExpediente(true);
    			}

    		});
    	},

	recalcularHonorarios : function(btn) {
		var form = btn.up('formBase');
		var me = this;
		var url = $AC.getRemoteUrl('expedientecomercial/recalcularHonorarios');
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
					form.funcionRecargar();           	
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
	
	permiteContinuarPorEstadoExpediente : function(btn){
		var me = this;
		
		var estadoActual = me.getViewModel().getData().expediente.getData().codigoEstado;
		var estadosAntesAprobado = [CONST.ESTADOS_EXPEDIENTE['EN_TRAMITACION'],CONST.ESTADOS_EXPEDIENTE['PTE_FIRMA'],CONST.ESTADOS_EXPEDIENTE['CONTRAOFERTADO'],
			CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES'],CONST.ESTADOS_EXPEDIENTE['RPTA_OFERTANTE'],CONST.ESTADOS_EXPEDIENTE['PEN_RES_OFER_COM'],CONST.ESTADOS_EXPEDIENTE['PTE_RESOLUCION_CES']];
		var estadosDespuesReservado = [CONST.ESTADOS_EXPEDIENTE['RESERVADO'],CONST.ESTADOS_EXPEDIENTE['PTE_PBC'],CONST.ESTADOS_EXPEDIENTE['PTE_CIERRE'], CONST.ESTADOS_EXPEDIENTE['PTE_POSICIONAMIENTO']];

		if("enviarTitularesUvem" === btn.handler){
			if(estadosAntesAprobado.includes(estadoActual) || estadosDespuesReservado.includes(estadoActual)) {
				return false;   			
			} else {
				return true;   			
			}
		}else if("validarCompradores" === btn.handler){
			if(estadosAntesAprobado.includes(estadoActual)) {
    			return false;   			
    		} else {
    			return true;   			
    		}
		}
	
	},
	//TODO estas dos funciones están para hacer pruebas ya que estas acciones se llamarán por ws. 
	pruebaBloqueo: function(btn) {
		var me = this;
		var url =  $AC.getRemoteUrl('expedientecomercial/bloqueoScreening');
		var numOferta = me.getView().getViewModel().getData().expediente.getData().idOferta;
		var motivo = "";
		var observaciones = "mundo";
		Ext.Ajax.request({
		     url: url,
		     method: 'POST',
			     params: {numOferta: numOferta, motivo: motivo, observaciones:observaciones},
			     success: function(response, opts) {
			     },
			    failure: function (a, operation) {
			    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			 	}
		});
	},
	pruebaDesBloqueo: function(btn) {
		var me = this;
		var url =  $AC.getRemoteUrl('expedientecomercial/desBloqueoScreening');
		var numOferta = me.getView().getViewModel().getData().expediente.getData().idOferta;
		var motivo = "";
		var observaciones = "mundo";
		Ext.Ajax.request({
		     url: url,
		     method: 'POST',
			     params: {numOferta: numOferta, motivo: motivo, observaciones:observaciones},
			     success: function(response, opts) {
			     },
			    failure: function (a, operation) {
			    	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			 	}
		});
	},
	
	evaluarBotonesEditarReserva: function(combo, value){
		var me = this;
		var tabReserva = me.getView().down('[reference=reservaExpediente]');
		if(me.getViewModel().get('esCarteraBankia')){
			tabReserva.evaluarBotonesEdicion(tabReserva.up('expedientedetallemain')); 
		}
		
	},
	
	onChangeMetodoActualizacion: function (combo, value){
		var me = this;
		
		var periodicidad = combo.up('[reference=fieldsetActualizacionRenta]').down('[reference=periodicidadBk]');
		var checkboxIPC = combo.up('[reference=fieldsetActualizacionRenta]').down('[reference=checkboxIPC]');
		var checkIGC = combo.up('[reference=fieldsetActualizacionRenta]').down('[reference=checkIGC]');
		var fechaActualizacionRenta = combo.up('[reference=fieldsetActualizacionRenta]').down('[reference=fechaActualizacionRenta]');
		var actualizacionRentaGridRef = combo.up('[reference=fieldsetActualizacionRenta]').down('[reference=actualizacionRentaGridRef]');
		
		periodicidad.setDisabled(true);
		checkboxIPC.setDisabled(true);
		checkIGC.setDisabled(true);
		fechaActualizacionRenta.setDisabled(true);
		actualizacionRentaGridRef.setDisabled(true);
		checkboxIPC.setReadOnly(false);
		
		 
		if(value == CONST.METODO_ATUALIZACION_RENTA['COD_LIBRE']){
			actualizacionRentaGridRef.setDisabled(false);
			periodicidad.setDisabled(false);
			fechaActualizacionRenta.setDisabled(false);
			checkboxIPC.setValue("");
			checkIGC.setValue("");
		}else if(value == CONST.METODO_ATUALIZACION_RENTA['COD_PORCENTUAL']){
			checkboxIPC.setDisabled(false);
			checkIGC.setDisabled(false);
			periodicidad.setValue("");
			fechaActualizacionRenta.setValue("");
			
		}else if(value == CONST.METODO_ATUALIZACION_RENTA['COD_MERCADO']){
			periodicidad.setDisabled(false);
			fechaActualizacionRenta.setDisabled(false);
			checkboxIPC.setValue("");
			checkIGC.setValue("");
		}else if(value == CONST.METODO_ATUALIZACION_RENTA['COD_IPCMERCADO']){
			periodicidad.setDisabled(false);
			fechaActualizacionRenta.setDisabled(false);
			checkboxIPC.setDisabled(false);
			checkboxIPC.setValue(true);
			checkboxIPC.setReadOnly(true);
			checkIGC.setValue("");
		}

	},
	
	hacerCamposObligatorios: function (form){
		var me = this;
		var view = me.getView();
		var isOk = true;
		if(form.xtype == "condicionesexpediente"){
			var valorMetodoActualizacion = view.down('[reference=comboMetodoActualizacionRentaRef]').value;
			if(valorMetodoActualizacion == CONST.METODO_ATUALIZACION_RENTA['COD_PORCENTUAL']){
				var checkboxIPC = view.down('[reference=checkboxIPC]').getValue();
				var checkIGC = view.down('[reference=checkIGC]').getValue();
				if(checkboxIPC =="" && checkIGC ==""){
					isOk = false;
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.ipc.o.igp.marcado"));
				}
			}
		} 
		
		return isOk;
	},
	evaluarLabelCaixa: function (form){
		var me = this;
		var labelAlquiler = me.lookupReference('tituloAlquilerRef');
		var labelVenta = me.lookupReference('tituloVentaRef');
		
		var viewModel = me.getViewModel();
		if(viewModel.get('esCarteraBankia')){
			labelAlquiler.setTitle(HreRem.i18n('title.generales'));
			labelVenta.setTitle(HreRem.i18n('title.generales'));
		}
	},
	
	changeOpcionCompra: function (combo, value, oldValue, eOpts, recarga){
		var me = this;
		var form = combo.up('form');
		var valorOpcionCompra = form.down('field[name=valorOpcionCompra]');
		var fechaOpcionCompra = form.down('field[name=fechaOpcionCompra]');
		
		if(value == "true"){
			valorOpcionCompra.setDisabled(false);
			fechaOpcionCompra.setDisabled(false);
		}else{
			valorOpcionCompra.setDisabled(true);
			fechaOpcionCompra.setDisabled(true);
		}
	},

	onClickCheckboxAval: function(checkbox, newValue, oldValue, eOpts){
		var me = this;
		var avalista= me.lookupReference('avalistaRef');
		var documento= me.lookupReference('documentoRef');
		var meses = me.lookupReference('mesesAvalRef');
		var importe = me.lookupReference('importeAvalRef');
		var entidadBancaria= me.lookupReference('entidadBancariaRef');
		var fechaVencimiento=me.lookupReference('fechaVencimientoRef');
		if(checkbox.checked){
			avalista.allowBlank=false;
			avalista.setDisabled(false);
			documento.allowBlank=false;
			documento.setDisabled(false);
			meses.setDisabled(false);
			importe.setDisabled(false);
			entidadBancaria.setDisabled(false);
			fechaVencimiento.setDisabled(false);
		}else{
			avalista.allowBlank=true;
			avalista.setValue(null);
			avalista.setDisabled(true);
			documento.allowBlank=true;
			documento.setValue(null);
			documento.setDisabled(true);
			meses.setDisabled(true);
			avalista.setValue(null);
			importe.setDisabled(true);
			importe.setValue(null);
			entidadBancaria.setDisabled(true);
			entidadBancaria.setValue(null);
			fechaVencimiento.setDisabled(true);
			fechaVencimiento.setValue(null);
			meses.setValue(null);
		}
	},
	
	onChangeMesesGarantiasAval: function(combo, value){
		var me = this;
		var meses = me.lookupReference('mesesAvalRef');
		var importe = me.lookupReference('importeAvalRef');
		if(Ext.isEmpty(meses.value)){
			importe.setDisabled(false);
		}else{
			importe.setDisabled(true);
		}
	},
	
	onChangeImporteGarantiasAval: function(combo, value){
		var me = this;
		var meses = me.lookupReference('mesesAvalRef');
		var importe = me.lookupReference('importeAvalRef');
		if(Ext.isEmpty(importe.value)){
			meses.setDisabled(false);
		}else{
			meses.setDisabled(true);
			meses.setValue(null);
		}
	},
	
	onChangeComboResultadoHaya: function(combo, value){
		var me = this;
		var motivoRechazo = me.lookupReference('motivoRechazoRef');
		if(combo.value == "02"){
			motivoRechazo.allowBlank=false;
			motivoRechazo.setDisabled(false);
		}else{
			motivoRechazo.allowBlank=true;
			motivoRechazo.setDisabled(true);
			motivoRechazo.setValue(null);
		}
	},
	
	onChangeMesesGarantiasRentas: function(combo, value){
		var me = this;
		var meses = me.lookupReference('mesesRentasRef');
		var importe = me.lookupReference('importeRentasRef');
		if(Ext.isEmpty(meses.value)){
			importe.setDisabled(false);
		}else{
			importe.setDisabled(true);
			importe.setValue(null);
		}
	},
	
	onChangeImporteGarantiasRentas: function(combo, value){
		var me = this;
		var meses = me.lookupReference('mesesRentasRef');
		var importe = me.lookupReference('importeRentasRef');
		if(Ext.isEmpty(importe.value)){
			meses.setDisabled(false);
		}else{
			meses.setDisabled(true);
			meses.setValue(null);
		}
	},
	
	onClickCheckBoxSeguroRentas: function(checkbox){
		var me = this;
		var aseguradora= me.lookupReference('aseguradoraRef');
		var fechaSancionRentas= me.lookupReference('fechaSancionRentasRef');
		var mesesRentas= me.lookupReference('mesesRentasRef');
		var importeRentas= me.lookupReference('importeRentasRef');
		
		if(checkbox.checked){
			aseguradora.allowBlank=false;
			aseguradora.setDisabled(false);
			fechaSancionRentas.allowBlank=false;
			fechaSancionRentas.setDisabled(false);
			mesesRentas.setDisabled(false);
			importeRentas.setDisabled(false);
		}else{
			aseguradora.allowBlank=true;
			aseguradora.setValue(null);
			aseguradora.setDisabled(true);
			fechaSancionRentas.allowBlank=true;
			fechaSancionRentas.setValue(null);
			fechaSancionRentas.setDisabled(true);
			mesesRentas.allowBlank=true;
			mesesRentas.setDisabled(true);
			mesesRentas.setValue(null);
			importeRentas.allowBlank=true;
			importeRentas.setDisabled(true);
			importeRentas.setValue(null);
		}
	},
	
	onClickCheckboxScoring: function(checkbox){
		var me = this;
		var resultadoHaya= me.lookupReference('resultadoHayaRef');
		var fechaSancion= me.lookupReference('fechaSancionRef');
		var	numeroExpediente =  me.lookupReference('numeroExpedienteRef');
		var resultadoPropiedad= me.lookupReference('resultadoPropiedadRef');
		var ratingHaya= me.lookupReference('ratingHayaRef');
		var motivoRechazo= me.lookupReference('motivoRechazoRef');
		if(checkbox.checked){
			resultadoHaya.allowBlank=false;
			resultadoHaya.setDisabled(false);
			fechaSancion.allowBlank=false;
			fechaSancion.setDisabled(false);
			numeroExpediente.allowBlank=false;
			numeroExpediente.setDisabled(false);
			resultadoPropiedad.allowBlank=false;
			resultadoPropiedad.setDisabled(false);
			ratingHaya.allowBlank=false;
			ratingHaya.setDisabled(false);
		}else{
			resultadoHaya.allowBlank=true;
			resultadoHaya.setValue("");
			resultadoHaya.setDisabled(true);
			fechaSancion.allowBlank=true;
			fechaSancion.setValue(null);
			fechaSancion.setDisabled(true);
			numeroExpediente.allowBlank=true;
			numeroExpediente.setValue(null);
			numeroExpediente.setDisabled(true);
			resultadoPropiedad.allowBlank=true;
			resultadoPropiedad.setValue(null);
			resultadoPropiedad.setDisabled(true);
			ratingHaya.allowBlank=true;
			ratingHaya.setValue(null);
			ratingHaya.setDisabled(true);
			motivoRechazo.allowBlank=true;
			motivoRechazo.setDisabled(true);
			motivoRechazo.setValue("");
		}
	},
	onCambioTipoImpuesto2 : function(combo, value, oldValue, eOpts) {
		try {
			if (!Ext.isEmpty(value)) {
				if(!Ext.isEmpty(value.data)){
					value = value.get('codigo');
				}
				var me = this, 
				
				tipoAplicableBk = me.lookupReference('tipoAplicableBk'),
				grupoImpuesto2 = me.lookupReference('grupoImpuestoRef2'),
				
				tipoAplicable = me.lookupReference('tipoAplicable'),
				inversionSujetoPasivo = me.lookupReference('chkboxInversionSujetoPasivo'), 
				renunciaExencion = me.lookupReference('chkboxRenunciaExencion'),
				grupoImpuesto = me.lookupReference('grupoImpuestoRef'),
				tributosPropiedad= me.lookupReference('chkboxTributosPropiedad'),
				
				esAlquiler = me.getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"],
				esAlquilerNoComercial = me.getViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER_NO_COMERCIAL"];
				if(esAlquiler || esAlquilerNoComercial){
					
					tipoAplicableBk.allowBlank=true;
					
			    	var esBankia = me.getViewModel().get("expediente.esBankia");
			    	
			    	tipoAplicable.reset();	    				
	    			inversionSujetoPasivo.reset();
	    			tributosPropiedad.reset();
	    			renunciaExencion.reset();
	    			
	    			tipoAplicable.setDisabled(true);
	    			renunciaExencion.setDisabled(true);
	    			tributosPropiedad.setDisabled(true);
	    			inversionSujetoPasivo.setDisabled(true);
	    			grupoImpuesto.setDisabled(true);
		    		
	    			grupoImpuesto.allowBlank = true;
	    			tipoAplicable.allowBlank = true;
	    			renunciaExencion.allowBlank = true;
	    			tributosPropiedad.allowBlank = true;
	    			inversionSujetoPasivo.allowBlank = true;
	    			
		    		if(CONST.TIPO_IMPUESTO['ITP'] == value){
		    			tipoAplicableBk.reset();
		    			tipoAplicableBk.setDisabled(true);
		    			if(esBankia){
		    				grupoImpuesto2.clearValue();
		    				grupoImpuesto2.setDisabled(true);
		    			}
		    			
		    		}else{
		    			tipoAplicableBk.setDisabled(false);
		    			
		    			if(esBankia){
		    				grupoImpuesto2.allowBlank = false;
		    				grupoImpuesto2.setDisabled(false);
		    			}
		    		}
				}
			}
		} catch (err) {
			Ext.global.console.log('Error en onCambioTipoImpuesto: '+ err)
		}
	},
	
	onClickCheckDeposito: function(checkbox){
		var me = this;
		var chekboxReservaConImpuesto= me.lookupReference('chekboxReservaConImpuesto');
		var mesesDeposito= me.lookupReference('mesesDepositoRef');
		var importeDeposito= me.lookupReference('importeDeposito');
		
		if(checkbox.checked){
			chekboxReservaConImpuesto.allowBlank=false;
			chekboxReservaConImpuesto.setDisabled(false);
			importeDeposito.setDisabled(false);
			mesesDeposito.setDisabled(false);
		}else{
			chekboxReservaConImpuesto.allowBlank=true;
			chekboxReservaConImpuesto.setValue(null);
			chekboxReservaConImpuesto.setDisabled(true);
			mesesDeposito.allowBlank=true;
			mesesDeposito.setDisabled(true);
			mesesDeposito.setValue(null);
			importeDeposito.allowBlank=true;
			importeDeposito.setDisabled(true);
			importeDeposito.setValue(null);
		}
	}
	
});