Ext.define('HreRem.view.common.ComboBoxSearchFieldBase', { 	
	extend			: 'Ext.form.field.ComboBox',
    xtype			: 'comboboxsearchfieldbase',
    displayField	: 'descripcion',      
    valueField		: 'codigo',    
    editable		: true,
    emptyText: 'Escribe minimo 3 letras para buscar', 
    hideTrigger: true,
	minLength: 3,
	queryMode: 'local',
	anyMatch: true,
	
	//Override del onTriggerClick con el nuevo atributo que indicar� si se carga de nuevo
	//el diccionario al hacer trigger o no (por defecto no se har�)
	
	privates: {
	
    onExpand: function(){
		if(!Ext.isEmpty(this.rawValue)){ 
			if(this.rawValue.length < 3){
				this.collapse();
			}else{								
				this.expand();
			}
		}							
	},
	onChange: function(newValue, oldValue){
		if(!Ext.isEmpty(newValue)){
			if(newValue.length < 3){
				this.collapse();
			}else{
				this.store.filter(
						{
							property: 'descripcion',
							anyMatch: true,
							value: newValue
						}
				);
				this.expand();
			}
		}else{
			this.collapse();
		}
	},
    
	initComponent: function() {    	
    	var me = this;    	
    	// Aqui configuraciones únicas para el CheckBoxFieldBase
   		me.callParent();
    }
	}
});     