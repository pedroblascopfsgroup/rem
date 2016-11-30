Ext.define('HreRem.view.activos.detalle.InfoVarios', {
    extend: 'Ext.container.Container',
    xtype: 'infovarios',
    
    requires: [
               'HreRem.view.activos.detalle.InstalacionesActivoInformacionComercial'
    ],
    
    initComponent: function () {

        var me = this;     
        
		me.items = [
		{
			xtype:			'fieldset',
			collapsible:	true,
			title:HreRem.i18n('title.varios'),
			layout: {
				type: 	'vbox',
				align: 	'stretch'
			},
			defaultType: 'textfieldbase',
			items :
			[
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
							width: '66%',
							layout: {
								type: 'vbox',
							    align: 'stretch'
							},
							items :
							[	
								{   
									xtype: 'container',
									layout: {
								        type: 'table',
						        		columns: 2,
						        		tableAttrs: {
								            style: { width: '100%' }
								        }
							        },
									items :
									[
										{
											xtype: 		'comboboxfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.tipo.varios'),
											bind: {
												store: 	'{comboSubtipoActivoOtros}',
												value: 	'{activo.subtipoActivoCodigo}'
											},
											readOnly: 	true
										},
										{ 
											xtype: 		'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.anchura'),
							            	bind:		'{infoComercial.anchura}',
											readOnly: 	true
										},
										{ 
											xtype: 		'comboboxfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.uso'),
											bind: {
												store: 	'{comboSubtipoPlazaGaraje}',
												value: 	'{infoComercial.subtipoPlazagarajeCodigo}'
											},
											readOnly: 	true
										},
										{ 
											xtype: 		'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.altura.mts'),
							            	bind:		'{infoComercial.aparcamientoAltura}',
											readOnly: 	true
										},
										{ 
											xtype: 		'comboboxfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.maniobrabilidad'),
											bind: {
												store: 	'{comboManiobra}',
												value: 	'{infoComercial.maniobrabilidadCodigo}'
											},
											readOnly: 	true
										},
										{ 
											xtype: 		'textfieldbase',
											fieldLabel: HreRem.i18n('fieldlabel.longitud.mts'),
							            	bind:		'{infoComercial.profundidad}',
											readOnly: 	true
										}
					 			
									]
								},
								{
									xtype: 		'textareafieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.descripcion.interior'),
									labelAlign: 'top',
									height: 	120,
									width: 		'100%',
									maxWidth:	1200,
					            	bind:		'{infoComercial.infoDistribucionInterior}'
								}
					 			
				 			]
						},
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
														 bind: '{infoComercial.aparcamientoLicencia}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.salida.emergencia'),
														 bind: '{infoComercial.aparcamientoSerbidumbre}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.acceso.minusvalidos'),
														 bind: '{infoComercial.aparcamientoMontacarga}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.salida.emergencia'),
														 bind: '{infoComercial.aparcamientoColumnas}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.acceso.minusvalidos'),
														 bind: '{infoComercial.aparcamientoSeguridad}',
														 readOnly: true
													 },
													 {
														 xtype: 'checkboxfieldbase',
														 fieldLabel: HreRem.i18n('fieldlabel.otros'),
														 bind: '{infoComercial.existeOtrasCaracteristicas}',
														 readOnly: true
													 }
									 			 ]
										},
										{
											 xtype: 'textareafieldbase',
											 fieldLabel: HreRem.i18n('fieldlabel.otros.descripcion'),
											 maxWidth:	500,
											 bind:		'{infoComercial.infoDescripcion}'
										 }
									]
								}
							]
						}
			 		]
				},		
				{//Instalaciones
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