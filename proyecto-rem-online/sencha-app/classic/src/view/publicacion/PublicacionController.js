Ext.define('HreRem.view.publicacion.PublicacionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.publicaciones',

	// Función que se ejecuta al hacer click en el botón Buscar.
	onSearchClick: function(btn) {
		
		var me = this;
		me.getViewModel().data.activospublicacion.load(1);
		
	},
	
	// Función que se ejecuta al hacer click en el botón de Limpiar.
	onCleanFiltersClick: function(btn) {
		var form = btn.up('panel').getForm();
		
		form.reset();

		form.findField('admision').setValue(false);
		form.findField('gestion').setValue(false);
		form.findField('estadoPublicacionCodigo').setValue(null);
		form.findField('estadoPublicacionAlquilerCodigo').setValue(null);
		
	},
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		var searchForm = this.getReferences().ActivosPublicacionSearch;
		var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
		
		Ext.Object.each(criteria, function(key, val) {
			if (Ext.isEmpty(val)) {
				delete criteria[key];
			}
		});	

		store.getProxy().extraParams = criteria;
		
		return true;

	},
	
	// Función que se ejecuta cuando se realiza doble click en un elemento del grid.
	onActivosPublicacionListDobleClick: function(grid, record) {       
    	var me = this;    	
    	me.abrirPestañaPublicacionActivo(record);
	},
	
	// Función que abre la pestaña de Publicación del activo.
	abrirPestañaPublicacionActivo: function(record)  {
	   	 var me = this;
	   	 me.getView().fireEvent('abrirDetalleActivoPrincipal', record);
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
		params.buscador = 'publicaciones';
		config.params = params;
		config.url= $AC.getRemoteUrl("activo/generateExcelPublicaciones");
		var url = $AC.getRemoteUrl("activo/registrarExportacionPublicaciones");
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
		        		title: 'Exportar publicaciones',
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
    },
    
	// Función para que el combo "Motivos de ocultación" del "Estado publicación Venta" 
	// se oculte cuando se selecciona "Oculto Venta".
    hiddenMotivosOcultacionVenta: function() {

		var me = this;
		var estadoPublicacionVenta = me.getViewModel().get('estadoPublicacionVenta');
		var motivosOcultacionVenta = me.lookupReference('motivosOcultacionVenta');
		
    	if (!Ext.isEmpty(estadoPublicacionVenta.selection) && estadoPublicacionVenta.selection.data.codigo == CONST.ESTADO_PUBLICACION_VENTA['OCULTO']){
    		motivosOcultacionVenta.setHidden(false);
    	} else {
    		motivosOcultacionVenta.setHidden(true);
	    }
	},
	
	// Función para que el combo "Motivos de ocultación" del "Estado publicación Alquiler" 
	// se oculte cuando se selecciona "Oculto Alquiler".
	hiddenMotivosOcultacionAlquiler: function() {

		var me = this;
		var estadoPublicacionAlquiler = me.getViewModel().get('estadoPublicacionAlquiler');
		var motivosOcultacionAlquiler = me.lookupReference('motivosOcultacionAlquiler');

    	if (!Ext.isEmpty(estadoPublicacionAlquiler.selection) && estadoPublicacionAlquiler.selection.data.codigo == CONST.ESTADO_PUBLICACION_ALQUILER['OCULTO']){
    		motivosOcultacionAlquiler.setHidden(false);
    	} else {
    		motivosOcultacionAlquiler.setHidden(true);
	    }	
    },
	
    onChangeChainedCombo: function(combo) {
		var me = this,
		chainedCombo = me.lookupReference(combo.chainedReference);   

		me.getViewModel().notify();

		if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
		}
		
		if(combo.chainedStore == 'comboSubfasePublicacion'){
			var store=chainedCombo.getStore(); 
			store.getProxy().setExtraParams({'codFase':combo.getValue()});
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