Ext.define('HreRem.view.agrupaciones.AgrupacionesController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.agrupaciones',
    
  //Funcion que se ejecuta al hacer click en el botón buscar
	onSearchClick: function(btn) {
		
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		if (searchForm.isValid()) {
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});
			this.lookupReference('agrupacioneslist').getStore().loadPage(1);
        }
	},
	
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('agrupacionessearch');
		if (searchForm.isValid()) {
			
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
		
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},
	
	
	// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {

		btn.up('panel').getForm().reset();
			
	},
	
	// Funcion para cuando hace click en una fila
    onAgrupacionesListDobleClick: function(grid, record) {       
    	var me = this;    	
    	me.abrirDetalleAgrupacion(record);   	        	
        	
    },
    
    
	abrirDetalleAgrupacion: function(record)  {
    	 var me = this;
    	 me.getView().fireEvent('abrirDetalleAgrupacion', record);
    	 
    },
    
    onClickDescargarExcel: function(btn) {
		
    	var me = this,
		config = {};
		
		
		
		var initialData = {};

		var searchForm = btn.up('formBase');
		if (searchForm.isValid()) {
			var params = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(params, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete params[key];
				}
			});
        }
		
		config.params = params;
		config.url= $AC.getRemoteUrl("agrupacion/generateExcel");
		//config.params = {};
		//config.params.idProcess = this.getView().down('grid').selection.data.id;
		
		me.fireEvent("downloadFile", config);		
    	
    	
    }    

    
});