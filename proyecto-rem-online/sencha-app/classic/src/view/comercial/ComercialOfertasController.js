Ext.define('HreRem.view.comercial.ComercialOfertasController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.comercialofertas',

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
			this.lookupReference('ofertasComercialList').getStore().loadPage(1);
        }
	},
	
	onSearchBusquedaDirectaExpediente: function(btn) {

		var me = this;
		
		var numOferta = btn.up('ofertascomercialsearch').down('[name="numOferta"]').value;
		var numExpediente = btn.up('ofertascomercialsearch').down('[name="numExpediente"]').value;
		
		var url= $AC.getRemoteUrl('expedientecomercial/getExpedienteExists');
		var data;
		
		if(numExpediente != ""){
			Ext.Ajax.request({
				url: url,
			    params: {numBusqueda : numExpediente, campo : "E"},
			    success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
			    	if(data.success == "true"){
			    		var titulo = "Expediente " + data.numExpediente;
			    		me.getView().fireEvent('abrirDetalleExpedienteDirecto', data.data, titulo);
			    	}else{
			    		me.fireEvent("errorToast", data.error);
			    	}
			    		         
			    },
			    failure: function(response) {
			    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			    }
			});    
		}else{
			Ext.Ajax.request({
				url: url,
			    params: {numBusqueda : numOferta, campo : "O"},
			    success: function(response, opts) {
			    	data = Ext.decode(response.responseText);
			    	if(data.success == "true"){
			    		var titulo = "Expediente " + data.numExpediente;
			    		me.getView().fireEvent('abrirDetalleExpedienteDirecto', data.data, titulo);
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
	
	onChangeNumOfertaOExpediente: function(me, oValue, nValue){
		var numOferta = me.up('ofertascomercialsearch').down('[name="numOferta"]').value;
		var numExpediente = me.up('ofertascomercialsearch').down('[name="numExpediente"]').value;
		var btn = me.up('ofertascomercialsearch').down('[reference="btnExp"]');
		
		if(numExpediente != "" || numOferta != ""){
			btn.setDisabled(false);
		}else{
			btn.setDisabled(true);
		}
	},
	
	paramLoading: function(store, operation, opts) {
		var initialData = {};
		var searchForm = this.lookupReference('ofertasComercialSearch');
		if (searchForm.isValid()) {
			
			var criteria = Ext.apply(initialData, searchForm ? searchForm.getValues() : {});
			
			if(!Ext.isEmpty(criteria.tipoGestor) && searchForm.primeraCarga){
				if(!criteria.usuarioGestor){
					criteria.usuarioGestor=$AU.getUser().userId;
					searchForm.primeraCarga=false;				
				}
			}
			
			Ext.Object.each(criteria, function(key, val) {
				if (Ext.isEmpty(val)) {
					delete criteria[key];
				}
			});	
		
			store.getProxy().extraParams = criteria;
			
			return true;		
		}
	},
	
	controlErrorOfertas: function(a, records, success, operation, eOpts){
		if(!success){
			this.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		}
	},
	
		// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {
		btn.up('form').getForm().reset();
		var form = btn.up('form');
		
		var comboboxTipoAlquiler = form.up().lookupReference('comboExpedienteAlquiler');
		var comboboxTipoVenta = form.up().lookupReference('comboExpedienteVenta'); 
		
		comboboxTipoAlquiler.setDisabled(true);
		comboboxTipoVenta.setDisabled(true);
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
		params.buscador = 'ofertas';
		config.params = params;		
		config.url= $AC.getRemoteUrl("ofertas/generateExcel");
		var url = $AC.getRemoteUrl("ofertas/registrarExportacion");
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
			        		title: 'Exportar ofertas',
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
	
	onClickAbrirActivoAgrupacion: function(tableView, indiceFila, indiceColumna) {
		var me = this;
		var grid = tableView.up('grid');
	    var record = grid.store.getAt(indiceFila);
	    grid.setSelection(record);
	    if(Ext.isEmpty(record.get('numAgrupacion'))){
	    	var idActivo = record.get("idActivo");
	   		me.redirectTo('activos', true);
	    	me.getView().fireEvent('abrirDetalleActivo', record);
	    }
	    else{
	    	me.getView().fireEvent('abrirDetalleAgrupacion', record);
	    }
	
	},
	
	onClickAbrirExpedienteComercial: function(grid, rowIndex, colIndex) {
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	if(!Ext.isEmpty(record.get('numExpediente'))){
    		me.getView().fireEvent('abrirDetalleExpediente', record);
    	}
    	
    },
    
    onOfertasListDobleClick: function(grid,record,tr,rowIndex) {        	       
    	var me = this,
    	record = grid.getStore().getAt(rowIndex);
    	if(!Ext.isEmpty(record.get('numExpediente'))){
    		me.getView().fireEvent('abrirDetalleExpediente', record);
    	}
        	
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
    
    onClickAbrirVisita: function(grid, rowIndex, colIndex) {
    	var me = this,
	    record = grid.getStore().getAt(rowIndex),
	    numVisita = record.get('numVisita');

    	if(Ext.isEmpty(numVisita)) {
    		return;
    	}

    	me.getView().mask(HreRem.i18n("msg.mask.loading"));

		Ext.Ajax.request({
    		url: $AC.getRemoteUrl('visitas/getVisitaDetalleById'),
    		params: {numVisitaRem: numVisita},
    		
    		success: function(response, opts){
    			var record = JSON.parse(response.responseText);
    			if(record.success === 'true') {
    				var ventana = Ext.create('HreRem.view.comercial.visitas.VisitasComercialDetalle',{detallevisita: record});
    				me.getView().add(ventana);
    				ventana.show();
    			} else {
    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    			}
    		},
		 	failure: function(record, operation) {
		 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    },
		    callback: function(record, operation) {
    			me.getView().unmask();
		    }
    	});
        
    	
    },
    
    activarCheckAgrupacionesVinculadas: function(field, newValue, oldValue, eOpts){
    	var me= this;
    	var numActivo= me.lookupReference('numActivoOfertaComercial');
    	var numActivoUvem= me.lookupReference('numActivoUvemOfertaComercial');
    	var numActivoSareb= me.lookupReference('numActivoSarebOfertaComercial');
    	var numPrinex= me.lookupReference('numPrinexOfertaComercial');
    	var agrupacionesVinculadas= me.lookupReference('agrupacionesVinculadasOfertaComercial');
    	
    	if(!Ext.isEmpty(agrupacionesVinculadas) && (!Ext.isEmpty(numActivo.getValue()) 
    			|| !Ext.isEmpty(numActivoUvem.getValue()) || !Ext.isEmpty(numActivoSareb.getValue()) || !Ext.isEmpty(numPrinex.getValue()))){
    		agrupacionesVinculadas.setDisabled(false);
    	}
    	else{
    		agrupacionesVinculadas.setDisabled(true);
    		agrupacionesVinculadas.setValue("");
    	}
    },
    
    activarComboEstadoExpediente: function(field, newValue, oldValue, eOpts){
    	var me= this;
    	var tipoOferta = me.lookupReference('tipoOfertaComercial');
    	var comboVenta = me.lookupReference('comboExpedienteVenta');
    	var comboAlquiler = me.lookupReference('comboExpedienteAlquiler');
    	
    	if(!Ext.isEmpty(tipoOferta) && tipoOferta.value == CONST.TIPOS_EXPEDIENTE_COMERCIAL["VENTA"]){
    		comboVenta.setDisabled(false);
    		comboAlquiler.setDisabled(true);
    	} else if(!Ext.isEmpty(tipoOferta) && tipoOferta.value == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"]){
    		comboAlquiler.setDisabled(false);
    		comboVenta.setDisabled(true);
    	}
    	
    },
    
    onClickDescargarExcelOfertaCES: function(btn) {
		
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
		config.url= $AC.getRemoteUrl("ofertas/generateExcelOfertaCES");
		
		me.fireEvent("downloadFile", config);		
    	
    	
    }

});