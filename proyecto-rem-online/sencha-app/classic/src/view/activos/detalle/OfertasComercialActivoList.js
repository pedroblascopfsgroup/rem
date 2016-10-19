Ext.define('HreRem.view.activos.detalle.OfertasComercialActivoList', {
	extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'ofertascomercialactivolist',
    bind: {
        store: '{storeOfertasActivo}'
    },
    requires: ['HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo'],
    topBar: true,

    listeners: {
    	boxready: function() {
    		me = this;
    		me.evaluarEdicion();
    	}
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
		        /*{
		            dataIndex: 'numAgrupacionRem',
		            text: HreRem.i18n('header.oferta.numAgrupacion'),
		            flex: 1
		        },*/
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
		var items= me.up('activosdetalle').getRefItems();
		
		for(var i=0;i<=items.length;i++){
			if(items[i].getXType()=='datosgeneralesactivo'){
				
				var datosBasicos= items[i].down('datosbasicosactivo');
				var record= datosBasicos.getBindRecord(),
				idActivo= record.get('id'),
				numActivo= record.get('numActivo'),
				pertenceAgrupacionRestringida= record.get('pertenceAgrupacionRestringida');
				break;
			}
		}
		
		if(pertenceAgrupacionRestringida=="false" || pertenceAgrupacionRestringida==undefined){
			var parent= me.up('ofertascomercialactivo'),
			oferta = Ext.create('HreRem.model.OfertaComercialActivo', {idActivo: idActivo, numActivo: numActivo});
			Ext.create('HreRem.view.activos.detalle.AnyadirNuevaOfertaActivo',{oferta: oferta, parent: parent}).show();
		}else{
			me.fireEvent("errorToast", HreRem.i18n("msg.boton.add.oferta.activo"));
		}
	    				    	
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
				                    	me.saveFailureFn();
			                      	
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
	                    	me.saveFailureFn();
                      	
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
				
				if(codigoEstadoOferta=='01' && record.data.codigoEstadoOferta=='01'){
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.ya.aceptada"));
					return false;
				}
				else if(codigoEstadoOferta=='01' && record.data.codigoEstadoOferta!='02'){
					me.fireEvent("errorToast", HreRem.i18n("msg.operacion.ko.guardar.oferta.solo.rechazar"));
					return false;
				}
				else if(record.data.codigoEstadoOferta.length > 2){
					return false
				}
			}
		}
		
		return true;		
	},
    saveSuccessFn: function () {
   		var me = this;
        me.unmask();			                        
        me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));	
		return true;
	},
	
	saveFailureFn: function() {
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
		
		if(activo.get('incluidoEnPerimetro')=="false" || !activo.get('aplicaComercializar')) {
			me.setTopBar(false);
			me.rowEditing.clearListeners();
		}
		
   }


});