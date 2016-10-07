Ext.define('HreRem.view.expedientes.CabeceraExpediente', {
    extend: 'Ext.container.Container',
    xtype: 'cabeceraexpediente',
    requires: ['HreRem.view.common.ToolFieldSet'],
    layout: 'fit',
    initComponent: function () {
    
	    var me = this;
	    
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
					                   		maxWidth: 800,
											height: 125,
					                   		margin: '5 10 10 30 ',
											defaultType: 'displayfield',
											defaults: {
												labelWidth: 80},
											autoScroll: true,
											layout: {
											    type: 'table',
										        columns: 3,
										        trAttrs: {width: '100%', pading: 0},
										        tdAttrs: {width: '33%',  pading: 0},
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
										                		src: '{getSrcCartera}'
										                	}
										                },
										                { 
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
															fieldLabel: HreRem.i18n('fieldlabel.propietario'),
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.propietario}'
										                },
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.comprador'),
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.comprador}'
										                },
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.fecha.sancion'),
															labelWidth: 100,
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.fechaSancion}',
										                	renderer: Ext.util.Format.dateRenderer('d/m/Y')
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
															fieldLabel: HreRem.i18n('fieldlabel.fecha.reserva'),
															labelWidth: 100,
															cls: 'cabecera-info-field',
										                	bind:		'{expediente.fechaReserva}',
										                	renderer: Ext.util.Format.dateRenderer('d/m/Y')
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