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
    },
    
    // Este método comprueba las fechas mientras se define una nueva agrupación de tipo asistida.
    validateFechas: function(field) {
    	var me = this;
		var grid = field.up('agrupacionesmain').lookupReference('agrupacioneslist')
		if(Ext.isEmpty(grid)){ return true;}
		var selected = grid.getSelectionModel().getSelection();

		// Obtener columnas automáticamente por 'dataindex = fechaFinVigencia' y 'dataindex = fechaInicioVigencia'.
		var fechaFinActualRow = grid.columns[Ext.Array.indexOf(Ext.Array.pluck(grid.columns, 'dataIndex'), 'fechaFinVigencia')];
		var fechaInicioActualRow = grid.columns[Ext.Array.indexOf(Ext.Array.pluck(grid.columns, 'dataIndex'), 'fechaInicioVigencia')];

		// Obtener valores.
		var fechaInicio = fechaInicioActualRow.getEditor().value;
		var fechaFin = fechaFinActualRow.getEditor().value;

		if(!Ext.isEmpty(fechaInicio) && !Ext.isEmpty(fechaFin) && (fechaFin < fechaInicio)) {
			return HreRem.i18n('info.fecha.vigencia.agrupacion.asistida.msg.validacion');
		}

		return true;
    },
    
    onChangeChainedCombo: function(combo) {
    	var me = this,
    	chainedCombo = me.lookupReference(combo.chainedReference);   
    	
    	me.getViewModel().notify();
    	if(!Ext.isEmpty(chainedCombo.getValue())) {
			chainedCombo.clearValue();
    	}
    	
    	if(combo.chainedStore == 'comboSubcarteraFiltered'){
			var store=chainedCombo.getStore(); 
			store.getProxy().setExtraParams({'idCartera':combo.getValue()});
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