Ext.define('HreRem.view.activos.detalle.BanyoInformacionComercial', {
    xtype: 'banyoinformacioncomercial',    
    reference: 'banyoref',
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
							fieldLabel: HreRem.i18n('fieldlabel.ducha.banyera'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.duchaBanyera}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ducha'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ducha}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.banyera.normal'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.banyera}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.banyera.hidromasaje'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.banyeraHidromasaje}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.columna.hidromasaje'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.columnaHidromasaje}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.alicatado.marmol'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.alicatadoMarmol}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.alicatado.granito'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.alicatadoGranito}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.alicatado.azulejo'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.alicatadoAzulejo}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.encimeraBanyo}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera.granito'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.encimeraBanyoGranito}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera.marmol'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.encimeraBanyoMarmol}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.encimera.otro.material'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.encimeraBanyoOtroMaterial}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.sanitarios'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.sanitarios}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.sanitarios'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.estadoSanitarios}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.suelos'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.suelosBanyo}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.griferia.monomando'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.grifoMonomando}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.griferia.monomando'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.estadoGrifoMonomando}'
							},
							readOnly: false
						},
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.banyoOtros}',
							readOnly: false
						}
					]
			}
     ];

     me.callParent();
    	
    }
});