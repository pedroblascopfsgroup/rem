Ext.define('HreRem.view.activos.detalle.InstalacionesInformacionComercial', {
    xtype: 'instalacionesinformacioncomercial',    
    reference: 'instalacionesref',
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
			        trAttrs: {height: '30px', width: '100%'},
			        tdAttrs: {width: '50%'},
			        tableAttrs: {
			            style: {
			                width: '100%'
							}
			        }
				},
				defaultType: 'textfieldbase',
				items :
					[
					 {
						xtype:'fieldset',
					    collapsed: false,
					    title: HreRem.i18n('title.electricidad'),
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
						items: [
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.instalaciones.contador'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.electricidadConContador}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.instalaciones.buen.estado'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.electricidadBuenEstado}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.instalaciones.defectuosas.antiguas'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.electricidadDefectuosa}'
								}
							}
						]
					 },
					 {
						xtype:'fieldset',
					    collapsed: false,
					    title: HreRem.i18n('title.agua'),
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
						items: [
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.instalaciones.contador'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.aguaConContador}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.instalaciones.buen.estado'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.aguaBuenEstado}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.instalaciones.defectuosas.antiguas'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.aguaDefectuosa}'
								}
							}
						  ]
					 	},
					 	 {
							xtype:'fieldset',
						    collapsed: false,
						    height: 116,
						    title: HreRem.i18n('title.agua.caliente'),
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
							items: [
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.central'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.aguaCalienteCentral}'
									}
								},
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.gas.natural'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.aguaCalienteGasNat}'
									}
								}
							]
					 	 },
					 	 {
								xtype:'fieldset',
							    collapsed: false,
							    title: HreRem.i18n('title.gas'),
							    height: 116,
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
								items: [
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.instalaciones.contador'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.gasConContador}'
									}
								},
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.instalaciones.buen.estado'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.gasBuenEstado}'
									}
								},
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.instalaciones.defectuosas.antiguas'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.gasDefectuosa}'
									}
								}
							]
					 	 },
					 	 {
								xtype:'fieldset',
							    collapsed: false,
							    title: HreRem.i18n('title.calefaccion'),
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
								items: [
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.central'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.calefaccionCentral}'
									}
								},
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.gas.natural'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.calefaccionGasNat}'
									}
								},	
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.radiadores.aluminio'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.calefaccionRadiadorAlu}'
									}
								},
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.preinstalacion'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.calefaccionPreinstalacion}'
									}
								}
							]
					 	 },
					 	 {
								xtype:'fieldset',
							    collapsed: false,
							    title: HreRem.i18n('title.aire'),
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
								items: [
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.preinstalacion'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.airePreinstalacion}'
									}
								},		
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.instalacion'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.aireInstalacion}'
									}
								},		
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.frio.calor'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboSiNoNSRem}',
										value: '{infoComercial.aireFrioCalor}'
									}
								}
							]
					 	 },
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.instalacionOtros}',
							readOnly: true
						}
					]
			}
     ];

     me.callParent();
    	
    }
});
