Ext.define('HreRem.view.comercial.ComercialVisitasController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.comercialvisitas',
    
    requires: ['HreRem.view.comercial.visitas.VisitasComercialDetalle'],

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
			this.lookupReference('visitasComercialList').getStore().loadPage(1);
        }
	},
	
	paramLoading: function(store, operation, opts) {
		var initialData = {};
		
		var searchForm = this.lookupReference('visitasComercialSearch');
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
		params.buscador = 'visitas';
		config.params = params;		
		config.url= $AC.getRemoteUrl("visitas/generateExcel");
		var url = $AC.getRemoteUrl("visitas/registrarExportacion");
		Ext.Ajax.request({			
		     url: url,
		     params: params,
		     method: 'POST'
		    ,success: function (a, operation, context) {
		    	var count = Ext.decode(a.responseText).data;
		    	if(count < 1000){
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
		        		title: 'Exportar visitas',
		        		height: 150,
		        		width: 700,
		        		modal: true,
		        		config: config,
		        		params: params,
		        		url: url,
		        		count: count,
		        		view: view,
		        		renderTo: view.body		        		
		        	});
		        	win.show();
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
    
    onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    var idActivo = record.get("idActivo");
	    me.redirectTo('activos', true);
	    me.getView().fireEvent('abrirDetalleActivo', record);
    	
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
	}

});