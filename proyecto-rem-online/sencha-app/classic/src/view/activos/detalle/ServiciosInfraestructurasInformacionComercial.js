Ext.define('HreRem.view.activos.detalle.ServiciosInfraestructurasInformacionComercial', {
    xtype: 'serviciosinfraestructurasinformacioncomercial',
    reference: 'serviciosinfraestructurasref',
    extend: 'Ext.container.Container',       
    cls	: 'panel-base shadow-panel',
    flex: 1,
    scrollable: 'y',


    initComponent: function () {

        var me = this;
        me.items= [

			{    
				xtype:'fieldset',
			    collapsed: false,
			    layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 2,
			        trAttrs: {height: '150px', width: '100%'},
			        tdAttrs: {width: '50%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				title:HreRem.i18n('title.ocio'),
				defaultType: 'textfieldbase',
				items :
					[

					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.hoteles'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.hoteles}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.hotelesDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.teatros'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.teatros}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.teatrosDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.salas.cine'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.salasCine}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.salasCineDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.instalaciones.deportivas'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.instDeportivas}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.instDeportivasDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.centros.comerciales'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.centrosComerciales}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.centrosComercialesDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.ocioOtros}',
							readOnly: false
						}
					]
			},
			{    
				xtype:'fieldset',
			    collapsed: false,
			    layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 2,
			        trAttrs: {height: '150px', width: '100%'},
			        tdAttrs: {width: '50%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				title:HreRem.i18n('title.centros.educativos'),
				defaultType: 'textfieldbase',
				items :
					[
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.escuelas.infantiles'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.escuelasInfantiles}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.escuelasInfantilesDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.colegios'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.colegios}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.colegiosDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.institutos'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.institutos}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.institutosDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.universidades'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.universidades}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.universidadesDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.centrosEducativosOtros}',
							readOnly: false
						}
					]
			},
			{    
				xtype:'fieldset',
			    collapsed: false,
			    layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 2,
			        trAttrs: {height: '150px', width: '100%'},
			        tdAttrs: {width: '50%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				title:HreRem.i18n('title.centros.sanitarios'),
				defaultType: 'textfieldbase',
				items :
					[
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.centros.salud'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.centrosSalud}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.centrosSaludDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.clinicas'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.clinicas}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.clinicasDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
					 	{
					 		xtype: 'container',
					 		flex: 1,
					 		layout: {
					 		   type: 'hbox'
					 		},
				            items :
				            	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.hospitales'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.hospitales}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.hospitalesDesc}',
										readOnly: false
									}
				            	 
				            	]
					 	},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.centrosSanitariosOtros}',
							readOnly: false
						}
					]
			},
		 	{
				xtype:'fieldset',
			    collapsed: false,
			    layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 2,
			        trAttrs: {height: '30px', width: '100%'},
			        tdAttrs: {width: '50%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				title: HreRem.i18n('title.aparcamientos'),
				defaultType: 'textfieldbase',
	            items :
	            	[
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.en.superficie'),
							flex: 1,
							//Poner el label a la izquierda
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.parkingSuperSufi}'
							},
							readOnly: false
						}
	            	 
	            	]
		 	},
			{    
		 		xtype:'fieldset',
			    collapsed: false,
			    layout: {
			        type: 'table',
			        // The total column count must be specified here
			        columns: 2,
			        trAttrs: {height: '30px', width: '100%'},
			        tdAttrs: {width: '50%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				title:HreRem.i18n('title.comunicaciones'),
				defaultType: 'textfieldbase',
				items :
					[
					 	{
							xtype: 'container',
							flex: 1,
							layout: {
							   type: 'hbox'
							},
						    items :
						    	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.facil.acceso.carretera'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.facilAcceso}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.facilAccesoDesc}',
										readOnly: false
									}
						    	 
						    	]
						},
					 	{
							xtype: 'container',
							flex: 1,
							layout: {
							   type: 'hbox'
							},
						    items :
						    	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.lineas.autobus'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.lineasBus}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.lineasBusDesc}',
										readOnly: false
									}
						    	 
						    	]
						},
					 	{
							xtype: 'container',
							flex: 1,
							layout: {
							   type: 'hbox'
							},
						    items :
						    	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.metro'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.metro}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.metroDesc}',
										readOnly: false
									}
						    	 
						    	]
						},
					 	{
							xtype: 'container',
							flex: 1,
							layout: {
							   type: 'hbox'
							},
						    items :
						    	[
									{ 
										xtype: 'comboboxfieldbase',
										fieldLabel: HreRem.i18n('fieldlabel.estaciones.tren'),
										flex: 1,
										//Poner el label a la izquierda
										emptyDisplayText: '-',
										bind: {
											store: '{comboSiNoNSRem}',
											value: '{infoComercial.estacionTren}'
										},
										readOnly: false
									},
									{
										xtype: 'textfieldbase',
										flex: 1,
										bind:	'{infoComercial.estacionTrenDesc}',
										readOnly: false
									}
						    	 
						    	]
						},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.comunicacionesOtro}',
							readOnly: false
						}
					]
			}
     ];

     me.callParent();
    	
    }
});