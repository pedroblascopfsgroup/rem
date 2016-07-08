Ext.define('HreRem.view.common.CheckBoxFieldBase', { 	
	extend			: 'Ext.form.field.Checkbox',
    xtype			: 'checkboxfieldbase',
    
    requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    
    cls	: 'checkboxfield-base',
    
    labelWidth: 150,

    privates: {
		
		/**
		 * Overrride del método original para en el momento de hacer el bind del value, 
		 * igualar el valor de lastValue a ese mismo valor, de manera que no se lance el evento change
		 * @param {} value
		 * @param {} oldValue
		 * @param {} binding
		 */
		onBindNotify: function(value, oldValue, binding) {
	        binding.syncing = (binding.syncing + 1) || 1;
	        this.lastValue = value;
	        this[binding._config.names.set](value);
	        --binding.syncing;
		
		}
    
    },
	
	
    
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el CheckBoxFieldBase
   		
   		me.callParent();
   		me.initFieldBase();
    }
});
							                	