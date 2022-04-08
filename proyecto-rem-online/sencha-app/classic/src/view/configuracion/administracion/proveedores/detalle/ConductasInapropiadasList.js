Ext.define('HreRem.view.configuracion.administracion.proveedores.detalle.ConductasInapropiadasList', {
    extend		: 'HreRem.view.common.GridBaseEditableRow',
    xtype		: 'conductasInapropiadasList',
	topBar		: true,
	editOnSelect: true,
	idPrincipal : 'id',
    bind: {
        store: '{storeConductasInapropiadas}'
    },

    initComponent: function () {
     	var me = this;
		me.setTitle('Conductas inapropiadas');
		me.columns = [
				{
					dataIndex: 'usuarioAlta',
					text: HreRem.i18n('title.conductas.usuario.alta'),
					flex: 0.8
				},
		        {
		            dataIndex: 'fechaAlta',
		            text: HreRem.i18n('title.conductas.fecha.alta'),
		            flex: 0.5
		        },
		        {
		            dataIndex: 'tipoConducta',
		            text: HreRem.i18n('title.conductas.tipo.conducta'),
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboTipoConducta}'
			            },
						allowBlank: false,
			            reference: 'tipoConductaCombo',
			            chainedStore: '{comboCategoriaConductaFiltered}',
						chainedReference: 'categoriaConductaCombo',
			            listeners: {
			            	select: 'onChangeTipoConducta'
			            }
			        },
		            flex: 0.4
		        },
		        {
		            dataIndex: 'categoriaConducta',
		            text: HreRem.i18n('title.conductas.categoria.conducta'),
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboCategoriaConductaFiltered}'
			            },
						disabled: true,
			            reference: 'categoriaConductaCombo',
			            chainedStore: '{comboNivelConductaFiltered}',
						chainedReference: 'nivelConductaCombo',
			            listeners: {
			            	select: 'onChangeCategoriaConducta'
			            }
			        },
		            flex: 1.2
		        },
		        {
		            dataIndex: 'nivelConducta',
		            text: HreRem.i18n('title.conductas.nivel.gravedad'),
		            editor: {
			            xtype: 'combobox',
			            displayField: 'descripcion',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboNivelConductaFiltered}'
			            },
			            reference: 'nivelConductaCombo',
						disabled: true,
						readOnly: true
			        },
		            flex: 0.4
		        },		        
		        {
		            dataIndex: 'comentarios',
		            text: HreRem.i18n('title.conductas.comentarios'),
		            editor: {
		        		xtype: 'textarea'
		        	},
		            flex: 1
		         
		        },	
		        {
		            dataIndex: 'delegacion',
		            text: HreRem.i18n('title.conductas.delegacion.conducta'),
		            editor: {
			            xtype: 'combobox',
			            displayField: 'codigo',
			            valueField: 'codigo',
			            bind: {
			            	store: '{comboDelegaciones}'
			            },
			            reference: 'delegacionesCombo'
			        },
		            flex: 0.5
		        },
				{
                    text : HreRem.i18n('title.conductas.doc.adjunto'),
                    flex : 1.5,
                    dataIndex : 'adjunto',
                    xtype: 'actioncolumn',
                    items: [							
							{
                 				xtype: 'button',
                  				//handler: 'onClickDescargarAdjuntoAN',
                  				isDisabled: function(view, rowIndex, colIndex, item, record ) {
					            	if (!Ext.isEmpty(record.get("idadjunto"))) return false;
					            	return true;		            	
			            		},
			            		getClass: function(v, metadata, record ) {					            	
					            	return 'margen-derecha ico-download';					            
					            }
              		 		},
              		 		{
                 				xtype: 'button',                  				
                  				//handler: 'onClickCargarAdjuntoAN',
                  				isDisabled: function(view, rowIndex, colIndex, item, record ) {
					            	if (Ext.isEmpty(record.get("idadjunto"))) return false;
					            	return true;		            	
			            		},
			            		getClass: function(v, metadata, record ) {					            	
					            	return 'margen-derecha ico-upload-documento';					            
					            }
              		 		},
              		 		{
                 				xtype: 'button',
                  				//handler: 'onClickBorrarAdjuntoAN',
                  				isDisabled: function(view, rowIndex, colIndex, item, record ) {
					            	if (!Ext.isEmpty(record.get("idadjunto"))) return false;
					            	return true;		            	
			            		},
			            		getClass: function(v, metadata, record ) {					            	
					            	return 'ico-delete-documento';					            
					            }
              		 		}
          		 	],
          		 	renderer: function(value, metadata, record) {
          		 		var documento = null;
          		 		if(!Ext.isEmpty(record.get("adjunto"))){
          		 			documento = record.get("adjunto");
          		 		}
          		 		if(Ext.isEmpty(record.get("adjunto"))) {
			        		return '<div style="float:left; margin:3px; font-size: 11px; line-height: 1em;"></div>'
			        	} else {
			        		return '<div style="float:left; margin:3px; font-size: 11px; line-height: 1em;"><strong>'+documento+'</strong></div>'
			        	}
		        		
		        	}
				}
		    ];
		

		    me.dockedItems = [
		        {
		            xtype: 'pagingtoolbar',
		            dock: 'bottom',
		            inputItemWidth: 60,
		            displayInfo: true,
		            bind: {
		                store: '{storeConductasInapropiadas}'
		            }
		        }
		    ];

		    me.callParent();
	        
	        
   },
   
   onAddClick: function(btn){
		
		var me = this;
		var rec = Ext.create(me.getStore().config.model);
		me.getStore().sorters.clear();
		me.editPosition = 0;
		rec.setId(null);
		rec.data.esEditable = true;
	    me.getStore().insert(me.editPosition, rec);
	    me.rowEditing.isNew = true;
	    me.rowEditing.startEdit(me.editPosition, 0);
	    me.disableAddButton(true);
	    me.disablePagingToolBar(true);

   },
   saveFunction: function(editor, context){
	   var me = this, comentarios = context.record.data.comentarios, 
			categoriaConductaCodigo = context.record.data.categoriaConductaCodigo != null ? context.record.data.categoriaConductaCodigo : context.record.data.categoriaConducta,
			delegacion = context.record.data.delegacion;
		me.mask(HreRem.i18n("msg.mask.espere"));
		if (me.isValidRecord(context.record)) {	
    		context.record.save({
                params: {
                    idProveedor: this.up('{viewModel}').getViewModel().get('proveedor.id'),
					comentarios: comentarios,
					categoriaConductaCodigo: categoriaConductaCodigo,
					delegacion: delegacion
                },
                success: function (a, operation, c) {
                    if (context.store.load) {
                    	context.store.load();
                    }
                    me.unmask();
                    me.fireEvent("infoToast", HreRem.i18n("msg.operacion.ok"));																			
					me.saveSuccessFn();											
					
                },
				failure: function (a, operation) {
                	context.store.load();
                	try {
                		var response = Ext.JSON.decode(operation.getResponse().responseText)
                		
                	}catch(err) {}
                	
                	if(!Ext.isEmpty(response) && !Ext.isEmpty(response.msgError)) {
                		me.fireEvent("errorToast", response.msgError);
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
   }
   
});
