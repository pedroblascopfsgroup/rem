Ext.define('HreRem.view.activos.detalle.InfoLocalComercial', {
	extend: 'Ext.container.Container',
    xtype: 'infolocalcomercial',
    
    requires: [
               'HreRem.view.activos.detalle.DistribucionPlantasActivoList',
               'HreRem.view.activos.detalle.InstalacionesActivoInformacionComercial'
    ],
    
    initComponent: function () {

        var me = this; 
        
		me.items = [
		{	
			xtype:			'fieldset',
			collapsible:	true,
			title: HreRem.i18n('title.local.comercial'),
			
			layout: {
				type: 	'vbox',
				align: 	'stretch'
			},
			
			defaultType: 'textfieldbase',
			items :
			[
				{   
					xtype: 	'container',
					margin: '0 10 0 10',
					layout: {
						type: 'hbox',
					    align: 'stretch'
					},
					items :
					[
						{ 	
					 		xtype: 'numberfieldbase',
					 		width: '33%',
					 		maxWidth:	600,
					 		decimalPrecision: 2,
					 		fieldLabel: HreRem.i18n('fieldlabel.longitud.fachada.calle.principal'),
			            	bind:		'{informeComercial.mtsFachadaPpal}',
							readOnly: true
						},
						{ 
					 		xtype: 'numberfieldbase',
					 		width: '33%',
					 		maxWidth:	600,
					 		decimalPrecision: 2,
							fieldLabel: HreRem.i18n('fieldlabel.longitud.fachada.calles.laterales'),
		                	bind:		'{informeComercial.mtsFachadaLat}',
							readOnly: true
		                },
		                { 
					 		xtype: 'numberfieldbase',
					 		width: '33%',
					 		maxWidth:	600,
					 		decimalPrecision: 2,
					 		fieldLabel: HreRem.i18n('fieldlabel.altura.libre'),
			            	bind:		'{informeComercial.mtsAlturaLibre}',
							readOnly: true
						}
	                ]
				},
				{
					xtype:		'fieldset',
	        	    layout: 	'fit',
					flex: 		1,
					colspan: 	3,
					title: 		HreRem.i18n('title.distribucion.plantas'),
					items :
						[
							{
								xtype: 'distribucionplantasactivolist'
							} 
						]
				},
				{   
					xtype: 	'container',
					layout: {
						type: 'hbox',
		        	    align: 'stretch'
		        	},
					items :
					[
						{   
							xtype: 'container',
							width: '33%',
							layout: {
								type: 'vbox',
							    align: 'stretch'
							},
							items :
							[
								{
								    xtype:'fieldset',				        	 
								    title: HreRem.i18n('title.otras.caracteristicas'),
									margin: '10 10 10 0',
									colspan: 1,
									items :
									[
								        { 
								        	xtype: 'container',
								        	layout: {
										        type: 'table',
								        		columns: 1,
								        		tableAttrs: {
										            style: { width: '25%' }
										        }
									        },
									 		items :
									 			[
													{
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.salida.humos'),
														 bind: '{informeComercial.existeSalidaHumos}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.salida.emergencia'),
														 bind: '{informeComercial.existeSalidaEmergencias}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.acceso.minusvalidos'),
														 bind: '{informeComercial.existeAccesoMinusvalidos}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.otros'),
														 bind: '{informeComercial.existeOtrasCaracteristicas}',
														 readOnly: true
													 }
									 			 ]
										},
										{
											 xtype: 'textareafieldbase',
											 fieldLabel: HreRem.i18n('fieldlabel.otros.descripcion'),
											 maxWidth:	500,
									 		 minWidth:	300,
											 bind:		'{informeComercial.otrosOtrasCaracteristicas}'
										 }
									]
								}
				 			]
						},
						{
							xtype: 'container',
							width: '66%',
							margin: '0 10 0 10',
							layout: {
				        	      type: 'vbox',
				        	      align: 'stretch'
				        	},
							items :
								[
									{
										xtype: 'container',
										colspan: 2,
										margin: '0 10 0 10',
											items :
												[
									 			{
									 				xtype: 		'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.uso.idoneo'),
													margin: '20 10 0 0',
									            	bind:		'{informeComercial.usuIdoneo}',
									            	flex:		1,
													readOnly: 	true
									 			},
									 			{ 
													xtype: 		'textfieldbase',
													fieldLabel: HreRem.i18n('fieldlabel.uso.anterior'),
									            	bind:		'{informeComercial.usuAnterior}',
									            	flex:		1,
													readOnly: 	true
									            },
									            { 
											 		xtype: 		'textareafieldbase',
											 		maxWidth:	1200,
											 		fieldLabel: HreRem.i18n('fieldlabel.info.distribucion.interior'),
											 		flex:		2,
											 		height: 	120,
									            	bind:		'{informeComercial.infoDistribucionInterior}'
											   }
												]
									}
								]
						}
			 		]
				},
				{
					 xtype:'fieldset',
	        	    layout: 'fit',
					flex: 1,
					colspan: 3,
					title: HreRem.i18n('title.instalaciones'),
					items :
					[
						{
							xtype: 'instalacionesactivoinformacioncomercial',
							layout: {
						        type: 'table',
						        columns: 3,
						        trAttrs: {height: '30px', width: '100%'},
						        tdAttrs: {width: '33%'},
						        tableAttrs: {
						            style: {
						                width: '100%'
										}
						        }
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