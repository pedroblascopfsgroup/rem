Ext.define('HreRem.view.configuracion.ConfiguracionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.configuracion',
    
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
    
    onChangeTipoProveedorChainedCombo: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
    	if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
    	}
		
    	var chainedStore = chainedCombo.getStore();
    	
    	if(!Ext.isEmpty(chainedStore)) {
    		chainedStore.getProxy().extraParams = {
    			'codigoTipoProveedor' : combo.getValue()
    		}
    		
	    	chainedStore.load({
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
    	}
    	
		if (me.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
    },
    
    onChangeCarteraTestigosChainedCombo: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
    	if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
    	}
		
    	var chainedStore = chainedCombo.getStore();
    	
    	if(!Ext.isEmpty(chainedStore)) {
    		chainedStore.getProxy().extraParams = {
    			'idCartera' : combo.getValue()
    		}
    		
	    	chainedStore.load({
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
    	}
    	
		if (me.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
    },

	onChangeCarteraRecomendacionChainedCombo: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);    	
    	me.getViewModel().notify();
    	if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
    	}
		
    	var chainedStore = chainedCombo.getStore();
    	
    	if(!Ext.isEmpty(chainedStore)) {
    		chainedStore.getProxy().extraParams = {
    			'idCartera' : combo.getValue()
    		}
    		
	    	chainedStore.load({
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
    	}
    	
		if (me.lookupReference(chainedCombo.chainedReference) != null) {
			var chainedDos = me.lookupReference(chainedCombo.chainedReference);
			if(!chainedDos.isDisabled()) {
				chainedDos.clearValue();
				chainedDos.getStore().removeAll();
				chainedDos.setDisabled(true);
			}
		}
    },
    
    paramLoadingProveedores: function(store, operation, opts) {
		var initialData = {};
		var searchForm = this.getReferences().configuracionProveedoresFiltros;
		var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
		
		Ext.Object.each(criteria, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete criteria[key];
			}
		});

		store.getProxy().extraParams = criteria;
		
		return true;
	},
	
	paramLoadingGestoresSustitutos: function(store, operation, opts) {
		var initialData = {};
		var searchForm = this.getReferences().configuracionGestoresSustitutosFiltros;
		var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
		
		Ext.Object.each(criteria, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete criteria[key];
			}
		});

		store.getProxy().extraParams = criteria;
		
		return true;
	},
	
	paramLoadingPerfiles: function(store, operation, opts) {
		var initialData = {};
		var searchForm = this.getReferences().configuracionPerfilesBusqueda;
		var itemSelector = this.getReferences().itemselFunciones; 
		var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
		
		Ext.Object.each(criteria, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete criteria[key];
			}
		});	

		store.getProxy().extraParams = criteria;
		return true;
	},
    
    // Función que abre la pestaña de proveedor.
	abrirPestanyaProveedor: function(grid, record)  {
	   	 var me = this;
	   	 me.getView().fireEvent('abrirDetalleProveedor', record);
	},
	
	abrirPestanyaPerfil: function(grid, record)  {
	   	 var me = this;
	   	 me.getView().fireEvent('abrirDetallePerfil', record);
	},
    
    // Función que se ejecuta al hacer click en el botón Buscar.
	onSearchProveedoresClick: function(btn) {
		var me = this;
		me.getViewModel().getData().configuracionproveedores.load(1);
	},
	 
	// Función que se ejecuta al hacer click en el botón Buscar.
	onSearchGestoresSustitutosClick: function(btn) {
		var me = this;
		me.getViewModel().getData().configuraciongestoressustitutos.load(1);
	},
	
	onSearchPerfilesClick: function(btn) {
		var me = this;
		me.getViewModel().getData().configuracionperfiles.load(1);
	},
	
	// Función que se ejecuta al hacer click en el botón de Limpiar.
	onCleanFiltersClick: function(btn) {

		btn.up('panel').getForm().reset();
	},
    
	// Función que se ejecuta al hacer click en el botón de Exportar.
	onClickDescargarExcel: function(btn) {
		var me = this,
    	view = me.getView(),
		config = {};	
		
		var initialData = {};
		view.mask(HreRem.i18n("msg.mask.loading"));
		var searchForm = btn.up('formBase');
		if (searchForm.isValid()) {
			var params = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(params, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete params[key];
				}
			});
        }
		params.buscador = 'proveedores';
		config.params = params;		
		config.url= $AC.getRemoteUrl("proveedores/generateExcelProveedores");
		var url = $AC.getRemoteUrl("proveedores/registrarExportacion");
		Ext.Ajax.request({			
		     url: url,
		     params: params,
		     method: 'POST'
		    ,success: function (a, operation, context) {
		    	var count = Ext.decode(a.responseText).data;
		    	var limite = Ext.decode(a.responseText).limite;
		    	var limiteMax = Ext.decode(a.responseText).limiteMax;
		    	var msg = Ext.decode(a.responseText).msg;
		    	if(!Ext.isEmpty(msg)){
		    		me.fireEvent("errorToastLong", HreRem.i18n("msg.error.export") + msg);
		    		view.unmask();
		    	} else {
			    	if(Number(count) < Number(limite)){
			    		config.params.exportar = true;
			    		Ext.Ajax.request({			
			   		     url: url,
					     params: params,
					     method: 'POST'
					    ,success: function (a, operation, context) {
					    	me.fireEvent("downloadFile", config);
				    		view.unmask();
			           },           
			           failure: function (a, operation, context) {
			           	  Ext.toast({
							     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACI\u00d3N',
							     width: 360,
							     height: 100,
							     align: 't'
							 });
			           	  view.unmask();
			           }
				     
					});
			    	}else {
			    		var win = Ext.create('HreRem.view.common.WindowExportar', {
			        		title: 'Exportar proveedores',
			        		height: 150,
			        		width: 700,
			        		modal: true,
			        		config: config,
			        		params: params,
			        		url: url,
			        		count: count,
			        		limiteMax: limiteMax,
			        		view: view,
			        		renderTo: view.body		        		
			        	});
			        	win.show();
			    	}
		    	}
           },           
           failure: function (a, operation, context) {
           	  Ext.toast({
				     html: 'NO HA SIDO POSIBLE REALIZAR LA OPERACI\u00d3N',
				     width: 360,
				     height: 100,
				     align: 't'
				 });
           	  view.unmask();
           }
	     
		});
    },
	
    // Funcion que se ejecuta al hacer click en el botón limpiar del formulario.
	onCleanFiltersClick: function(btn) {			
		btn.up('form').getForm().reset();				
	},
	
	// Recupera el id por su nif de un nuevo proveedor creado, y abre su ficha
	openProveedorByNif: function(nif) {
		var me = this,
		url = $AC.getRemoteUrl("proveedores/getIdProveedorByNif");
		var parameters = {};
		parameters.nifProveedor = nif;
		
		Ext.Ajax.request({
			url:url,
			params: parameters,
			success: function(response,opts){
				var idProveedorNuevo = Ext.decode(response.responseText).id;
				var codigoProveedorNuevo = Ext.decode(response.responseText).codigo;
				var record = Ext.create('Ext.data.Model',{'id':idProveedorNuevo, 'codigo':codigoProveedorNuevo});

				me.getView().fireEvent('abrirDetalleProveedor', record);
			}
		});
		
	}
});