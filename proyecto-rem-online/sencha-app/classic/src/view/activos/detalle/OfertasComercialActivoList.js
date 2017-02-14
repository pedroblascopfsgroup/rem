Ext.define('HreRem.view.activos.detalle.OfertasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialactivolist',
    bind		: {
        store: '{storeOfertasActivo}'
    },
    requires	: ['HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo'],
    topBar		: true,
	removeButton: false,
    listeners	: {
    	focusenter: function() {
    		me = this;
    		me.evaluarEdicion();
    	},
    	boxReady: function() {
    		me = this;
    		me.evaluarEdicion();
    	},
    	rowclick: 'onOfertaListClick'
    },

    initComponent: function () {

        var me = this;

        me.columns= [
		        {
		        	dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            flex: 1
		        },
		        {	  
		        	xtype: 'actioncolumn',
		            dataIndex: 'numActivoAgrupacion',
		            text: HreRem.i18n('header.numero.activo.agrupacion'),
		            flex: 1,
		            items: [{
			            tooltip: HreRem.i18n('tooltip.ver.expediente'),
			            getClass: function(v, metadata, record ) {
			            	if (Ext.isEmpty(record.get("idAgrupacion"))) {
			            		return 'app-list-ico ico-ver-activov2';
			            	}
			            	else{
			            		return 'app-list-ico ico-ver-agrupacion'
			            	}
			            },
			            handler: 'onClickAbrirActivoAgrupacion'
			        }],
			        renderer: function(value, metadata, record) {
			        	return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>';
			        },
		            flex     : 1,            
		            align: 'right',
		            hideable: false,
		            sortable: true
		        },
		        {
		            dataIndex: 'fechaCreacion',
		            text: HreRem.i18n('header.oferta.fechaAlta'),
		            formatter: 'date("d/m/Y H:i")',
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionTipoOferta',
		            text: HreRem.i18n('header.oferta.tipoOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.ofertante'),
		            flex: 1
		        },
		        {
		            dataIndex: 'comite',
		            text: HreRem.i18n('header.oferta.comite'),
		            flex: 1,
		            hidden: true
		        },
		        {
		        	dataIndex: 'canalPrescripcionDescripcion',
		        	text: HreRem.i18n('header.canal.prescripcion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'precioPublicado',
		            text: HreRem.i18n('header.oferta.precioPublicado'),
		            flex: 1
		        },
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.oferta.importeOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'codigoEstadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
					editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'estadosOfertas'}
							},
							autoLoad: true,
							bind: {
								disabled: '{activo.aplicaComercializar}'
							}
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
					renderer: function(value, metaData, record, rowIndex, colIndex, store, view) {								        		
			        		var me = this,
			        		comboEditor = me.columns  && me.columns[colIndex].getEditor ? me.columns[colIndex].getEditor() : me.getEditor ? me.getEditor() : null,
			        		store, record;
			        		
			        		if(!Ext.isEmpty(comboEditor)) {
				        		store = comboEditor.getStore(),							        		
				        		record = store.findRecord("codigo", value);
			        		
				        		if(!Ext.isEmpty(record)) {								        			
				        			return record.get("descripcion");								        		
				        		} else {
				        			comboEditor.setValue(value);								        			
				        		}
			        		}
			        },
		            flex: 1
		        },
		        /*{
		            dataIndex: 'numExpediente',
		            text: HreRem.i18n('header.oferta.expediente'),
		            flex: 1
		        },*/
		        {
	    			xtype: 'actioncolumn',
	    			text: HreRem.i18n('header.oferta.expediente'),
		        	dataIndex: 'numExpediente',
			        items: [{
			            tooltip: HreRem.i18n('tooltip.ver.expediente'),
			            getClass: function(v, metadata, record ) {
			            	if (!Ext.isEmpty(record.get("numExpediente"))) {
			            		return 'fa fa-folder-open blue-medium-color';
			            	}			            	
			            },
			            handler: 'onClickAbrirExpedienteComercial'
			        }],
			        renderer: function(value, metadata, record) {
			        	if(Ext.isEmpty(record.get("numExpediente"))) {
			        		return "";
			        	} else {
			        		return '<div style="display:inline; margin-right: 15px; font-size: 11px;">'+ value+'</div>'
			        	}
			        },
		            flex     : 1,            
		            align: 'right',
		            menuDisabled: true,
		            hideable: false
		        },
		        {
		            dataIndex: 'descripcionEstadoExpediente',
		            text: HreRem.i18n('header.oferta.estadoExpediente'),
		            flex: 1
		        }
		        
        ];
        
        me.addListener ('beforeedit', function(editor, context) {
            var estado = context.record.get("codigoEstadoOferta");
            var numAgrupacion = context.record.get("numAgrupacionRem");  
            var allowEdit = estado != '01' && estado != '02' && Ext.isEmpty(numAgrupacion);
            this.editOnSelect = allowEdit;
            return allowEdit;
        });  

        
        me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            itemId: 'ofertasPaginationToolbar',
		            inputItemWidth: 100,
		            displayInfo: true,
		            bind: {
		                store: '{storeOfertasActivo}'
		            }
		        }
		];
		
        me.callParent(); 
        
    },
	
	onAddClick: function (btn) {
		var me = this;
		var activo = me.lookupController().getViewModel().get('activo'),
		idActivo= activo.get('id'),
		numActivo= activo.get('numActivo');

		var parent= me.up('ofertascomercialactivo'),
		oferta = Ext.create('HreRem.model.OfertaComercialActivo', {idActivo: idActivo, numActivo: numActivo});
		Ext.create('HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo',{oferta: oferta, parent: parent}).show();
	    				    	
	},
	
	editFuncion: function(editor, context){
		var me= this;
		
			var estado = context.record.get("codigoEstadoOferta");	
			if(CONST.ESTADOS_OFERTA['ACEPTADA'] == estado){
				
				Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.oferta.aceptacion'),
				   msg: HreRem.i18n('msg.desea.aceptar.oferta'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {

							if (me.isValidRecord(context.record)) {				
								me.mask(HreRem.i18n("msg.mask.espere"));
				        		context.record.save({
				
				                    params: {
				                        idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal)
				                    },
				                    success: function (a, operation, c) {																			
										me.saveSuccessFn();
									},
				                    
									failure: function (a, operation) {
				                    	me.saveFailureFn(operation);
			                      	
				                    },
				                    callback: function() {
				                    	me.unmask();
				                    	me.getStore().load();
				                    }
				          		});	                            
					        	me.disableAddButton(false);
					        	me.disablePagingToolBar(false);
					        	me.getSelectionModel().deselectAll();
					        	editor.isNew = false;
							} else {
				    			me.getStore().load(); 	
				    		}
						} else{
				    		me.getStore().load(); 	
				    	}
					}
				});
			}
			else{
				
				if (me.isValidRecord(context.record)) {				
			
	        		context.record.save({
	
	                    params: {
	                        idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal)
	                    },
	                    success: function (a, operation, c) {																			
							me.saveSuccessFn();
						},
	                    
						failure: function (a, operation) {
	                    	me.saveFailureFn(operation);
                      	
	                    },
            			callback: function() {
	                    	me.unmask();
	                    	me.getStore().load();
	                    }
	                });	                            
	        		me.disableAddButton(false);
	        		me.disablePagingToolBar(false);
	        		me.getSelectionModel().deselectAll();
	        		editor.isNew = false;
				} else {
				   me.getStore().load(); 	
				}
			}
					
	},
	
	isValidRecord: function (record, context) {
		
		var me = this;
		var hayOfertaAceptada=false;
		for (i=0; !hayOfertaAceptada && i<me.getStore().getData().items.length;i++){
			
			if(me.getStore().getData().items[i].data.idOferta != record.data.idOferta){
				var codigoEstadoOferta=  me.getStore().getData().items[i].data.codigoEstadoOferta;
				var codigoEstadoExpediente=  me.getStore().getData().items[i].data.codigoEstadoExpediente;
				var expedienteBlocked = CONST.ESTADOS_EXPEDIENTE['APROBADO'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['RESERVADO'] == codigoEstadoExpediente 
					|| CONST.ESTADOS_EXPEDIENTE['EN_DEVOLUCION'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['VENDIDO'] == codigoEstadoExpediente 
					|| CONST.ESTADOS_EXPEDIENTE['FIRMADO'] == codigoEstadoExpediente || CONST.ESTADOS_EXPEDIENTE['BLOQUEO_ADM'] == codigoEstadoExpediente;
				hayOfertaAceptada = CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoOferta && expedienteBlocked;
			}
		}
		
		var codigoEstadoNuevo = record.data.codigoEstadoOferta;
		
		if(hayOfertaAceptada && CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.ya.aceptada"));
			return false;
		} else if(hayOfertaAceptada && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.rechazar"));
			return false;
		} else if(!hayOfertaAceptada && CONST.ESTADOS_OFERTA['RECHAZADA'] != codigoEstadoNuevo && CONST.ESTADOS_OFERTA['ACEPTADA'] != codigoEstadoNuevo ){
			me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.aceptar.rechazar"));
			return false;
		}
		
		return true;			
	},
    saveSuccessFn: function () {
   		var me = this;
        me.unmask();			                        
        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));	
		return true;
	},
	
	saveFailureFn: function(operation) {
		var me = this;
        try {
    		var response = Ext.JSON.decode(operation.getResponse().responseText)
    		
    	}catch(err) {}
    	
    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
    		me.fireEvent("errorToast", response.msg);
    	} else {
    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
    	}  
		
	},
	
	
   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
   },
   
   //HREOS-846 Si NO esta dentro del perimetro, ocultamos del grid las opciones de agregar/elminar y las acciones editables por fila
   //HREOS-1001 Si está en el perimetro pero no es comercializable tampoco se puede editar
   evaluarEdicion: function() {    	
		var me = this;
		var activo = me.lookupController().getViewModel().get('activo');

		if(activo.get('incluidoEnPerimetro')=="false" || !activo.get('aplicaComercializar') || activo.get('pertenceAgrupacionRestringida')
			||activo.get('situacionComercialDescripcion') == "Vendido" ) {
			me.setTopBar(false);
			me.rowEditing.clearListeners();
		}
		
   }


});