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
    
    paramLoading: function(store, operation, opts) {
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
    
    // Función que abre la pestaña de proveedor.
	abrirPestañaProveedor: function(grid, record)  {
	   	 var me = this;
	   	 me.getView().fireEvent('abrirDetalleProveedor', record);
   },
    
    // Función que se ejecuta al hacer click en el botón Buscar.
	onSearchClick: function(btn) {
		var me = this;
		me.getViewModel().getData().configuracionproveedores.load(1);
	},
	
	// Función que se ejecuta al hacer click en el botón de Limpiar.
	onCleanFiltersClick: function(btn) {

		btn.up('panel').getForm().reset();
	},
    
	// Función que se ejecuta al hacer click en el botón de Exportar.
	onClickDescargarExcel: function(btn) {
		
    	var me = this,
		config = {};

		var initialData = {};

		var searchForm = btn.up('formBase');
		var params = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
		
		Ext.Object.each(params, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete params[key];
			}
		});
		
		config.params = params;
		config.url= $AC.getRemoteUrl("proveedores/generateExcelProveedores");
		
		me.fireEvent("downloadFile", config);		
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