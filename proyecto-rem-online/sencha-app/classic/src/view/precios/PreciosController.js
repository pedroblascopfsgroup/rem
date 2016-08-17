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

			var activeTab = me.getView().down("generacionpropuestastabpanel").getActiveTab();
	    	switch (activeTab.xtype) {
	    		
	    		case 'generacionpropuestasmanual':
	    			store.getProxy().extraParams = me.getFormCriteria(searchForm);
	    			break;
	    			
	    		case 'generacionpropuestasautomatica':
	    			store.getProxy().extraParams = {entidadPropietariaCodigo: me.entidadPropietariaCodigo, tipoPropuestaCodigo: me.tipoPropuestaCodigo}
	    			break;
	    	}	
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
    			
    		case 'generacionpropuestasautomatica':
    			me.exportarExcelAutomatica();
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
    			
    		case 'generacionpropuestasautomatica':
    			me.generarPropuestaAutomatica();
    			break;
    	}

    },
	
    exportarExcelManual: function() {
		
    	var me = this;
		var searchForm = this.lookupReference('generacionPropuestasManual');
		
		if (searchForm.isValid()) {
			var params = me.getFormCriteria(searchForm);
        }
		
		me.realizarExportacionExcel(params,me);

    },    
    
    generarPropuestaManual: function() {
    	
    	var me = this,
    	searchForm = this.lookupReference('generacionPropuestasManual');
    	
    	if(Ext.isEmpty(searchForm.down("[name=entidadPropietariaCodigo]").getValue())
    		|| Ext.isEmpty(searchForm.down("[name=tipoPropuestaCodigo]").getValue())) {
    		
			 me.fireEvent("warnToast", HreRem.i18n("msg.falta.filtro.propuesta.precios.manual"));   		
    			
    	} else {    	
    	
    		if (searchForm.isValid()) {
				var params = me.getFormCriteria(searchForm);
	        }   
    		
    		me.realizarGeneracionPropuesta(params);
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
    },
    
    //HREOS-641 Funcion que abre listado activos al seleccionar una propuesta del huistorico
    onPropuestaPrecioListClick: function() {
    	
    	var me = this;
		me.lookupReference('historicoPropuestaActivosList').expand();	
		this.lookupReference('historicoPropuestaActivosList').getStore().loadPage(1);
    },
    
    beforeLoadActivosByPropuesta: function(store, operation, opts) {
		
		var me = this;		
		var idPropuesta = me.getViewModel().get('historicoPropuestasList').selection.id;
		
		if(idPropuesta != null) {
			store.getProxy().extraParams = {idPropuesta: idPropuesta};	
			
			return true;
		}
	},
	
	//HREOS-639 Identifica la celda seleccionada (col,fila) del grid de generacionPropuestasAutomatica
	cellClickPropuestaPrecioInclusionAutomatica: function(view, td, cellIndex, record, tr, rowIndex, e, eOpts) {
		
		var me = this;	
		
		if(cellIndex != 0 && cellIndex != 1) {
			this.tipoPropuestaCodigo = me.tipoPropuestaByColumnaSeleccionadaAutomatica(cellIndex);
			this.entidadPropietariaCodigo = record.data.entidadPropietariaCodigo;
			
			me.lookupReference('generacionPropuestasActivosList').expand();	
			this.lookupReference('generacionPropuestasActivosList').getStore().loadPage(1);	
		}
	},

	//HREOS-639 Devuelve Codigo Propuesta Segun la columna seleccionada en el grid del tab Inclusion Automatica
	tipoPropuestaByColumnaSeleccionadaAutomatica: function(col) {
		
		switch(col) {
			case 2:
				return "01";//Preciar
				break;
			case 3:
				return "02";//Repreciar
				break;
			case 4:
				return "03";//De descuento (oculta)
				break;
		}
	},
	
	//HREOS-639 Generacion de propuesta automatica (segun celda seleccionada, tendra un propietario y un tipo propuesta)
	generarPropuestaAutomatica: function() {
		
		var me = this,
    	params = {};
		
		params.entidadPropietariaCodigo = me.entidadPropietariaCodigo;
    	params.tipoPropuestaCodigo = me.tipoPropuestaCodigo;
    	
    	me.realizarGeneracionPropuesta(params);	
	},
	
	exportarExcelAutomatica: function() {
		
		var me = this,
		params = {};
		
		params.entidadPropietariaCodigo = me.entidadPropietariaCodigo;
    	params.tipoPropuestaCodigo = me.tipoPropuestaCodigo;
		
    	me.realizarExportacionExcel(params,me);
		
			
	},
	
	realizarExportacionExcel: function(params, me) {
		
		var config = {};
		
		config.params = params;
		config.url= $AC.getRemoteUrl("precios/generateExcelSeleccionManual");
		
		me.fireEvent("downloadFile", config);
    },    
	
	//HREOS-639 llamada a generar propuesta (manual y automatica usan la misma llamada)
	realizarGeneracionPropuesta: function(params) {
		
		var me=this,
		config = {};
		
		var messageBox = Ext.Msg.prompt(HreRem.i18n('title.generar.propuesta'),"<span class='txt-guardar-propuesta'>" + HreRem.i18n('txt.aviso.guardar.propuesta') + "</span>", function(btn, text){
		    if (btn == 'ok'){
		    	
		    	params.nombrePropuesta = text;
		        
		        config.params = params;
				config.url= $AC.getRemoteUrl('precios/generarPropuestaManual'),
				
				me.fireEvent("downloadFile", config);
		    }
    	});

		messageBox.textField.maskRe=/^[a-z0-9\s_/]+$/;
		messageBox.textField.mon(messageBox.textField.el, 'keypress', messageBox.textField.filterKeys, messageBox.textField);
	}

});