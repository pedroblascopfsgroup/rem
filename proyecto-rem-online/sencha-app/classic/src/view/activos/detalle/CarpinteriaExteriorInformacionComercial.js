Ext.define('HreRem.view.activos.detalle.CarpinteriaExteriorInformacionComercial', {
    xtype: 'carpinteriaexteriorinformacioncomercial',    
    reference: 'carpinteriaexteriorref',
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
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.hierro'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasHierro}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.aluminio.anodizado'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasAluAnodizado}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.aluminio.lacado.blanco'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasAluLacado}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.pvc'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasPVC}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.madera'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasMadera}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.persianas.plastico'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.persianasPlastico}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.persianas.aluminio'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.persianasAluminio}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.correderas'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasCorrederas}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.abatibles'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasAbatibles}'
							},
							readOnly: false
						},		
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.ventanas.oscilobatientes'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.ventanasOscilobatientes}'
							},
							readOnly: false
						},
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.doble.acristalamiento.climalit'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboSiNoNSRem}',
								value: '{infoComercial.dobleCristal}'
							},
							readOnly: false
						},	
						{ 
							xtype: 'comboboxfieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.estado.doble.acristalamiento'),
							flex: 1,
							emptyDisplayText: '-',
							bind: {
								store: '{comboBuenoMaloRem}',
								value: '{infoComercial.dobleCristalEstado}'
							},
							readOnly: false
						},						
						{
							xtype: 'textareafieldbase',
							fieldLabel: HreRem.i18n('fieldlabel.otros'),
							bind: '{infoComercial.carpinteriaExteriorOtros}',
							readOnly: false
						}
					]
			}
     ];

     me.callParent();
    	
    }
});