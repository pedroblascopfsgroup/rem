Ext.define('HreRem.view.administracion.AdministracionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.administracion',
    
    init: function() {
    	
    	// Si el usuario es proveedor, las búsquedas deberan filtrarse por el nif de este, 
    	// y todas las listas de selección de proveedores estarán deshabilitadas.
    	var me = this;
    	
    	me.nifProveedorIdentificado= null;
    	
    	if($AU.userIsRol(CONST.PERFILES['PROVEEDOR'])) {
			var url =  $AC.getRemoteUrl('gastosproveedor/getNifProveedorByUsuario');
			Ext.Ajax.request({
			     url: url,			
			     success: function(response, opts) {
			     	var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }  catch (e){ };
	                
	                me.nifProveedorIdentificado = data.data;
	                
	                if(data.success != "true") {	                	
	                	me.fireEvent("errorToast", data.msg);
	                }
	                
	                me.onClickGastosSearch(me.lookupReference('btnSearchGastos'));
			     },
			     
			     failure: function(response) {
		     		var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                	me.nifProveedorIdentificado = data.data;
	                }
	                catch (e){ };
	                if (!Ext.isEmpty(data.msg)) {
	                	me.fireEvent("errorToast", data.msg);
	                } else {
	                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                }
			     }
	    		     
	    	});				
		}
    	
    },
    
    control: {
    	
    	'gestiongastoslist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var me = this;
    			var autorizarBtn = grid.down('button[itemId=autorizarBtn]');
    			var rechazarBtn = grid.down('button[itemId=rechazarBtn]');
    			var rechazarContabilidadBtn = grid.down('button[itemId=rechazarContabilidadBtn]')
    			var displaySelection = grid.down('displayfield[itemId=displaySelection]');
    			var disabled = Ext.isEmpty(persistedSelection);

    			if (!Ext.isEmpty(autorizarBtn)) autorizarBtn.setDisabled(disabled);    		
    			if (!Ext.isEmpty(rechazarBtn)) rechazarBtn.setDisabled(disabled);
    			if (!Ext.isEmpty(rechazarContabilidadBtn)) rechazarContabilidadBtn.setDisabled(disabled);

    			if(disabled) {
    				displaySelection.setValue("No seleccionados");
    			} else if (persistedSelection.length > 1) {
    				displaySelection.setValue(persistedSelection.length +  " gastos seleccionados"); 
    			} else {
    				displaySelection.setValue("1 gasto seleccionado"); 
    			}
    			
    			
    		},    		
    		
    		onClickAddGasto: 'onClickAddGasto'
    	},
    	
    	'gestionprovisiongastoslist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var autorizarBtn = grid.down('button[itemId=autorizarBtn]');
    			var rechazarBtn = grid.down('button[itemId=rechazarBtn]');
    			var displaySelection = grid.down('displayfield[itemId=displaySelection]');
    			var displayImporteTotalLabel = grid.down('displayfield[itemId=labelImporteTotal]');
    			var displayImporteTotal = grid.down('displayfield[itemId=displayImporteTotal]');
    			var disabled = Ext.isEmpty(persistedSelection);

