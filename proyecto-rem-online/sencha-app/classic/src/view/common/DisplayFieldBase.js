Ext.define('HreRem.view.common.DisplayFieldBase', { 
    extend		: 'Ext.form.field.Display',
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    xtype		: 'displayfieldbase',
	
    labelWidth: 150,
    
	initComponent: function() {    	
    	var me = this;
   		me.callParent();
    }
});