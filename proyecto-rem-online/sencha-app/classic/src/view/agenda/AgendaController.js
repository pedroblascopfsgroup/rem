Ext.define('HreRem.view.agenda.AgendaController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.agenda',
    
  //Funcion que se ejecuta al hacer click en el botón buscar
	onSearchClick: function(btn) {
		
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		var store = this.getViewModel().get('tareas');
		
		if (searchForm.isValid()) {
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});
			this.lookupReference('agendalist').reconfigure(store)
			this.lookupReference('agendaPaginator').setStore(store);
			this.lookupReference('agendalist').getStore().loadPage(1);
        }
	},
	
	//Funcion que se ejecuta al hacer click en el botón buscar
	onSearchAlertasClick: function(btn) {
		
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		if (searchForm.isValid()) {
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});

			this.lookupReference('agendaalertaslist').getStore().loadPage(1);
        }
	},
	
	//Funcion que se ejecuta al hacer click en el botón buscar
	onSearchAvisosClick: function(btn) {
		
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		if (searchForm.isValid()) {
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});

			this.lookupReference('agendaavisoslist').getStore().loadPage(1);
        }
	},
	
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('agendasearch');
		if (searchForm.isValid()) {
			
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
			
			criteria['codigoTipoTarea'] = '1';
			criteria['esAlerta'] = false;
			
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},
	
	paramLoadingAlertas: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('agendaalertassearch');
		if (searchForm.isValid()) {
			
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
		
			criteria['esAlerta'] = true;
			criteria['codigoTipoTarea'] = '1';
			
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},
	
	
	paramLoadingAvisos: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('agendaavisossearch');
		if (searchForm.isValid()) {
			
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
		
			criteria['codigoTipoTarea'] = '3';
			criteria['esAlerta'] = false;
			
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},
	
	
	// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {

		btn.up('panel').getForm().reset();
			
	},
	
    
    onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {

    	var me = this;
    	var grid = tableView.up('grid');

    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);

    	me.getView().fireEvent('abriractivo', record);

    	
    },
    
    onAgendaListDobleClick: function(gridView, record) {
    	var me = this;
    	me.getView().fireEvent('abrirtarea', record, gridView.up('grid'), me.getView());   	
    	
    },
	
    
    onEnlaceTareasClick: function(tableView, indiceFila, indiceColumna) {
    	
    	var me = this;
    	var grid = tableView.up('grid');

    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);
    	
    	me.getView().fireEvent('abrirtarea', record, tableView.up('grid'), me.getView());
    	//grid.fireEvent("abrirtarea", record);	
    	
    },
    
    onNotificacionClick: function(){
    	var me = this;
    	me.getView().fireEvent('nuevanotificacion');
    },
    
    onAgendaTreeSelectionChange: function (tree, node) {
    	
    	var me = this;
    	me.getView().lookupReference("agendaContainer").getLayout().setActiveItem(node.data.card);

    	
    },
    
    onCambiarCalendario: function () {
    	
    	var me = this;
    	var layout = this.getView().down('agendacardwidget').getLayout();
    	
    	if (layout.calcCount == 3) {
    		layout["prev"]();
    		this.getView().lookupReference('botonCambiarCalendario').setText("Listado");
    		this.getView().lookupReference('botonCambiarCalendario').setIcon("resources/images/ico_tareas_active.svg");
    	} else {
    		layout["next"]();
    		this.getView().lookupReference('botonCambiarCalendario').setText("Calendario");
    		this.getView().lookupReference('botonCambiarCalendario').setIcon("resources/images/calendario.svg");
    	}
    	
    },
    
    onChangeChainedCombo: function(combo) {
    	
    	var me = this;
    	chainedCombo = me.lookupReference(combo.chainedReference);
		chainedCombo.clearValue("");
		me.getViewModel().notify();
		me.getViewModel().getStore(combo.chainedStore).load(); 	
    	
    },
    
    onClickDescargarExcelTareas: function(btn) {
		
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
		
		params.codigoTipoTarea = "1";
		params.esAlerta = false;
		config.params = params;
		config.url= $AC.getRemoteUrl("agenda/generateExcel");
		
		me.fireEvent("downloadFile", config);		
    	
    	
    },
    
    onClickDescargarExcelAvisos: function(btn) {
		
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
		
		params.codigoTipoTarea = "1";
		params.esAlerta = false;
		config.params = params;
		config.url= $AC.getRemoteUrl("agenda/generateExcel");
		
		me.fireEvent("downloadFile", config);		
    	
    	
    },
    
    onClickDescargarExcelAlertas: function(btn) {
		
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
		
		params.codigoTipoTarea = "1";
		params.esAlerta = true;
		config.params = params;
		config.url= $AC.getRemoteUrl("agenda/generateExcel");
		
		me.fireEvent("downloadFile", config);		
    	
    	
    },
    
    onClickCargaTareasGestorSustituto: function(btn){

    	var initialData = {};

		var searchForm = btn.up('formBase');
		
		var store = this.getViewModel().get('tareasGestorSustituto');
		
		if (searchForm.isValid()) {
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});
			this.lookupReference('agendalist').reconfigure(store)
			this.lookupReference('agendaPaginator').setStore(store);
			this.lookupReference('agendalist').getStore().loadPage(1);
		}
    }
    
    
    
});