Ext.define('HreRem.view.activos.detalle.ParamentosVerticalesInformacionComercial', {
    xtype: 'paramentosverticalesinformacioncomercial',    
    reference: 'paramentosverticalesref',
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
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.humedad.pared'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.humedadPared}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.humedad.techo'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.humedadTecho}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.grieta.pared'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.grietaPared}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.grieta.techo'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.grietaTecho}'
							},
							readOnly: false
						},
						{
							xtype:'fieldset',
						    collapsed: false,
						    title: HreRem.i18n('title.estado.pintura.paredes'),
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
									fieldLabel: HreRem.i18n('fieldlabel.gotelet'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboBuenoMaloRem}',
										value: '{infoComercial.gotele}'
									},
									readOnly: false
								},
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.plastica.lisa'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboBuenoMaloRem}',
										value: '{infoComercial.plasticaLisa}'
									},
									eadOnly: false
								},
								{ 
									xtype: 'comboboxfieldbase',
									fieldLabel: HreRem.i18n('fieldlabel.papel.pintado'),
									flex: 1,
									emptyDisplayText: '-',
									bind: {
										store: '{comboBuenoMaloRem}',
										value: '{infoComercial.papelPintado}'
									},
									readOnly: false
								}
							]
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.pintura.lisa.techos'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.pinturaLisaTecho}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.pintura.lisa.techos'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.pinturaLisaTechoEstado}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.moldura.escayola'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.molduraEscayola}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.moldura.escayola'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.molduraEscayolaEstado}'
							},
							readOnly: false
						},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.paramentosOtros}',
							readOnly: false
						}
					]
			}
     ];

     me.callParent();
    	
    }
});