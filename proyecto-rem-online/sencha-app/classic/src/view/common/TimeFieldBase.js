Ext.define('HreRem.view.common.TimeFieldBase', { 	
	extend			: 'Ext.form.field.Time',
    xtype			: 'timefieldbase',    
    requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    
    labelWidth: this.defaultLabelWidth,
    
    cls	: 'timefield-base',
    
    labelWidth: 150,
    
    maxWidth: 400,
    
    format: 'H:i',
    
    increment: 30,
    
    valuePublishEvent: ['select', 'blur', 'change'],
    checkChangeBuffer: 1000,
    
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el textfield
   		
   		me.callParent();
   		me.initFieldBase();
    }
});
	
							                	