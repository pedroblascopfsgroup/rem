Ext.define('HreRem.view.administracion.AdministracionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.administracion',

	//Funcion que se ejecuta al hacer click en el botón buscar
//	onSearchClick: function(btn) {
//		var initialData = {};
//
//		var searchForm = btn.up('formBase');
//		
//		if (searchForm.isValid()) {
//			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
//			
//			Ext.Object.each(criteria, function(key, val) {
//				if (Ext.isEmpty(val)) {
//					delete criteria[key];
//				}
//			});
//			this.lookupReference('visitasComercialList').getStore().loadPage(1);
//        }
//	},
	
	paramLoading: function(store, operation, opts) {
//		var initialData = {};
//		
//		var searchForm = this.lookupReference('visitasComercialSearch');
//		if (searchForm.isValid()) {
//			
//			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
//			
//			Ext.Object.each(criteria, function(key, val) {
//				if (Ext.isEmpty(val)) {
//					delete criteria[key];
//				}
//			});	
//		
//			store.getProxy().extraParams = criteria;
//			
//			return true;		
//		}
	},
	
	onClickAbrirGastoProveedor: function(grid, record){
		var me = this;
		
    	me.getView().fireEvent('abrirDetalleGasto', record);
		
	}
	
		// Funcion que se ejecuta al hacer click en el botón limpiar
//	onCleanFiltersClick: function(btn) {			
//		btn.up('form').getForm().reset();				
//	},
	
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

});