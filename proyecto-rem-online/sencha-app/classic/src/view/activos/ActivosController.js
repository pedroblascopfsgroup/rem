Ext.define('HreRem.view.activos.ActivosController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.activos',

    
   	
    // Funcion para cuando hace click en una fila
    onActivosListDobleClick: function(grid, record) {        	       
    	var me = this;  
    	me.abrirDetalleActivo(record);   	        	
        	
    },    
    
	abrirDetalleActivo: function(record)  {
    	 var me = this;
    	 me.getView().fireEvent('abrirDetalleActivo', record);
    	 
    },  

    //Funcion que se ejecuta al hacer click en el botón buscar
	
	onSearchClick: function(btn) {
		
		var me = this;
		this.lookupReference('activoslist').getStore().loadPage(1);
        
	},	
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('activossearch');
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
		config.url= $AC.getRemoteUrl("activo/generateExcel");
		//config.params = {};
		//config.params.idProcess = this.getView().down('grid').selection.data.id;
		
		me.fireEvent("downloadFile", config);		
    	
    	
		},
		    
		onClickCrearTrabajo: function (btn) {
			
		  	var me = this;
		  	var idActivo = me.getViewModel().get("activo.id");
		  	var idAgrupacion = me.getViewModel().get("agrupacionficha.id");
		  	var url= $AC.getRemoteUrl('trabajo/getSupervisorGestorTrabajo');
        	var data;
    		Ext.Ajax.request({
    		     url: url,
    		     params: {idActivo : idActivo, idAgrupacion : idAgrupacion},
    		     success: function(response, opts) {
    		    	 data = Ext.decode(response.responseText);
    		    	 me.getView().fireEvent('openModalWindow',"HreRem.view.trabajos.detalle.CrearTrabajo",{idActivo: null, idAgrupacion: null, idGestor: null, idSupervisor: data.data.id});
    		         
    		     },
    		     failure: function(response) {
    		    	 me.getView().fireEvent('openModalWindow',"HreRem.view.trabajos.detalle.CrearTrabajo",{idActivo: null, idAgrupacion: null, idUsuario: null});
    		     }
    		 });    	
		},

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
	}
});