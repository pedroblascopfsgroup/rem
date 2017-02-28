Ext.define('HreRem.view.agrupaciones.detalle.AgrupacionDetalleController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.agrupaciondetalle',    

    control: {
      'fotossubdivision': {
         	updateOrdenFotos: 'updateOrdenFotosInterno',
         	cargarFotosSubdivision: 'cargarFotosSubdivision'
      }
    },

	cargarTabData: function (form) {

		var me = this,
		model = form.getModelInstance(),
		id = me.getViewModel().get("agrupacionficha.id");
		
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

	onClickBotonFavoritos: function(btn) {
		
		var me = this,			
		agrupacionesDetalle = btn.up('agrupacionesdetalle'),
		textoFavorito = "Agrupacion " + me.getViewModel().get("agrupacionficha.id");
		btn.updateFavorito(textoFavorito);
			
	},
	
	onClickBotonCerrarPestanya: function(btn) {
    	var me = this;
    	me.getView().destroy();
    },
    
    onClickBotonCerrarTodas: function(btn) {
    	var me = this;
    	me.getView().up("tabpanel").fireEvent("cerrarTodas", me.getView().up("tabpanel"));    	

    },
    
    onClickCrearTrabajo: function (btn) {
    	
    	var me = this;
    	var idAgrupacion = me.getViewModel().get("agrupacionficha.id");
    	me.getView().fireEvent('openModalWindow',"HreRem.view.trabajos.detalle.CrearTrabajo",{idActivo: null, idAgrupacion: idAgrupacion});
  	    	
    },
	
	 /**
     * Función que refresca la pestaña activa, y marca el resto de componentes para referescar.
     * Para que un componente sea marcado para refrescar, es necesario que implemente la función 
     * funciónRecargar con el código necesario para refrescar los datos.
     */
	onClickBotonRefrescar: function (btn) {
		
		var me = this;
		me.refrescarAgrupacion(true);

	},
	
	refrescarAgrupacion: function(refrescarPestañaActiva) {
		
		var me = this,
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
		};
		
		me.getView().fireEvent("refrescarAgrupacion", me.getView());
		
	},
	
	onSaveSingleField: function(campo) {
		// TODO VALIDACIONES
		campo.up('form').getBindRecord().save();
	},	
	    
   	onSaveFormularioCompletoForm: function(btn, form) {
		
   		var me = this;
   		if(form.isFormValid()) {

	   		Ext.Array.each(form.query('field[isReadOnlyEdit]'),
	   				function (field, index){field.fireEvent('update'); field.fireEvent('save');}
	   		);
	   		
			me.getViewModel().set("editing", false);
			
	   		me.getView().mask(HreRem.i18n("msg.mask.loading"));	
	   		
	   		form.getBindRecord().save({

		   		success: function (a, operation) {		  
			   		me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
			   		me.getView().unmask();
			   		me.onClickBotonRefrescar();					
		   		},		   		          
		   		failure: function(a, operation) {
		   			Utils.defaultOperationFailure(a, operation, form);
		   		}
		   	});

   		} else {
   			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
   		}
	},
	
    onChangeChainedCombo: function(combo) {
    	
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);
    	me.getViewModel().notify();
		chainedCombo.clearValue("");
		chainedCombo.getStore().load(); 	
    	
    },
    
    onClickBotonEditar: function(btn) {
		
		var me = this;
		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		me.getViewModel().set("editing", true);
		
	},
	
	onClickBotonEditarFoto: function(btn) {
		
		var me = this;
		Ext.Array.each(btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('edit');});
								
		btn.up('tabpanel').getActiveTab().query('field[isReadOnlyEdit]')[0].focus();
		me.getViewModel().set("editingfotos", true);
		
	},
    
	onClickBotonGuardar: function(btn) {
		var me = this;	
		me.onSaveFormularioCompletoForm(btn, btn.up('tabpanel').getActiveTab());				
	},
	
	onClickBotonCancelar: function(btn) {
		var me = this,
		activeTab = btn.up('tabpanel').getActiveTab();

		if (!activeTab.saveMultiple) {
			if(activeTab && activeTab.getBindRecord && activeTab.getBindRecord()) {
				activeTab.getForm().clearInvalid();
				activeTab.getBindRecord().reject();
			}
		} else {
			
			var records = activeTab.getBindRecords();
			
			for (i=0; i<records.length; i++) {
				records[i].reject();
			}

		}	
	
		Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
		me.getViewModel().set("editing", false);
	},
	
	onClickBotonCancelarFoto: function(btn) {
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
		Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
						function (field, index) 
							{ 
								field.fireEvent('save');
								field.fireEvent('update');});
		me.getViewModel().set("editingfotos", false);
	},

    onChangeTipoAgrupacion: function(btn,value) {
    	
    	//Se deja comentado porque volverá a aplicar en fase 2
    	/*var me = this;

    	if (value != '01') {	
    		me.lookupReference('estadoObraNuevaCombo').setVisible(false);
    	}*/

    },
    
    cargarTabFotos: function (form) {

		var me = this,
		idAgrupacion = me.getViewModel().get("agrupacionficha.id");
		me.getView().mask(HreRem.i18n("msg.mask.loading"));

		me.getViewModel().data.storeFotos.getProxy().setExtraParams({'id':idAgrupacion});
		me.getViewModel().data.storeFotos.on('load',function(){
			me.getView().unmask();
		});
		me.getViewModel().data.storeFotos.load();
		
	},
	
	onAddFotoClick: function(btn, grid, c) {
		
		var me = this,
		idAgrupacion = me.getViewModel().get("agrupacionficha.id");

		//HREOS-1381, Permitimos más de una foto por agrupación
    	/*if (btn.up('form').down('dataview').getStore().totalCount == 0) {
			
			Ext.create("HreRem.view.common.adjuntos.AdjuntarFotoAgrupacion", {idEntidad: idAgrupacion, parent: btn}).show();
			
		} else {
			
			me.fireEvent("errorToast", "Solo puede insertarse una foto por agrupación");
			
		}*/
		Ext.create("HreRem.view.common.adjuntos.AdjuntarFotoAgrupacion", {idEntidad: idAgrupacion, parent: btn}).show();
		
	},
	
	
	onAddFotoSubdivisionClick: function(btn) {
		
		var me = this,
		idAgrupacion = me.getViewModel().get("agrupacionficha.id"),
		idSubdivision = me.getViewModel().get("subdivisionFoto.id");

		if(Ext.isEmpty(idSubdivision)) {
			me.fireEvent("warnToast", HreRem.i18n("msg.error.necesario.seleccionar.subdivision"));
		} else {
			Ext.create("HreRem.view.common.adjuntos.AdjuntarFotoSubdivision", {idSubdivision: idSubdivision, idAgrupacion: idAgrupacion, parentToRefresh: btn.up("form") }).show();
		}		
	},
	
	onDeleteFotoClick: function(btn, b, c, d) {

		var me = this;
		
		if (btn.up('form').dataViewAlternativo != null) {
    		var nodos = btn.up('form').down('[reference=' + btn.up('form').dataViewAlternativo + ']').getSelectedNodes();
			var storeTemp = btn.up('form').down('[reference=' + btn.up('form').dataViewAlternativo + ']').getStore();
    	} else {
    		var nodos = btn.up('form').down('dataview').getSelectedNodes();
			var storeTemp = btn.up('form').down('dataview').getStore();
    	}
		
		if(nodos.length > 0) {
			Ext.Msg.show({
			   title: HreRem.i18n('title.confirmar.eliminacion'),
			   msg: HreRem.i18n('msg.desea.eliminar'),
			   buttons: Ext.MessageBox.YESNO,
			   fn: function(buttonId) {
			        if (buttonId == 'yes') {

						var idSeleccionados = [];
						for (var i=0; i<nodos.length; i++) {
				
							idSeleccionados[i] = storeTemp.getAt(nodos[i].getAttribute('data-recordindex')).getId();
							
						}
			    		
			        	var url =  $AC.getRemoteUrl('activo/deleteFotosActivoById');
			    		Ext.Ajax.request({
			    			
			    		     url: url,
			    		     params: {id : idSeleccionados},
			    		
			    		     success: function (a, operation, context) {
                                	
                            	//storeTemp.removeAll();
                            	storeTemp.load();
								me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
								 //me.unmask();
                            },
                            
                            failure: function (a, operation, context) {
								me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));	
								 //me.unmask();
                            }
			    		     
			    		 });

			        }
			   }
			});
			
		} else {
			me.fireEvent("warnToast", HreRem.i18n("msg.error.necesario.seleccionar.foto"));
			
		}
		
	},
	
	onDownloadFotoClick: function(btn) {
		var me = this,
		config = {};
		
		if (btn.up('form').dataViewAlternativo != null) {
			
			var nodos = btn.up('form').down('[reference=' + btn.up('form').dataViewAlternativo + ']').getSelectedNodes();
			
		} else {
		
			var nodos = btn.up('form').down('dataview').getSelectedNodes();
			
		}
		if (nodos.length != 0) {
		
			if (btn.up('form').dataViewAlternativo != null) {
				var storeTemp = btn.up('form').down('[reference=' + btn.up('form').dataViewAlternativo + ']').getStore();
				
			} else {
				var storeTemp = btn.up('form').down('dataview').getStore();
				
			}
			
			config.url=$AC.getWebPath()+"activo/getFotoActivoById."+$AC.getUrlPattern();
			config.params = {};
			config.params.idFoto=storeTemp.getAt(nodos[0].getAttribute('data-recordindex')).getId();
			
			me.fireEvent("downloadFile", config);
		}
	},
	
    onActivosAgrupacionListDobleClick: function(grid, record) {
    	var me = this,  
    	titulo = "Activo " + record.get("numActivo"),
    	id = record.get("activoId");  	
    	
    	me.getView().fireEvent('abrirDetalleActivo', id, titulo);
    },
    
    onSubdivisionesAgrupacionListClick: function(grid,record) {
		var me = this;		
		me.getViewModel().set("subdivision", record);
		me.getViewModel().notify();
		grid.up('form').down('[reference=listaActivosSubdivision]').getStore().loadPage(1);
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
	                    }
	                },
	                
	                failure: function (a, operation, context) {
	                	 me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
						 me.unmask();
	                }
    		     
				});
				
				
			}
			orden++;
			me.ordenGuardado++;
		}
		
	},
	
	cargarFotosSubdivision: function (recordSelected) {

		var me = this;
		me.getViewModel().set("subdivisionFoto",recordSelected);
		me.getViewModel().notify();
		me.lookupReference("imageDataViewSubdivision").getStore().load();
		
	},
	
	onMarcarPrincipalClick: function(grid, rowIndex, colIndex, item, e, rec) {
		
    	var me = this;
    	me.gridOrigen = grid;
    	
    	var esEditable = me.getViewModel().get('agrupacionficha.esEditable');
    	
		if(esEditable) {
			if (rec.data.activoPrincipal != 1) {
				Ext.Msg.show({
					   title: HreRem.i18n('title.confirmar.activo.principal'),
					   msg: HreRem.i18n('msg.confirmar.activo.principal'),
					   buttons: Ext.MessageBox.YESNO,
					   fn: function(buttonId) {
					        if (buttonId == 'yes') {	
								me.getView().mask();
								var url =  $AC.getRemoteUrl('agrupacion/marcarPrincipal');
								Ext.Ajax.request({
								
								     url: url,
								     params: {
								     			idAgrupacion: rec.data.agrId,
								     			idActivo: rec.data.activoId	
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
		}

    	
    },
    
    onClickAbrirExpedienteComercial: function(grid, rowIndex, colIndex) {
    	
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	me.getView().fireEvent('abrirDetalleExpediente', record);
    	
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
	    	window.parent.funcionRecargar();
	    	window.destroy();
		};

		me.onSaveFormularioCompleto(form, success);	
	},
	
	onSaveFormularioCompleto: function(form, success) {
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
					
					if(Ext.isDefined(form.funcionRefrescar)) {
						form.funcionRefrescar();
					} else {
						if (Ext.isDefined(form.otrafuncion)) {
							alert("gdsgdfgdfgdf");
						}
					}
			    }
			});
		} else {
			me.fireEvent("errorToast", HreRem.i18n("msg.form.invalido"));
		}
	
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

	// Método que es llamado cuando se solicita exportar losa ctivos de la agrupación tipo 'lote comercial'.
    onClickExportarActivosLoteComercial: function() {
	  	var me = this;
	  	var config = {};
		var idAgrupacion = me.getViewModel().get("agrupacionficha.id");

		config.params = {agrID : idAgrupacion};
		config.url= $AC.getRemoteUrl("agrupacion/exportarActivosLoteComercial");

		me.fireEvent("downloadFile", config);
    },

	onClickBotonGuardarInfoFoto: function(btn){
		var me = this;
		btn.up('tabpanel').mask();
		form= btn.up('tabpanel').getActiveTab().getForm();
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
				Ext.Array.each(activeTab.query('field[isReadOnlyEdit]'),
								function (field, index) 
									{ 
										field.fireEvent('save');
										field.fireEvent('update');});
				me.getViewModel().set("editingfotos", false);
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
	},

	onClickPublicarActivosSeleccionadosSubmenuGrid: function(menuItem) {
		var me = this;

		menuItem.up('activosagrupacionlist').mask();

		var arraySelection = menuItem.up('activosagrupacionlist').getActivoIDPersistedSelection();
		var url = $AC.getRemoteUrl('agrupacion/publicarActivosAgrupacion');
		var params = {
					'agrupacionID': me.getViewModel().get("agrupacionficha.id"),
					'activosID': arraySelection
				};

		me.genericAJAXController(menuItem, url, params);
	},

	onClickPublicarSubdivisionesActivosSeleccioandosSubmenuGrid: function(menuItem) {
		var me = this;

		menuItem.up('activosagrupacionlist').mask();

		var arraySelection = menuItem.up('activosagrupacionlist').getActivoIDPersistedSelection();
		var url = $AC.getRemoteUrl('agrupacion/publicarSubdivisionesActivosAgrupacion');
		var params = {
					'agrupacionID': me.getViewModel().get("agrupacionficha.id"),
					'activosID': arraySelection
				};

		me.genericAJAXController(menuItem, url, params);
	},

	onClickPublicarAgrupacionSubmenuGrid: function(menuItem) {
		var me = this;

		menuItem.up('activosagrupacionlist').mask();

		var url = $AC.getRemoteUrl('agrupacion/publicarAgrupacion');
		var params = {
				'agrupacionID': me.getViewModel().get("agrupacionficha.id")
			};

		me.genericAJAXController(menuItem, url, params);
	},

	genericAJAXController: function(menuItem, url, params) {
		var me = this;

		Ext.Ajax.request({
		     url: url,
		     params:params,
		     success: function (response, operation, context) {
				 if(Ext.decode(response.responseText).success === 'false') {
					 me.fireEvent("errorToast", Ext.decode(response.responseText).msg);
				 } else {
					me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				 }
				 menuItem.up('activosagrupacionlist').unmask();
            },

            failure: function (a, operation, context) {
          	   me.fireEvent("errorToast", 'NO HA SIDO POSIBLE REALIZAR LA OPERACIÓN');
          	   menuItem.up('activosagrupacionlist').unmask();
           }
	    });
	}
});