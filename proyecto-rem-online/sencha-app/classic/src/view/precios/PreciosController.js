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
	    			if(me.isAmpliada)
	    				store.getProxy().extraParams = {entidadPropietariaCodigo: me.entidadPropietariaCodigo, subcarteraCodigo: me.subcarteraCodigo, tipoPropuestaCodigo: me.tipoPropuestaCodigo, conBloqueo: '0', estadoActivoCodigo: me.estadoFisicoCodigo}
	    			else
	    				store.getProxy().extraParams = {entidadPropietariaCodigo: me.entidadPropietariaCodigo, subcarteraCodigo: me.subcarteraCodigo, tipoPropuestaCodigo: me.tipoPropuestaCodigo, conBloqueo: '0'}
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
    	
    	if(Ext.isEmpty(searchForm.down("[name=entidadPropietariaCodigo]").getValue())) {
    		
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
    	
    	if(!Ext.isEmpty(me.getViewModel().get('historicoPropuestasList').selection)) {
    		
			me.lookupReference('historicoPropuestaActivosList').expand();	
			this.lookupReference('historicoPropuestaActivosList').getStore().loadPage(1);
    	}
    },
    
    beforeLoadActivosByPropuesta: function(store, operation, opts) {
		
		var me = this;		

		if(!Ext.isEmpty(me.getViewModel().get('historicoPropuestasList').selection)) {
			var idPropuesta = me.getViewModel().get('historicoPropuestasList').selection.id;
			
			if(idPropuesta != null) {
				store.getProxy().extraParams = {idPropuesta: idPropuesta};	
				return true;
			}
	    }
	},
	
	//HREOS-639 Identifica la celda seleccionada (col,fila) del grid de generacionPropuestasAutomatica
	cellClickContadorAutomatico: function(view, td, cellIndex, record, tr, rowIndex, e, eOpts) {
		
		var me = this;	

		if(cellIndex != 0 && cellIndex != 1 && cellIndex != 3) {
			
			this.tipoPropuestaCodigo = me.tipoPropuestaByColumnaSeleccionadaAutomatica(cellIndex);
			this.entidadPropietariaCodigo = record.data.entidadPropietariaCodigo;
			this.numActivosToGenerar = record.get(view.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex);
			this.subcarteraCodigo = record.data.subcarteraCodigo;
			this.isAmpliada = false;
			
			//Agrega / elimina fondo de la celda seleccionada
			me.marcarDesmarcarCeldaInclusionAutomatica(e);
			
			me.lookupReference('generacionPropuestasActivosList').expand();	
			this.lookupReference('generacionPropuestasActivosList').getStore().loadPage(1);	
		}else{
			if(record.getData().entidadPropietariaDescripcion=="Sareb"){
				me.lookupReference('generacionPropuestasAutomaticaContadoresAmpliada').setDisabled(false);
			}else{
				me.lookupReference('generacionPropuestasAutomaticaContadoresAmpliada').setDisabled(true);
			}
		}
	},
	
	cellClickContadorAutomaticoAmpliada: function(view, td, cellIndex, record, tr, rowIndex, e, eOpts) {
		var me = this;
		if(cellIndex != 0 && cellIndex != 1 && cellIndex != 3) {
			this.tipoPropuestaCodigo = me.tipoPropuestaByColumnaSeleccionadaAutomatica(cellIndex);
			this.entidadPropietariaCodigo = record.data.entidadPropietariaCodigo;
			this.numActivosToGenerar = record.get(view.panel.headerCt.getHeaderAtIndex(cellIndex).dataIndex);
			this.estadoFisicoCodigo = record.data.estadoFisicoCodigo;
			this.subcarteraCodigo = record.data.subcarteraCodigo;
			this.isAmpliada = true;
			
			//Agrega / elimina fondo de la celda seleccionada
			me.marcarDesmarcarCeldaInclusionAutomatica(e);
			
			me.lookupReference('generacionPropuestasActivosList').expand();	
			this.lookupReference('generacionPropuestasActivosList').getStore().loadPage(1);	
		}
	},

	//HREOS-639 Devuelve Codigo Propuesta Segun la columna seleccionada en el grid del tab Inclusion Automatica
	tipoPropuestaByColumnaSeleccionadaAutomatica: function(col) {
		
		switch(col) {
			case 4:
				return "01";//Preciar
				break;
			case 5:
				return "02";//Repreciar
				break;
			case 6:
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
	    	params.subcarteraCodigo = me.subcarteraCodigo;
	    	params.estadoActivoCodigo = me.estadoFisicoCodigo;
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
	    	params.subcarteraCodigo = me.subcarteraCodigo;
	    	params.estadoActivoCodigo = me.estadoFisicoCodigo;
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
		url = $AC.getRemoteUrl('precios/generarPropuestaManual');

		var messageBox = Ext.Msg.prompt(HreRem.i18n('title.generar.propuesta'),"<span class='txt-guardar-propuesta'>" + HreRem.i18n('txt.aviso.guardar.propuesta') + "</span>", function(btn, text){
		    if (btn == 'ok'){
		    	
		    	me.getView().mask(HreRem.i18n("msg.mask.loading"));	
		    	params.nombrePropuesta = text;
		    	var advertencia;
		    	
		    	Ext.Ajax.request({
		    		url: url,
		    		params: params,
		    		success: function(response, opts){
		    			if(Ext.decode(response.responseText).success) {
		    				advertencia = Ext.JSON.decode(response.responseText).advertencia;
		    				if(Ext.isEmpty(advertencia))
		    					me.fireEvent("infoToast", HreRem.i18n('msg.generar.propuesta.ok.mensaje'));
		    				else {
		    					if(advertencia=='01')
		    						me.fireEvent("warnToast", HreRem.i18n('msg.advertencia.precios.generar.prp.existen.activos.in.prp.entramite'));
	    						else
	    							me.fireEvent("errorToast", HreRem.i18n('msg.advertencia.precios.no.gernerar.prp.todos.activos.in.prp.tramite'));
		    				}
		    			}
		    			else
		    				me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
		    		},
				 	failure: function(record, operation) {
				 		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
				    },
				    callback: function(record, operation) {
		    			me.getView().unmask();
		    			//Refrescamos los resultados de los contadores de activos, el listado donde se muestran los activos, y el listado de propuestas del historico
			        	me.getViewModel().data.numActivosByTipoPrecio.load();
			        	me.numActivosToGenerar = 0;
			        	me.getViewModel().data.activos.load();
			        	me.getViewModel().data.propuestas.load();
				    }
		    	});
		    }
    	});

		messageBox.textField.maskRe=/^[A-Za-z0-9\s_/]+$/;
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
	   	
	   	if(!Ext.isEmpty(record.get('idTrabajo')))
	   		me.abrirDetalleTrabajo(record);
	   	else
	   		me.fireEvent("warnToast", HreRem.i18n("msg.historico.propuesta.sin.trabajo"));
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
   		
   		gridContadoresAmpliada = me.lookupReference("generacionPropuestasAutomaticaContadoresAmpliada");
   		
   		gridContadoresAmpliada.getStore().load(); 
   		me.lookupReference('generacionPropuestasActivosList').getStore().loadPage(0);
   	
   },
   
   onTabChangeGeneracionPropuestasTabPanel: function(tab) {
   		var me = this,   		
   		activeTab = me.getView().down("generacionpropuestastabpanel").getActiveTab(),
   		activosList = me.lookupReference('generacionPropuestasActivosList');
   		
    	switch (activeTab.xtype) {
    		
    		case 'generacionpropuestasmanual':
    			activosList.getStore().loadPage(0); 
    			activosList.getColumnManager().getHeaderByDataIndex("incluidoEnBolsa").setVisible(true);
    			activosList.getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(true);
    			
    			
    			break;
    			
    		case 'generacionpropuestasautomatica':
    		
    			activosList.getColumnManager().getHeaderByDataIndex("incluidoEnBolsa").setVisible(false);
    			activosList.getColumnManager().getHeaderByDataIndex("activoEnPropuestaEnTramitacion").setVisible(false);
    			
    		   	if(Ext.isEmpty(me.entidadPropietariaCodigo)) {
    		   		activosList.getStore().loadPage(0); 
    		   	} else {
    		   		activosList.getStore().load();
    			}
    			break;
    	}	
   		  	
   },
   
   downloadPropuestaAdjunto: function(grid, record) {
	   
	   var me = this,
		config = {};
	   
		if(!Ext.isEmpty(record.get('idAdjunto'))) {
			config.url=$AC.getWebPath()+"precios/bajarAdjuntoPropuesta."+$AC.getUrlPattern();
			config.params = {};
			config.params.id=record.get('idAdjunto');
			config.params.idTrabajo=record.get("idTrabajo");
			
			me.fireEvent("downloadFile", config);
	   }
		else {
			me.fireEvent("warnToast", HreRem.i18n("msg.historico.propuesta.sin.documento.en.trabajo"));   
	   }

   },

   onChangeCarteraChainedCombo: function(combo) {
	   	var me = this,
	   	chainedCombo = me.lookupReference(combo.chainedReference);    	
	   	me.getViewModel().notify();
	   	if(!Ext.isEmpty(chainedCombo.getValue())) {
				chainedCombo.clearValue();
	   	}

	   	var chainedStore = chainedCombo.getStore();

	   	if(!Ext.isEmpty(chainedStore)) {
	   		chainedStore.getProxy().extraParams = {
	   			'codigoCartera' : combo.getValue()
	   		}

	    	chainedStore.load({
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
	   	}
   },

   /**
    * Este método habilita los campos de edición en caso de ser necesario especificar condiciones.
    */
   onChangeIndicadorCondicionPrecio: function(combo) {
	   	var me = this;

		var colMenorQue = me.lookupReference('cbColMenorQue');
		var colMayorQue = me.lookupReference('cbColMayorQue');
		var colIgualQue = me.lookupReference('cbColIgualQue');

		var condicion = combo.getSelectedRecord().getData().necesitaCondicion;

		if(Ext.isEmpty(condicion)) {
			// Si viene null deshabilitar campos de edición.
			colMenorQue.setDisabled(true);
			colMayorQue.setDisabled(true);
			colIgualQue.setDisabled(true);
		} else if(condicion == 1) {
			// Si viene relleno con 1 habilitar campos de edición.
			colMenorQue.setDisabled(false);
			colMayorQue.setDisabled(false);
			colIgualQue.setDisabled(false);
			// Validar los campos para que se muestre la necesidad de completar.
			colMenorQue.validate();
			colMayorQue.validate();
			colIgualQue.validate();
		} else {
			// Si viene cualquier otra cosa deshabilitar campos de edición.
			colMenorQue.setDisabled(true);
			colMayorQue.setDisabled(true);
			colIgualQue.setDisabled(true);
		}
   },

   /**
    * Este método comprueba si al menos un campo de los 3 contiene datos.
    */
   validateCamposRellenos: function(value) {
	    var me = this;

	   	var colMenorQue = me.lookupReference('cbColMenorQue');
		var colMayorQue = me.lookupReference('cbColMayorQue');
		var colIgualQue = me.lookupReference('cbColIgualQue');

		if(Ext.isEmpty(colMenorQue.getValue()) && Ext.isEmpty(colMayorQue.getValue()) && Ext.isEmpty(colIgualQue.getValue())) {
			return HreRem.i18n("msg.error.validate.emptpy.fields");
		} else {
			return true;
		}
   }
});