Ext.define('HreRem.view.activos.tramites.TramiteDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.tramitedetalle', 
    
    requires: ['HreRem.view.activos.tramites.LanzarTareaAdministrativa'],

    control: {	
         'tareaslist gridBase': {
             aftersaveTarea: function(grid) {
             	// grid.getStore().load();
            	var tabActivo = grid.up("tabpanel").getActiveTab();
            	var tabHistorico = grid.up("tramitesdetalle").lookupReference("historicoTareasTramite");
            	
            	if(tabActivo.funcionRecargar){
            		tabActivo.funcionRecargar();
            	}
            	if(tabHistorico.funcionRecargar){
            		tabHistorico.funcionRecargar();
            	}
             }
         }
         
     },

	cargarTabData: function (tab) {
		var me = this,
		model = tab.getModelInstance(),
		id = me.getViewModel().get("tramite.idTramite");
		model.setId(id);
		model.load({
		    success: function(record) {
		    	tab.setBindRecord(record);
		    }
		});
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
	 * Función que refresca la pestaña activa, y marca el resto de componentes para referescar. Para
	 * que un componente sea marcado para refrescar, es necesario que implemente la función
	 * funciónRecargar con el código necesario para refrescar los datos.
	 */
	onClickBotonRefrescar: function (btn) {
		
		var me = this,
		activeTab = me.getView().down("tabpanel").getActiveTab();		
		// Marcamos todas los componentes para refrescar, de manera que se vayan actualizando
		// conforme se vayan mostrando.
		Ext.Array.each(me.getView().query('component[funcionRecargar]'), function(component) {
  			if(component.rendered) {
  				component.recargar=true;
  			}
  		});
  		
  		// Actualizamos la pestaña actual si tiene función de recargar
		if(activeTab.funcionRecargar) {
  			activeTab.funcionRecargar();
		}
		
		me.getView().fireEvent("refrescarTramite", me.getView());
	},
	

	
	hacerEditable: function(form, xtype) {
				
		var me = this;
		var editor = new Ext.Editor({
		    // update the innerHTML of the bound element
		    // when editing completes
		    updateEl: true,
		    alignment: 'l-l',
		    autoSize: {
		        width: 'boundEl'
		    },
		    field: {
		        xtype: 'textfield'
		    }
		});
		
		form.getTargetEl().on('dblclick', function(e, t) {
		    editor.startEdit(t);
		    // Manually focus, since clicking on the label will focus the text field
		    editor.field.focus(50, true);
		});

	},
   
   	onSaveFormularioCompleto: function(form) {
		var me = this;
		// TODO VALIDACIONES
		form.getBindRecord().save();
		
	},
	
	onClickBotonEditar: function(btn) {
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		
	},
    
	onClickBotonGuardar: function(btn) {
		
		var me = this;
		
		btn.hide();
		btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();
		
		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
		
		me.onSaveFormularioCompleto(btn.up('tabpanel').getActiveTab());				
	},
	
	onClickBotonCancelar: function(btn) {
		btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();
		
		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
	},
	
	onTramitesListDobleClick : function(gridView,record) {
    	var me = this;
    	me.getView().fireEvent('abrirDetalleTramite', grid,record);
    },
	
    onTareasListSelect : function(gridView,record) {
		var me = this;
		me.getView().down('[name=btnAutoprorroga]').setDisabled(false);
	},
	
    onTareasListDeselect : function(gridView,record) {
		var me = this;
		me.getView().down('[name=btnAutoprorroga]').setDisabled(true);
	},
	
	onTareasListDobleClick : function(gridView,record) {
		var me = this,
		idTrabajo = me.getViewModel().get("tramite.idTrabajo");
		idActivo = me.getViewModel().get("tramite.idActivo");
		idExpediente = me.getViewModel().get("tramite.idExpediente");
		numEC = me.getViewModel().get("tramite.numEC");
		
		me.getView().fireEvent('abrirtarea',record, gridView.up('grid'), me.getView(), idTrabajo, idActivo, idExpediente, numEC);
	},
	
	onTareasListDobleClickHistorico : function(gridView,record) {
		var me = this;
		me.getView().fireEvent('abrirtareahistorico',record,gridView.up('grid'));
	},
	
	onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
		var record = grid.store.getAt(indiceFila);
		var idActivo;

		if(Ext.isEmpty(record)) {
			// Si el record está vacío indica que se ha seleccionado con doble click.
			idActivo = grid.getSelection()[0].getData().id;
		} else {
			// Si el record contiene datos indica que se ha seleccionado con el icono.
			idActivo = record.getData().id;
			grid.setSelection(record);
		}

		me.getView().fireEvent('abrirDetalleActivoPrincipal', idActivo);
	}, 

	solicitarAutoprorroga: function(button){
		var me = this;
		
		var idTareaExterna = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idTareaExterna");
		
		me.getView().fireEvent('solicitarautoprorroga', me.getView(), idTareaExterna);
	},
	
	generarAutoprorroga: function(button) {
		var me = this;
		
		var formulario = me.getView().down('[reference=formSolicitarProrroga]');
		
		if(formulario.getForm().isValid()) {
			
			button.up('window').mask("Guardando....");
			
    		var task = new Ext.util.DelayedTask(function(){    			
 
    			me.getView().mask(HreRem.i18n("msg.mask.loading"));
    			var parametros = formulario.getValues();
    			
    			
    			var url = $AC.getRemoteUrl('agenda/generarAutoprorroga');
    	    	var data;
    	    	Ext.Ajax.request({
    	    			url:url,
    	    			params: parametros,
    	    			success: function(response,opts){
    	    				data = Ext.decode(response.responseText);
    	    				if(data.success == 'true')
    	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
    	    				else
    	    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga")); 
    	    			},
    	    			failure: function(options, success, response){
    	    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga")); 
    	    			},
    	    			callback: function(options, success, response){
    	    				me.getView().unmask();
    	    				button.up('window').unmask();
    	    				button.up('window').destroy();
    	    			}
    	    	});
			});
			
			task.delay(500);
		}
		me.onClickBotonRefrescar(button);
	},
	
	saltoCierreEconomico: function(button){
		var me = this;
		
		var idTareaExterna = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idTareaExterna");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		var url = $AC.getRemoteUrl('agenda/saltoCierreEconomico');
		
		var data;
		Ext.Ajax.request({
			url:url,
			params: {idTareaExterna : idTareaExterna},
			success: function(response, opts){
				data = Ext.decode(response.responseText);
				if(data.success == 'true') {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				} else {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
				}
				me.onClickBotonRefrescar(button);
			},
			failure: function(options, success, response){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
			},
			callback: function(options, success, response){
				me.getView().unmask();
			}
		})
		// me.getView().fireEvent('saltocierreeconomico', me.getView(), idTareaExterna);
	},
	
	anularTramite : function(button) {
		
		var me = this;
		var idTramite = me.getViewModel().get("tramite.idTramite");
		var url = $AC.getRemoteUrl('agenda/anularTramite');
		
		var data;
		Ext.Ajax.request({
			url:url,
			params: {idTramite : idTramite},
			success: function(response, opts){
				data = Ext.decode(response.responseText);
				if(data.success == 'true') {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				} else {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anulartramite"));
				}
				me.onClickBotonRefrescar(button);
			},
			failure: function(options, success, response){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anulartramite"));
			},
			callback: function(options, success, response){
				me.getView().unmask();
			}
		})
	},
	
	lanzarTareaAdministrativa : function(button) {
		
		var me = this;
  		var salto_tarea_window = Ext.create('HreRem.view.activos.tramites.LanzarTareaAdministrativa',{idTramite: me.getViewModel().get("tramite.idTramite"), idExpediente: me.getViewModel().get("tramite.idExpediente")});
  		me.getView().add(salto_tarea_window);
  		salto_tarea_window.show();
	},
	
	reactivarTramite : function(button) {
		
		var me = this;
		console.log("TODO");
		
	},
	
	saltoResolucionExpediente: function(button){
		var me = this;
		var idExpediente = me.getViewModel().get("tramite.idExpediente");
		if(CONST.CARTERA['BANKIA'] == me.getViewModel().get('tramite.codigoCartera')){
			me.saltoResolucionExpedienteBankia(button,idExpediente);
		}else{
			Ext.Msg.show({
			    title:'Avanzar a Resolución Expediente',
			    message: 'Si confirma esta acción, el trámite avanzará a la tarea donde se anulará el expediente. ¿Desea continuar?',
			    buttons: Ext.Msg.YESNO,
			    fn: function(btn) {
			        if (btn == 'yes') {
			        	
			    		idExpediente = me.getViewModel().get("tramite.idExpediente");
			    		me.getView().mask(HreRem.i18n("msg.mask.loading"));
			    		var url = $AC.getRemoteUrl('agenda/saltoResolucionExpedienteByIdExp');
			    		
			    		var data;
			    		Ext.Ajax.request({
			    			url:url,
			    			params: {idExpediente : idExpediente},
			    			success: function(response, opts){
			    				data = Ext.decode(response.responseText);
			    				if(data.success == 'true') {
			    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			    				} else {
			    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.saltoresolucion"));
			    				}
			    				me.onClickBotonRefrescar(button);
			    			},
			    			failure: function(options, success, response){
			    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.saltoresolucion"));
			    			},
			    			callback: function(options, success, response){
			    				me.getView().unmask();
			    			}
			    		})
			        } else if (btn === 'no') {}
			    }
			});
			// me.getView().fireEvent('saltocierreeconomico', me.getView(), idTareaExterna);
		}
		
	},
	
	saltoResolucionExpedienteAlquiler: function(button){
		

			var me = this;
			var codigoCartera = me.getViewModel().get('tramite.codigoCartera');
			var store = CONST.CARTERA['BANKIA'] == codigoCartera ? '{comboMotivoAnulacionCaixa}' : '{comboMotivoAnulacionAlquiler}';
			me.getView().up('tabpanel').setDisabled(true);
			var win = new Ext.window.Window({
				 border: true,
				 closable: false,
				 viewModel: {
				    type: 'tramitedetalle'
				 },
				 width: 400,
			     title: 'Seleccione motivo anulación',
			     layout: 'hbox',
			     items: [
			    	 {
			             xtype: 'label',
			             text: 'Motivo:',
			             labelStyle: 'font-weight:bold;',
			             style: 'margin: 15px 25px 20px 25px'
			         },
			    	 {	
			             xtype: 'combobox',
			             reference: 'comboalquiler',
			             width: '90%',
			             forceSelection: true,
			             allowblank: false,
			             displayField: 'descripcion',
			             valueField: 'codigo',
			             bind: {
			            	 store: store
			             },
			             style: 'margin: 15px 0px 0px 0px'
			         }
			     ],
			     buttons: [{
			        xtype: 'button',
			        name: 'guardarBoton',
			        text: 'Guardar',
			        handler: function() {
			        	var idTramite = me.getViewModel().get("tramite.idTramite");
					    var url = $AC.getRemoteUrl('agenda/anularTramiteAlquiler');
				 	    var motivo = this.lookupController(true).lookupReference('comboalquiler').getValue();
					 	if(motivo != null) {
					 		Ext.Msg.show({
							title:'Anular expediente.',
							message: 'Si confirma esta acción, se anulará el expediente. ¿Desea continuar?',
							buttons: Ext.Msg.YESNO,
							fn: function(btn) {
								if (btn == 'yes') {
									me.getView().mask(HreRem.i18n("msg.mask.loading"));
									win.close();
									var data;
									Ext.Ajax.request({
										url:url,
									    params: {idTramite : idTramite, motivo: motivo},
									    success: function(response, opts){
									    data = Ext.decode(response.responseText);
									    if(data.success == 'true') {
									    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
									    	me.getView().up('tabpanel').setDisabled(false);	
									    } else {
									    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anulacion"));
									   }
									   me.onClickBotonRefrescar(button);
									    },
									    failure: function(options, success, response){
									    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anulacion"));
									    },
									    callback: function(options, success, response){
									    	me.getView().unmask();
									    	me.getView().up('tabpanel').setDisabled(false);
									    }
									})
								} else if (btn === 'no') {}
							}
				    	});
				    	} else {
				    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.saltoresolucionvacia"));
				    	}
				  }			
			    },{
			        xtype: 'button',
			        name: 'cancelarBoton',
			        text: 'Cancelar',
			        handler: function() {
			            win.close();
			            me.getView().up('tabpanel').setDisabled(false);
			        }
			    }]
			})
			win.show();
		},
		
		
	
	// generaSaltoCierreEconomico: function(button) {
	// var me = this;
	//		
	// var formulario = me.getView().down('[reference=formSolicitarProrroga]');
	//		
	// if(formulario.getForm().isValid()) {
	//			
	// button.up('window').mask("Guardando....");
	//			
	// var task = new Ext.util.DelayedTask(function(){
	// 
	// me.getView().mask(HreRem.i18n("msg.mask.loading"));
	// var parametros = formulario.getValues();
	//    			
	//    			
	// var url = $AC.getRemoteUrl('agenda/generarAutoprorroga');
	// var data;
	// Ext.Ajax.request({
	// url:url,
	// params: parametros,
	// success: function(response,opts){
	// data = Ext.decode(response.responseText);
	// if(data.success == 'true')
	// me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	// else
	// me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
	// },
	// failure: function(options, success, response){
	// me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.autoprorroga"));
	// },
	// callback: function(options, success, response){
	// me.getView().unmask();
	// button.up('window').unmask();
	// button.up('window').destroy();
	// }
	// });
	// });
				
	// task.delay(500);
	// }
	//			
	//    	
	// },
		
		
	cancelarProrroga: function(button) {
    	
		button.up('window').destroy();
        	
     },
     
     reasignarTarea: function(button){
     	var me= this;
     	var idTareaExterna = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idTareaExterna");
     	var idGestor = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idGestor");
     	var idSupervisor = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("idSupervisor");
     	var nombreUsuarioGestor = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("nombreUsuarioGestor");
     	var nombreUsuarioSupervisor = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("nombreUsuarioSupervisor");
     	     	
  		me.getView().fireEvent('reasignartarea', me.getView(), idTareaExterna,idGestor,idSupervisor,nombreUsuarioGestor,nombreUsuarioSupervisor);
     	 
      },
      
     cancelarReasignacionTarea: function(button) {
     	button.up('window').destroy();
          	
     },
     
     anularDevolucion: function(button){
     	var me = this;
 		
 		Ext.Msg.show({
 		    title:'Solicitar anulación de la devolución de la reserva',
 		    message: 'Si confirma esta acción, la devolución se anulará y el trámite volverá a la tarea anterior a Resolución Expediente. ¿Desea continuar?',
 		    buttons: Ext.Msg.YESNO,
 		    fn: function(btn) {
 		        if (btn == 'yes') {
 		        	
 		    		var idExpediente = me.getViewModel().get("tramite.idExpediente");
 		    		me.getView().mask(HreRem.i18n("msg.mask.loading"));
 		    		var url = $AC.getRemoteUrl('agenda/anulacionDevolucionReservaByIdExp');
 		    		
 		    		var data;
 		    		Ext.Ajax.request({
 		    			url:url,
 		    			params: {idExpediente : idExpediente},
 		    			success: function(response, opts){
 		    				data = Ext.decode(response.responseText);
 		    				if(data.success == 'true') {
 		    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
 		    				} else {
 		    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anular.devolucion.reserva"));
 		    				}
 		    				me.onClickBotonRefrescar(button);
 		    			},
 		    			failure: function(options, success, response){
 		    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anular.devolucion.reserva"));
 		    			},
 		    			callback: function(options, success, response){
 		    				me.getView().unmask();
 		    			}
 		    		})
 		        } else if (btn === 'no') {
 		        }
 		    }
 		});
      },
     
     solicitarAnulacionDevolucion: function(button){
    	var me = this;
		
		Ext.Msg.show({
		    title:'Solicitar anulación de la solicitud de devolución de la reserva',
		    message: 'Si confirma esta acción, el trámite avanzará a la tarea donde se pedirá la anulación de la solicitud de devolución de la reserva. ¿Desea continuar?',
		    buttons: Ext.Msg.YESNO,
		    fn: function(btn) {
		        if (btn == 'yes') {
		        	
		    		var idExpediente = me.getViewModel().get("tramite.idExpediente");
		    		me.getView().mask(HreRem.i18n("msg.mask.loading"));
		    		var url = $AC.getRemoteUrl('agenda/solicitarAnulacionDevolucionReservaByIdExp');
		    		
		    		var data;
		    		Ext.Ajax.request({
		    			url:url,
		    			params: {idExpediente : idExpediente},
		    			success: function(response, opts){
		    				data = Ext.decode(response.responseText);
		    				if(data.success == 'true') {
		    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
		    				} else {
		    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.solicitar.anulacion.devolucion.reserva"));
		    				}
		    				me.onClickBotonRefrescar(button);
		    			},
		    			failure: function(options, success, response){
		    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.solicitar.anulacion.devolucion.reserva"));
		    			},
		    			callback: function(options, success, response){
		    				me.getView().unmask();
		    			}
		    		})
		        } else if (btn === 'no') {
		        }
		    }
		});
     },
     
     anularSolicitudAnulacionDevolucion: function(button){
     	var me = this;
 		
 		Ext.Msg.show({
 		    title:'Anular la solicitud de la anulación de la devolución de la reserva',
 		    message: 'Si confirma esta acción, se anulará la petición de anulación de la devolución de la reserva y el tramite volverá a la tarea Pendiente de la devolución. ¿Desea continuar?',
 		    buttons: Ext.Msg.YESNO,
 		    fn: function(btn) {
 		        if (btn == 'yes') {
 		        	
 		    		var idExpediente = me.getViewModel().get("tramite.idExpediente");
 		    		me.getView().mask(HreRem.i18n("msg.mask.loading"));
 		    		var url = $AC.getRemoteUrl('agenda/anularSolicitudAnulacionDevolucionReservaByIdExp');
 		    		
 		    		var data;
 		    		Ext.Ajax.request({
 		    			url:url,
 		    			params: {idExpediente : idExpediente},
 		    			success: function(response, opts){
 		    				data = Ext.decode(response.responseText);
 		    				if(data.success == 'true') {
 		    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
 		    				} else {
 		    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anular.peticion.anulacion.devolucion.reserva"));
 		    				}
 		    				me.onClickBotonRefrescar(button);
 		    			},
 		    			failure: function(options, success, response){
 		    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.anular.peticion.anulacion.devolucion.reserva"));
 		    			},
 		    			callback: function(options, success, response){
 		    				me.getView().unmask();
 		    			}
 		    		})
 		        } else if (btn === 'no') {
 		        }
 		    }
 		});
      },
     
     onChangeChainedCombo: function(combo) {
    	    	
    	 var me = this,
    	 chainedCombo = me.lookupReference(combo.chainedReference);
    	 chainedCombo.clearValue("");
    	 me.getViewModel().notify();
    	 me.getViewModel().getStore(combo.chainedStore).load(); 	   	
     },
     
     onChangeChainedComboGestores: function(combo) {
 		var me = this,
 		chainedCombo = me.lookupReference(combo.chainedReference);
 		
 		if(combo.getName()=='tipoGestor' && !Ext.isEmpty(combo.getSelection())) {
 			me.getView().down("[reference=usuarioGestor]").setHidden(false);
 	 		me.getView().down("[reference=usuarioGestorText]").setHidden(true);
 	 		me.getView().down("[reference=usuarioGestorText]").allowBlank = false;
 		}
 		if(combo.getName()=='tipoGestorSupervisor' && !Ext.isEmpty(combo.getSelection())){
 			me.getView().down("[reference=usuarioSupervisor]").setHidden(false);
 			me.getView().down("[reference=usuarioSupervisorText]").setHidden(true);	
 			me.getView().down("[reference=usuarioSupervisorText]").allowBlank = false;
 		}
 		
		
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
 						chainedCombo.allowBlank = false;
 					} else {
 						chainedCombo.setDisabled(true);
 						chainedCombo.allowBlank = true;
 					}
 			}
 		});

 		if (me.lookupReference(chainedCombo.chainedReference) != null) {
 			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
 			if(!chainedDos.isDisabled()) {
 				chainedDos.clearValue();
 				chainedDos.getStore().removeAll();
 				chainedDos.setDisabled(true);
 				chainedDos.allowBlank = true;
 			}
 		}
 	},
 	
 	generarReasignacionTarea: function(button){
 		var me = this;
		var formulario = me.getView().down('[reference=formReasignarTarea]');
		if(formulario.getForm().isValid()) {
			button.up('window').mask("Guardando....");
			var idTareaExterna = me.getView().down('[reference=listadoTareasTramite]').getSelectionModel().getSelection()[0].get("id");
				me.getView().mask(HreRem.i18n("msg.mask.loading"));
			var parametros = formulario.getValues();
			parametros.idTarea= idTareaExterna;
			
			var url = $AC.getRemoteUrl('agenda/reasignarTarea');
	    	var data;
	    	Ext.Ajax.request({
	    			url:url,
	    			params: parametros,
	    			success: function(response,opts){
	    				data = Ext.decode(response.responseText);
	    				if(data.success == 'true')
	    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    				else
	    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.reasignacion")); 
	    			},
	    			failure: function(options, success, response){
	    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.reasignacion")); 
	    			},
	    			callback: function(options, success, response){
	    				me.getView().unmask();
	    				button.up('window').unmask();
	    				button.up('window').destroy();
	    				me.getView().down('[reference=tareaslistref]').funcionRecargar()
	    			}
	    	});
			
			
			

		}
		
 		
 	},
	
	saltoResolucionExpedienteBankia: function(button, idExpediente){
		var me = this;
		var idExpediente = me.getViewModel().get("tramite.idExpediente");
		
		Ext.Ajax.request({
			url:$AC.getRemoteUrl('expedientecomercial/getCamposAnulacionInformados'),
			params: {idExpediente : idExpediente},
			success: function(response, opts){
				data = Ext.decode(response.responseText);
				if(data.success == 'true') {

					Ext.Msg.show({
					    title:'Avanzar a Resolución Expediente',
					    message: 'Si confirma esta acción, el trámite avanzará a la tarea donde se anulará el expediente. ¿Desea continuar?',
					    buttons: Ext.Msg.YESNO,
					    fn: function(btn) {
					        if (btn == 'yes') {
					        	
					    		idExpediente = me.getViewModel().get("tramite.idExpediente");
					    		me.getView().mask(HreRem.i18n("msg.mask.loading"));
					    		var url = $AC.getRemoteUrl('agenda/saltoResolucionExpedienteByIdExp');
					    		
					    		var data;
					    		Ext.Ajax.request({
					    			url:url,
					    			params: {idExpediente : idExpediente},
					    			success: function(response, opts){
					    				data = Ext.decode(response.responseText);
					    				if(data.success == 'true') {
					    					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					    				} else {
					    					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.saltoresolucion"));
					    				}
					    				me.onClickBotonRefrescar(button);
					    			},
					    			failure: function(options, success, response){
					    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.saltoresolucion"));
					    			},
					    			callback: function(options, success, response){
					    				me.getView().unmask();
					    			}
					    		})
					        } else if (btn === 'no') {}
					    }
					});
					
				} else {
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.campos.anulacion"));
				}
				me.onClickBotonRefrescar(button);
			},
			failure: function(options, success, response){
				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.saltoresolucion"));
			}
		});
		
		
		// me.getView().fireEvent('saltocierreeconomico', me.getView(), idTareaExterna);
	}

});