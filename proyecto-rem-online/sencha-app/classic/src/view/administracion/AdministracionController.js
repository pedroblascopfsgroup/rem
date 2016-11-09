Ext.define('HreRem.view.administracion.AdministracionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.administracion',
    
    init: function() {
    	
    	// Si el usuario es proveedor, las búsquedas deberan filtrarse por el nif de este, 
    	// y todas las listas de selección de proveedores estarán deshabilitadas.
    	var me = this;
    	
    	me.nifProveedorIdentificado= null;
    	
    	if($AU.userIsRol(CONST.PERFILES['PROVEEDOR'])) {
			var url =  $AC.getRemoteUrl('gastosproveedor/getCodProveedorByUsuario');
			Ext.Ajax.request({
			     url: url,			
			     success: function(response, opts) {
			     	var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }  catch (e){ };
	                
	                if(data.success === "true") {
						me.nifProveedorIdentificado = data.data;
	                }else {
	                	me.fireEvent("errorToast", data.msg);
	                }
			     },
			     
			     failure: function(response) {
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
		}
    	
    },
    
    control: {
    	
    	'gestiongastoslist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var me = this;
    			var autorizarBtn = grid.down('button[itemId=autorizarBtn]');
    			var rechazarBtn = grid.down('button[itemId=rechazarBtn]');
    			var displaySelection = grid.down('displayfield[itemId=displaySelection]');
    			var disabled = Ext.isEmpty(persistedSelection);
    			autorizarBtn.setDisabled(disabled);    		
    			rechazarBtn.setDisabled(disabled);

    			if(disabled) {
    				displaySelection.setValue("No seleccionados");
    			} else if (persistedSelection.length > 1) {
    				displaySelection.setValue(persistedSelection.length +  " gastos seleccionados"); 
    			} else {
    				displaySelection.setValue("1 gasto seleccionado"); 
    			}
    			
    			
    		},    		
    		
    		onClickAddGasto: 'onClickAddGasto'
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
	
//	onClickDescargarExcel: function(btn) {
//		
//    	var me = this,
//		config = {};
//		
//		
//		
//		var initialData = {};
//
//		var searchForm = btn.up('formBase');
//		if (searchForm.isValid()) {
//			var params = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
//			
//			Ext.Object.each(params, function(key, val) {
//				if (Ext.isEmpty(val)) {
//					delete params[key];
//				}
//			});
//        }
//		
//		config.params = params;
//		config.url= $AC.getRemoteUrl("visitas/generateExcel");
//		//config.params = {};
//		//config.params.idProcess = this.getView().down('grid').selection.data.id;
//		
//		me.fireEvent("downloadFile", config);		
//    	
//    	
//    },
    
//    onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
//		var me = this;
//		var grid = tableView.up('grid');
//	    var record = grid.store.getAt(indiceFila);
//	    grid.setSelection(record);
//	    var idActivo = record.get("idActivo");
//	    me.redirectTo('activos', true);
//	    me.getView().fireEvent('abrirDetalleActivo', record);
//    	
//    }

	onRowClickProvisionesList: function(gridView,record) {
		
		var me = this;    		
		me.getViewModel().set("provisionSeleccionada", record);
		me.getViewModel().notify();
		
		me.lookupReference('provisionesGastosList').expand();	
		this.lookupReference('provisionesGastosList').getStore().loadPage(1);
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
		Ext.create('HreRem.view.administracion.gastos.AnyadirNuevoGasto',{parent: parent, nifEmisor: me.nifProveedorIdentificado}).show();
	                
    },
    
    onClickAutorizar: function(btn) {
    	var me = this,
    	listaGastos = btn.up('gridBase');
    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.autorizar.gastos.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		        if (buttonId == 'yes') {
					var gastos = listaGastos.getPersistedSelection(),
					url =  $AC.getRemoteUrl('gastosproveedor/autorizarGastos'),		
					idsGasto = [];
					
					// Recuperamos todos los ids de los trabajos seleccionados
					Ext.Array.each(gastos, function(gasto, index) {
					    idsGasto.push(gasto.get("id"));
					});
	
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
	
					Ext.Ajax.request({
				    			
					     url: url,
					     params: {idsGasto: idsGasto},
					
					     success: function(response, opts) {
					         me.getView().unmask();		         
					         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
					         listaGastos.getStore().loadPage(1);
					     },
					     failure: function(response) {
					     	me.getView().unmask();
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
					     }
				    		    
				    });
		        }
		   }
		});
    	
    	
    	
    },
    
    onClickRechazar: function(btn) {
    	
    	var me = this,
    	listaGastos = btn.up('gridBase');
    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.rechazar.gastos.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
 				if (buttonId == 'yes') {
 					
 					var combo = Ext.create("HreRem.view.common.ComboBoxFieldBase", {
 						addUxReadOnlyEditFieldPlugin: false, store: {model: 'HreRem.model.ComboBase',proxy: {type: 'uxproxy',remoteUrl: 'generic/getDiccionario',extraParams: {diccionario: 'motivosRechazoHaya'}}}
 					});
 						
					HreRem.Msg.promptCombo(HreRem.i18n('title.motivo.rechazo'),"", function(btn, text){    
					    if (btn == 'ok'){
					    	
					    	var gastos = listaGastos.getPersistedSelection(),
							url =  $AC.getRemoteUrl('gastosproveedor/rechazarGastos'),		
							idsGasto = [];
							
							// Recuperamos todos los ids de los trabajos seleccionados
							Ext.Array.each(gastos, function(gasto, index) {
							    idsGasto.push(gasto.get("id"));
							});
			
							me.getView().mask(HreRem.i18n("msg.mask.loading"));
			
							Ext.Ajax.request({
						    			
							     url: url,
							     params: {idsGasto: idsGasto, motivoRechazo: text},
							
							     success: function(response, opts) {
							         me.getView().unmask();		         
							         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
							         listaGastos.getStore().loadPage(1);
							     },
							     failure: function(response) {
							     	me.getView().unmask();
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
							     }
						    		    
						    });
					    	 
							
					    }
		    		}, null, null, null, combo);
		        }
		   }
		});
    	
    }

});