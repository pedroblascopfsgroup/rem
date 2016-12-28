Ext.define('HreRem.view.agrupacion.detalle.OfertasComercialAgrupacionList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialagrupacionlist',
    topBar: true,
    bind: {
        store: '{storeOfertasAgrupacion}',
        topBar: '{agrupacionficha.esEditable}',
		editOnSelect: '{agrupacionficha.esEditable}'
    },
    requires: ['HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaAgrupacion'],
    
   	removeButton: false,
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
		            formatter: 'date("d/m/Y H:i")',
		            flex: 1
		        },
		        {
		            dataIndex: 'descripcionTipoOferta',
		            text: HreRem.i18n('header.oferta.tipoOferta'),
		            flex: 1
		        },
		        /*{
		            dataIndex: 'numAgrupacionRem',
		            text: HreRem.i18n('header.oferta.numAgrupacion'),
		            flex: 1
		        },*/
		        {
		            dataIndex: 'ofertante',
		            text: HreRem.i18n('header.oferta.ofertante'),
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
							autoLoad: true
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
         	
         	if(this.editOnSelect) {
	            var estado = context.record.get("codigoEstadoOferta");  
	            var allowEdit = estado != '01' && estado != '02';
	            this.editOnSelect = allowEdit;
         	}
            return this.editOnSelect;
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
    
    onAddClick: function (btn) {
		var me = this;
		var items= me.up('agrupacionesdetalle').getRefItems();
		
		for(var i=0;i<=items.length;i++){
			if(items[i].getXType()=='fichaagrupacion'){
				var record= items[i].getBindRecord(),
				idAgrupacion= record.get('id'),
				numAgrupacionRem= record.get('numAgrupRem');
				break;
			}
		}

		var parent= me.up('ofertascomercialagrupacion');
		oferta = Ext.create('HreRem.model.OfertaComercial', {idAgrupacion: idAgrupacion, numAgrupacionRem: numAgrupacionRem});
		Ext.create('HreRem.view.agrupaciones.detalle.AnyadirNuevaOfertaAgrupacion',{oferta: oferta, parent: parent}).show();
		    				    	
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
						}
				    	else{
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
				hayOfertaAceptada = CONST.ESTADOS_OFERTA['ACEPTADA'] == codigoEstadoOferta;
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

   		me.lookupController().lookupReference('activosagrupacion').lookupController().refrescarAgrupacion(true);
        me.unmask();
        me.getStore().load();
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
		
	}


});

