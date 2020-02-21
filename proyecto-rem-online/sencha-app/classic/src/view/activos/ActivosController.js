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
	
	onSearchBusquedaDirectaActivos: function(btn){
		var me = this;
		var numActivo = btn.up('activossearch').down('[name="numActivo"]').value;
		
		if(numActivo != ""){
		  	var url= $AC.getRemoteUrl('activo/getActivoExists');
        	var data;
    		Ext.Ajax.request({
    		     url: url,
    		     params: {numActivo : numActivo},
    		     success: function(response, opts) {
    		    	 data = Ext.decode(response.responseText);
    		    	 if(data.success == "true"){
    		    		 var titulo = "Activo " + numActivo;
        		    	 me.getView().fireEvent('abrirDetalleActivoById', data.data, titulo);
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
	
	onChangeNumActivo: function(me, oValue, nValue){
		
		var numActivo = me.value;
		var btn = me.up('activossearch').down('[reference="btnActivo"]');
		
		if(numActivo != ""){
			btn.setDisabled(false);
		}else{
			btn.setDisabled(true); 
		}
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
		var me = this;
		var comboApiPrimario = btn.up('form').getForm().findField("apiPrimarioId");
		comboApiPrimario.getStore().removeAll();
		comboApiPrimario.getStore().clearFilter();
		comboApiPrimario.getStore().load();
		btn.up('form').getForm().reset();				
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
		params.buscador = 'activos';
		config.params = params;		
		config.url= $AC.getRemoteUrl("activo/generateExcel");
		var url = $AC.getRemoteUrl("activo/registrarExportacion");
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
		        		title: 'Exportar activos',
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
		    
		onClickCrearTrabajo: function (btn) {
			var me = this;
			var idActivo = null;
			var codCartera = null;
			var codSubcartera = null;
			var grid = me.getView().down('grid');
			if(Ext.isEmpty(grid)){ 
				return true;
			}
			var selected = grid.getSelectionModel().getSelection();
		
			if(!Ext.isEmpty(selected)) {
			
				idActivo = selected[0].getData().id;
		  		codCartera = selected[0].getData().entidadPropietariaCodigo;
		  		codSubcartera = selected[0].getData().subcarteraCodigo;
		  	}
			 me.getView().fireEvent('openModalWindow',"HreRem.view.trabajos.detalle.CrearTrabajo",{idActivo: idActivo, codCartera: codCartera, codSubcartera: codSubcartera, logadoGestorMantenimiento: true,idAgrupacion: null, idGestor: null});    	
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
	
	changeComboEstadoPublicacionVenta: function() {
		var me = this;
		var estadoPublicacionVenta = me.getViewModel().get('estadoPublicacionVenta');
		var estadoPublicacionAlquiler = me.getViewModel().get('estadoPublicacionAlquiler');
		var motivosOcultacionVenta = me.lookupReference('motivosOcultacionVenta');
		var tipoPublicacion = me.lookupReference('tipoPublicacionCodigo');
    	
    	if (!Ext.isEmpty(estadoPublicacionVenta.selection) && estadoPublicacionVenta.selection.data.codigo == CONST.ESTADO_PUBLICACION_VENTA['OCULTO']){
    		motivosOcultacionVenta.setHidden(false);
    	} else {
    		motivosOcultacionVenta.setHidden(true);
    		motivosOcultacionVenta.reset();
	    }
    	
    	if ((!Ext.isEmpty(estadoPublicacionVenta.selection) && estadoPublicacionVenta.selection.data.codigo == CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'])
    			|| (!Ext.isEmpty(estadoPublicacionAlquiler.selection) && estadoPublicacionAlquiler.selection.data.codigo == CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'])){
    		tipoPublicacion.setHidden(false);
    	} else {
    		tipoPublicacion.setHidden(true);
    		tipoPublicacion.reset();
    	}
	},
	
	changeComboEstadoPublicacionAlquiler: function() {
		var me = this;
		var estadoPublicacionVenta = me.getViewModel().get('estadoPublicacionVenta');
		var estadoPublicacionAlquiler = me.getViewModel().get('estadoPublicacionAlquiler');
		var motivosOcultacionAlquiler = me.lookupReference('motivosOcultacionAlquiler');
		var tipoPublicacion = me.lookupReference('tipoPublicacionCodigo');
    	
    	if (!Ext.isEmpty(estadoPublicacionAlquiler.selection) && estadoPublicacionAlquiler.selection.data.codigo == CONST.ESTADO_PUBLICACION_ALQUILER['OCULTO']){
    		motivosOcultacionAlquiler.setHidden(false);
    	} else {
    		motivosOcultacionAlquiler.setHidden(true);
    	    motivosOcultacionAlquiler.reset();
	    }
	    
	    if ((!Ext.isEmpty(estadoPublicacionVenta.selection) && estadoPublicacionVenta.selection.data.codigo == CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'])
    			|| (!Ext.isEmpty(estadoPublicacionAlquiler.selection) && estadoPublicacionAlquiler.selection.data.codigo == CONST.ESTADO_PUBLICACION_VENTA['PUBLICADO'])){
    		tipoPublicacion.setHidden(false);
    	} else {
    		tipoPublicacion.setHidden(true);
    		tipoPublicacion.reset();
    	}
    },
    
    onChangeSubcartera: function(me, nValue, oValue){
    	var comboTipoSegmento = me.up('activossearch').down('[reference="tipoSegmentoRef"]');
    	var comboPerimetroMacc = me.up('activossearch').down('[reference="perimetroMaccRef"]');
    	
    	if(nValue == CONST.SUBCARTERA['APPLEINMOBILIARIO']){
    		comboPerimetroMacc.setHidden(false);
    	} else if(nValue == CONST.SUBCARTERA['DIVARIANARROW'] || nValue == CONST.SUBCARTERA['DIVARIANREMAINING']){
    		comboPerimetroMacc.setHidden(false);
    		comboTipoSegmento.setHidden(false);
    	} else {
    		comboTipoSegmento.setHidden(true);
    		comboPerimetroMacc.setHidden(true);
    	}
    }
});