//    			if (!Ext.isEmpty(autorizarBtn)){
//    				autorizarBtn.setDisabled(disabled);    		
//    			}
//    			if (!Ext.isEmpty(rechazarBtn)){
//    				rechazarBtn.setDisabled(disabled);
//    			}

    			if(disabled) {
    				displayImporteTotal.setHidden(true);
    				displayImporteTotalLabel.setHidden(true);
    				displaySelection.setValue("No seleccionados");
    			} else if (persistedSelection.length > 1) {
    				displayImporteTotal.setHidden(false);
    				displayImporteTotalLabel.setHidden(false);
    				displaySelection.setValue(persistedSelection.length +  " gastos seleccionados"); 
    			} else {
    				displayImporteTotal.setHidden(false);
    				displayImporteTotalLabel.setHidden(false);
    				displaySelection.setValue("1 gasto seleccionado"); 
    			}
    			var importeTotalAcumulado = 0;
    			var importeTotalAgrupacion = 0;
    			Ext.Array.each(persistedSelection, function (item) {
    				if(importeTotalAgrupacion == 0){
    					importeTotalAgrupacion = parseFloat(item.data.importeTotalAgrupacion);
    				}
    				if(item.data.importeTotal && item.data.estadoGastoCodigo != '03'){
    					//Ext.global.console.log(item.data.importeTotal);
    					importeTotalAcumulado += parseFloat(item.data.importeTotal);
    				}
    				
                });
    			
    			displayImporteTotal.setValue(Number(importeTotalAcumulado+importeTotalAgrupacion).toFixed(2));
    		}
    		
    	}

    },

    //Funcion que se ejecuta al hacer click en el botón buscar gastos
	onClickGastosSearch: function(btn) {
		var me = this;
		var initialData = {};

		var searchForm = btn.up('formBase');

		if (searchForm.isValid()) {
			this.lookupReference('gestiongastoslistref').deselectAll();
			this.lookupReference('gestiongastoslistref').getStore().loadPage(1);
        }
		
		
	},
    
	// Función que se ejecuta al hacer click en el botón de Exportar en gestión gastos.
	onClickDescargarExcelGestionGastos: function(btn) {
		var me = this,
		config = {};

		var initialData = {};

		var searchForm = btn.up('formBase');
		if (!searchForm.isValid()) { 
			return;
		}
		var params = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});

		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});

		config.params = params;
		config.url= $AC.getRemoteUrl("gastosproveedor/generateExcelGestionGastos");
		
		me.fireEvent("downloadFile", config);		
	},

	// Función que se ejecuta al hacer click en el botón de Exportar en agrupaciones de gastos.
	onClickDescargarExcelProvisionGastos: function(btn) {
		var me = this,
		config = {};

		var initialData = {};

		var searchForm = btn.up('formBase');
		if (!searchForm.isValid()) { 
			return;
		}
		var params = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});

		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});

		config.params = params;
		config.url= $AC.getRemoteUrl("provisiongastos/generateExcelProvisionGastos");
		
		me.fireEvent("downloadFile", config);		
	},

	// Función que se ejecuta al hacer click en el botón de Exportar en gastos por agrupación.
	onClickDescargarExcelGastosAgrupacion: function(btn) {
		var me = this,
		config = {};

		var provision = me.getViewModel().get('provisionSeleccionada');
		if(Ext.isEmpty(provision)) {
			return;
		}

		var params = {'idProvision':provision.get('id')}

		config.params = params;
		config.url= $AC.getRemoteUrl("gastosproveedor/generateExcelGestionGastos");

		me.fireEvent("downloadFile", config);		
	},

	//Funcion que se ejecuta al hacer click en el botón buscar provisiones
	onClickProvisionesSearch: function(btn) {
		var me = this;
		this.lookupReference('provisionesGastosList').collapse();
		this.lookupReference('provisionesList').getStore().loadPage(1);
	},
	
	// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {			
		btn.up('form').getForm().reset();				
	},
	
	paramLoading: function(store, operation, opts) {
		var initialData = {};
		var me = this;
		var searchForm = this.lookupReference('gestiongastossearchref');
		if (searchForm.isValid()) {
			
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
			if($AU.userIsRol(CONST.PERFILES['PROVEEDOR'])) {
				criteria.nifProveedor = me.nifProveedorIdentificado;
			}
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},
	
	onClickAbrirGastoProveedor: function(grid, record){
		var me = this;
		
    	me.getView().fireEvent('abrirDetalleGasto', record);
		
	},

	onRowClickProvisionesList: function(gridView,record) {
		var me = this;
		var viewModel = me.getViewModel();
		viewModel.set("provisionSeleccionada", record);
		viewModel.notify();

		var grid = me.lookupReference('provisionesGastosList');
		var store = grid.getStore();
		grid.expand();
		store.loadPage(1);
		store.on('load', function(store ,records ,successful ,eOpts){
	        grid.mostrarExportarGastos();
    	});

		var estadoProvision = record.get("estadoProvisionCodigo");
		if(CONST.ESTADOS_PROVISION['RECHAZADA_SUBSANABLE'] == estadoProvision) {
			grid.mostrarEdicionGastos();
		} else {
			grid.ocultarEdicionGastos();
		}
    },

	paramLoadingProvisiones: function(store, operation, opts) {
		var me = this;
		
		var me = this,		
		searchForm = this.lookupReference('provisionesSearch');
		
		if (searchForm.isValid()) {				
			store.getProxy().extraParams = me.getFormCriteria(searchForm);			
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
    
    onClickAddGasto: function(grid) {
    	
    	var me =this,
    	parent= grid.up('gestiongastos');
    	var anyadirGastoWindow = Ext.create('HreRem.view.administracion.gastos.AnyadirNuevoGasto',{parent: parent, nifEmisor: me.nifProveedorIdentificado});
    	me.getView().up('tabpanel').add(anyadirGastoWindow);
    	anyadirGastoWindow.show();
	                
    },
    
    onClickAutorizar: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.autorizar.gastos.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		        if (buttonId == 'yes') {
					me.autorizarGasto(btn, "SG");
		        }
		   }
		});
    },
    
    onClickAutorizarGastosAgrupados: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.autorizar.gastos.agrupados.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		        if (buttonId == 'yes') {
					me.autorizarGasto(btn, "SA");
		        }
		   }
		});
    },
    
    autorizarGasto: function(btn, origen) {
    	
    	var me = this,
    	listaGastos = btn.up('gridBase'),
    	gastos = listaGastos.getPersistedSelection(),
		url =  $AC.getRemoteUrl('gastosproveedor/autorizarGastos'),		
		idsGasto = [], error=null;
					
		// Recuperamos todos los ids de los trabajos seleccionados
		// y validamos que se pueden autorizar
		Ext.Array.each(gastos, function(gasto, index) {
		    error = me.validarSeleccionGasto("A", gasto, origen);
		    if(Ext.isEmpty(error)) {
		    	idsGasto.push(gasto.get("id"));	
		    } else {
		    	// Salimos del foreach y mostramos el error
		    	return false;	
		    }
		});

		if(Ext.isEmpty(error)){
			me.getView().mask(HreRem.i18n("msg.mask.loading"));

			Ext.Ajax.request({
		    			
			     url: url,
			     params: {idsGasto: idsGasto},
			
			     success: function(response, opts) {
			     	me.getView().unmask();
			        var data = {};
		            try {
		                data = Ext.decode(response.responseText);
		            } catch (e){ };
		            
		            if(data.success === "false") {
			            if (!Ext.isEmpty(data.msg)) {
			              	me.fireEvent("errorToast", data.msg);
			            } else {
			            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			            }
		            } else {							         
				         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				         listaGastos.deselectAll();
				         listaGastos.getStore().loadPage(1);
				         Ext.Array.each(gastos, function(gasto, index) {
						    me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.get("id"));
						});
		            }
			     },
			     failure: function(response) {
			     	me.getView().unmask();
		     		var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }
	                catch (e){ };
	                if (!Ext.isEmpty(data.msg)) {
	                	me.fireEvent("errorToast", data.msg);
	                } else {
	                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                }
			     }
		    		    
		    });
		} else {
			me.fireEvent("errorToast", error);
		}
    	
    },
    
     onClickRechazar: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.rechazar.gastos.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
 				if (buttonId == 'yes') { 					
 					me.rechazarGasto(btn, "SG");
 				}
		   }
		});
    	
    },
    
    onClickRechazarContabilidad: function(btn) {
    	
    	var me = this;
    	Ext.Msg.show({
    		title: HreRem.i18n('title.mensaje.confirmacion'),
    		msg: HreRem.i18n('msg.desea.rechazar.gastos.seleccionados'),
    		buttons: Ext.MessageBox.YESNO,
    		fn: function(buttonId){
    			if(buttonId == 'yes'){
    				me.rechazarGastoContabilidad(btn, "SG")
    			}
    		}
    	})
    },
    
    onClickRechazarGastosAgrupados: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.rechazar.gastos.agrupados.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
 				if (buttonId == 'yes') { 					
 					me.rechazarGasto(btn, "SA");
 				}
		   }
		});
    	
    },
    
    rechazarGasto: function(btn, origen) {
    	
    	var me = this;
    	var listaGastos = btn.up('gridBase');
    	var combo = Ext.create("HreRem.view.common.ComboBoxFieldBase", {
 			addUxReadOnlyEditFieldPlugin: false, store: {model: 'HreRem.model.ComboBase',proxy: {type: 'uxproxy',remoteUrl: 'generic/getDiccionario',extraParams: {diccionario: 'motivosRechazoHaya'}}}
 		});
 						
		HreRem.Msg.promptCombo(HreRem.i18n('title.motivo.rechazo'),"", function(btn, text){    
		    if (btn == 'ok'){
		    	
		    	var gastos = listaGastos.getPersistedSelection(),
				url =  $AC.getRemoteUrl('gastosproveedor/rechazarGastos'),		
				idsGasto = [], error=null;
		
				// Recuperamos todos los ids de los trabajos seleccionados
				// y validamos que se pueden rechazar
				Ext.Array.each(gastos, function(gasto, index) {
				    error = me.validarSeleccionGasto("R", gasto, origen);
				    if(Ext.isEmpty(error)) {
				    	idsGasto.push(gasto.get("id"));	
				    } else {
				    	// Salimos del foreach y mostramos el error
				    	return false;	
				    }
				});

				if(Ext.isEmpty(error)) {
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
	
					Ext.Ajax.request({
				    			
					     url: url,
					     params: {idsGasto: idsGasto, motivoRechazo: text},
					
					     success: function(response, opts) {
					     	
					     	var data = {};
					     	me.getView().unmask();	
				            try {
				                data = Ext.decode(response.responseText);
				            } catch (e){ };
				            
				            if(data.success === "false") {
					            if (!Ext.isEmpty(data.msg)) {
					              	me.fireEvent("errorToast", data.msg);
					            } else {
					            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					            }
				            } else {							         
						         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						         listaGastos.deselectAll();
						         listaGastos.getStore().loadPage(1);
						         Ext.Array.each(gastos, function(gasto, index) {
						    		me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.get("id"));
								 });
				            }
					     },
					     failure: function(response) {
					     	me.getView().unmask();
				     		var data = {};
			                try {
			                	data = Ext.decode(response.responseText);
			                }
			                catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
					     }
				    		    
				    });
				} else {
					me.fireEvent("errorToast", error);								
				}
		    	 
				
		    }
		}, null, null, null, combo);
    	
    },
    
    rechazarGastoContabilidad: function(btn, origen){
    	
    	var me = this;
    	var listaGastos = btn.up('gridBase');
    	var rechazo = "RECHAZADO POR CONTABILIDAD";
		    	var gastos = listaGastos.getPersistedSelection(),
				url =  $AC.getRemoteUrl('gastosproveedor/rechazarGastosContabilidad'),		
				idsGasto = [], error=null;
		
				// Recuperamos todos los ids de los gastos seleccionados
				// y validamos que se pueden rechazar
				Ext.Array.each(gastos, function(gasto, index) {
				    error = me.validarSeleccionGastoContabilidad("R", gasto, origen);
				    if(Ext.isEmpty(error)) {
				    	idsGasto.push(gasto.get("id"));	
				    } else {
				    	// Salimos del foreach y mostramos el error
				    	return false;	
				    }
				});

				if(Ext.isEmpty(error)) {
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
	
					Ext.Ajax.request({
				    			
					     url: url,
					     params: {idsGasto: idsGasto, motivoRechazo: rechazo},
					
					     success: function(response, opts) {
					     	
					     	var data = {};
					     	me.getView().unmask();	
				            try {
				                data = Ext.decode(response.responseText);
				            } catch (e){ };
				            
				            if(data.success === "false") {
					            if (!Ext.isEmpty(data.msg)) {
					              	me.fireEvent("errorToast", data.msg);
					            } else {
					            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					            }
				            } else {							         
						         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						         listaGastos.deselectAll();
						         listaGastos.getStore().loadPage(1);
						         Ext.Array.each(gastos, function(gasto, index) {
						    		me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.get("id"));
								 });
				            }
					     },
					     failure: function(response) {
					     	me.getView().unmask();
				     		var data = {};
			                try {
			                	data = Ext.decode(response.responseText);
			                }
			                catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
					     }
				    		    
				    });
				} else {
					me.fireEvent("errorToast", error);								
				}    	 
				
		    
    },
    
    validarSeleccionGasto: function(operacion, gasto, origen) { 
    	var me = this, error = null;
    	var OPERACION_AUTORIZAR = "A";
    	var OPERACION_RECHAZAR = "R";
    	
    	var SELECCION_GASTOS = "SG";
    	var SELECCION_AGRUPACION = "SA";

    	if(CONST.ESTADOS_GASTO['ANULADO'] == gasto.get("estadoGastoCodigo") ||
			CONST.ESTADOS_GASTO['PAGADO'] == gasto.get("estadoGastoCodigo") ||
			CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.get("estadoGastoCodigo") || CONST.ESTADOS_GASTO['RETENIDO'] == gasto.get("estadoGastoCodigo")) {	    		
			error = ("<span>Se han seleccionado gastos retenidos, anulados, contabilizados o pagados</span></br>")
		} else if (SELECCION_GASTOS == origen && gasto.get("esGastoAgrupado")) {
			error = ("<span>Se han seleccionado gastos agrupados. Estos gastos deben gestionarse desde la pestaña de agrupación de gastos.</span></br>")
		
		} else if(OPERACION_AUTORIZAR == operacion && CONST.ESTADOS_AUTORIZACION_HAYA['AUTORIZADO'] == gasto.get("estadoAutorizacionHayaCodigo")) {
			error = ("<span>Se han seleccionado gastos ya autorizados</span></br>")
		} else if(OPERACION_RECHAZAR == operacion && CONST.ESTADOS_AUTORIZACION_HAYA['RECHAZADO'] == gasto.get("estadoAutorizacionHayaCodigo")) {
			error = ("<span>Se han seleccionado gastos ya rechazados</span></br>")
		}


		
		return error;
    	
    },
    
    validarSeleccionGastoContabilidad: function(operacion, gasto, origen) {
    	var me = this, error = null;
    	var OPERACION_AUTORIZAR = "A";
    	var OPERACION_RECHAZAR = "R";
    	
    	var SELECCION_GASTOS = "SG";
    	var SELECCION_AGRUPACION = "SA";
    	
    	if((!(CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.get("estadoGastoCodigo")) || (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.get("estadoGastoCodigo"))) && OPERACION_RECHAZAR == operacion){
    		error = ("<span>Se han seleccionado gastos que no tiene el estado Autorizados Administración</span></br>")
    	} else if(OPERACION_RECHAZAR == operacion && CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO'] == gasto.get("estadoGastoCodigo")) {
    		error = ("<span>Se han seleccionado gastos ya rechazados</span></br>")
		} else if(!CONST.CARTERA['TANGO'] == gasto.get("entidadPropietariaCodigo")){
			error = ("<span>Se han seleccionado gastos que no pertenecen a la cartera Tango</span></br>")
		}
    	return error;
    }
    	

});