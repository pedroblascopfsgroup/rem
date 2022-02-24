Ext.define('HreRem.view.administracion.AdministracionController', {
    extend: 'Ext.app.ViewController',
    alias: 'controller.administracion',
    
    init: function() {
    	
    	// Si el usuario es proveedor, las búsquedas deberan filtrarse por el nif de este, 
    	// y todas las listas de selección de proveedores estarán deshabilitadas.
    	var me = this;
    	
    	me.nifProveedorIdentificado= null;
    	
    	if($AU.userIsRol(CONST.PERFILES['PROVEEDOR'])) {
			var url =  $AC.getRemoteUrl('gastosproveedor/getNifProveedorByUsuario');
			Ext.Ajax.request({
			     url: url,			
			     success: function(response, opts) {
			     	var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }  catch (e){ };
	                
	                me.nifProveedorIdentificado = data.data;
	                
	                if(data.success != "true") {	                	
	                	me.fireEvent("errorToast", data.msg);
	                }
	                
	                me.onClickGastosSearch(me.lookupReference('btnSearchGastos'));
			     },
			     
			     failure: function(response) {
		     		var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                	me.nifProveedorIdentificado = data.data;
	                }
	                catch (e){ };
	                if (!Ext.isEmpty(data.msg)) {
	                	me.fireEvent("errorToast", data.msg);
	                } else {
	                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                }
			     }
	    		     
	    	});				
		}
    	
    },
    
    control: {
    	
    	
        'documentosjuntas gridBase': {
        	abrirFormulario: 'abrirFormularioAdjuntarDocumentos',
            onClickRemove: 'borrarDocumentoAdjunto',
            download: 'downloadDocumentoAdjunto',
            afterupload: function(grid) {
            	grid.getStore().load();
            	grid.up('form').funcionRecargar();
            	grid.fireEvent("refreshComponent", "documentosjuntas");
            },
            
             afterdelete: function(grid) {
            	grid.getStore().load();
            }
            
        },
    	
    	'gestiongastoslist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var me = this;
    			var autorizarBtn = grid.down('button[itemId=autorizarBtn]');
    			var rechazarBtn = grid.down('button[itemId=rechazarBtn]');
    			var rechazarContabilidadBtn = grid.down('button[itemId=rechazarContabilidadBtn]')
    			var autorizarContBtn = grid.down('button[itemId=autorizarContBtn]')
    			var displaySelection = grid.down('displayfield[itemId=displaySelection]');
    			var disabled = Ext.isEmpty(persistedSelection);

    			if (!Ext.isEmpty(autorizarBtn)) autorizarBtn.setDisabled(disabled);    		
    			if (!Ext.isEmpty(rechazarBtn)) rechazarBtn.setDisabled(disabled);
    			if (!Ext.isEmpty(rechazarContabilidadBtn)) rechazarContabilidadBtn.setDisabled(disabled);
    			if (!Ext.isEmpty(autorizarContBtn)) autorizarContBtn.setDisabled(disabled);

    			if(disabled) {
    				displaySelection.setValue("No seleccionados");
    			} else if (persistedSelection.length > 1) {
    				displaySelection.setValue(persistedSelection.length +  " gastos seleccionados"); 
    			} else {
    				displaySelection.setValue("1 gasto seleccionado"); 
    			}
    			
    			
    		},    		
    		
    		onClickAddGasto: 'onClickAddGasto'
    	},
    	
    	'gestionprovisiongastoslist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var autorizarBtn = grid.down('button[itemId=autorizarBtn]');
    			var rechazarBtn = grid.down('button[itemId=rechazarBtn]');
    			var displaySelection = grid.down('displayfield[itemId=displaySelection]');
    			var displayImporteTotalLabel = grid.down('displayfield[itemId=labelImporteTotal]');
    			var displayImporteTotal = grid.down('displayfield[itemId=displayImporteTotal]');
    			var disabled = Ext.isEmpty(persistedSelection);

