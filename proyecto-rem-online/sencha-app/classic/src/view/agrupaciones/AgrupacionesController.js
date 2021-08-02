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
	
	esAgrupacionPromocionAlquiler: function(btn) {
		return true;
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
		this.getStore('agrupaciones').sorters.clear();
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
		config.url= $AC.getRemoteUrl("agrupacion/generateExcel");
		var url = $AC.getRemoteUrl("agrupacion/registrarExportacion");
		Ext.Ajax.request({			
		     url: url,
		     params: params,
		     method: 'POST'
		    ,success: function (a, operation, context) {
		    	var count = Ext.decode(a.responseText).data;
		    	var limite = Ext.decode(a.responseText).limite;
		    	var limiteMax = Ext.decode(a.responseText).limiteMax;
		    	var msg = Ext.decode(a.responseText).msg;
		    	if(!Ext.isEmpty(msg)){
		    		me.fireEvent("errorToastLong", HreRem.i18n("msg.error.export") + msg);
		    		view.unmask();
		    	} else {
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
			        		title: 'Exportar agrupaciones',
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

    },

onChangeTipoAgrupacion: function(combo, records) {
	var me = this,
	comboTipo = me.lookupReference(combo.reference);   
	comboTipoAlquiler = me.lookupReference('comboTipoAlquiler');
	
	if(comboTipo.getValue() == CONST.TIPOS_AGRUPACION['COMERCIAL_ALQUILER'] ){
		comboTipoAlquiler.show();
	}else{
		comboTipoAlquiler.hide();
		comboTipoAlquiler.clearValue();
	}
},
    onSearchBusquedaDirectaAgrupaciones: function(btn) {

    	var me = this;
    	var numAgrupacion = btn.up('agrupacionessearch').down('[name="numAgrupacionRem"]').value;
   		var url= $AC.getRemoteUrl('agrupacion/getAgrupacionExists');
    	var data;
    			
		if(numAgrupacion != ""){
			Ext.Ajax.request({
				url: url,
			    params: {numAgrupacion : numAgrupacion},
			    success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
			    	if(data.success == "true"){
			    		var titulo = "Agrupación " + numAgrupacion;
			    		me.getView().fireEvent('abrirDetalleAgrupacionDirecto', data.data, titulo);
			    	}else{
			    		me.fireEvent("errorToast", data.error);
			    	}
			    		         
			    },
			    failure: function(response) {
			    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    }
			});    
		}
	
    },
	
	onChangeNumAgrupacion: function(me, oValue, nValue){
		var numAgrupacion = me.up('agrupacionessearch').down('[name="numAgrupacionRem"]').value;
		var btn = me.up('agrupacionessearch').down('[reference="btnAgrupacion"]');
		
		if(numAgrupacion != ""){
			btn.setDisabled(false);
		}else{
			btn.setDisabled(true);
		}
	}
});