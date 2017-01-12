Ext.define('HreRem.view.common.ComboBoxFieldBase', { 	
	extend			: 'Ext.form.field.ComboBox',
    xtype			: 'comboboxfieldbase',
   	
   	requires: ['HreRem.ux.field.FieldBase'],
    mixins: [
        'HreRem.ux.field.FieldBase'
    ],
    
    cls				: 'comboboxfield-base',
    
    labelWidth		: 150,  
 
    displayField	: 'descripcion',  
    
    valueField		: 'codigo',
       
    autoLoadOnValue	: true,
        
    reloadOnTrigger : false,
    
    editable		: false,
    
    forceSelection	: true,
    
    loadOnBind	: true,
	
	//Override del onTriggerClick con el nuevo atributo que indicar� si se carga de nuevo
	//el diccionario al hacer trigger o no (por defecto no se har�)
	
	privates: {
		
		/**
		 * Overrride del método original para en el momento de hacer el bind del value, lanzar el evento 
		 * afterbind
		 * @param {} value
		 * @param {} oldValue
		 * @param {} binding
		 */
		onBindNotify: function(value, oldValue, binding) {
			
			var me = this;
			if (me.value == null || (me.value != binding.lastValue)) {
				if (me.loadOnBind && me.getStore() != null && me.getStore().type!="chained") {
					me.loadPage();
				}
				/*me.getStore().load({
					    scope: this,
					    callback: function(records, operation, success) {
					    	this[binding._config.names.set](value);
					    }
					});
				}*/
			}
	        binding.syncing = (binding.syncing + 1) || 1;
	        this[binding._config.names.set](value);
	        --binding.syncing;
	        this.fireEvent("afterbind", this, value);
		
		},
		
		 onTriggerClick: function() {
		        var me = this;
		        if (!me.readOnly && !me.disabled) {
		            if (me.isExpanded) {
		                me.collapse();
		            } else 
		                if (me.reloadOnTrigger || (!Ext.isEmpty(me.getStore()) &&  !me.getStore().isLoaded()))
		                {
			                if (me.triggerAction === 'all') {
			                    me.doQuery(me.allQuery, true);
			                } else if (me.triggerAction === 'last') {
			                    me.doQuery(me.lastQuery, true);
			                } else {
			                    me.doQuery(me.getRawValue(), false, true);
			                }
		                }
		                else
		                {
		                	me.expand();
		                }
		       }
		 }
    
    },
    
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el CheckBoxFieldBase
   		me.initFieldBase();
   		me.callParent();
    }
});     