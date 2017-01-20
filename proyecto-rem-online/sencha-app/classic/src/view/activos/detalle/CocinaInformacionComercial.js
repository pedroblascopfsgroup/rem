Ext.define('HreRem.view.activos.detalle.CocinaInformacionComercial', {
    xtype: 'cocinainformacioncomercial',    
    reference: 'cocinaref',
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
							fieldLabel: HreRem.i18n('fieldlabel.cocina.amueblada'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.amueblada}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.cocina.amueblada'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.estadoAmueblada}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.encimera}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera.granito'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.encimeraGranito}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera.marmol'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.encimeraMarmol}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera.otro.material'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.encimeraOtroMaterial}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.vitroceramica'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.vitro}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.lavadora'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.lavadora}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.frigorifico'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.frigorifico}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.lavavajillas'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.lavavajillas}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.microondas'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.microondas}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.horno'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.horno}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.suelos'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.suelosCocina}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.azulejos'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.azulejos}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.azulejos'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.estadoAzulejos}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.griferia.monomando'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.grifosMonomandos}'
							}
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.griferia.monomando'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.estadoGrifosMonomandos}'
							}
						},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.cocinaOtros}',
							readOnly: true
						}
					]
			}
     ];

     me.callParent();
    	
    }
});