//    			if (!Ext.isEmpty(autorizarBtn)){
//    				autorizarBtn.setDisabled(disabled);    		
//    			}
//    			if (!Ext.isEmpty(rechazarBtn)){
//    				rechazarBtn.setDisabled(disabled);
//    			}

    			if(disabled) {
    				displayImporteTotal.setHidden(true);
    				displayImporteTotalLabel.setHidden(true);
    				displaySelection.setValue("No seleccionados");
    			} else if (persistedSelection.length > 1) {
    				displayImporteTotal.setHidden(false);
    				displayImporteTotalLabel.setHidden(false);
    				displaySelection.setValue(persistedSelection.length +  " gastos seleccionados"); 
    			} else {
    				displayImporteTotal.setHidden(false);
    				displayImporteTotalLabel.setHidden(false);
    				displaySelection.setValue("1 gasto seleccionado"); 
    			}
    			var importeTotalAcumulado = 0;
    			var importeTotalAgrupacion = 0;
    			Ext.Array.each(persistedSelection, function (item) {
    				if(importeTotalAgrupacion == 0 && !Ext.isEmpty(item.data.importeTotalAgrupacion)){
    					importeTotalAgrupacion = parseFloat(item.data.importeTotalAgrupacion);
    				}
    				if(item.data.importeTotal && item.data.estadoGastoCodigo != '03'){
    					//Ext.global.console.log(item.data.importeTotal);
    					importeTotalAcumulado += parseFloat(item.data.importeTotal);
    				}
    				
                });
    			
    			displayImporteTotal.setValue(Number(importeTotalAgrupacion).toFixed(2) 
											+ " + " + Number(importeTotalAcumulado).toFixed(2) 
											+ " = " + Number(importeTotalAcumulado+importeTotalAgrupacion).toFixed(2));
    		}
    		
    	},
    	
    	'gestionprovisioneslist' : {
    		
    		persistedsselectionchange: function (sm, record, e, grid, persistedSelection) {
    			var me = this;
    			var autorizarContAgruGastosBtn = grid.down('button[itemId=autorizarContAgruGastosBtn]');
    			var rechazarContabilidadAgrupGastoBtn = grid.down('button[itemId=rechazarContabilidadAgrupGastoBtn]');
    			var displaySelection = grid.down('displayfield[itemId=displaySelection]');
    			var disabled = Ext.isEmpty(persistedSelection);

    			if (!Ext.isEmpty(autorizarContAgruGastosBtn)) autorizarContAgruGastosBtn.setDisabled(disabled);
    			if (!Ext.isEmpty(rechazarContabilidadAgrupGastoBtn)) rechazarContabilidadAgrupGastoBtn.setDisabled(disabled);

    			if(disabled) {
    				displaySelection.setValue("No seleccionados");
    			} else {
    				displaySelection.setValue("1 agrupacion seleccionado"); 
    			}
    			
    		} 
    	}

    },
    
        refrescarJuntas: function(detalle, callbackFn) {
    	
    	var me = this,
    	id = detalle.getViewModel().get("junta.id");
    	
    	HreRem.model.GastoProveedor.load(id, {
    		scope: this,
		    success: function(junta) {
		    	
		    	detalle.getViewModel().set("junta", junta);		    	
		    	detalle.configCmp(junta);
		    	callbackFn();
		    	HreRem.model.GastoAviso.load(id, {
		    		scope: this,
				    success: function(avisos) {
			    		detalle.getViewModel().set("avisos", avisos);				    	
				    }
				});
		    }
		});
    	
    },
    
    abrirFormularioAdjuntarDocumentos: function(grid) {
		var me = this,
		idJunta = me.getViewModel().get("junta.id");
    	Ext.create("HreRem.view.common.adjuntos.AdjuntarDocumentoJuntas", {entidad: 'activojuntapropietarios', idEntidad: idJunta, parent: grid}).show();
		
	},
    
	cargarTabData: function (form) {
		var me = this,
		model = form.getModelInstance(),
		id = me.getViewModel().get("junta.id");
		
		form.up("tabpanel").mask(HreRem.i18n('msg.mask.loading'));	
		model.setId(id);
		model.load({
		    success: function(record) {
		    	
		    	form.setBindRecord(record);		    	
		    	form.up("tabpanel").unmask();
		    },
		    failure: function(operation) {		    	
		    	form.up("tabpanel").unmask();
		    	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko")); 
		    }
		});
	},
	
    borrarDocumentoAdjunto: function(grid, record) {
		var me = this;
		idJunta = me.getViewModel().get("junta.id");
		id = grid.getSelection()[0].data.id;
		url = $AC.getRemoteUrl('activojuntapropietarios/deleteAdjunto');
		Ext.Ajax.request({
			url : url,
			params: {idEntidad: idJunta, id: id},
            success: function(record, operation) {
           		 me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
           		 grid.fireEvent("afterdelete", grid);
            },
            failure: function(record, operation) {
                  me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
                  grid.fireEvent("afterdelete", grid);
            }
            
        });	
	},
	
	downloadDocumentoAdjunto: function(grid, record) {
		var me = this,
		config = {};
		
		config.url=$AC.getWebPath()+"activojuntapropietarios/bajarAdjuntoJunta."+$AC.getUrlPattern();
		config.params = {};
		config.params.id=record.get('id');
		config.params.idJunta=me.getViewModel().get("junta.id");
		config.params.nombreDocumento=record.get("nombre").replace(/,/g, "");
		
		me.fireEvent("downloadFile", config);
	},

    //Funcion que se ejecuta al hacer click en el botón buscar gastos
	onClickGastosSearch: function(btn) {
		var me = this;
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		if (searchForm.isValid()) {
			this.lookupReference('gestiongastoslistref').deselectAll();
			this.lookupReference('gestiongastoslistref').getStore().loadPage(1);
        }
		
		
	},
	
	 //Funcion que se ejecuta al hacer click en el botón buscar plusvalia
	onClickPlusvaliaSearch: function(btn) {
		var me = this;
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		if (searchForm.isValid()) {
			this.lookupReference('gestionplusvalialistref').getStore().loadPage(1);
        }
		
		
	},
	
	 //Funcion que se ejecuta al hacer click en el boton buscar juntas
	onClickJuntasSearch: function(btn) {
		var me = this;
		var initialData = {};

		var searchForm = btn.up('formBase');
		
		if (searchForm.isValid()) {
			this.lookupReference('gestionList').getStore().loadPage(1);
        }
		
		
	},
    
	// Función que se ejecuta al hacer click en el botón de Exportar en gestión gastos.
	onClickDescargarExcelGestionGastos: function(btn) {
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
		params.buscador = 'gastos';
		config.params = params;		
		config.url= $AC.getRemoteUrl("gastosproveedor/generateExcelGestionGastos");
		var url = $AC.getRemoteUrl("gastosproveedor/registrarExportacion");
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
			    	if(parseInt(count) < parseInt(limite)){
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
			        		title: 'Exportar gastos',
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

	// Función que se ejecuta al hacer click en el botón de Exportar en agrupaciones de gastos.
	onClickDescargarExcelProvisionGastos: function(btn) {
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
		params.buscador = 'provisiongastos';
		config.params = params;		
		config.url= $AC.getRemoteUrl("provisiongastos/generateExcelProvisionGastos");
		var url = $AC.getRemoteUrl("provisiongastos/registrarExportacion");
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
		    		me.fireEvent("errorToast", HreRem.i18n("msg.error.adquisicion.noactivo") + msg);
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
			        		title: 'Exportar agrupaciones gastos',
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

	// Función que se ejecuta al hacer click en el botón de Exportar en gastos por agrupación.
	onClickDescargarExcelGastosAgrupacion: function(btn) {
		var me = this,
		config = {};

		var provision = me.getViewModel().get('provisionSeleccionada');
		if(Ext.isEmpty(provision)) {
			return;
		}

		var params = {'idProvision':provision.get('id')}

		config.params = params;
		config.url= $AC.getRemoteUrl("gastosproveedor/generateExcelGestionGastos");

		me.fireEvent("downloadFile", config);		
	},

	//Funcion que se ejecuta al hacer click en el botón buscar provisiones
	onClickProvisionesSearch: function(btn) {
		var me = this;
		this.lookupReference('provisionesGastosList').collapse();
		this.lookupReference('provisionesList').getStore().loadPage(1);
	},
	
	// Funcion que se ejecuta al hacer click en el botón limpiar
	onCleanFiltersClick: function(btn) {			
		btn.up('form').getForm().reset();				
	},
	
	paramLoading: function(store, operation, opts) {
		var initialData = {};
		var me = this;
		var searchForm = null;
		
		if(this.lookupReference('gestiongastossearchref') == null){
			searchForm = this.lookupReference('gestionplusvaliasearchref');
		}else{
			searchForm = this.lookupReference('gestiongastossearchref');
		}

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
	
	onClickAbrirGastoProveedor: function(grid, record){
		var me = this;
		
    	me.getView().fireEvent('abrirDetalleGasto', record);
		
	},
	
	onClickAbrirPlusvalia: function(grid, record){
		var me = this;
    	me.getView().fireEvent('abrirDetallePlusvalia', record);
		
	},

	onRowClickProvisionesList: function(gridView,record) {
		var me = this;
		var viewModel = me.getViewModel();
		viewModel.set("provisionSeleccionada", record);
		viewModel.notify();
		
		var grid = me.lookupReference('provisionesGastosList');
		var displaySelection = grid.down('displayfield[itemId=displaySelection]');
		var displayImporteTotalLabel = grid.down('displayfield[itemId=labelImporteTotal]');
		var displayImporteTotal = grid.down('displayfield[itemId=displayImporteTotal]');
		
		grid.getSelectionModel().deselectAll();
		displayImporteTotal.setHidden(true);
		displayImporteTotalLabel.setHidden(true);
		displaySelection.setValue("No seleccionados");

		var store = grid.getStore();
		grid.expand();
		store.loadPage(1);
		store.on('load', function(store ,records ,successful ,eOpts){
	        grid.mostrarExportarGastos();
    	});

		var estadoProvision = record.get("estadoProvisionCodigo");
		if(CONST.ESTADOS_PROVISION['RECHAZADA_SUBSANABLE'] == estadoProvision) {
			grid.mostrarEdicionGastos();
		} else {
			grid.ocultarEdicionGastos();
		}
    },

	paramLoadingProvisiones: function(store, operation, opts) {
		var me = this;
		
		var me = this,		
		searchForm = this.lookupReference('provisionesSearch');
		
		if (searchForm.isValid()) {				
			store.getProxy().extraParams = me.getFormCriteria(searchForm);			
			return true;		
		}
		
	},
	
	paramLoadingJuntas: function(store, operation, opts) {
		//var me = this;
		
		var me = this,		
		searchForm = this.lookupReference('juntasSearch');
		
		if (searchForm.isValid()) {				
			store.getProxy().extraParams = me.getFormCriteria(searchForm);			
			return true;		
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
    
    onClickAddGasto: function(grid) {
    	
    	var me =this,
    	parent= grid.up('gestiongastos');
    	var anyadirGastoWindow = Ext.create('HreRem.view.administracion.gastos.AnyadirNuevoGasto',{parent: parent, nifEmisor: me.nifProveedorIdentificado});
    	me.getView().up('tabpanel').add(anyadirGastoWindow);
    	anyadirGastoWindow.show();
	                
    },
    
    onClickAutorizar: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.autorizar.gastos.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		        if (buttonId == 'yes') {
					me.autorizarGasto(btn, "SG");
		        }
		   }
		});
    },
     
    onClickAutorizarContabilidad: function(btn){
    	
    	var me = this,
    	nErrors = 0,
    	
    	grid = btn.up('gridBase'),
    	tabPanel = grid.up(),
    	gastos = grid.getPersistedSelection();
    	// Recuperamos todos los ids de los trabajos seleccionados
		// y validamos que se pueden autorizar
    	Ext.Array.each(gastos, function(gasto, index) {
		    error = me.validarSeleccionGastoContabilidad("A", gasto, null);
		    if(!Ext.isEmpty(error)) {
		    	nErrors += 1;
		    	me.fireEvent("errorToast", error);
		    	return false;
		    }
		});
    	
    	if(nErrors == 0) {
    		var win = Ext.create('Ext.window.Window', {
	    		title: HreRem.i18n('title.mensaje.confirmacion'),
	    		height: 150,
	    		width: 700,
	    		modal: true,
	    		renderTo: tabPanel.body,
	    		layout: 'fit',
	    		items:{
	    			xtype: 'form',
	    			id: 'autorizarForm',
	    			layout: {
	    				type: 'hbox', 
	    				pack: 'center', 
	    				align: 'center' 
	    			},
	    			items:[
	        			{
	        				xtype: 'datefield',
	        				id: 'fechaConta',
	        				name: 'fechaConta',
	        				reference: 'fechaConta',
	        				fieldLabel: HreRem.i18n('msg.fecha.contabilizacion'),
	        				allowBlank: me.fechaContaAllowBlank(gastos),
	        				disabled: me.fechaContaHidden(gastos)
	        			},{
	        				xtype: 'datefield',
	        				id: 'fechaPago',
	        				name: 'fechaPago',
	        				reference: 'fechaPago',
	        				fieldLabel: HreRem.i18n('msg.fecha.pago'),
	        				allowBlank: me.fechaPagoAllowBlank(gastos)
	        			}
	        		],
	        		border: false,
	        		buttonAlign: 'center',
	        		buttons: [
	        			  {
	        				  text: 'Aceptar',
	        				  formBind: true,
	        				  handler: function(){
	        					  me.autorizarGastoContabilidad(btn, "SG");
	        					  win.close();
	        				  }
	        			  },
	        			  {
	        				  text: 'Cancelar', 
	        				  handler: function(){
	        					  win.close();
	        				  }
	        			  }
	        		]
	    		}
	    	});

	    	win.show();
	    }
    },
    
    onClickAutorizarContabilidadAgrupacion: function(btn, origen){
    	var me = this,
    	nErrors = 0,
    	grid = btn.up('gridBase'),
    	tabPanel = grid.up(),
    	agrupacion = grid.getPersistedSelection();
    	
    	var idAgrupacion = agrupacion[0].id;
    	
    	var urlGastos = $AC.getRemoteUrl('gastosproveedor/getListGastosProvisionAgrupGastos');
    	Ext.Ajax.request({
			
		     url: urlGastos,
		     params: {id: idAgrupacion},
		
		     success: function(response, opts) {
		     	var result = Ext.decode(response.responseText);
		     	gastos = result.data;
		     	
		     // Recuperamos todos los ids de los gastos de la agrupaci�n
				// y validamos que se pueden rechazar
				Ext.Array.each(gastos, function(gasto, index) {
					var gastoModel = Ext.create('HreRem.model.Gasto');
					gastoModel.set('entidadPropietariaCodigo', gasto.entidadPropietariaCodigo);
					gastoModel.set('estadoGastoCodigo', gasto.estadoGastoCodigo);
				    error = me.validarSeleccionGastoContabilidad("A", gastoModel, origen);
				    if(!Ext.isEmpty(error)) {
				    	nErrors += 1;
				    	me.fireEvent("errorToast", error);
				    	return false;
				    } 
				});
				
				if(nErrors == 0) {
		    		var win = Ext.create('Ext.window.Window', {
			    		title: HreRem.i18n('title.mensaje.confirmacion'),
			    		height: 150,
			    		modal: true,
			    		renderTo: tabPanel.body,
			    		width: 700,
			    		layout: 'fit',
			    		items:{
			    			xtype: 'form',
			    			id: 'autorizarForm',
			    			layout: {
			    				type: 'hbox', 
			    				pack: 'center', 
			    				align: 'center' 
			    			},
			    			items:[
			        			{
			        				xtype: 'datefield',
			        				id: 'fechaConta',
			        				name: 'fechaConta',
			        				reference: 'fechaConta',
			        				fieldLabel: HreRem.i18n('msg.fecha.contabilizacion'),
			        				allowBlank: me.fechaContaAllowBlankArray(gastos),
			        				disabled: me.fechaContaHiddenArray(gastos)
			        			},{
			        				xtype: 'datefield',
			        				id: 'fechaPago',
			        				name: 'fechaPago',
			        				reference: 'fechaPago',
			        				fieldLabel: HreRem.i18n('msg.fecha.pago'),
			        				allowBlank: me.fechaPagoAllowBlankArray(gastos)
			        			}
			        		],
			        		border: false,
			        		buttonAlign: 'center',
			        		buttons: [
			        			  {
			        				  text: 'Aceptar',
			        				  formBind: true,
			        				  handler: function(){
			        					  me.autorizarGastoContabilidadAgrupacion(btn, "SA");
			        					  win.close();
			        				  }
			        			  },
			        			  {
			        				  text: 'Cancelar', 
			        				  handler: function(){
			        					  win.close();
			        				  }
			        			  }
			        		]
			    		}
			    	});

			    	win.show();
			    }
				
		     },
		     failure: function(response) {
		     	me.getView().unmask();
	     		var data = {};
               try {
               	data = Ext.decode(response.responseText);
               }
               catch (e){ };
               if (!Ext.isEmpty(data.msg)) {
               	me.fireEvent("errorToast", data.msg);
               } else {
               	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
               }
		     }
	    });
    },
    
    
    onClickRechazarContabilidadAgrupGastos: function(btn, origen){
    	
    	var me = this;
    	var agrupacion = btn.up('gridBase').getPersistedSelection();
    	var idAgrupacion = agrupacion[0].id;
    	var rechazo = "RECHAZADO POR CONTABILIDAD";
    	var gastos;
    	var individual = false;
		idsGasto = [], error=null;
    	
    	var urlGastos = $AC.getRemoteUrl('gastosproveedor/getListGastosProvisionAgrupGastos');
    	Ext.Ajax.request({
			
		     url: urlGastos,
		     params: {id: idAgrupacion},
		
		     success: function(response, opts) {
		     	
		     	var result = Ext.decode(response.responseText);
		     	gastos = result.data;
		     	
		     // Recuperamos todos los ids de los gastos seleccionados
				// y validamos que se pueden rechazar
				Ext.Array.each(gastos, function(gasto, index) {
					var gastoModel = Ext.create('HreRem.model.Gasto');
					gastoModel.set('entidadPropietariaCodigo', gasto.entidadPropietariaCodigo);
					gastoModel.set('estadoGastoCodigo', gasto.estadoGastoCodigo);
				    error = me.validarSeleccionGastoContabilidad("R", gastoModel, origen);
				    if(Ext.isEmpty(error)) {
				    	idsGasto.push(gasto.id);	
				    } else {
				    	// Salimos del foreach y mostramos el error
				    	return false;	
				    }
				});
		    	
		    	if(Ext.isEmpty(error)) {
		    		
			    	url =  $AC.getRemoteUrl('gastosproveedor/rechazarGastosContabilidadAgrupGastos'),	
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
			    	
					Ext.Ajax.request({
				    			
					     url: url,
					     params: {idAgrupGasto: idAgrupacion,idsGasto: idsGasto, motivoRechazo: rechazo, individual: individual},
					
					     success: function(response, opts) {
					    		
					     	var data = {};
					     	me.getView().unmask();	
				            try {
				                data = Ext.decode(response.responseText);
				            } catch (e){ };
				            
				            if(data.success === "false") {
					            if (!Ext.isEmpty(data.msg)) {
					              	me.fireEvent("errorToast", data.msg);
					            } else {
					            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					            }
				            } else {							         
						         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));

						         Ext.Array.each(gastos, function(gasto, index) {
						    		me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.id);
								 });

						         me.getView().down('gestionprovisiones').funcionRecargar();
				            }
					     },
					     failure: function(response) {
					     	me.getView().unmask();
				     		var data = {};
			                try {
			                	data = Ext.decode(response.responseText);
			                }
			                catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
					     }
				    		    
				    });
		    	} else {
					me.fireEvent("errorToast", error);
				}
		     	
		     },
		     failure: function(response) {
		     	me.getView().unmask();
	     		var data = {};
               try {
               	data = Ext.decode(response.responseText);
               }
               catch (e){ };
               if (!Ext.isEmpty(data.msg)) {
               	me.fireEvent("errorToast", data.msg);
               } else {
               	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
               }
		     }
	    		    
	    });

    },
    
    onClickAutorizarGastosAgrupados: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.autorizar.gastos.agrupados.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
		        if (buttonId == 'yes') {
					me.autorizarGasto(btn, "SA");
		        }
		   }
		});
    },
    
    autorizarGasto: function(btn, origen) {
    	
    	var me = this,
    	listaGastos = btn.up('gridBase'),
    	gastos = listaGastos.getPersistedSelection(),
		url =  $AC.getRemoteUrl('gastosproveedor/autorizarGastos'),		
		idsGasto = [], error=null;
					
		// Recuperamos todos los ids de los trabajos seleccionados
		// y validamos que se pueden autorizar
		Ext.Array.each(gastos, function(gasto, index) {
		    error = me.validarSeleccionGasto("A", gasto, origen);
		    if(Ext.isEmpty(error)) {
		    	idsGasto.push(gasto.get("id"));	
		    } else {
		    	// Salimos del foreach y mostramos el error
		    	return false;	
		    }
		});

		if(Ext.isEmpty(error)){
			me.getView().mask(HreRem.i18n("msg.mask.loading"));

			Ext.Ajax.request({
		    			
			     url: url,
			     method: 'POST',
			     params: {idsGasto: idsGasto},
			
			     success: function(response, opts) {
			     	me.getView().unmask();
			        var data = {};
		            try {
		                data = Ext.decode(response.responseText);
		            } catch (e){ };
		            
		            if(data.success === "false") {
			            if (!Ext.isEmpty(data.msg)) {
			              	me.fireEvent("errorToast", data.msg);
			            } else {
			            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			            }
		            } else {							         
				         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				         listaGastos.deselectAll();
				         listaGastos.getStore().loadPage(1);
				         Ext.Array.each(gastos, function(gasto, index) {
						    me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.get("id"));
						});
		            }
			     },
			     failure: function(response) {
			     	me.getView().unmask();
		     		var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }
	                catch (e){ };
	                if (!Ext.isEmpty(data.msg)) {
	                	me.fireEvent("errorToast", data.msg);
	                } else {
	                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                }
			     }
		    		    
		    });
		} else {
			me.fireEvent("errorToast", error);
		}
    	
    },
    
    autorizarGastoContabilidad: function(btn, origen) {
    	
    	var me = this,
    	listaGastos = btn.up('gridBase'),
    	fechaConta = Ext.getCmp('autorizarForm').getForm().findField('fechaConta').rawValue,
    	fechaPago = Ext.getCmp('autorizarForm').getForm().findField('fechaPago').rawValue,  
    	gastos = listaGastos.getPersistedSelection(),
		url =  $AC.getRemoteUrl('gastosproveedor/autorizarGastosContabilidad'),		
		idsGasto = [], error=null;
    	var individual = true;
    	// Recuperamos todos los ids de los trabajos seleccionados
    	Ext.Array.each(gastos, function(gasto, index) {
		    error = me.validarSeleccionGastoContabilidad("A", gasto, origen);
		    if(Ext.isEmpty(error)) {
		    	idsGasto.push(gasto.get("id"));	
		    }
		});

		if(Ext.isEmpty(error)){
			me.getView().mask(HreRem.i18n("msg.mask.loading"));

			Ext.Ajax.request({
		    			
			     url: url,
			     params: {
			    	 idsGasto: idsGasto,
			    	 fechaConta: fechaConta,
			    	 fechaPago: fechaPago,
			    	 individual: individual
			     },
			
			     success: function(response, opts) {
			     	me.getView().unmask();
			        var data = {};
		            try {
		                data = Ext.decode(response.responseText);
		            } catch (e){ };
		            
		            if(data.success === "false") {
			            if (!Ext.isEmpty(data.msg)) {
			              	me.fireEvent("errorToast", data.msg);
			            } else {
			            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			            }
		            } else {							         
				         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				         listaGastos.deselectAll();
				         listaGastos.getStore().loadPage(1);
				         Ext.Array.each(gastos, function(gasto, index) {
						    me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.get("id"));
						});
		            }
			     },
			     failure: function(response) {
			     	me.getView().unmask();
		     		var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }
	                catch (e){ };
	                if (!Ext.isEmpty(data.msg)) {
	                	me.fireEvent("errorToast", data.msg);
	                } else {
	                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                }
			     }
		    		    
		    });
		} else {
			me.fireEvent("errorToast", error);
		}
    	
    },

    autorizarGastoContabilidadAgrupacion: function(btn, origen) {
    	
    	var me = this,
    	agrupacion = btn.up('gridBase').getPersistedSelection(),
    	fechaConta = Ext.getCmp('autorizarForm').getForm().findField('fechaConta').rawValue,
    	fechaPago = Ext.getCmp('autorizarForm').getForm().findField('fechaPago').rawValue,  
		url =  $AC.getRemoteUrl('gastosproveedor/autorizarGastosContabilidadAgrupacion'),		
		idsGasto = [], error=null;
    	var individual = false;
    	var idAgrupacion = agrupacion[0].id;
    	// Recuperamos todos los ids de los gastos de la agrupaci�n seleccionada
    	Ext.Array.each(gastos, function(gasto, index) {
    		var gastoModel = Ext.create('HreRem.model.Gasto');
			gastoModel.set('entidadPropietariaCodigo', gasto.entidadPropietariaCodigo);
			gastoModel.set('estadoGastoCodigo', gasto.estadoGastoCodigo);
		    error = me.validarSeleccionGastoContabilidad("A", gastoModel, origen);
		    if(Ext.isEmpty(error)) {
		    	idsGasto.push(gasto.id);	   
		    }
		});

		if(Ext.isEmpty(error)){
			me.getView().mask(HreRem.i18n("msg.mask.loading"));

			Ext.Ajax.request({
		    			
			     url: url,
			     params: {
			    	 idsGasto: idsGasto,
			    	 idAgrupacion: idAgrupacion, 
			    	 fechaConta: fechaConta,
			    	 fechaPago: fechaPago,
			    	 individual: individual
			     },
			
			     success: function(response, opts) {
			     	me.getView().unmask();
			        var data = {};
		            try {
		                data = Ext.decode(response.responseText);
		            } catch (e){ };
		            
		            if(data.success === "false") {
			            if (!Ext.isEmpty(data.msg)) {
			              	me.fireEvent("errorToast", data.msg);
			            } else {
			            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			            }
		            } else {							         
				         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
				      
				         Ext.Array.each(gastos, function(gasto, index) {
						    me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.id);
						 });

				         me.getView().down('gestionprovisiones').funcionRecargar();
		            }
			     },
			     failure: function(response) {
			     	me.getView().unmask();
		     		var data = {};
	                try {
	                	data = Ext.decode(response.responseText);
	                }
	                catch (e){ };
	                if (!Ext.isEmpty(data.msg)) {
	                	me.fireEvent("errorToast", data.msg);
	                } else {
	                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                }
			     }
		    		    
		    });
		} else {
			me.fireEvent("errorToast", error);
		}
    	
    },
    
     onClickRechazar: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.rechazar.gastos.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
 				if (buttonId == 'yes') { 					
 					me.rechazarGasto(btn, "SG");
 				}
		   }
		});
    	
    },
    
    onClickRechazarContabilidad: function(btn) {
    	
    	var me = this;
    	Ext.Msg.show({
    		title: HreRem.i18n('title.mensaje.confirmacion'),
    		msg: HreRem.i18n('msg.desea.rechazar.gastos.seleccionados'),
    		buttons: Ext.MessageBox.YESNO,
    		fn: function(buttonId){
    			if(buttonId == 'yes'){
    				me.rechazarGastoContabilidad(btn, "SG")
    			}
    		}
    	})
    },
    
    onClickRechazarGastosAgrupados: function(btn) {
    	
    	var me = this;    	
    	Ext.Msg.show({
		   title: HreRem.i18n('title.mensaje.confirmacion'),
		   msg: HreRem.i18n('msg.desea.rechazar.gastos.agrupados.seleccionados'),
		   buttons: Ext.MessageBox.YESNO,
		   fn: function(buttonId) {
 				if (buttonId == 'yes') { 					
 					me.rechazarGasto(btn, "SA");
 				}
		   }
		});
    	
    },
    
    rechazarGasto: function(btn, origen) {
    	
    	var me = this;
    	var listaGastos = btn.up('gridBase');
    	var combo = Ext.create("HreRem.view.common.ComboBoxFieldBase", {
 			addUxReadOnlyEditFieldPlugin: false, store: {model: 'HreRem.model.ComboBase',proxy: {type: 'uxproxy',remoteUrl: 'generic/getDiccionario',extraParams: {diccionario: 'motivosRechazoHaya'}}}
 		});
 						
		HreRem.Msg.promptCombo(HreRem.i18n('title.motivo.rechazo'),"", function(btn, text){    
		    if (btn == 'ok'){
		    	
		    	var gastos = listaGastos.getPersistedSelection(),
				url =  $AC.getRemoteUrl('gastosproveedor/rechazarGastos'),		
				idsGasto = [], error=null;
		
				// Recuperamos todos los ids de los trabajos seleccionados
				// y validamos que se pueden rechazar
				Ext.Array.each(gastos, function(gasto, index) {
				    error = me.validarSeleccionGasto("R", gasto, origen);
				    if(Ext.isEmpty(error)) {
				    	idsGasto.push(gasto.get("id"));	
				    } else {
				    	// Salimos del foreach y mostramos el error
				    	return false;	
				    }
				});

				if(Ext.isEmpty(error)) {
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
	
					Ext.Ajax.request({
				    			
					     url: url,
					     params: {idsGasto: idsGasto, motivoRechazo: text},
					
					     success: function(response, opts) {
					     	
					     	var data = {};
					     	me.getView().unmask();	
				            try {
				                data = Ext.decode(response.responseText);
				            } catch (e){ };
				            
				            if(data.success === "false") {
					            if (!Ext.isEmpty(data.msg)) {
					              	me.fireEvent("errorToast", data.msg);
					            } else {
					            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					            }
				            } else {							         
						         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						         listaGastos.deselectAll();
						         listaGastos.getStore().loadPage(1);
						         Ext.Array.each(gastos, function(gasto, index) {
						    		me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.get("id"));
								 });
				            }
					     },
					     failure: function(response) {
					     	me.getView().unmask();
				     		var data = {};
			                try {
			                	data = Ext.decode(response.responseText);
			                }
			                catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
					     }
				    		    
				    });
				} else {
					me.fireEvent("errorToast", error);								
				}
		    	 
				
		    }
		}, null, null, null, combo);
    	
    },
    
    rechazarGastoContabilidad: function(btn, origen){
    	
    	var me = this;
    	var listaGastos = btn.up('gridBase');
    	var rechazo = "RECHAZADO POR CONTABILIDAD";
		    	var gastos = listaGastos.getPersistedSelection(),
				url =  $AC.getRemoteUrl('gastosproveedor/rechazarGastosContabilidad'),		
				idsGasto = [], error=null;
		var individual = true;
		
				// Recuperamos todos los ids de los gastos seleccionados
				// y validamos que se pueden rechazar
				Ext.Array.each(gastos, function(gasto, index) {
				    error = me.validarSeleccionGastoContabilidad("R", gasto, origen);
				    if(Ext.isEmpty(error)) {
				    	idsGasto.push(gasto.get("id"));	
				    } else {
				    	// Salimos del foreach y mostramos el error
				    	return false;	
				    }
				});

				if(Ext.isEmpty(error)) {
					me.getView().mask(HreRem.i18n("msg.mask.loading"));
	
					Ext.Ajax.request({
				    			
					     url: url,
					     params: {idsGasto: idsGasto, motivoRechazo: rechazo, individual: individual},
					
					     success: function(response, opts) {
					     	
					     	var data = {};
					     	me.getView().unmask();	
				            try {
				                data = Ext.decode(response.responseText);
				            } catch (e){ };
				            
				            if(data.success === "false") {
					            if (!Ext.isEmpty(data.msg)) {
					              	me.fireEvent("errorToast", data.msg);
					            } else {
					            	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
					            }
				            } else {							         
						         me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));
						         listaGastos.deselectAll();
						         listaGastos.getStore().loadPage(1);
						         Ext.Array.each(gastos, function(gasto, index) {
						    		me.getView().fireEvent("refreshEntityOnActivate", CONST.ENTITY_TYPES["GASTO"], gasto.get("id"));
								 });
				            }
					     },
					     failure: function(response) {
					     	me.getView().unmask();
				     		var data = {};
			                try {
			                	data = Ext.decode(response.responseText);
			                }
			                catch (e){ };
			                if (!Ext.isEmpty(data.msg)) {
			                	me.fireEvent("errorToast", data.msg);
			                } else {
			                	me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
			                }
					     }
				    		    
				    });
				} else {
					me.fireEvent("errorToast", error);								
				}    	 
				
		    
    },
    
    validarSeleccionGasto: function(operacion, gasto, origen) { 
    	var me = this, error = null;
    	var OPERACION_AUTORIZAR = "A";
    	var OPERACION_RECHAZAR = "R";
    	
    	var SELECCION_GASTOS = "SG";
    	var SELECCION_AGRUPACION = "SA";

    	if(CONST.ESTADOS_GASTO['ANULADO'] == gasto.get("estadoGastoCodigo") ||
			CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.get("estadoGastoCodigo") || CONST.ESTADOS_GASTO['RETENIDO'] == gasto.get("estadoGastoCodigo")) {	    		
			error = ("<span>Se han seleccionado gastos retenidos, anulados o contabilizados</span></br>")
		} else if (SELECCION_GASTOS == origen && gasto.get("esGastoAgrupado")) {
			error = ("<span>Se han seleccionado gastos agrupados. Estos gastos deben gestionarse desde la pestaña de agrupación de gastos.</span></br>")
		
		} else if(OPERACION_AUTORIZAR == operacion && CONST.ESTADOS_AUTORIZACION_HAYA['AUTORIZADO'] == gasto.get("estadoAutorizacionHayaCodigo")) {
			error = ("<span>Se han seleccionado gastos ya autorizados</span></br>")
		} else if(OPERACION_RECHAZAR == operacion && CONST.ESTADOS_AUTORIZACION_HAYA['RECHAZADO'] == gasto.get("estadoAutorizacionHayaCodigo")) {
			error = ("<span>Se han seleccionado gastos ya rechazados</span></br>")
		}


		
		return error;
    	
    },
    
    validarSeleccionGastoContabilidad: function(operacion, gasto, origen) {
    	
    	var me = this, error = null;
    	
    	var OPERACION_AUTORIZAR = "A";
    	var OPERACION_RECHAZAR = "R";
    	
    	var SELECCION_GASTOS = "SG";
    	var SELECCION_AGRUPACION = "SA";
    	
    	if (!((CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.get("estadoGastoCodigo")) || 
    			(CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.get("estadoGastoCodigo")) ||
    			(CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.get("estadoGastoCodigo"))) && OPERACION_AUTORIZAR == operacion) {
    	    		error = ("<span>Alguno de los gastos no se encuentra en el estado pertinente para ejecutar esta acci&oacute;n</span></br>")
    	}
    	
    	if((!(CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.get("estadoGastoCodigo")) || (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.get("estadoGastoCodigo"))) && OPERACION_RECHAZAR == operacion){
       		error = ("<span>Se han seleccionado gastos que no son Autorizados Administraci&oacute;n</span></br>")
       	} 
    	
    	if((OPERACION_RECHAZAR == operacion || OPERACION_AUTORIZAR == operacion) && CONST.ESTADOS_GASTO['RECHAZADO_PROPIETARIO'] == gasto.get("estadoGastoCodigo")) {
       		error = ("<span>Se han seleccionado gastos ya rechazados</span></br>")
       	}
    	
    	if(!CONST.CARTERA['TANGO'] == gasto.get("entidadPropietariaCodigo")){
       		error = ("<span>Se han seleccionado gastos que no pertenecen a la cartera Tango</span></br>")
       	}
    			
		return error;
    	
    },
    
    fechaContaAllowBlank: function(gastos){
    	var autorizados = 0;
	    var subsanados = 0;
	    var contabilizados = 0;
	    
	    	Ext.Array.each(gastos, function(gasto){
	    		if (CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.get("estadoGastoCodigo")) {
	    			autorizados += 1;
	    		} else if (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.get("estadoGastoCodigo")) {
	    			subsanados += 1;
	    		} else if (CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.get("estadoGastoCodigo")) {
	    			contabilizados += 1;
	    		}
			});
    	
    	if(autorizados != 0 || subsanados != 0) {
	    	return false;	
	    } else {
	    	return true;	
	    }
    },
    
    fechaContaAllowBlankArray: function(gastos){
    	var autorizados = 0;
	    var subsanados = 0;
	    var contabilizados = 0;
	    
	    	Ext.Array.each(gastos, function(gasto){
	    		if (CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.estadoGastoCodigo) {
	    			autorizados += 1;
	    		} else if (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.estadoGastoCodigo) {
	    			subsanados += 1;
	    		} else if (CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.estadoGastoCodigo) {
	    			contabilizados += 1;
	    		}
			});
    	
    	if(autorizados != 0 || subsanados != 0) {
	    	return false;	
	    } else {
	    	return true;	
	    }
    },
    
    fechaContaHidden: function(gastos){
    	var autorizados = 0;
	    var subsanados = 0;
	    var contabilizados = 0;
	   
	    Ext.Array.each(gastos, function(gasto){
	   		if (CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.get("estadoGastoCodigo")) {
	   			autorizados += 1;
	   		} else if (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.get("estadoGastoCodigo")) {
	    		subsanados += 1;
	   		} else if (CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.get("estadoGastoCodigo")) {
	   			contabilizados += 1;
	   		}
		}); 

    	if(autorizados == 0 && subsanados == 0 && contabilizados != 0) {
	    	return true;	
	    }else{
	    	return false;
	    }
    },
    
    fechaContaHiddenArray: function(gastos){
    	var autorizados = 0;
	    var subsanados = 0;
	    var contabilizados = 0;
	    
	    Ext.Array.each(gastos, function(gasto){
	    	if (CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.estadoGastoCodigo) {
	    		autorizados += 1;
	    	} else if (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.estadoGastoCodigo) {
	    		subsanados += 1;
	    	} else if (CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.estadoGastoCodigo) {
	    		contabilizados += 1;
	    	}
		}); 

    	if(autorizados == 0 && subsanados == 0 && contabilizados != 0) {
	    	return true;	
	    }else{
	    	return false;
	    }
    },
    
    fechaPagoAllowBlank: function(gastos){
    	var autorizados = 0;
	    var subsanados = 0;
	    var contabilizados = 0;
	    
	    	Ext.Array.each(gastos, function(gasto){
	    		if (CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.get("estadoGastoCodigo")) {
	    			autorizados += 1;
	    		} else if (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.get("estadoGastoCodigo")) {
	    			subsanados += 1;
	    		} else if (CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.get("estadoGastoCodigo")) {
	    			contabilizados += 1;
	    		}
			});
    	
    	if(autorizados == 0 && subsanados == 0 && contabilizados != 0) {
	    	return false;	
	    } else {
	    	return true;	
	    }
    },
    
    fechaPagoAllowBlankArray: function(gastos){
    	var autorizados = 0;
	    var subsanados = 0;
	    var contabilizados = 0;

	    	Ext.Array.each(gastos, function(gasto){
	    		if (CONST.ESTADOS_GASTO['AUTORIZADO'] == gasto.estadoGastoCodigo) {
	    			autorizados += 1;
	    		} else if (CONST.ESTADOS_GASTO['SUBSANADO'] == gasto.estadoGastoCodigo) {
	    			subsanados += 1;
	    		} else if (CONST.ESTADOS_GASTO['CONTABILIZADO'] == gasto.estadoGastoCodigo) {
	    			contabilizados += 1;
	    		}
			});
    	
    	if(autorizados == 0 && subsanados == 0 && contabilizados != 0) {
	    	return false;	
	    } else {
	    	return true;	
	    }
    },
    
    onExportClickFacturas: function(btn){
		var me = this;
		var url =  $AC.getRemoteUrl('gastosproveedor/generateExcelFacturas');
		var config = {};

		config.url= url;
		config.method = "POST";
		me.fireEvent("downloadFile", config);		
	},
	
	onExportClickTasasImpuestos: function(btn){
		var me = this;
		var url =  $AC.getRemoteUrl('gastosproveedor/generateExcelTasasImpuestos');
		var config = {};

		config.url= url;
		config.method = "POST";
		me.fireEvent("downloadFile", config);		
	},	

	 onChangeChainedCombo: function(combo) {
    	
    	var me = this, chainedCombo = me.lookupReference(combo.chainedReference);
    	me.getViewModel().notify();
		chainedCombo.clearValue("");
		chainedCombo.getStore().load(); 	
    	
    },
    
    onRowClickJuntasList: function(gridView, record){
    	var me = this;
    	me.getView().fireEvent('abrirDetalleJunta', record);
    },
	
    
    onClickBotonCerrar: function(btn){
		var me = this;
		var window = btn.up("window");
		window.hide();
    },
    onSearchBusquedaDirectaGasto: function(btn) {
    	
    		var me = this;
    		var numGastoHaya = btn.up('gestiongastossearch').down('[name="numGastoHaya"]').value;
    		var url= $AC.getRemoteUrl('gastosproveedor/getGastoExists');
    		var data;
    			
    		if(numGastoHaya != ""){
    			Ext.Ajax.request({
    				url: url,
    			    params: {numGastoHaya : numGastoHaya},
    			    success: function(response, opts) {
    			    	data = Ext.decode(response.responseText);
    			    	if(data.success == "true"){
    			    		var titulo = "Gasto " + numGastoHaya;
    			    		me.getView().fireEvent('abrirDetalleGastoDirecto', data.data, titulo);
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
    		
    	onChangeNumGasto: function(me, oValue, nValue){
    		var numGastoHaya = me.up('gestiongastossearch').down('[name="numGastoHaya"]').value;
    		var btn = me.up('gestiongastossearch').down('[reference="btnGasto"]');
    			
    		if(numGastoHaya != ""){
    			btn.setDisabled(false);
    		}else{
    			btn.setDisabled(true);
    		}
    	}
	
});