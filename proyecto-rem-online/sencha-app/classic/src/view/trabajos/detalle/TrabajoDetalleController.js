Ext.define('HreRem.view.trabajos.detalle.TrabajoDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.trabajodetalle',    
    
    control: {
    	
         'documentostrabajo gridBase': {
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
         
         'fotostrabajosolicitante': {
         	updateOrdenFotos: 'updateOrdenFotos'
         },
         
          'fotostrabajoproveedor': {
         	updateOrdenFotos: 'updateOrdenFotos'
         },
         
         'tramitestareastrabajo gridBase': {
             aftersaveTarea: function(grid) {
             	grid.getStore().load();
             }
         }
     },
    
	cargarTabData: function (form) {

		var me = this,
		model = form.getModelInstance(),
		id = me.getViewModel().get("trabajo.id");
		
		form.up("tabpanel").mask(HreRem.i18n('msg.mask.loading'));	
		model.setId(id);
		model.load({
		    success: function(record) {
		    	
		    	form.setBindRecord(record);		    	
		    	form.up("tabpanel").unmask();
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
    
    refreshStoreSeleccionTarifas: function(combo) {
    	
    	var gridSeleccionTarifas = combo.up("window").down("grid");
	    gridSeleccionTarifas.getStore().load();
	    
    },
	
	onChangeSubtipoTrabajoCombo: function(combo) {

		    	
    	var me = this;
    	var idActivo = combo.up("window").idActivo;
    	var codigoSubtipoTrabajo = combo.getValue();
    	var advertencia;
    	
    	if (Ext.isDefined(idActivo) && idActivo != null){
		    var url = $AC.getRemoteUrl('trabajo/getAdvertenciaCrearTrabajo');
		    Ext.Ajax.request({
			  url:url,
			  params:  {idActivo : combo.up("window").idActivo, 
			  			codigoSubtipoTrabajo : combo.getValue()},
			  success: function(response,opts){
			  
				  //TODO: Aqui debe mostrarse el mensaje de alerta para existencia de otros subtipos de trabajo
				  advertencia = Ext.JSON.decode(response.responseText).advertencia;
				  me.lookupReference("textAdvertenciaCrearTrabajo").setText(advertencia);
			  }
		    });
		}
    	
    	if(combo.getValue() == "44" || combo.getValue() == "45") {
    		me.lookupReference("checkEnglobaTodosActivosAgrRef").setValue(true);
    		me.lookupReference("checkEnglobaTodosActivosRef").setValue(true);
    		me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(true);
    		me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(true);
    	}
    	else {
    		me.lookupReference("checkEnglobaTodosActivosAgrRef").setValue(false);
    		me.lookupReference("checkEnglobaTodosActivosRef").setValue(false);
    		me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(false);
    		me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(false);
    	}
	    
    },
    	
	onClickBotonFavoritos: function(btn) {
		
		var me = this,
		textoFavorito = "Trabajo " + me.getViewModel().get("trabajo.numTrabajo");
		
		btn.updateFavorito(textoFavorito);
			
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
			 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
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
		/*btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').show();
		btn.up('tabbar').down('button[itemId=botoncancelar]').show();*/

		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
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
			/*btn.hide();
			btn.up('tabbar').down('button[itemId=botoncancelar]').hide();
			btn.up('tabbar').down('button[itemId=botoneditar]').show();*/
			
			Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
							function (field, index) 
								{ 
									field.fireEvent('save');
									field.fireEvent('update');});
									
			me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	me.getView().fireEvent("refreshComponentOnActivate", "trabajosmain");
	    	me.getView().fireEvent("refreshComponentOnActivate", "agendamain");
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
		/*btn.hide();
		btn.up('tabbar').down('button[itemId=botonguardar]').hide();
		btn.up('tabbar').down('button[itemId=botoneditar]').show();*/
		
		Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('cancel');
							});
	},
	
	onClickBotonCrearTrabajo: function(btn) {
		
		var me =this,
		window = btn.up("window"),
		form = window.down("form"),
		idAgrupacion = window.idAgrupacion,
		idActivo = window.idActivo,
		idProceso = window.idProceso;
		
		form.getBindRecord().set("idActivo", idActivo);
		form.getBindRecord().set("idAgrupacion", idAgrupacion);
		form.getBindRecord().set("idProceso", idProceso);
		var success = function(record, operation) {
			me.getView().unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	me.getView().fireEvent("refreshComponentOnActivate", "trabajosmain");
	    	me.getView().fireEvent("refreshComponentOnActivate", "agendamain");
	    	me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], idActivo);	
	    	window.hide();
		};

		me.onSaveFormularioCompleto(form, success);

	},
	
	onClickBotonCancelarTrabajo: function(btn) {		
		btn.up('window').hide();		
	},
	
	onClickBotonCancelarPresupuesto: function(btn) {		
		var me = this,
		window = btn.up('window');
		
		window.parent.down("[reference=gridpresupuestostrabajo]").getStore().load();
    	window.close();
	},
	
	abrirFormularioAdjuntarDocumentos: function(grid) {
		
		var me = this,
		idTrabajo = me.getViewModel().get("trabajo.id");
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumento", {entidad: 'trabajo', idEntidad: idTrabajo, parent: grid}).show();
		
	},
	
	borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idTrabajo = me.getViewModel().get("trabajo.id");

		record.erase({
			params: {idTrabajo: idTrabajo},
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
		
		config.url=$AC.getWebPath()+"trabajo/bajarAdjuntoTrabajo."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.idTrabajo=record.get("idTrabajo");
		
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
    
    /**
     * Funcióhn que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la función 
     * funciónRecargar con el código necesario para refrescar los datos.
     */
    onClickBotonRefrescar: function () {
		var me = this,
		activeTab = me.getView().down("tabpanel").getActiveTab();
  		
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
		
		me.getView().fireEvent("refrescarTrabajo", me.getView());

	},
	
	cargarTabFotos: function (form) {
		var me = this,
		idTrabajo = me.getViewModel().get("trabajo.id");
		
		me.getViewModel().data.storeFotosTrabajoProveedor.getProxy().setExtraParams({'id':idTrabajo, solicitanteProveedor: true}); 
		me.getViewModel().data.storeFotosTrabajoSolicitante.getProxy().setExtraParams({'id':idTrabajo, solicitanteProveedor: false}); 
		
		me.getViewModel().data.storeFotosTrabajoProveedor.load();
		me.getViewModel().data.storeFotosTrabajoSolicitante.load();

	},
	
	onAddFotoClick: function(grid) {
		var me = this,
		idTrabajo = me.getViewModel().get("trabajo.id");
    	
    	//Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumento", {entidad: 'activo', idEntidad: idActivo, parent: grid}).show();
		Ext.create("HreRem.view.common.adjuntos.AdjuntarFotoTrabajo", {idEntidad: idTrabajo, parent: grid, parentDos: true}).show();
		
	},
	
	updateOrdenFotos: function(data, record, store) {

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
				//FIXME: ¿Poner máscara?
				//me.getView().mask(HreRem.i18n("msg.mask.loading"));
				var url =  $AC.getRemoteUrl('trabajo/updateFotosById');
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
			    		
			        	var url =  $AC.getRemoteUrl('trabajo/deleteFotosTrabajoById');
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
			
			config.url=$AC.getWebPath()+"trabajo/getFotoTrabajoById."+$AC.getUrlPattern();
			config.params = {};

			config.params.idFoto=storeTemp.getAt(nodos[0].getAttribute('data-recordindex')).getId();
			
			me.fireEvent("downloadFile", config);
		}
	},

	addParamAgrupacion: function(store, operation, opts){
	
		var me = this;
		
		var idAgrupacion = Ext.ComponentQuery.query("creartrabajowindow")[0].idAgrupacion;
		store.getProxy().extraParams = {id: idAgrupacion};	
		return true;		
	},
	
	addParamProveedores: function(store, operation, opts) {
		var me = this;
		
		
	},
	
	onChangeProveedor: function(combo, value) {
		var me = this;		    
		me.getViewModel().set('proveedor', combo.getSelection());		
	},

	onListadoTramitesTareasTrabajoDobleClick : function(gridView,record) {
		var me = this;
		
		if(Ext.isEmpty(record.get("fechaFin"))) { // Si la tarea está activa
			me.getView().fireEvent('abrirDetalleTramiteTarea',gridView,record);
		} else {
			me.getView().fireEvent('abrirDetalleTramiteHistoricoTarea',gridView,record);
		}
	},

	addParamsTrabajo: function(store, operation, opts){
		
		var me = this;
		//Acceder as� a los tres atributos que le hemos pasado a la openModalWindow
		//de selecci�n de tarifa: tipo de trabajo, subtipo de trabajo y cartera
		var carteraCodigo = me.getViewModel().get("trabajo.carteraCodigo"),
		tipoTrabajoCodigo = me.getViewModel().get("trabajo.tipoTrabajoCodigo"),
		subtipoTrabajoCodigo = me.getViewModel().get("trabajo.subtipoTrabajoCodigo");
		store.getProxy().extraParams = {cartera: carteraCodigo, tipoTrabajo: tipoTrabajoCodigo, subtipoTrabajo: subtipoTrabajoCodigo};	
		return true;		

	},
	
	addParamIdTrabajo: function(store, operation, opts){
		var me = this;
		var idTrabajo = me.getViewModel().get("trabajo.id");
		store.getProxy().extraParams = {idTrabajo: idTrabajo};
		return true;
		
	},
	
    onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
    	
    	var me = this;
    	var grid = tableView.up('grid');

    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);
    	
    	//grid.fireEvent("abriractivo", record);
    	me.getView().fireEvent('abrirDetalleActivo', record.get('idActivo'));

    	
    },
    
    onSeleccionTarifasListDobleClick: function(grid, record) {
    	var me = this,
    	windowSeleccionTarifas = grid.up('window'),
    	idTrabajo = windowSeleccionTarifas.idTrabajo,
    	newRecord = Ext.create('HreRem.model.TarifasTrabajo', {idConfigTarifa: record.getData().id, codigoTarifa: record.getData().codigoTarifa, precioUnitario: record.getData().precioUnitario, unidadMedida: record.getData().unidadmedida, idTrabajo: idTrabajo});
		//Ahora hacer el save en el store para que se llame al controller java
    	newRecord.save({
    		callback: function() {
    			windowSeleccionTarifas.parent.funcionRecargar();
    			windowSeleccionTarifas.hide();
    		}
    		
    	});

    	
    	
    },
    
    onPresupuestosListDobleClick: function(grid, record) {
    	var me = this,
    	parent = grid.up("gestioneconomicatrabajo"),    	
    	idTrabajo = parent.getBindRecord().get('idTrabajo'),
    	tipoTrabajoDescripcion = parent.getBindRecord().get('tipoTrabajoDescripcion'),
    	subtipoTrabajoDescripcion = parent.getBindRecord().get('subtipoTrabajoDescripcion');

    	Ext.create("HreRem.view.trabajos.detalle.ModificarPresupuesto", {idTrabajo: idTrabajo, tipoTrabajoDescripcion: tipoTrabajoDescripcion, subtipoTrabajoDescripcion: subtipoTrabajoDescripcion, parent: parent, modoEdicion: true, presupuesto: record}).show();
    },
    
    onPresupuestosListClick: function(grid, record) {
    	var form = grid.up('form');
    	if (grid.getSelectionModel().getCount() != 0)
    	{
    		//Cuando la selecci�n no es 0: Rellenar el form de presupuesto con los campos correspondientes
	    	model = Ext.create('HreRem.model.PresupuestoTrabajo'),
	    	idPresupuesto = record.get("id"),
	    	
	    	fieldset = grid.up('form').down('[reference=detallepresupuesto]');
			fieldset.mask(HreRem.i18n("msg.mask.loading"));
	    	
			model.setId(idPresupuesto);
			model.load({			
			    success: function(record) {	
			    	form.setBindRecord(record);
			    	fieldset.unmask();
			    }
			});
    	}
    	else
    	{
    		//Cuando la selecci�n es 0: Resetear el form (no hay nada seleccionado) 
    		form.getForm().reset();
    	}
    	
    },
    
    onClickBotonGuardarPresupuesto: function(btn) {
		var me =this,
		window = btn.up("window"),
		form = window.down("form"),
		idTrabajo = window.idTrabajo;
		form.getBindRecord().set("idTrabajo", idTrabajo);
		
		var grid = window.parent.down("[reference=gridpresupuestostrabajo]");
		
		var success = function(record, operation) {
			me.getView().unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	window.parent.funcionRecargar();
	    	window.hide();	    	
    		
		};

		me.onSaveFormularioCompleto(form, success);	

    	
    },
    
    onClickBotonActualizarPresupuesto: function(btn) {
		var me = this,
		window = btn.up("window"),
		form = window.down("form");
		
		form.recordName = "presupuesto";
		form.recordClass = "HreRem.model.PresupuestosTrabajo";
		
		var success = function(record, operation) {
			me.getView().unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	window.parent.funcionRecargar();
	    	window.hide();

		};

		//En este caso, actualizar
		me.onSaveFormularioCompleto(form, success);
    },
    
     onClickUploadListaActivos: function(btn) {
       	var me = this,
       	form = me.getView().lookupReference("formSubirListaActivos");
       	
       	var params = form.getValues(false,false,false,true);
       	params.idTipoOperacion = "141";
       	
       	if(form.isValid()){
        	form.submit({
        		waitMsg: HreRem.i18n('msg.mask.loading'),
        		params: params,
    	   		success: function(fp, o){
    	   			idProceso = Ext.JSON.decode(o.response.responseText).idProceso;
    	   			
    	   			//btn.up('creartrabajowindow').getViewModel().getData().trabajo.getData().idProceso = idProceso;
    	   			//btn.up('creartrabajowindow').lookupReference('')form.getBindRecord().set("idActivo", idActivo);
    	   			var window = btn.up('creartrabajowindow');
    	   			window.idProceso = idProceso;
    	   			window.lookupReference('listaActivosSubidaRef').getStore().getProxy().setExtraParams({'idProceso':idProceso});
    	   			window.lookupReference('listaActivosSubidaRef').getStore().load();    	   	    	
    		    		}
    	
    				
    		    })
    	    }
     },
     
     onClickGenerarPropuesta: function(btn) {
     	
     	var me = this, params = {},
     	idTrabajo = me.getViewModel().get('trabajo').get('id'),
     	config = {};
		
		var messageBox = Ext.Msg.prompt(HreRem.i18n('title.generar.propuesta'),"<span class='txt-guardar-propuesta'>" + HreRem.i18n('txt.aviso.guardar.propuesta') + "</span>", function(btn, text){
		    if (btn == 'ok'){
		    	
		    	//LLamada para comprobar si se puede crear la propuesta
		    	var url = $AC.getRemoteUrl('trabajo/comprobarCreacionPropuesta');
			    Ext.Ajax.request({
				  url:url,
				  params:  {idTrabajo : idTrabajo},
				  			
				  success: function(response,opts){
					  //Si se puede crear la propuesta, la crea
					  if(Ext.JSON.decode(response.responseText).success == "true") {
					    	params.nombrePropuesta = text;
					    	params.idTrabajo = idTrabajo;
					       
					        config.params = params;
							config.url= $AC.getRemoteUrl('trabajo/createPropuestaPreciosFromTrabajo');
							
							me.fireEvent("downloadFile", config);
					  }
					  else {
						  me.fireEvent("errorToast", Ext.JSON.decode(response.responseText).mensaje); 
					  }
							
				  },
				  failure: function (a, operation, context) {
					  
					  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
				  }
		    	});
		    }
    	});

		messageBox.textField.maskRe=/^[A-Za-z0-9\s_/]+$/;
		messageBox.textField.mon(messageBox.textField.el, 'keypress', messageBox.textField.filterKeys, messageBox.textField);
		
     }
    	
});