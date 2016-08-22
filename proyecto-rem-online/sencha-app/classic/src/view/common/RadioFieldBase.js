Ext.define('HreRem.view.common.RadioFieldBase', { 	
	extend			: 'Ext.form.field.Radio',
    xtype			: 'radiofieldbase',      
    
    requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    
    cls	: 'radiofield-base',
	
    labelWidth: 150,
    
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el textfield
   		
   		me.callParent();
   		me.initFieldBase();
    }
});
							                	