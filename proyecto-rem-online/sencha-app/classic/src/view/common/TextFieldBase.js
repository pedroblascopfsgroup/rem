Ext.define('HreRem.view.common.TextFieldBase', { 
    extend		: 'Ext.form.field.Text',
    xtype		: 'textfieldbase',
    requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    
    cls: 'textfield-base',
    
    labelWidth: 150,
	
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el textfield   		
   		me.initFieldBase();
   		me.callParent();
    }
});