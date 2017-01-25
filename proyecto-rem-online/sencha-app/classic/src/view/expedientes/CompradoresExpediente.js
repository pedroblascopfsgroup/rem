Ext.define('HreRem.view.expedientes.CompradoresExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'compradoresexpediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'compradoresexpedienteref',
    scrollable	: 'y',
  

    initComponent: function () {

        var me = this;
		me.setTitle(HreRem.i18n('title.compradores'));
        var items= [

			{   
				xtype: 'fieldset',
            	title:  HreRem.i18n('title.compradores'),
            	items : [
                	{
					    xtype		: 'gridBase',
					    topBar		: true,
					    reference: 'listadoCompradores',
						cls	: 'panel-base shadow-panel',
						bind: {
							store: '{storeCompradoresExpediente}'
						},									
						listeners : {
					    	rowdblclick: 'onCompradoresListDobleClick'					    	
					    },
					    features: [{
				            id: 'summary',
				            ftype: 'summary',
				            hideGroupedHeader: true,
				            enableGroupingMenu: false,
				            dock: 'bottom'
					    }],
						columns: [
							{
						        xtype: 'actioncolumn',
						        reference: 'titularContratacion',
						        width: 30,
						        text: HreRem.i18n('header.principal'),
								hideable: false,
								items: [
								        	{
									            getClass: function(v, meta, rec) {
									                if (rec.get('titularContratacion') != 1) {
									                	this.items[0].handler = 'onMarcarPrincipalClick';
									                    return 'fa fa-check';
									                } else {
							            				this.items[0].handler = 'onMarcarPrincipalClick';
									                    return 'fa fa-check green-color';
									                }
									            }
								        	}
								 ]
				    		}, 
						   {    text: HreRem.i18n('header.id.cliente'),
					        	dataIndex: 'id',
					        	flex: 1,
					        	hidden: true,
					        	hideable: false
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
								flex: 1,
								renderer: function(value) {
					            	return Ext.util.Format.number(value, '0.00%');
					            },
					            summaryType: 'sum',
					            summaryRenderer: function(value, summaryData, dataIndex) {
					            	var msg = HreRem.i18n("fieldlabel.porcentaje.compra.total") + " " + value + "%";
					            	var style = "" 
					            	if(value != 100) {
					            		msg = HreRem.i18n("fieldlabel.porcentaje.compra.total.error")	
					            		style = "style= 'color: red'" 
					            	}			            	
					            	return "<span "+style+ ">"+msg+"</span>"
					            }
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
					            dataIndex: 'descripcionEstadoPbc',
					            flex: 1,
					            hidden: true
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
					    ],
					    onClickAdd: function (btn) {
							var me = this;
							var controller= me.lookupController();
							controller.abrirFormularioCrearComprador(me);
											    				    	
						}
					}
            	]
			} 
			
			// HREOS - 939 Fuera de alcance detalle PBC
			/*,{
				xtype:'fieldsettable',
				defaultType: 'displayfieldbase',
				reference: 'estadoPbcCompradoRef',
				title: HreRem.i18n('title.detalle.pbc'),
				items :
					[
					
						{
						xtype:'fieldsettable',
						layout: {
							type: 'table',
							columns: 2,
							width: 200
						},
						collapsible: false,
						border: false,
							defaultType: 'displayfieldbase',				
							items : [
					
								{
						        	xtype:'fieldset',
						        	width: 500,
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
													//store: '{storeDocumentosExpediente}'
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
						        	layout: {
										type: 'table',
										columns: 2,
										width: 200
									},
									defaultType: 'textfieldbase',
									items :
										[
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
											        	fieldLabel:  HreRem.i18n('fieldlabel.estado'),
				                						bind:		'{detalleComprador.descripcionEstadoPbc}',
				    									readOnly: true
											        },
											        {	
													 	xtype:'datefieldbase',
													 	fieldLabel:  HreRem.i18n('fieldlabel.fecha.peticion'),
							        					bind: '{detalleComprador.fechaPeticion}',
							        					readOnly: true
											        },
											        {	
													 	xtype:'datefieldbase',
													 	fieldLabel:  HreRem.i18n('fieldlabel.fecha.resolucion'),
							        					bind: '{detalleComprador.fechaResolucion}',
							        					readOnly: true
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
							                	fieldLabel:  HreRem.i18n('fieldlabel.importe.proporcional.oferta'),
							                	bind:		'{detalleComprador.importeProporcionalOferta}',
							                	readOnly: true
					
							                },
							                {	
									        	xtype: 'numberfieldbase',
									        	symbol: HreRem.i18n("symbol.euro"),
							                	fieldLabel:  HreRem.i18n('fieldlabel.importe.financiado'),
							                	bind:		'{detalleComprador.importeFinanciado}'
							                },
							                { 
												xtype: 'comboboxfieldbase',
							                	fieldLabel:  HreRem.i18n('fieldlabel.destino.activo'),
									        	bind: {
								            		store: '{comboDestinoActivo}',
								            		value: '{detalleComprador.codUsoActivo}'
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
							                }
							                ]}

											
										]
						        	}
						        ]
					}
						
					    
		        ]
            }*/
          
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
		var me = this; 
		me.recargar = false;
		//recargar grid
		var listadoCompradores = me.down("[reference=listadoCompradores]");
		listadoCompradores.getStore().load();
		
//		me.lookupController().cargarTabData(me);

    }
    
    
});