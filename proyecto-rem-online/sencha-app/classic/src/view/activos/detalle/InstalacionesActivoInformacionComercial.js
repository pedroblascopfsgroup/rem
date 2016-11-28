Ext.define('HreRem.view.activos.detalle.InstalacionesActivoInformacionComercial', {
    xtype: 'instalacionesactivoinformacioncomercial',    
    reference: 'instalacionesactivoref',
    extend: 'Ext.container.Container',       
    cls	: 'panel-base shadow-panel',
    scrollable: 'y',


    initComponent: function () {

        var me = this;
        me.items= [
                   
			{ 
				xtype: 'comboboxfieldbase',
				editable: false,
				readOnly: true,
				fieldLabel: HreRem.i18n('fieldlabel.instalacion.electrica'),
				emptyDisplayText: '-',
				bind: {
					store: '{comboSiNoNSRem}',
					value: '{informeComercial.electricidad}'		            		
				}
			},
			{ 
				xtype: 'comboboxfieldbase',
				editable: false,
				readOnly: true,
				fieldLabel: HreRem.i18n('fieldlabel.instalacion.agua'),
				emptyDisplayText: '-',
				bind: {
					store: '{comboSiNoNSRem}',
					value: '{informeComercial.agua}'
				}
			},
			{ 
				xtype: 'comboboxfieldbase',
				editable: false,
				readOnly: true,
				fieldLabel: HreRem.i18n('fieldlabel.instalacion.gas'),
				emptyDisplayText: '-',
				bind: {
					store: '{comboSiNoNSRem}',
					value: '{informeComercial.gas}'
				}
			},
			{ 
				xtype: 'comboboxfieldbase',
				editable: false,
				readOnly: true,
				fieldLabel: HreRem.i18n('fieldlabel.contador.luz'),
				emptyDisplayText: '-',
				bind: {
					store: '{comboSiNoNSRem}',
					value: '{informeComercial.electricidadConContador}'
				}
			},
			{ 
				xtype: 'comboboxfieldbase',
				editable: false,
				readOnly: true,
				fieldLabel: HreRem.i18n('fieldlabel.contador.agua'),
				emptyDisplayText: '-',
				bind: {
					store: '{comboSiNoNSRem}',
					value: '{informeComercial.aguaConContador}'
				}
			}
     ];

     me.callParent();
    	
    }
});
