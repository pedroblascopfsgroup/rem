Ext.define('HreRem.view.activos.detalle.ZonasComunesInformacionComercial', {
    xtype: 'zonascomunesinformacioncomercial',    
    reference: 'zonascomunesref',
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
				items: [
				{  
					xtype:'fieldset',
				    collapsed: false,
					title: HreRem.i18n('title.zonas.comunes'),
					height: 94,
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
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.jardines.zonas.verdes'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.jardines}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.piscina'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.piscina}'
								}
							}
						]
				},
				{    
				  xtype: 'fieldset',
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
					height: 94,
					title: HreRem.i18n('title.instalaciones.deportivas'),
					items :
						[
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.pista.padel'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.padel}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.pista.tenis'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.tenis}'
								}
							},
							{ 
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.pista.polideportiva'),
								flex: 1,
								emptyDisplayText: '-',
								bind: {
									store: '{comboSiNoNSRem}',
									value: '{infoComercial.pistaPolideportiva}'
								}
							},
							{
								xtype: 'textareafieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.otros'),
								bind: '{infoComercial.instalacionesDeportivasOtros}',
								readOnly: true
							}
						]
				},
				{ 
					xtype: 'comboboxfieldbase',
					fieldLabel: HreRem.i18n('fieldlabel.zona.infantil'),
					flex: 1,
					emptyDisplayText: '-',
					bind: {
						store: '{comboSiNoNSRem}',
						value: '{infoComercial.zonaInfantil}'
					}
				},
				{ 
					xtype: 'comboboxfieldbase',
					fieldLabel: HreRem.i18n('fieldlabel.conserje.vigilancia'),
					flex: 1,
					emptyDisplayText: '-',
					bind: {
						store: '{comboSiNoNSRem}',
						value: '{infoComercial.conserjeVigilancia}'
					}
				},
				{ 
					xtype: 'comboboxfieldbase',
					fieldLabel: HreRem.i18n('fieldlabel.gimnasio'),
					flex: 1,
					emptyDisplayText: '-',
					bind: {
						store: '{comboSiNoNSRem}',
						value: '{infoComercial.gimnasio}'
					}
				},
				{
					xtype: 'textareafieldbase',
					fieldLabel: HreRem.i18n('fieldlabel.otros'),
					bind: '{infoComercial.zonasComunesOtros}',
					readOnly: true
				}
			]
        }
     ];

     me.callParent();
    	
    }
});