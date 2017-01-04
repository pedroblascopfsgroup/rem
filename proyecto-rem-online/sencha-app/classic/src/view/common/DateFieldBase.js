Ext.define('HreRem.view.common.DateFieldBase', { 	
	extend			: 'Ext.form.field.Date',
    xtype			: 'datefieldbase', 
    
	requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    
    cls				: 'datefield-base',
    
    labelWidth: 150,    

    valuePublishEvent: ['select', 'blur', 'change'],
    checkChangeBuffer: 1000,
	
	/**
	 * Fecha máxima seleccionable, en caso de ser necesario seleccionar fechas a futuro
	 * sobreescribir en el componente que extienda con otra fecha o null.
	 */
	maxValue: $AC.getCurrentDate(),
	
	privates: {
		
		onBindNotify: function(value, oldValue, binding) {
            binding.syncing = (binding.syncing + 1) || 1;
            this[binding._config.names.set](value);
            --binding.syncing;
            this.fireEvent("afterbind", this, value);
        }
		
	},
    
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el textfield
   		
    	///me.maxValue = $AC.getCurrentDate();
   		me.callParent();
   		me.initFieldBase();
    }	
    
});