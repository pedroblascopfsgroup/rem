Ext.define('HreRem.view.expedientes.CabeceraExpediente', {
    extend: 'Ext.container.Container',
    xtype: 'cabeceraexpediente',
    requires: ['HreRem.view.common.ToolFieldSet'],
    layout: 'fit',
    initComponent: function () {
    
	    var me = this;
	    
	    var columns = 3;
	    if(me.lookupViewModel().get('expediente.tipoExpedienteCodigo') == CONST.TIPOS_EXPEDIENTE_COMERCIAL["ALQUILER"]){
	    	columns=4;
	    }
	    me.menu = Ext.create("Ext.menu.Menu", {
	    	width: 150,
		    cls: 'menu-favoritos',
		    plain: true,
		    floating: true,
	    	items: [
	    		{
	    			text: HreRem.i18n('btn.cerrar.pestanya'),
	    			handler: 'onClickBotonCerrarPestanya'
	    		},
	    		{
	    			text: HreRem.i18n('btn.cerrar.todas'),
	    			handler: 'onClickBotonCerrarTodas'
	    		}	    		
	    	]
	    	
	    });	
	 
	    me.items= [	 
	    
				    {
			    			xtype:'toolfieldset',
			    			height: 175,
			   				bind: {
			   		         title: 'EXPEDIENTE COMERCIAL {expediente.numExpediente} / {getTipoExpedienteCabecera} '
			   		        },
			        		cls: 'fieldsetBase cabecera',
			        		border: false,
							collapsible: true,
							collapsed: false,
						    layout: {
						        type: 'hbox'
						    },
						    
						    tools: [
								    
							    	{	xtype: 'tbfill'},
							    	{
										xtype: 'button',
										margin: '10 6 0 0',
										cls: 'btn-tbfieldset boton-cabecera',
										iconCls: 'ico-refrescar',
										handler	: 'onClickBotonRefrescar',
										tooltip: HreRem.i18n('btn.refrescar')
							    	},								
									{
										xtype: 'button',
										margin: '10 6 0 0',
										cls: 'btn-tbfieldset boton-cabecera',
										iconCls: 'x-fa fa-bars',
										arrowVisible: false,
				   						menuAlign: 'tr-br',								
								        menu:  me.menu
							    	}
							],
						    
							items: [
								        {								                   		
					                   		xtype:'container',
					                   		flex: 4,
					                   		maxWidth: 900,
											height: 125,
					                   		margin: '5 10 10 30 ',
											defaultType: 'displayfield',
											defaults: {
												labelWidth: 80},
											autoScroll: true,
											layout: {
											    type: 'table',
										        columns: columns,
										        trAttrs: {width: '100%', pading: 0},
										        tdAttrs: {width: '20%',  pading: 0},
										        tableAttrs: {
										            style: {
										                width: '100%'
														}
										        }
											},
											cls: 'cabecera-apartado cabecera-info',
											items: [
										                { 
															xtype: 'imagefield',
															fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
															cls: 'cabecera-info-field',
															width: 70,
										                	bind: {
										                		hidden:'{isEmptySrcCartera}',
										                		src: '{getSrcCartera}',
										                		alt: '{expediente.entidadPropietariaDescripcion}'
										                	}
										                },
										                {
																fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
																cls: 'cabecera-info-field',
																fieldStyle: 'color: #0a94d6 !important;font-weight: bold !important',
																width: 70,
																bind: {
																	hidden:'{!isEmptySrcCartera}',
																	value: '{expediente.entidadPropietariaDescripcion}'
																}
																
														},
										                {
										                	xtype: 'currencyfieldbase',
										                	fieldLabel: HreRem.i18n('fieldlabel.importe'),
															cls: 'cabecera-info-field',
															bind:		'{expediente.importe}'
														},
									                   	{ 
													 		fieldLabel: HreRem.i18n('fieldlabel.fecha.alta'),
													 		cls: 'cabecera-info-field',
											            	bind:		'{expediente.fechaAlta}',
											            	renderer: Ext.util.Format.dateRenderer('d/m/Y')
											            },
											            {   
											            	xtype:'comboboxfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.tipo.alquiler'),
															cls: 'cabecera-info-field',
															bind :{ 
																value: '{expediente.tipoAlquiler}',
																store: '{comboTipoAlquiler}',
																hidden: '{esOfertaVenta}'
															}
										                },
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.propietario'),
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.propietario}'
										                },
														{ 
															cls: 'cabecera-info-field',
										                	bind:{
																fieldLabel:'{compradorTipoEsAlquiler}',
																value: '{expediente.comprador}'
										                	}		
										                },
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
															labelWidth: 100,
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.fechaSancion}',
										                	renderer: Ext.util.Format.dateRenderer('d/m/Y')
										                },
										                {  
										                	xtype:'comboboxfieldbase',
															fieldLabel:HreRem.i18n('fieldlabel.tipo.inquilino'),
															cls: 'cabecera-info-field',
															bind :{ 
																value: '{expediente.tipoInquilino}',
																store :'{comboTiposInquilino}',
																hidden: '{esOfertaVenta}'
															}
										                },
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.mediador'),
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.mediador}'
										                },

										                { 
															fieldLabel: HreRem.i18n('fieldlabel.estado'),
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.estado}'
										                },
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.subestado'),
															cls: 'cabecera-info-field',
										                	bind :{ 
																value: '{expediente.subestadoExpediente}',
																hidden: '{!expediente.esActivoHayaHome}'
															}
										                },
										                { 
										                	xtype:'datefieldbase',
															formatter: 'date("d/m/Y")',
															reference: 'fechaReserva',
															fieldLabel:	HreRem.i18n('fieldlabel.fecha.reserva'),
															bind:	{
										                		value: '{expediente.fechaReserva}'
										                		
										                	},
										                	listeners: {
																render: 'tareaDefinicionDeOferta'
															}		
										                },
										                {
										                	xtype: 'textfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.oferta.origen'),
															readOnly: true,
															cls: 'cabecera-info-field',
										                	bind: {
										                		value: '{expediente.idOfertaAnterior}',
										                		hidden: '{!expediente.idOfertaAnterior}'
										                	},
										                	listeners: {
										                		click: {
										                	            element: 'el',
										                	            fn: 'onClickAbrirExpedienteComercial'
										                	    }
										                	},
														    style:{
														    	cursor: 'pointer',
														    	'text-decoration': 'underline'
														    }
										                }
										               
										                
										               
										      ]
										},
										{
											xtype:'container',
											style: 'float: right;',
											maxWidth: 400,
											bind: {
										    		hidden: '{!avisos.descripcion}'
										    },
											padding: '10 100 0 30',
											flex: 2.5,
											height: 125,
											autoScroll: true,
											defaultType: 'displayfield',
											cls: 'cabecera-apartado cabecera-avisos',
											items: [
							                   	{
													cls: 'display-field-avisos',
													bind: 
														{
												    		value: '{avisos.descripcion}'
												        }
							                   	}

							                  ]
							            }
							            
							]

				    }
    ];   	
    
	me.callParent();
	}
});