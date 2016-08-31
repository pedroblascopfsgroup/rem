Ext.define('HreRem.view.comercial.ComercialOfertasController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.comercialofertas',

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
			this.lookupReference('ofertasComercialList').getStore().loadPage(1);
        }
	},
	
	paramLoading: function(store, operation, opts) {
		var initialData = {};
		
		var searchForm = this.lookupReference('ofertasComercialSearch');
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
		btn.up('form').getForm().reset();				
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
		config.url= $AC.getRemoteUrl("ofertas/generateExcel");
		//config.params = {};
		//config.params.idProcess = this.getView().down('grid').selection.data.id;
		
		me.fireEvent("downloadFile", config);		
    	
    	
    },
	
	onClickAbrirActivoAgrupacion: function(tableView, indiceFila, indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    if(Ext.isEmpty(record.get('idAgrupacion'))){
	    	var idActivo = record.get("idActivo");
	   		me.redirectTo('activos', true);
	    	me.getView().fireEvent('abrirDetalleActivo', record);
	    }
	    else{
	    	var idAgrupacion = record.get("idAgrupacion");
	    	me.getView().fireEvent('abrirDetalleAgrupacion', record);
	    }
	
	},
	
	onClickAbrirExpedienteComercial: function(grid, rowIndex, colIndex) {
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	if(!Ext.isEmpty(record.get('numExpediente'))){
    		me.getView().fireEvent('abrirDetalleExpediente', record);
    	}
    	
    },
    
    onOfertasListDobleClick: function(grid,record,tr,rowIndex) {        	       
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	if(!Ext.isEmpty(record.get('numExpediente'))){
    		me.getView().fireEvent('abrirDetalleExpediente', record);
    	}
        	
    }

});