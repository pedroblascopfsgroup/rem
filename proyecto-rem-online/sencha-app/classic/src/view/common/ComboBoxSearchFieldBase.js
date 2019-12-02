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
		if(!Ext.isEmpty(this.rawValue) && this.rawValue.length >= 3)
			this.expand();
		else
			this.collapse();
	},
	
    onExpand: function(){
    	if(!Ext.isEmpty(this.rawValue) && this.rawValue.length >= 3)
			this.expand();
		else
			this.collapse();					
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
   		me.callParent();
    }
	}
});     