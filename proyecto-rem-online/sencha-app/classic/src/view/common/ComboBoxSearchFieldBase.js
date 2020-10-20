Ext.define('HreRem.view.common.ComboBoxSearchFieldBase', { 	
	extend			: 'Ext.form.field.ComboBox',
    xtype			: 'comboboxsearchfieldbase',
    displayField	: 'descripcion',      
    valueField		: 'codigo',    
    editable		: true,
    emptyText: 'Escribe m\u00ednimo 3 letras para buscar', 
    triggerCls: Ext.baseCSSPrefix + 'form-search-trigger',
	minLength: 3,
	queryMode: 'local',
	triggerAction: 'query',
	anyMatch: true,
	
	privates: {
	onRender: function(){
		this.store.clearFilter(true);
		this.callParent();
	},
		
	onTriggerClick: function() {
		if(!Ext.isEmpty(this.rawValue) && this.rawValue.length >= this.minLength)
			this.expand();
		else
			this.collapse();
	},
	
    onExpand: function(){
    	if(!Ext.isEmpty(this.rawValue) && this.rawValue.length >= this.minLength)
			this.expand();
		else
			this.collapse();					
	},
	onChange: function(newValue, oldValue){
		if(!Ext.isEmpty(newValue)){
			if(newValue.length < this.minLength){
				this.collapse();
			}else{
				this.store.filter(
						{
							property: this.displayField,
							anyMatch: true,
							caseSensitive: false,
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
   		me.callParent();
    }
	}
});     