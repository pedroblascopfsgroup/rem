Ext.define('HreRem.view.agrupaciones.detalle.CabeceraAgrupacion', {
    extend: 'Ext.container.Container',
    xtype: 'cabeceraagrupacion',
    requires: ['HreRem.view.common.ToolFieldSet', 'HreRem.ux.button.BotonFavorito'],
    layout: 'fit',    
   
    initComponent: function () {
    
	    var me = this;
	    var visibilityBtnCrearTrabajo = me.lookupController().checkVisibilityOfBtnCrearTrabajo()
	    
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
	    
		me.gmap = Ext.create('HreRem.ux.panel.GMapPanel', {
		        gmapType: 'map',
		        center: {},
		        mapOptions : {
		        	disableDefaultUI: true,
		            mapTypeId: google.maps.MapTypeId.ROADMAP,
		            zoom: 16
		        }		       
		});	
	    
	    me.items= [	 
	    
				    {
			    			xtype:'toolfieldset',
			    			height: 175,
			   				bind: {
			   		         title: 'AGRUPACION {agrupacionficha.numAgrupRem} / TIPO {agrupacionficha.tipoAgrupacionDescripcion}'
			   		        },
			        		cls: 'fieldsetBase cabecera',
			        		style: 'padding-top:10px',
			        		border: false,
							collapsible: true,
							collapsed: false,
						    layout: {
						        type: 'hbox'
						    },
						    tools: [
						    	{
									xtype: 'button',
									cls: 'btn-tbfieldset delete-focus-bg no-pointer',
									bind: {
										iconCls: '{getIconClsEstadoVenta}',
										hidden: '{!esAgrupacionRestringidaIncluyeDestinoComercialVenta}'
									},
									iconAlign: 'right',
									text: HreRem.i18n('title.agrupaciones.indicador.venta')
								},
								{
									xtype: 'button',
									cls: 'btn-tbfieldset delete-focus-bg no-pointer',
									bind: {
										iconCls: '{getIconClsestadoAlquiler}',
										hidden: '{!esAgrupacionRestringidaIncluyeDestinoComercialAlquiler}'
									},
									iconAlign: 'right',
									text: HreRem.i18n('title.agrupaciones.indicador.alquiler')
								},
						   		{	
									xtype: 'tbfill'
								},
						   		{
						    		xtype: 'button',
									cls: 'boton-cabecera',
									iconCls: 'ico-crear-trabajo',
				        			tooltip: HreRem.i18n('btn.nueva.peticion.trabajo'),
				        			hidden: visibilityBtnCrearTrabajo,
				        			handler: 'onClickCrearTrabajo'
						    	},
						    	{
									xtype: 'button',
									cls: 'boton-cabecera',
									iconCls: 'ico-refrescar',
									handler	: 'onClickBotonRefrescar',
									tooltip: HreRem.i18n('btn.refrescar')
						    	},
						    	{
				        			xtype: 'botonfavorito',
				        			cssFavorito: 'ico-pestana-agrupaciones',
				        			tipoId: 'agrupacion'									
								},
								{
									xtype: 'button',
									cls: 'boton-cabecera',
									iconCls: 'x-fa fa-bars',
									arrowVisible: false,
			   						menuAlign: 'tr-br',								
							        menu:  me.menu
						    	}
						    ],
							items: [
							
										{
											xtype: 'container',
											layout: 'hbox',
											items: [
												{
													xtype: 'panel',
													tipo: 'panelgmap',
													layout: 'fit',
												    width: 225,
												    height: 125,
												    cls: 'cabecera-mapa',
												    margin: '10 10 10 20',
													listeners: {
													   'render': function(panel) {
													       panel.body.on('click', function() {
													    	   panel.add(me.gmap);
													       });
													    }
													}
												}
											]
										},
		
						    			{								                   		
					                   		xtype:'container',
					                   		flex: 4,
					                   		maxWidth: 1000,
											height: 125,
					                   		margin: '5 10 10 10 ',
											defaultType: 'displayfield',
											defaults: {
												labelWidth: 120},
											autoScroll: true,
											layout: {
											    type: 'table',
										        columns: 2,
										        tdAttrs: {width: '50%',  pading: 0},
										        tableAttrs: {
										            style: {
										                width: '100%'
														}
										        }
											},
											cls: 'cabecera-apartado cabecera-info',
											items: [
														{
															fieldLabel: HreRem.i18n('title.publicaciones.venta'),
															cls: 'cabecera-info-field',
															bind: {
																hidden: '{!agrupacionficha.incluyeDestinoComercialVentaYIsRestringida}',
																value: '{getValuePublicacionVentaAgrupacion}'
															}
														},
														{
															fieldLabel: HreRem.i18n('title.publicaciones.alquiler'),
															cls: 'cabecera-info-field',
															bind: {
																hidden: '{!agrupacionficha.incluyeDestinoComercialAlquilerYIsRestringida}',
																value: '{getValuePublicacionAlquilerAgrupacion}'
															}
														},
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion'),
															bind:	{
																value: '{getValueNumAgrupacion}'
															}	
									                   	},	
									                   	{
									                   		fieldLabel: HreRem.i18n('fieldlabel.numero.agrupacion.externo'),
															bind: {
																hidden: '{esAgrupacionPromocionAlquiler}',
																value: '{agrupacionficha.numAgrupUvem}'
															},
															listeners:
															{
																afterrender: function(get){
																	var me=this;
																	var cartera = me.lookupController().getViewModel().getData().agrupacionficha.getData().codigoCartera;
																	
																	if (cartera == CONST.CARTERA['BANKIA']) {
																		me.setFieldLabel(HreRem.i18n('fieldlabel.numero.agrupacion.caixa'));
																	}
																}
															}
									                   	},
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.nombre'),
										                	bind: 		'{agrupacionficha.nombre}'
										                },
										                {
										                	fieldLabel: HreRem.i18n('header.numero.agrupacion.prinex'),
										                	bind: {
										                		hidden: '{!esAgrupacionPromocionAlquiler}',
										                		value: '{agrupacionficha.numAgrupPrinexHPM}'
										                	}		
										                },
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.tipo'),
															bind:		'{agrupacionficha.tipoAgrupacionDescripcion}'
														},
														{ 
															xtype: 'imagefield',
															fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
															cls: 'cabecera-info-field',
															width: 70,
										                	bind: {
										                		hidden:'{isEmptySrcCartera}',
										                		src: '{getSrcCartera}',
										                		alt: '{agrupacionficha.cartera}'
										                	}
										                },
										                {
																fieldLabel: HreRem.i18n('fieldlabel.entidad.propietaria'),
																cls: 'cabecera-info-field',
																fieldStyle: 'color: #0a94d6 !important;font-weight: bold !important',
																width: 70,
																bind: {
																	hidden:'{!isEmptySrcCartera}',
																	value: '{agrupacionficha.cartera}'
																}
																
														},
										                {
															xtype: 'textfieldbase',
															readOnly: true,
															fieldLabel: HreRem.i18n('fieldlabel.activo.matriz'),
															reference: 'activoMatrizRef',
															bind: {
																hidden: '{!esAgrupacionPromocionAlquiler}',
																value: '{agrupacionficha.activoMatriz}'
															},
															cls: 'show-text-as-link',
															listeners: {
														        click: {
														            element: 'el', //bind to the underlying el property on the panel
														            fn:'onClickActivoMatriz'									       
														        }
															}
														},
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.numero.activos.incluidos'),
															bind:		'{agrupacionficha.numeroActivos}'
														},
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.numero.activos.publicados'),
															bind:		'{agrupacionficha.numeroPublicados}'
														},
														{ 
															fieldLabel: "Activos GENCAT:",
															bind: {
																value : '{agrupacionficha.activosGencat}',
																hidden : '{agrupacionficha.isAgrupacionGencat}'
															}
														},
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.provincia'),
															bind: {
																hidden: '{agrupacionficha.isComercial}',
																value: '{agrupacionficha.provinciaDescripcion}'
															}
														},
														{ 
															fieldLabel: HreRem.i18n('fieldlabel.municipio'),
															bind: {
																hidden: '{agrupacionficha.isComercial}',
																value: '{agrupacionficha.municipioDescripcion}'
															}
														},
										                { 
															fieldLabel: HreRem.i18n('fieldlabel.direccion'),
															bind: {
																hidden: '{agrupacionficha.isComercial}',
																value: '{agrupacionficha.direccion}'
															}
														},
														{ 
															xtype: 'datefieldbase',
															fieldLabel: HreRem.i18n('header.fecha.inicio.vigencia'),
															bind: {
																hidden: '{!agrupacionficha.isAsistida}',
																value: '{agrupacionficha.fechaInicioVigencia}'
															},
															readOnly: true
														},
														{ 
															xtype: 'datefieldbase',
															fieldLabel: HreRem.i18n('header.fecha.fin.vigencia'),
															bind: {
																hidden: '{!agrupacionficha.isAsistida}',
																value: '{agrupacionficha.fechaFinVigencia}'
															},
															readOnly: true
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
											padding: '10 30 0 30',
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
													/*,
													{
														xtype:'container',						
														layout: 'column',
														width: '15%',
														defaultType: 'displayfield',
														padding: '10 0 0 0',
														defaults: {
															style: 'width: 100%',
															labelWidth: 150},
														layout: 'column',							
														items: [
										                   	{
																//bind: '',
																cls: 'display-field-avisos',
																bind: 
																	{
															    		value: '{avisos.descripcion}',
															        	hidden: '{!avisos.descripcion}'
															        }
										                   	}

										                  ]
										            }*/
							
							]
				    }
    ];   	

	me.callParent();
    
	},
	
	configCmp:function(data) {
		
		var me = this,
		token = data.get("direccion") + " " + data.get("municipioDescripcion") + " " + data.get("provinciaDescripcion"),
    	title = "Activo " + data.get("numActivo");
    	
    	me.down('botonfavorito').setOpenId(data.get("id"));
    	
    	me.gmap.center.geoCodeAddr = token;
    	me.gmap.center.marker = {title: title};
    	
    	me.down('[tipo=panelgmap]').setHtml("<img style= 'width: 225px; height: 125px;' alt= 'Imagen de relleno de google maps' src='resources/images/imagenPrecargaMapa.jpg' />");
	}
});