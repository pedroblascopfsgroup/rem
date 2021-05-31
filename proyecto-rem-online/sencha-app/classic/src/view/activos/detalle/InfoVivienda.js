Ext.define('HreRem.view.activos.detalle.InfoVivienda', {
    extend: 'Ext.container.Container',
    xtype: 'infovivienda',
    
    requires: ['HreRem.view.activos.detalle.ServiciosInfraestructurasInformacionComercial',
               'HreRem.view.activos.detalle.CarpinteriaInteriorInformacionComercial',
               'HreRem.view.activos.detalle.CarpinteriaExteriorInformacionComercial',
               'HreRem.view.activos.detalle.ParamentosVerticalesInformacionComercial',
               'HreRem.view.activos.detalle.SoladosInformacionComercial',
               'HreRem.view.activos.detalle.CocinaInformacionComercial',
               'HreRem.view.activos.detalle.BanyoInformacionComercial',
               'HreRem.view.activos.detalle.InstalacionesInformacionComercial',
               'HreRem.view.activos.detalle.ZonasComunesInformacionComercial'
    ],

    initComponent: function () {

        var me = this;
		me.items = [

           {    

				xtype:'fieldset',
				collapsible: true,
				title:HreRem.i18n('title.vivienda'),
				layout: {
					type: 'vbox',
					align: 'stretch'
				},
				defaultType: 'textfieldbase',
				items :
					[
			          {    

							xtype:'container',
							layout: {
								type: 'hbox',
								align: 'stretch'
							},
							defaultType: 'textfieldbase',
							items :
								[
								 	{
								 		xtype: 'container',
								 		width: '33%',
								 		height: 435,
								 		layout: {
							        	      type: 'vbox',
							        	      align: 'stretch'
							        	},
								 		margin: '0 10 6 0',
								 		items: [
											{ 
												xtype: 'comboboxfieldbasedd',
												fieldLabel: HreRem.i18n('fieldlabel.tipo.vivienda'),
												bind: {
													store: '{comboTipoVivienda}',
													value: '{infoComercial.tipoViviendaCodigo}',
												    rawValue : '{infoComercial.tipoViviendaDescripcion}',
													readOnly: '{esActivoMacc}'
												}
											},  
											{ 
									        	xtype: 'comboboxfieldbase',
									        	editable: false,
									        	fieldLabel: HreRem.i18n('fieldlabel.orientacion'),
									        	bind: {
								            		store: '{comboTipoOrientacion}',
								            		value: '{infoComercial.tipoOrientacionCodigo}'			            		
								            	},
												readOnly: true
									        },
									        { 
									        	xtype: 'comboboxfieldbase',
									        	fieldLabel: HreRem.i18n('fieldlabel.nivel.renta'),
									        	bind: {
								            		store: '{comboTipoRenta}',
								            		value: '{infoComercial.tipoRentaCodigo}'			            		
								            	},
												readOnly: true
									        },
									        { 
									        	xtype: 'comboboxfieldbase',
									        	fieldLabel: HreRem.i18n('fieldlabel.ultima.planta'),
									        	bind: {
								            		store: '{comboSiNoRem}',
								            		value: '{infoComercial.ultimaPlanta}'			            		
								            	},
												readOnly: true
									        },
									        {
								        	    xtype:'fieldset',				        	 
										        layout: {
											        type: 'table',
									        		trAttrs: {height: '45px', width: '100%'},
									        		columns: 1,
									        		tableAttrs: {
											            style: { width: '100%' }
											        	}
										        },
										        margin: '0 0 0 2',
												defaultType: 'textfieldbase',
												title: HreRem.i18n('title.reformas.necesarias'),
												items :
												[
									                { 
											        	xtype: 'container',
												 		items :
												 			[
													 			 {
													 				 xtype: 'checkboxfieldbase',
													 				 fieldLabel: 'Carpintería exterior',
													 				 bind: '{infoComercial.reformaCarpExt}',
																	 readOnly: true
													 			 },
													 			 {
													 				 xtype: 'checkboxfieldbase',
													 				 fieldLabel: 'Carpintería interior',
													 				 bind: '{infoComercial.reformaCarpInt}',
																	 readOnly: true
													 			 },
													 			 {
													 				 xtype: 'checkboxfieldbase',
													 				 fieldLabel: 'Cocina',
													 				 bind: '{infoComercial.reformaCocina}',
																	 readOnly: true
													 			 },
													 			 {
													 				 xtype: 'checkboxfieldbase',
													 				 fieldLabel: 'Baños',
													 				 bind: '{infoComercial.reformaBanyo}',
																	 readOnly: true
													 			 },
													 			 {
													 				 xtype: 'checkboxfieldbase',
													 				 fieldLabel: 'Suelo',
													 				 bind: '{infoComercial.reformaSuelo}',
																	 readOnly: true
													 			 },
													 			 {
													 				 xtype: 'checkboxfieldbase',
													 				 fieldLabel: 'Pintura',
													 				 bind: '{infoComercial.reformaPintura}',
																	 readOnly: true
													 			 },
													 			 {
													 				 xtype: 'checkboxfieldbase',
													 				 fieldLabel: 'Integral',
													 				 bind: '{infoComercial.reformaIntegral}',
																	 readOnly: true
													 			 },
													 			 {
													 				 xtype: 'textfieldbase',
															 		 fieldLabel: HreRem.i18n('fieldlabel.otros'),
															 		 bind: '{infoComercial.reformaOtroDesc}',
																	 readOnly: true
																 },
																 {
																	 xtype: 'currencyfieldbase',
															 		 fieldLabel: HreRem.i18n('fieldlabel.presupuesto.estimado.reformas'),
													            	 bind:		'{infoComercial.reformaPresupuesto}',
																	 readOnly: true
																 }
												 			]
													}
												]
											}
									       
								 		]
								 	},
								 	{
								 		xtype: 'container',
								 		width: '66%',
								 		height: 435,
								 		layout: {
							        	      type: 'vbox',
							        	      align: 'stretch'
							        	},
								 		items: [
											{ 
												xtype: 'numberfieldbase',
												fieldLabel: HreRem.i18n('fieldlabel.numero.plantas.interiores'),
												bind:		'{infoComercial.numPlantasInter}',
												readOnly: false
											},
											{
								        	    xtype:'fieldset',
								        	    layout: 'fit',
												flex: 1,
												title: HreRem.i18n('title.distribucion.plantas'),
												items :
												[
													{
														xtype: 'distribucionplantasactivolist'
													} 
									 			]
											},
											/////////////////////
											 {
								        	    xtype:'fieldsettable',				        	 
										        defaultType: 'textfieldbase',
												title: HreRem.i18n('fieldlabel.terrazas'),
												colspan: 2,
												items :
												[
									              
													{
														xtype: 'numberfieldbase',
														decimalPrecision: 0,
														fieldLabel : HreRem.i18n('fieldlabel.descubiertas'),							
														bind : '{infoComercial.numTerrazaDescubierta}'
													},
													{
														fieldLabel : HreRem.i18n('header.descripcion'),
														bind : '{infoComercial.descTerrazaDescubierta}',
														colspan: 2
													},
													{
														xtype: 'numberfieldbase',
														decimalPrecision: 0,
														fieldLabel : HreRem.i18n('fieldlabel.cubiertas'),							
														bind : '{infoComercial.numTerrazaCubierta}'
													},
													{
														fieldLabel : HreRem.i18n('header.descripcion'),
														bind : '{infoComercial.descTerrazaCubierta}',
														colspan: 2
													}
									            ]
											 },
											 {
									            xtype:'fieldsettable',				        	 
											    defaultType: 'textfieldbase',
											    title: HreRem.i18n('header.otras.dependencias'),
												items :
												[
												 	
												 		{
															xtype: 'checkboxfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.despensa'),
															bind: '{infoComercial.despensa}'
														},
														{
															xtype: 'checkboxfieldbase',
															fieldLabel: HreRem.i18n('fieldlabel.lavadero'),
															bind: '{infoComercial.lavadero}'
														},
														{
															fieldLabel : HreRem.i18n('header.descripcion'),
															bind : '{infoComercial.descOtras}',
															colspan: 3
														}
										            
										        ]
											},
											{
									            xtype:'fieldsettable',				        	 
											    defaultType: 'textfieldbase',
											    title: HreRem.i18n('header.otras.caracteristicas'),
												items :
												[
													{
														xtype: 'comboboxfieldbase',
														fieldLabel: HreRem.i18n('fieldlabel.mascota'),
														bind:{ 
														   	store: '{comboAdmiteMascota}',
															value: '{infoComercial.admiteMascotaCodigo}'	
														   	}
			    		    						}
										            
										        ]
											}
											
			        
								 		]	
								 	}
								 ]
			                 
			           },
			           {
				            xtype:'container',
							layout: {
								type: 'hbox',
								align: 'stretch'
							},
							margin: '10 0 10 0',
							items : [
							   { 
							 		xtype: 		'textareafieldbase',
							 		maxWidth:	null,
							 		fieldLabel: HreRem.i18n('fieldlabel.distribucion.interior'),
							 		flex:		1,
					            	bind:		'{infoComercial.distribucionTxt}'
							   }
							]
			           }
				]
                 
           },
           
           {    
                
				xtype:'fieldset',
				height: 1720,
				layout: {type: 'hbox'},
				collapsible: true,
				title:HreRem.i18n('title.calidades'),
				/*bind: {
					hidden: '{!infoComercial.isVivienda}'
				},	*/
				items :
					[
						{
							xtype: 'container',	
							height: 580,
							style: {borderRight: '1px solid #606060', backgroundColor: '#E4E4E4' },
							layout: 'vbox',
							defaults: {
								listeners: {
										 click: {
								            element: 'el', //bind to the underlying el property on the panel
								            fn: function(event, el){
								            	this.component.up('container').onLabelClick(this.component);
											}
								        }
								},
								overCls: 'btn-label-over'
							},
							items: [
							
								{
									xtype: 'label',
									cls:'btn-label btn-label-selected',
									text:  HreRem.i18n('title.servicios.infraestructuras'),
									card: 0
								},
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.carpinteria.interior'),
									card: 1
								},
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.carpinteria.exterior'),
									card: 2
								},															
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.paramentos.verticales'),
									card: 3
								},
																
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.solados'),
									card: 4
								},							
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.cocina'),
									card: 5
								},								
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.banyo'),
									card: 6
								},								
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.instalaciones'),
									card: 7
								},
								{
									xtype: 'label',
									cls:'btn-label',
									html: HreRem.i18n('title.zonas.comunes'),
									card: 8
								}								
							],
							onLabelClick: function(label) {												            	
				            	Ext.Array.each(this.items.items, function(item, index) {
				            		item.removeCls("btn-label-selected");								            		
				            	});
				            	label.addCls("btn-label-selected");
				            	this.up("fieldset").down("container[reference=containercard]").getLayout().setActiveItem(label.card);
				            	label.focus();
				            	
							}
						},
					
					
						{
							xtype		: 'container',
							reference	: 'containercard',
							layout		: {type: 'card', deferredRender: true},							 
							flex		:1,
							plugins		: 
									{
										ptype: 'lazyitems', 
										items: [
											{
												xtype: 'serviciosinfraestructurasinformacioncomercial'
											},
											{
												xtype: 'carpinteriainteriorinformacioncomercial'
											
											},
											{
												xtype: 'carpinteriaexteriorinformacioncomercial'
											
											},
											{
												xtype: 'paramentosverticalesinformacioncomercial'
											},
											{
												xtype: 'soladosinformacioncomercial'									
											},
											{
												xtype: 'cocinainformacioncomercial'									
											},
											{
												xtype: 'banyoinformacioncomercial'
											
											},
											{
												xtype: 'instalacionesinformacioncomercial'
											
											},
											{
												xtype: 'zonascomunesinformacioncomercial'
											
											}
										]
									}
							}
					]     
           }
            
            
     	];
    	
    	me.callParent();
    	
    }
    
});