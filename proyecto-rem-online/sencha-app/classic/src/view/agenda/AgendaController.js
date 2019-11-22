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
    
    onClickDescargarExcel: function(btn,buscador) {
		
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
		if(buscador == 'avisos'){
			params.codigoTipoTarea = "3";
		}else{
			params.codigoTipoTarea = "1";
		}		
		if(buscador == 'alertas'){
			params.esAlerta = true;
		}else{
			params.esAlerta = false;
		}
		params.buscador = buscador;
		config.params = params;
		config.url= $AC.getRemoteUrl("agenda/generateExcel");
		var url = $AC.getRemoteUrl("agenda/registrarExportacion");
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
		        		title: 'Exportar '+buscador,
		        		height: 150,
		        		width: 700,
		        		modal: true,
		        		config: config,
		        		count: count,
		        		params: params,
		        		url: url,
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
    onClickDescargarExcelTareas: function(btn) {
		var me = this;
    	me.onClickDescargarExcel(btn, 'tareas');
    	
    },
    
    onClickDescargarExcelAvisos: function(btn) {
		var me = this;
    	me.onClickDescargarExcel(btn, 'avisos');   	
    	
    },
    
    onClickDescargarExcelAlertas: function(btn) {		
		var me = this;
    	me.onClickDescargarExcel(btn, 'alertas');
    	
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