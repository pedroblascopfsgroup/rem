Ext.define('HreRem.view.expedientes.CompradoresExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'compradoresexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'compradoresexpedienteref',
    scrollable	: 'y',
    controller: 'expedientedetalle',
   

    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.compradores.pbc'));
        var items= [

			{   
				xtype: 'fieldset',
            	title:  HreRem.i18n('title.compradores'),
            	items : [
                	{
					    xtype		: 'gridBase',
					    reference: 'listadoCompradores',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeCompradoresExpediente}'
						},									
						listeners : {
					    	rowdblclick: 'onCompradoresListDobleClick',
					    	rowclick: 'onCompradoresListClick'
					    	
					    },
					    
						columns: [
						   {    text: HreRem.i18n('header.id.cliente'),
					        	dataIndex: 'id',
					        	flex: 1
					       },
						   {
								text: HreRem.i18n('header.nombre.razon.social'),
								dataIndex: 'nombreComprador',
								flex: 1
						   },
						   {
						   		text: HreRem.i18n('header.numero.documento'),
					            dataIndex: 'numDocumentoComprador',
					            flex: 1
						   },						   
						   {
						   		text: HreRem.i18n('header.representante'),
					            dataIndex: 'nombreRepresentante',
					            flex: 1						   
						   },
						   {    text: HreRem.i18n('header.numero.documento'),
					        	dataIndex: 'numDocumentoRepresentante',
					        	flex: 1
					       },
						   {
								text: HreRem.i18n('header.procentaje.compra'),
								dataIndex: 'porcentajeCompra',
								flex: 1
						   },
						   {
						   		text: HreRem.i18n('header.telefono'),
					            dataIndex: 'telefono',
					            flex: 1
						   },						   
						   {
						   		text: HreRem.i18n('header.email'),
					            dataIndex: 'email',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.estado.pbc'),
					            dataIndex: 'estadoPbc',
					            flex: 1						   
						   },
						   {
						   		text: HreRem.i18n('fieldlabel.relacion.hre'),
					            dataIndex: 'relacionHre',
					            flex: 1						   
						   }
					    ],
					    dockedItems : [
					        {
					            xtype: 'pagingtoolbar',
					            dock: 'bottom',
					            displayInfo: true,
					            bind: {
					                store: '{storeCompradoresExpediente}'
					            }
					        }
					    ]
					}
            	]
			},
			{
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',
				reference: 'estadoPbcCompradoRef',
				title: HreRem.i18n('title.estado.pbc.comprador'),
				items :
					[
					
						{
						xtype:'fieldsettable',
						collapsible: false,
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
					
								{
						        	xtype:'fieldset',
						        	width: '80%',
									border: false,
									defaultType: 'textfieldbase',
									items :
										[
											{			
											    xtype		: 'gridBase',
											    features: [{ftype:'grouping'}],
											    reference: 'listadoDocumentosExpediente',
												cls	: 'panel-base shadow-panel',
												bind: {
													store: '{storeDocumentosExpediente}'
												},
												columns: [
												
													{
												        xtype: 'actioncolumn',
												        width: 30,	
												        hideable: false,
												        items: [{
												           	iconCls: 'ico-download',
												           	tooltip: HreRem.i18n("tooltip.download"),
												            handler: function(grid, rowIndex, colIndex) {
												                var grid = me.down('gridBase'),
												                record = grid.getStore().getAt(rowIndex);
												               
												                grid.fireEvent("download", grid, record);					                
										            		}
												        }]
										    		},
												    {   text: HreRem.i18n('header.documento'),
											        	dataIndex: 'documento',
											        	flex: 4
											        },
											        {   text: HreRem.i18n('header.aplica'),
											        	dataIndex: 'aplica',
											        	flex: 1,
											        	width: 50
											        },
											        {   text: HreRem.i18n('header.obtenido'),
											        	dataIndex: 'obtenido',
											        	flex: 1,
											        	width: 50
											        }
											    ]
				
	         			 					}	
				
										]
								},
						        
						        {
						        	xtype:'fieldset',
						        	border: false,
									defaultType: 'textfieldbase',
									items :
										[		
										
											{
		                						fieldLabel:  HreRem.i18n('fieldlabel.responsable.tramitacion'),
		                						bind:		'{detalleComprador.responsableTramitacion}'
		               						},	
										
											 { 
									        	xtype: 'comboboxfieldbase',							        	
									        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
									        	bind: {
								            		store: '{comboEstado}',
								            		value: '{estado}'
								            	},
					            				displayField: 'descripcion',
		    									valueField: 'codigo',
		    									readOnly: true
									        },
									        {	
											 	xtype:'datefieldbase',
											 	fieldLabel:  HreRem.i18n('fieldlabel.fecha.peticion'),
					        					bind: '{fechaPeticion}',
					        					readOnly: true
									        },
									        {	
											 	xtype:'datefieldbase',
											 	fieldLabel:  HreRem.i18n('fieldlabel.fecha.resolucion'),
					        					bind: '{fechaResolucion}',
					        					readOnly: true
									        }
									        
									        
									        
											
										]
						        	}
						        ]
					}
						
					    
		        ]
            },
            {
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.detalle.pbc'),
				items :
					[
		                {
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.proporcional.oferta'),
		                	bind:		'{detalleComprador.importeProporcionalOferta}',
		                	readOnly: true

		                },
		                { 
							xtype: 'comboboxfieldbase',
		                	fieldLabel:  HreRem.i18n('fieldlabel.destino.activo'),
				        	bind: {
			            		store: '{comboDestinoActivo}',
			            		value: '{destinoActivo}'
			            	},
			            	displayField: 'descripcion',
		    				valueField: 'codigo',
		    				allowBlank: false,
		    				listeners: {
		    					change: 'onHaCambiadoDestinoActivo'
		    				}
				        },
				        {	
				        	xtype: 'textfieldbase',
				        	reference: 'otrosDetallePbc',
		                	fieldLabel:  HreRem.i18n('fieldlabel.otros'),
		                	bind:		'{detalleComprador.otros}',
		                	allowBlank: false,
		                	disabled: '{!esDestinoActivoOtros}'
		                },
				        {	
				        	xtype: 'numberfieldbase',
				        	symbol: HreRem.i18n("symbol.euro"),
		                	fieldLabel:  HreRem.i18n('fieldlabel.importe.financiado'),
		                	bind:		'{detalleComprador.importeFinanciado}'
		                }
		        ]
            },
            {
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',				
				title: HreRem.i18n('title.politica.corporativa'),
				items :
					[
						{
		                	xtype: 'comboboxfieldbase',
							reference: 'comboConflictoIntereses',
		                	fieldLabel:  HreRem.i18n('fieldlabel.conflicto.intereses'),
				        	bind: {
			            		store: '{comboConflictoIntereses}',
			            		value: '{conflictoIntereses}'
			            	},
			            	allowBlank: false
		                },
		                {
		                	xtype: 'comboboxfieldbase',
							reference: 'comboRiesgoReputacional',
		                	fieldLabel:  HreRem.i18n('fieldlabel.riesgo.reputacional'),
				        	bind: {
			            		store: '{comboRiesgoReputacional}',
			            		value: '{riesgoReputacional}'
			            	},
			            	allowBlank: false
		                }
		        ]
            }
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		var listadoCompradores = me.down("[reference=listadoCompradores]");
		
		// FIXME ¿¿Deberiamos cargar la primera página??
		listadoCompradores.getStore().load();
		
//		me.lookupController().cargarTabData(me);

    }
    
    
});