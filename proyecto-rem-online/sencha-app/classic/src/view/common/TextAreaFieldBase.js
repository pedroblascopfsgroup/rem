Ext.define('HreRem.view.common.TextAreaFieldBase', { 
    extend		: 'Ext.form.field.TextArea',
    xtype		: 'textareafieldbase',
	
	requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],

    cls	: 'textareafield-base',
    
    labelWidth: 150,
    
    maxWidth: 400,
	
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el textfield
   		
   		me.callParent();
   		me.initFieldBase();
    }
});