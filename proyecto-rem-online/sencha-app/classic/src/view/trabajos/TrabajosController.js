Ext.define('HreRem.view.trabajos.TrabajosController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.trabajos',
    
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

			this.lookupReference('trabajoslist').getStore().loadPage(1);
        }
	},
	
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('trabajossearch');
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
    onTrabajosListDobleClick: function(grid, record) {        	       
    	var me = this;    	
    	me.abrirDetalleTrabajo(record);   	        	
        	
    },
    
	
    
    onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
    	var me = this;
    	
    	var grid = tableView.up('grid');

    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);
    	
    	if(record.get("tipoEntidad")=='agrupaciones'){
    		var idAgrupacion = record.get("numAgrupacionRem");
    		
    		me.redirectTo('activos', true);

        	me.getView().fireEvent('abrirDetalleAgrupacionByNum', idAgrupacion);
    	}else{
    		var idActivo = record.get("idActivo");
        	
        	me.redirectTo('activos', true);

        	me.getView().fireEvent('abrirDetalleActivo', idActivo);
    	}
    	
    	
    	
    },
    
    
    
	abrirDetalleTrabajo: function(record)  {
    	 var me = this;
    	 me.getView().fireEvent('abrirDetalleTrabajo', record);
    	 
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
		
		config.params = params;
		config.url= $AC.getRemoteUrl("trabajo/generateExcel");
		var url = $AC.getRemoteUrl("trabajo/registrarExportacion");
		Ext.Ajax.request({			
		     url: url,
		     params: params,
		     method: 'POST'
		    ,success: function (a, operation, context) {
		    	var count = Ext.decode(a.responseText).data;
		    	var limite = Ext.decode(a.responseText).limite;
		    	var limiteMax = Ext.decode(a.responseText).limiteMax;
		    	if(count < limite){
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
		        		title: 'Exportar trabajos',
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
    	
    	
    }    

    
});