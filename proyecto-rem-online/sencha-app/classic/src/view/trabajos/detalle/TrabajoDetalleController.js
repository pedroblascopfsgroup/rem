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
		if(combo.getValue() == "02"){
			me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(true);
			me.lookupReference('checkEnglobaTodosActivosAgrRef').setValue(false);
			me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(true);
			me.lookupReference('checkEnglobaTodosActivosRef').setValue(false);
		}else{
			me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(false);
			me.lookupReference('checkEnglobaTodosActivosAgrRef').setValue(true);
			me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(false);
			me.lookupReference('checkEnglobaTodosActivosRef').setValue(true);
		}
		
		if(combo.getValue() == "04" || combo.getValue() == "05"){
			me.lookupReference("gestorActivoResponsableCombo").allowBlank= true;
			me.lookupReference("supervisorActivoCombo").allowBlank= true;
		}
		else{
			me.lookupReference("gestorActivoResponsableCombo").allowBlank= false;
			me.lookupReference("supervisorActivoCombo").allowBlank= false;
		}
		
		if(combo.getValue() != "02" && combo.getValue() != "03") {
			me.lookupReference("fieldSetMomentoRealizacionRef").setVisible(false);
		} 
		else {
			me.lookupReference("fieldSetMomentoRealizacionRef").setVisible(true);
		}
		
		if(combo.getValue() == CONST.TIPOS_TRABAJO.ACTUACION_TECNICA) {
			me.lookupReference("codigoPromocionPrinex").setDisabled(false);
		} else {
			me.lookupReference("codigoPromocionPrinex").setDisabled(true);
			me.lookupReference("codigoPromocionPrinex").setValue(null);
		}
		
		me.lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(false);
    	
		
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
			  
				  advertencia = Ext.JSON.decode(response.responseText).advertencia;
				  me.lookupReference("textAdvertenciaCrearTrabajo").setText(advertencia);
			  }
		    });
		}
    	
    	if(combo.getValue() == CONST.SUBTIPOS_TRABAJO['TRAMITAR_PROPUESTA_PRECIOS'] 
    		|| combo.getValue() == CONST.SUBTIPOS_TRABAJO['TRAMITAR_PROPUESTA_DESCUENTO']) {
    		me.lookupReference("checkEnglobaTodosActivosAgrRef").setValue(true);
    		me.lookupReference("checkEnglobaTodosActivosRef").setValue(true);
    		me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(true);
    		me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(true);
    		
    		me.lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(true);
    		
    		
    	}
    	else {
    		
    		me.lookupReference("listaActivosSubidaRef").getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(false);
    		
    		if(me.lookupReference("tipoTrabajo").getValue() != CONST.TIPOS_TRABAJO['OBTENCION_DOCUMENTACION']){
    			me.lookupReference("checkEnglobaTodosActivosAgrRef").setDisabled(false);
    			me.lookupReference("checkEnglobaTodosActivosRef").setDisabled(false);
    		}
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
			 		var response = Ext.decode(operation.getResponse().responseText);
			 		if(response.success === "false" && Ext.isDefined(response.error)) {
						me.fireEvent("errorToast", Ext.decode(operation.getResponse().responseText).error);
						if(me.getView().down("[reference=activosagrupaciontrabajo]") != null){
			 				me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
			 			}
						//me.fireEvent("errorToast", operation.getError());
			 		}else{
			 			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			 			if(me.getView().down("[reference=activosagrupaciontrabajo]") != null){
			 				me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
			 			}
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
	
	// Este método es llamado cuando se pulsa el botón de 'crear' en la ventana pop-up
	// de crear trabajo. Comprueba si se ha seleccionado el checkbox de agrupar activos
	// en un sólo trabajo. Si no se ha seleccionado informa al usuario de que se va a
	// generar un trabajo por cada activo.
	onClickBotonCrearTrabajo: function(btn) {
		var me =this;
		var arraySelection = me.lookupReference('activosagrupaciontrabajo').getActivoIDPersistedSelection();
		// Comprobar el estado del checkbox para agrupar los activos en un trabajo.
		var check = me.lookupReference('checkEnglobaTodosActivosRef').getValue();	
		var codPromo;
		//Si no se ha seleccionado ning�n activo
		if(Ext.isEmpty(arraySelection)){
			
			var storeListaActivosTrabajo = me.lookupReference('listaActivosSubidaRef').getStore();
			if(!Ext.isEmpty(storeListaActivosTrabajo) && !Ext.isEmpty(storeListaActivosTrabajo.data)){
				codPromo = me.lookupReference('codigoPromocionPrinex').getValue();
				var actuacionTecnica = (me.lookupReference('tipoTrabajo').getValue() == CONST.TIPOS_TRABAJO.ACTUACION_TECNICA ? true : false);
				for (var i=0; i < storeListaActivosTrabajo.data.length; i++) {
					if (storeListaActivosTrabajo.data.items[i].data.tienePerimetroGestion != "1"){
						Ext.MessageBox.alert(
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
								HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.mensaje.todos")
						);
						return false;
			        }
					if (actuacionTecnica && !Ext.isEmpty(codPromo)) {
						if (storeListaActivosTrabajo.data.items[i].data.codigoCartera == CONST.CARTERA.LIBERBANK) {
							if (!Ext.isEmpty(codPromo) && storeListaActivosTrabajo.data.items[i].data.codigoPromocionPrinex != codPromo){
								Ext.MessageBox.alert(
										HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
										HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinCodPromo.mensaje.todos")
								);
								return false;
					        }
						} else {
							Ext.MessageBox.alert(
									HreRem.i18n("msgbox.multiples.trabajos.seleccionado.sinGestion.titulo"),
									HreRem.i18n("msgbox.multiples.trabajos.seleccionado.todosCarteraLiberbank.mensaje.todos")
							);
							return false;
						}
					}
					arraySelection.push(storeListaActivosTrabajo.data.items[i].data.idActivo);
				}
			}
			//Si se marca el check y se esta creando desde agrupaciones
			if(check && Ext.isEmpty(me.getView().idActivo)){
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.seleccionado.check.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}
			else if(Ext.isEmpty(me.getView().idActivo)){
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.check.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}else{
				me.crearTrabajo(btn,arraySelection,codPromo);
			}
		}
		else{
			if(check && Ext.isEmpty(me.getView().idActivo)){
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.seleccionados.check.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}
			else{
				Ext.MessageBox.confirm(
						HreRem.i18n("msgbox.multiples.trabajos.title"),
						HreRem.i18n("msgbox.multiples.trabajos.checks.mensaje"),
						function(result) {
			        		if(result === 'yes'){
			        			me.crearTrabajo(btn,arraySelection,codPromo);
			        		}
			    		}
				);
			}
			
		}
		
	},
	
	hideWindowPeticionTrabajo: function(btn) {
    	var me = this;
    	me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
    	btn.up('window').hide();   	
    },
	
	// Este método crea el trabajo especificado en la ventana pop-up de crear trabajo.
	crearTrabajo: function(btn,arraySelection, codigoPromocionPrinex) {
		var me =this,
		window = btn.up("window"),
		form = window.down("form"),
		idAgrupacion = window.idAgrupacion,
		idActivo = window.idActivo,
		idProceso = window.idProceso;
		codCartera = window.codCartera;
		codSubcartera = window.codSubcartera;
		
		form.getBindRecord().set("idActivo", idActivo);
		form.getBindRecord().set("idAgrupacion", idAgrupacion);
		form.getBindRecord().set("idProceso", idProceso);
		form.getBindRecord().set("idsActivos", arraySelection);
		form.getBindRecord().set("codigoPromocionPrinex", codigoPromocionPrinex);
		form.getBindRecord().set("codCartera", codCartera);
		form.getBindRecord().set("codSubcartera", codSubcartera);
				
		var success = function(record, operation) {
			me.getView().unmask();
	    	me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
	    	me.getView().fireEvent("refreshComponentOnActivate", "trabajosmain");
	    	me.getView().fireEvent("refreshComponentOnActivate", "agendamain");
	    	me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES['ACTIVO'], idActivo);
	    	me.getView().down("[reference=activosagrupaciontrabajo]").deselectAll();
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
		tipoTrabajoCodigo = me.getViewModel().get("trabajo.tipoTrabajoCodigo");
		Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumento", {entidad: 'trabajo', idEntidad: idTrabajo, tipoTrabajoCodigo: tipoTrabajoCodigo, parent: grid}).show();

	},
	
	borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idTrabajo = me.getViewModel().get("trabajo.id");

		record.erase({
			params: {idEntidad: idTrabajo},
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
		config.params.nombreDocumento=record.get("nombre");
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
		//combo.validate();
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

		var idTrabajo = me.getViewModel().get("trabajo.id");
		//REMVIP-558 - Se añaden dos campos mas, descpripcion y codigo del trabajo
		var carteraCodigo = me.getViewModel().get("trabajo.carteraCodigo"),
		tipoTrabajoCodigo = me.getViewModel().get("trabajo.tipoTrabajoCodigo"),
		subtipoTrabajoCodigo = me.getViewModel().get("trabajo.subtipoTrabajoCodigo"),
		codigoTarifaTrabajo = me.getViewModel().get('trabajo.codigoTarifaTrabajo'),
		descripcionTarifaTrabajo = me.getViewModel().get('trabajo.descripcionTarifaTrabajo');
		
		store.getProxy().extraParams = {idTrabajo: idTrabajo, cartera: carteraCodigo, tipoTrabajo: tipoTrabajoCodigo, subtipoTrabajo: subtipoTrabajoCodigo
			, codigoTarifa: codigoTarifaTrabajo, descripcionTarifa: descripcionTarifaTrabajo};	
		
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
    	subtipoTrabajoDescripcion = parent.getBindRecord().get('subtipoTrabajoDescripcion'),
    	codigoTipoProveedor = parent.getBindRecord().get('codigoTipoProveedor'),
    	idProveedor = parent.getBindRecord().get('idProveedor'),
    	idProveedorContacto = parent.getBindRecord().get('idProveedorContacto');
    	emailProveedorContacto = parent.getBindRecord().get('emailProveedorContacto');
    	nombreProveedorContacto = parent.getBindRecord().get('nombreProveedorContacto');
    	usuarioProveedorContacto = parent.getBindRecord().get('usuarioProveedorContacto');

    	var window=Ext.create("HreRem.view.trabajos.detalle.ModificarPresupuesto", {idTrabajo: idTrabajo, tipoTrabajoDescripcion: tipoTrabajoDescripcion, subtipoTrabajoDescripcion: subtipoTrabajoDescripcion, codigoTipoProveedor: codigoTipoProveedor, idProveedor: idProveedor, idProveedorContacto: idProveedorContacto, emailProveedorContacto: emailProveedorContacto, nombreProveedorContacto: nombreProveedorContacto, usuarioProveedorContacto: usuarioProveedorContacto, parent: parent, modoEdicion: true, presupuesto: record}).show();
    	window.getViewModel().set('trabajo',me.getViewModel().get('trabajo'));
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
    	//me.getViewModel().set('proveedor', record);
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
		form = window.down("form"),
		combo = me.lookupReference('labelEmailContacto');
		
		combo.validate();
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
    	   			window.lookupReference('listaActivosSubidaRef').getStore().load(1);    
    	   			//Si carga correctametne desde listado, ya no sera obligatorio insertar archivo
    	   			window.lookupReference('filefieldActivosRef').allowBlank=true;
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
					  boton = me.lookupReference("botonGenerarPropuesta");
					  if(Ext.JSON.decode(response.responseText).success == "true") {
					    	params.nombrePropuesta = text;
					    	params.idTrabajo = idTrabajo;
		    				
					        config.params = params;
							config.url= $AC.getRemoteUrl('trabajo/createPropuestaPreciosFromTrabajo');
							
							me.fireEvent("downloadFile", config);
							boton.setDisabled(true);
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
		
     },
     
     comprobarExistePropuestaTrabajo: function(){
     	var me = this, params = {},
       	idTrabajo = me.getViewModel().get('trabajo').get('id');
     	//LLamada para comprobar si se puede crear la propuesta
     	var url = $AC.getRemoteUrl('trabajo/comprobarCreacionPropuesta');
 	    Ext.Ajax.request({
 		  url:url,
 		  params:  {idTrabajo : idTrabajo},
 		  			
 		  success: function(response,opts){
 			  
 			  boton = me.lookupReference("botonGenerarPropuesta");
 			  //Si se puede crear la propuesta, activa el boton sino lo desactiva
 			  if(Ext.JSON.decode(response.responseText).success == "true") {
 				  boton.setDisabled(false);
 			  }
 			  else {
 				  boton.setDisabled(true);
 			  }		
 		  }
     	});
      },
      
	comprobarActivosEnOtrasPropuestas: function() {
      	var me = this, params = {},
       	idTrabajo = me.getViewModel().get('trabajo').get('id');
       	
       	var boton = me.lookupReference("botonGenerarPropuesta");
       	if(!boton.isDisabled() && (me.getViewModel().get('trabajo').get('subtipoTrabajoCodigo')==='44'
    			|| me.getViewModel().get('trabajo').get('subtipoTrabajoCodigo')==='45')) 
    	{
	     	//LLamada para comprobar si hay activos en otras propuestas en trámite
	     	var url = $AC.getRemoteUrl('trabajo/comprobarActivosEnOtrasPropuesta');
	     	var advertencia;
	 	    Ext.Ajax.request({
				url:url,
				params:  {idTrabajo : idTrabajo},
	 		  			
				success: function(response,opts){
		 			//Respuesta que indica si se creará la propuesta con algunos activos (ya que existen algunos en otras propuestas en trámite)
			    	advertencia = Ext.JSON.decode(response.responseText).advertencia;
			    	
			    	if(!Ext.isEmpty(advertencia) /*&& !boton.isDisabled()*/) {
			    		var msgAdvertencia = me.lookupReference("msgAdvertenciaActivosEnOtrasPropuestas");
			    		var texto = "<span style= 'color: red; float: left'>";
			    		if(advertencia=='01'){
			    			texto += HreRem.i18n('msg.advertencia.precios.generar.prp.existen.activos.in.prp.entramite');
			    			boton.setDisabled(false);
			    		}else {
			    			texto += HreRem.i18n('msg.advertencia.precios.no.gernerar.prp.todos.activos.in.prp.tramite');
			    			boton.setDisabled(true);
			    		}
			    		texto += "</span>";
			    		msgAdvertencia.setText(texto);
			    	}
		 		}
	     	});
       	}
	},
     
     onClickBotonDescargarPlantilla: function(btn) {
    	var me = this,
		config = {};
		
		config.url= $AC.getRemoteUrl("trabajo/downloadTemplateActivosTrabajo");
		
		me.fireEvent("downloadFile", config);
     },
     
     
     onChangeComboProveedorGE: function(combo) {
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
    					chainedCombo.setAllowBlank(false); 
    				}
 			}
 		});
 		if (me.lookupReference(chainedCombo.chainedReference) != null) {
 			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
 			if(chainedDos.getXType()=='comboboxfieldbase'){
	 			if(!chainedDos.isDisabled()) {
	 				chainedDos.clearValue();
	 				chainedDos.getStore().removeAll();
	 				chainedDos.setDisabled(true);
	 			}
 			}
 			do{
 				chainedDos.setValue('');
 				chainedDos = me.lookupReference(chainedDos.chainedReference);
 			}while(chainedDos != null);
 		}
 		

     },
     
     onClickBotonFiltrar: function(btn) {
    	 var me = this;
    	 
    	 var store = me.getViewModel().get('storeSeleccionTarifas');
    	 store.load();
    	 
     },

     onClickRefrescarParticipacion: function(btn) {
    	var me = this;
    	var grid = btn.up('trabajosdetalle').lookupReference('listadoActivosTrabajo');

    	grid.mask(HreRem.i18n("msg.mask.loading"))
    	idTrabajo = me.getViewModel().get('trabajo').get('id');

	 	Ext.Ajax.request({
			url: $AC.getRemoteUrl('trabajo/recalcularParticipacion'),
			params:  {idTrabajo : idTrabajo},
			success: function(response,opts){
				grid.unmask();
				btn.up('activostrabajo').funcionRecargar();
			},
			failure: function (a, operation, context) {
				grid.unmask();
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    }
	    });
	 	    
 	}
});
