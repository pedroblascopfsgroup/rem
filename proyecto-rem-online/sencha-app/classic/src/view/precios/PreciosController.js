Ext.define('HreRem.view.precios.PreciosController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.precios',

	onSearchManualClick: function(btn) {
		
		var me = this;
		me.lookupReference('generacionPropuestasActivosList').expand();	
		this.lookupReference('generacionPropuestasActivosList').getStore().loadPage(1);
        
	},
	
	onSearchHistoricoClick: function(btn) {
		
		var me = this;
		this.lookupReference('historicoPropuestasList').getStore().loadPage(1);
        
	},
	
	beforeLoadActivos: function(store, operation, opts) {
		
		var me = this,		
		searchForm = this.lookupReference('generacionPropuestasManual');
		
		if (searchForm.isValid()) {	
			
			store.getProxy().extraParams = me.getFormCriteria(searchForm);
			
			return true;		
		}
	},
	
	beforeLoadPropuestas: function(store, operation, opts) {
		
		var me = this,		
		searchForm = this.lookupReference('historicoPropuestasSearch');
		
		if (searchForm.isValid()) {	
			
			store.getProxy().extraParams = me.getFormCriteria(searchForm);
			
			return true;		
		}
	},	
	
	
	// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {			
		btn.up('form').getForm().reset();				
	},
	
	onClickExportar: function(btn) {
		
    	var me = this;
    	
    	var activeTab = me.getView().down("generacionpropuestastabpanel").getActiveTab();
    	switch (activeTab.xtype) {
    		
    		case 'generacionpropuestasmanual':
    			me.exportarExcelManual();
    			break;    		
    	}

    },
    
    onClickGenerarPropuesta: function(btn) {
    	
    	
    	var me = this;    	
    	var activeTab = me.getView().down("generacionpropuestastabpanel").getActiveTab();

		switch (activeTab.xtype) {
	
    		case 'generacionpropuestasmanual':
    			me.generarPropuestaManual();
    			break;    		
    	}

    },
	
    exportarExcelManual: function() {
		
    	var me = this,
		config = {};
		
		var searchForm = this.lookupReference('generacionPropuestasManual');
		
		if (searchForm.isValid()) {
			var params = me.getFormCriteria(searchForm);
        }
		
		config.params = params;
		config.url= $AC.getRemoteUrl("precios/generateExcelSeleccionManual");
		
		me.fireEvent("downloadFile", config);		
    	
    },    
    
    generarPropuestaManual: function() {
    	
    	var me = this,
    	config = {},
    	searchForm = this.lookupReference('generacionPropuestasManual');
    	
    	if(Ext.isEmpty(searchForm.down("[name=entidadPropietariaCodigo]").getValue())
    		|| Ext.isEmpty(searchForm.down("[name=tipoPropuestaCodigo]").getValue())) {
    		
			 me.fireEvent("warnToast", HreRem.i18n("msg.falta.filtro.propuesta.precios.manual"));   		
    			
    		
    	} else {    	
    	
	    	var messageBox = Ext.Msg.prompt(HreRem.i18n('title.generar.propuesta'),"<span class='txt-guardar-propuesta'>" + HreRem.i18n('txt.aviso.guardar.propuesta') + "</span>", function(btn, text){
			    if (btn == 'ok'){
			    	if (searchForm.isValid()) {
						var params = me.getFormCriteria(searchForm);
			        }        
			        params.nombrePropuesta = text;
			        
			        config.params = params;
					config.url= $AC.getRemoteUrl('precios/generarPropuestaManual'),
					
					me.fireEvent("downloadFile", config);
			    }
	    	});
	
			messageBox.textField.maskRe=/^[a-z0-9\s_/]+$/;
			messageBox.textField.mon(messageBox.textField.el, 'keypress', messageBox.textField.filterKeys, messageBox.textField);
    	
    	
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
    }

});