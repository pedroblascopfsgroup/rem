Ext.define('HreRem.view.activos.detalle.OfertasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialactivolist',
    bind: {
        store: '{storeOfertasActivo}'
    },
        
    initComponent: function () {
        
        var me = this; 
        
        
        me.columns= [
        
		         {
		        	dataIndex: 'id',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaCreacion',
		            text: HreRem.i18n('header.oferta.fechaAlta'),
					cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionTipoOferta',
		            text: HreRem.i18n('header.oferta.tipoOferta'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 1
		        },
		        {
		            dataIndex: 'numAgrupacionRem',
		            text: HreRem.i18n('header.oferta.numAgrupacion'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 1
		        },
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.oferante'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 2
		        },
		        {
		            dataIndex: 'comite',
		            text: HreRem.i18n('header.oferta.comite'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 0.5
		        },
		        {
		            dataIndex: 'precioPublicado',
		            text: HreRem.i18n('header.oferta.precioPublicado'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 1
		        },
		        {
		            dataIndex: 'importeOferta',
		            text: HreRem.i18n('header.oferta.importeOferta'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 1
		        },
		        {
		            dataIndex: 'estadoOferta',
		            text: HreRem.i18n('header.oferta.estadoOferta'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
					editor: {
						xtype: 'combobox',								        		
						store: new Ext.data.Store({
							model: 'HreRem.model.ComboBase',
							proxy: {
								type: 'uxproxy',
								remoteUrl: 'generic/getDiccionario',
								extraParams: {diccionario: 'estadosOfertas'}
							},
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 1
		        },
		        {
		            dataIndex: 'numExpediente',
		            text: HreRem.i18n('header.oferta.expediente'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 1
		        },
		        {
	    			xtype: 'actioncolumn',
		        	dataIndex: 'numExpediente',
			        handler: 'onEnlaceActivosClick',
			        items: [{
			            tooltip: 'Ver Expediente',
			            isDisabled: function(view, rowIndex, colIndex, item, record) {
			            	if (Ext.isEmpty(record.get("numExpediente")))
			            		return true;
			            	else
			            		return false;
			            },
			            iconCls: 'ico-download'
			        }],
		            flex     : 0.5,            
		            align: 'center',
		            menuDisabled: true,
		            hideable: false
		        },
		        {
		            dataIndex: 'descripcionEstadoExpediente',
		            text: HreRem.i18n('header.oferta.estadoExpediente'),
		            cls: 'grid-no-seleccionable-col',
					tdCls: 'grid-no-seleccionable-td',
		            flex: 1
		        }
		        
        ];
        
        me.addListener ('beforeedit', function(editor, context) {
            var estado = context.record.get("codigoEstadoOferta");  
            var allowEdit = estado != '01' && estado != '02';
            this.editOnSelect = allowEdit;
            return allowEdit;
        });  
        
        
        me.addListener ('beforeedit', function(editor) {
        	if (editor.editing)
        		return false;
        });
        	
        me.addListener('canceledit', function(editor){
			me.disableAddButton(false);
			me.disablePagingToolBar(false);
        	me.getSelectionModel().deselectAll();
        	if(editor.isNew) {
        		me.getStore().remove(me.getStore().getAt(me.editPosition));
        		editor.isNew = false;
        	}
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
   	saveSuccessFn: function () {
		var me = this;
		return true;
	},
	
	editFuncion: function(editor, context){
		me= this;
		me.mask(HreRem.i18n("msg.mask.espere"));
			var estado = context.record.get("estadoOferta");	
			if(estado=='01'){
				
				Ext.Msg.show({
				   title: HreRem.i18n('title.confirmar.oferta.aceptacion'),
				   msg: HreRem.i18n('msg.desea.aceptar.oferta'),
				   buttons: Ext.MessageBox.YESNO,
				   fn: function(buttonId) {
				        if (buttonId == 'yes') {
				            
							if (me.isValidRecord(context.record)) {				
			
				        		context.record.save({
				
				                    params: {
				                        idEntidad: Ext.isEmpty(me.idPrincipal) ? "" : this.up('{viewModel}').getViewModel().get(me.idPrincipal)
				                    },
				                    success: function (a, operation, c) {
				                        context.store.load();
				                        me.unmask();
				                        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
										me.saveSuccessFn();											
										
				                    },
				                    
									failure: function (a, operation) {
				                    	
				                    	context.store.load();
				                    	try {
				                    		var response = Ext.JSON.decode(operation.getResponse().responseText)
				                    		
				                    	}catch(err) {}
				                    	
				                    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
				                    		me.fireEvent("errorToast", response.msg);
				                    	} else {
				                    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
				                    	}                        	
										me.unmask();
				                    }
				          		});	                            
					        	me.disableAddButton(false);
					        	me.disablePagingToolBar(false);
					        	me.getSelectionModel().deselectAll();
					        	editor.isNew = false;
							}
							context.store.load();
							me.unmask(); 
						}
				    	else{
				    		context.store.load();
				       		me.unmask(); 	
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
	                        context.store.load();
	                        me.unmask();
	                        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
							me.saveSuccessFn();											
							
	                    },
	                    
						failure: function (a, operation) {
	                    	
	                    	context.store.load();
	                    	try {
	                    		var response = Ext.JSON.decode(operation.getResponse().responseText)
	                    		
	                    	}catch(err) {}
	                    	
	                    	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msg)) {
	                    		me.fireEvent("errorToast", response.msg);
	                    	} else {
	                    		me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko"));
	                    	}                        	
							me.unmask();
	                    }
	                });	                            
	        		me.disableAddButton(false);
	        		me.disablePagingToolBar(false);
	        		me.getSelectionModel().deselectAll();
	        		editor.isNew = false;
				}
				context.store.load();
				me.unmask();
			}
					
	},
	
	isValidRecord: function (record, context) {
		var me = this;
		for (i=0; i<me.getStore().getData().items.length;i++){
			
			if(me.getStore().getData().items[i].data.idOferta != record.data.idOferta){
				codigoEstadoOferta=  me.getStore().getData().items[i].data.codigoEstadoOferta;
				
				if(codigoEstadoOferta=='01' && record.data.estadoOferta=='01'){
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.ya.aceptada"));
					return false;
				}
				else if(codigoEstadoOferta=='01' && record.data.estadoOferta!='02'){
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.rechazar"));
					return false;
				}
				else if(record.data.estadoOferta.length > 2){
					return false
				}
			}
		}
		
		return true;		
	},
   
	
	
   funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		me.lookupController().cargarTabData(me);
   }


});