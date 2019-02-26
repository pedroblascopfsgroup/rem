Ext.define('HreRem.view.expedientes.PlusValiaVentaExpediente', {
    extend: 'HreRem.view.common.FormBase',
    xtype: 'plusvaliaventaexpedediente',    
    cls	: 'panel-base shadow-panel',
    collapsed: false,
    disableValidation: true,
    reference: 'plusValiaVentaExpedediente',
    scrollable	: 'y',
    
	recordName: "plus",
	
	recordClass: "HreRem.model.PlusValiaVenta",
	
	requires: ['HreRem.view.common.FieldSetTable', 'HreRem.model.PlusValiaVenta'],
	
    listeners: {
		boxready:'cargarTabData'
},

    

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.plusvalia.ventas'));
        var items= [

			{
				
            	xtype: 'fieldset',
            	//title:  HreRem.i18n('title.plusvalia.ventas'),
            	items : [   { 
					xtype: 'comboboxfieldbase',
					width: 		250,
					fieldLabel: HreRem.i18n('fieldlabel.exento'),
					bind: {
						store: '{comboSiNoRem}',
						value: '{plus.exento}'
					}
				},
				 { 
					xtype: 'comboboxfieldbase',
					width: 		250,
					fieldLabel: HreRem.i18n('fieldlabel.autoliquidacion'),
					bind: {
						store: '{comboSiNoRem}',
						value: '{plus.autoliquidacion}'
					}
				},
			      { 
                	xtype:'datefieldbase',
			 		fieldLabel: HreRem.i18n('fieldlabel.fecha.escrito'),
			 		width: 		275,
	            	bind:		'{plus.fechaEscritoAyt}'
				},
		        { 
                	xtype: 'textareafieldbase',
                	//rowspan: 5,
                	fieldLabel: HreRem.i18n('fieldlabel.observaciones'),
                	width: 		'100%',
                	height:		120,
                	bind:		'{plus.observaciones}'
                	//rowspan:	3
                }
            	
            	
            		
            		
            		
            		]
            }
    	];
    
	    me.addPlugin({ptype: 'lazyitems', items: items });
	    
	    me.callParent(); 
    },
    
    funcionRecargar: function() {
    	var me = this; 
		me.recargar = false;		
		me.lookupController().cargarTabData(me);
		
    }
});