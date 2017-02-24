Ext.define('HreRem.view.common.CurrencyFieldBase', { 
    extend		: 'Ext.form.field.Number',
    xtype		: 'currencyfieldbase',
    requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],

    labelWidth: 150,
    
    
    hideTrigger: true,
	keyNavEnable: false,
	mouseWheelEnabled: false,

	initComponent: function() {    	
	    var me = this;    	
		// Aqui configuraciones únicas para el CurrencyFieldBase
		
		me.callParent();
		me.initFieldBase();
    }
});