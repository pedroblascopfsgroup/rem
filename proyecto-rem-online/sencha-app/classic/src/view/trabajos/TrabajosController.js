Ext.define('HreRem.view.trabajos.TrabajosController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.trabajos',
    
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

			this.lookupReference('trabajoslist').getStore().loadPage(1);
        }
	},
	onSearchBusquedaDirectaTrabajo: function(btn) {
		var me = this;
		var numTrabajo = btn.up('trabajossearch').down('[name="numTrabajo"]').value;
		var url= $AC.getRemoteUrl('trabajo/getTrabajoExists');
		var data;
		
		if(numTrabajo != ""){
			Ext.Ajax.request({
					url: url,
				params: {numTrabajo : numTrabajo},
				success: function(response, opts) {
					data = Ext.decode(response.responseText);
					if(data.success == "true"){
							var titulo = "Trabajo " + numTrabajo;
							me.getView().fireEvent('abrirDetalleTrabajoDirecto', data.data, titulo);
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
	
		onChangeNumTrabajo: function(me, oValue, nValue){
			var numTrabajo = me.up('trabajossearch').down('[name="numTrabajo"]').value;
			var btn = me.up('trabajossearch').down('[reference="btnTrabajo"]');

			if(numTrabajo != ""){
				btn.setDisabled(false);
			}else{
				btn.setDisabled(true);
		    }
		},
	
	
	paramLoading: function(store, operation, opts) {
		
		var initialData = {};
		
		var searchForm = this.lookupReference('trabajossearch');
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
    onTrabajosListDobleClick: function(grid, record) {        	       
    	var me = this;    	
    	me.abrirDetalleTrabajo(record);   	        	
        	
    },
    
	
    
    onEnlaceActivosClick: function(tableView, indiceFila, indiceColumna) {
    	var me = this;
    	me.getView().mask(HreRem.i18n("msg.mask.loading"));
    	
    	var grid = tableView.up('grid');

    	var record = grid.store.getAt(indiceFila);

    	grid.setSelection(record);
    	
    	var numEntidad = record.getData().numActivoAgrupacion;
    	
    	if(record.get("tipoEntidad")=='agrupaciones'){
    		
    		me.getView().unmask();
    		
    		me.redirectTo('activos', true);

        	me.getView().fireEvent('abrirDetalleAgrupacionByNum', numEntidad);
    	}else{
    		
    		var url= $AC.getRemoteUrl('activo/getActivoExists');
    		Ext.Ajax.request({
    		     url: url,
    		     params: {numActivo : numEntidad},
    		     success: function(response, opts) {
    		    	 var data = Ext.decode(response.responseText);
    		    	 if(data.success == "true"){
    		    	 	me.getView().unmask();
    		    		me.redirectTo('activos', true);

        				me.getView().fireEvent('abrirDetalleActivo', data.data);
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
    
    
    
	abrirDetalleTrabajo: function(record)  {
    	 var me = this;
    	 me.getView().fireEvent('abrirDetalleTrabajo', record);
    	 
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
		config.url= $AC.getRemoteUrl("trabajo/generateExcel");
		var url = $AC.getRemoteUrl("trabajo/registrarExportacion");
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
			        		title: 'Exportar trabajos',
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
    	
    	
    }    

    
});