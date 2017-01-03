Ext.define('HreRem.view.gastos.CabeceraGasto', {
    extend: 'Ext.container.Container',
    xtype: 'cabeceragasto',
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
			    			height: 150,
			   				bind: {
			   		         title: 'GASTO {gasto.numGastoHaya} {getTipoOperacion} / {getTipoGasto}'
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
										text: HreRem.i18n("btn.autorizar"),
										cls: 'boton-cabecera',
										handler: 'onClickAutorizar',
										secFunPermToRender: 'OPERAR_GASTO',
										hidden: true,
										bind: {
											hidden: '{!esAutorizable}'
										}
									},
									{
										xtype: 'button',
										margin: '10 6 0 0',
										text: HreRem.i18n("btn.rechazar"),
										cls: 'boton-cabecera',
										handler: 'onClickRechazar',
										hidden: true,
										bind: {
											hidden: '{!esRechazable}'
										}
									},	
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
												labelWidth: 120},
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
				    					        			fieldLabel:  HreRem.i18n('fieldlabel.referencia.emisor'),
													 		cls: 'cabecera-info-field',
											            	bind:		'{gasto.referenciaEmisor}'
											            },
											            { 
				    					        			fieldLabel:  HreRem.i18n('fieldlabel.fecha.emision'),
													 		cls: 'cabecera-info-field',
											            	bind:		'{gasto.fechaEmision}',
											            	renderer: Ext.util.Format.dateRenderer('d/m/Y')
											            },
										                {
										                	xtype: 'currencyfieldbase',
										                	fieldLabel: HreRem.i18n('fieldlabel.importe'),
															cls: 'cabecera-info-field',
															bind:		'{gasto.importeTotal}'
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.propietario'),
															cls: 'cabecera-info-field',
										                	bind:		'{gasto.nombrePropietario}'
										                },
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.proveedor'),
															cls: 'cabecera-info-field',
										                	bind:		'{gasto.nombreEmisor}'
										                },
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.gasto.gestion.gestoria'),
															cls: 'cabecera-info-field',
										                	bind:		'{gasto.nombreGestoria}'
										                	
										                },
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.estado'),
															cls: 'cabecera-info-field',
										                	bind:		'{gasto.estadoGastoDescripcion}'
										                	
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