Ext.define('HreRem.view.precios.PreciosController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.precios',

	onSearchManualClick: function(btn) {
		
		var me = this,
		searchForm = this.lookupReference('generacionPropuestasManual');
		
		if(searchForm.isValid()) {
			me.lookupReference('generacionPropuestasActivosList').expand();	
			this.lookupReference('generacionPropuestasActivosList').getStore().loadPage(1);
		}
		else {
			me.fireEvent("errorToast", HreRem.i18n("msg.busqueda.invalida"));
		}
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
	    			//Se mete estos parametros, ya que se requieren para la propuesta automatica
	    			store.getProxy().extraParams = {entidadPropietariaCodigo: me.entidadPropietariaCodigo, tipoPropuestaCodigo: me.tipoPropuestaCodigo, conBloqueo: '0'}
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
	cellClickContadorAutomatico: function(view, td, cellIndex, record, tr, rowIndex, e, eOpts) {
		
		var me = this;	
		
		if(cellIndex != 0 && cellIndex != 1) {
			
			this.tipoPropuestaCodigo = me.tipoPropuestaByColumnaSeleccionadaAutomatica(cellIndex);
			this.entidadPropietariaCodigo = record.data.entidadPropietariaCodigo;
			this.numActivosToGenerar = record.get(view.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex);
			
			//Agrega / elimina fondo de la celda seleccionada
			me.marcarDesmarcarCeldaInclusionAutomatica(e);
			
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
	
	//HREOS-639 Generacion de propuesta automatica (segun celda seleccionada, tendra un propietario y un tipo propuesta; Y deben ser activos SIN bloqueo)
	generarPropuestaAutomatica: function() {
		
		var me = this,
    	params = {};
		
		if(me.numActivosToGenerar > 0) {
		
			params.entidadPropietariaCodigo = me.entidadPropietariaCodigo;
	    	params.tipoPropuestaCodigo = me.tipoPropuestaCodigo;
	    	params.conBloqueo = '0';
	    	
	    	me.realizarGeneracionPropuesta(params);
	    	
		}
		else {
			 me.fireEvent("warnToast", HreRem.i18n("msg.generar.propuesta.sin.activos"));
		}
	},
	
	//HREOS-639 Se genera el excel por Cartera, Tipo de precio y activos sin bloqueo
	exportarExcelAutomatica: function() {
		
		var me = this,
		params = {};
		
		if(me.numActivosToGenerar > 0) {
			params.entidadPropietariaCodigo = me.entidadPropietariaCodigo;
	    	params.tipoPropuestaCodigo = me.tipoPropuestaCodigo;
	    	params.conBloqueo = '0';
			
	    	me.realizarExportacionExcel(params,me);
		}
		else {
			me.fireEvent("warnToast", HreRem.i18n("msg.generar.excel.sin.activos"));
		}
			
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
				config.url= $AC.getRemoteUrl('precios/generarPropuestaManual');
				
				me.fireEvent("downloadFile", config);
				
				Ext.Msg.show({
				    title:HreRem.i18n('msg.generar.propuesta.ok.title'),
				    message: HreRem.i18n('msg.generar.propuesta.ok.mensaje'),
				    buttons: Ext.Msg.OK,
				    icon: Ext.Msg.INFO,
				    fn: function(btn) {
				    	//Refrescamos los resultados de los contadores de activos, y el listado donde se muestran los activos
			        	me.getViewModel().data.numActivosByTipoPrecio.load();
			        	me.numActivosToGenerar = 0;
			        	me.getViewModel().data.activos.load();
				    }
				});    
				
		    }
    	});

		messageBox.textField.maskRe=/^[a-z0-9\s_/]+$/;
		messageBox.textField.mon(messageBox.textField.el, 'keypress', messageBox.textField.filterKeys, messageBox.textField);
	},
	
	onHistoricoActivosListDobleClick: function(grid, record) {  
		
    	var me = this;    	
    	me.abrirPestañaActivosHistoricoPropuesta(record);
	},
	
	//HREOS-639 Función que abre la pestaña de Precios.propuestasPrecios del activo.
	abrirPestañaActivosHistoricoPropuesta: function(record)  {
		
		var me = this;
	   	me.getView().fireEvent('abrirDetalleActivoPrincipal', record);
   },
   
   //HREOS-639 Rellena el fondo de la celda seleccionada, y lo deshace en la anterior seleccionada
   marcarDesmarcarCeldaInclusionAutomatica : function (e) {

	   	Ext.select("div.x-boundlist-selected").removeCls('x-boundlist-selected');
	   	Ext.get(e.target).addCls('x-boundlist-selected');
   },
   
   //HREOS-641 Entra al hacer doble click sobre una propuesta del listado
   onPropuestaPrecioListDobleClick : function(grid, record) {        
		
	   	var me = this;    	
		me.abrirDetalleTrabajo(record);   	        	
   },
   
   //HREOS-641 Abre un trabajo al hacer doble click en una propuesta
   abrirDetalleTrabajo: function(record)  {
	   
	   	var me = this;
		record.data.id=record.data.idTrabajo;
		me.getView().fireEvent('abrirDetalleTrabajo', record);	 
   },
   
   onClickBotonRefrescarContadores: function(btn) {
   		
   		var me = this,
   		gridContadores = me.lookupReference("generacionPropuestasAutomaticaContadores");
   		
   		gridContadores.getStore().load(); 
   		me.lookupReference('generacionPropuestasActivosList').getStore().loadPage(0);	
   	
   },
   
   onTabChangeGeneracionPropuestasTabPanel: function(tab) {
   		var me = this;
   		
   		var activeTab = me.getView().down("generacionpropuestastabpanel").getActiveTab();
   		
    	switch (activeTab.xtype) {
    		
    		case 'generacionpropuestasmanual':
    			me.lookupReference('generacionPropuestasActivosList').getStore().loadPage(0); 
    			break;
    			
    		case 'generacionpropuestasautomatica':
    		   	if(Ext.isEmpty(me.entidadPropietariaCodigo)) {
    		   		me.lookupReference('generacionPropuestasActivosList').getStore().loadPage(0); 
    		   	} else {
    		   		me.lookupReference('generacionPropuestasActivosList').getStore().load();
    			}
    			break;
    	}	
   		  	
   }

});