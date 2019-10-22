Ext.define('HreRem.view.administracion.plusvalia.GestionPlusvaliaSearch', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'gestionplusvaliasearch',
    isSearchFormPlusvalia: true,
    layout: 'column',
	defaults: {
        xtype: 'fieldsettable',
        columnWidth: 1,
        cls: 'fieldsetCabecera'
    },
	 requires	: ['HreRem.view.administracion.AdministracionModel','HreRem.view.administracion.AdministracionController'],
	initComponent: function() {

		var me = this;
    	me.setTitle(HreRem.i18n('title.filtro'));
    	me.removeCls('shadow-panel');

	    me.items= [
				    {
			    		defaultType: 'textfieldbase',
			    		defaults: {
							addUxReadOnlyEditFieldPlugin: false
						},
			    		items: [
	    					{
						    	fieldLabel: HreRem.i18n('fieldlabel.num.activo'),
						        name: 'numActivo'
						    },
						    {
						    	fieldLabel: HreRem.i18n('fieldlabel.num.plusvalia'),
						        name: 'numPlusvalia'
						    },
					       	{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.provincia'),
								reference: 'provinciaCombo',
								name: 'provinciaCombo',
								chainedStore: 'comboMunicipio',
								chainedReference: 'municipioCombo',
			            		bind: {
			            			store: '{comboProvincia}',
			            	    	value: '{plusvalia.provinciaCodigo}'
			            		},
    							listeners: {
									select: 'onChangeChainedCombo'
	    						}
							},
    						{
								xtype: 'comboboxfieldbase',
								fieldLabel: HreRem.i18n('fieldlabel.municipio'),
								reference: 'municipioCombo',
								name: 'municipioCombo',
								chainedStore: 'comboInferiorMunicipio',
								chainedReference: 'inferiorMunicipioCombo',
			            		bind: {
			            			store: '{comboMunicipio}',
			            			value: '{plusvalia.municipioCodigo}',
			            			disabled: '{!plusvalia.provinciaCodigo}'
			            		},
    							listeners: {
									select: 'onChangeChainedCombo'
    							}
							}
							]
				    }
	    ];

	    me.callParent();
	}
});
