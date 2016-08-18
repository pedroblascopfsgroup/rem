Ext.define('HreRem.view.agrupacion.detalle.OfertasComercialAgrupacionList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialagrupacionlist',
    bind: {
        store: '{storeOfertasAgrupacion}'
    },
        
    initComponent: function () {
        
        var me = this;  
        
        me.columns= [
        
		          {
		        	dataIndex: 'numOferta',
		            text: HreRem.i18n('header.oferta.numOferta'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'fechaCreacion',
		            text: HreRem.i18n('header.oferta.fechaAlta'),
		            formatter: 'date("d/m/Y")',
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionTipoOferta',
		            text: HreRem.i18n('header.oferta.tipoOferta'),
		            flex: 1
		        },
		        {
		            dataIndex: 'numAgrupacionRem',
		            text: HreRem.i18n('header.oferta.numAgrupacion'),
		            flex: 1
		        },
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.oferante'),
		            flex: 2
		        },
		        {
		            dataIndex: 'comite',
		            text: HreRem.i18n('header.oferta.comite'),
		            flex: 0.5
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
		            dataIndex: 'estadoOferta',
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
							autoLoad: true
						}),
						displayField: 'descripcion',
    					valueField: 'codigo'
					},
		            flex: 1
		        },
		        {
	    			xtype: 'actioncolumn',
	    			text: HreRem.i18n('header.oferta.expediente'),
		        	dataIndex: 'numExpediente',
			        items: [{
			            tooltip: HreRem.i18n('tooltip.ver.expediente'),
			            getClass: function(v, metadata, record ) {
			            	if (!Ext.isEmpty(record.get("numExpediente"))) {
			            		return 'fa fa-folder-open';
			            	}			            	
			            },
			            handler: 'onClickAbrirExpedienteComercial'
			        }],
			        renderer: function(value, metadata, record) {			        	
			        	if(Ext.isEmpty(record.get("numExpediente"))) {
			        		return "";
			        	} else {
			        		return '<div style="float:left; margin-top:3px; font-size: 11px; line-height: 1em;">'+ value+'</div>'
			        	}
			        },
		            flex     : 1,            
		            align: 'center',
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
            var allowEdit = estado != '01' && estado != '02';
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
		                store: '{storeOfertasAgrupacion}'
		            }
		        }
		];
		    
        me.callParent(); 
        
    },
	
	editFuncion: function(editor, context){

		var me= this;
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
				var codigoEstadoOferta=  me.getStore().getData().items[i].data.codigoEstadoOferta;
				
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
	}


});

