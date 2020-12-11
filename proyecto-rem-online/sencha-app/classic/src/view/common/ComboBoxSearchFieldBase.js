Ext.define('HreRem.view.common.ComboBoxSearchFieldBase', { 	
	extend			: 'HreRem.view.common.ComboBoxFieldBase',
    xtype			: 'comboboxsearchfieldbase',
    displayField	: 'descripcion',      
    valueField		: 'codigo',    
    editable		: true,
	autoLoadOnValue	: false,
	loadOnBind		: false,
	forceSelection	: false,	
    emptyText: 'Escribe m\u00ednimo 3 letras para buscar', 
    triggerCls: Ext.baseCSSPrefix + 'form-search-trigger',
	minLength: 3,
	mode: 'local',
	queryMode: 'local',
	triggerAction: 'query',
	anyMatch: true,	
	addUxReadOnlyEditFieldPlugin: false,
	enableKeyEvents:true,
	privates: {
			
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
			if(!Ext.isEmpty(this.rawValue)){
				if(this.rawValue.length < this.minLength){
					this.collapse();
				}else{
					this.store.clearFilter();
					this.store.filter(
							{
								property: this.displayField,
								anyMatch: true,
								caseSensitive: false,
								value: this.rawValue
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
	    },

		beforequery : function(queryEvent) {			
			if(this.rawValue >= this.minLength){
				this.store.clearFilter();
				queryEvent.combo.onLoad();
			}else{
				this.collapse();
			}
		}		
	}
});     