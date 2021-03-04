/**
 * @class HreRem.ux.button.BotonTab
 * @author Jose Villel
 * 
 * Componente para los botones pestaña que activan los campos de ediciḉon y guardan datos de una pestaña 
 * en un tabpanel
 */
Ext.define('HreRem.ux.button.BotonTab', {
	extend	: 'Ext.button.Button',
	xtype	: 'buttontab',
	overCls: 'x-tab-over x-button-tab-over',
	focusCls: 'x-tab-focus x-button-tab-focus',
	reorderable: false,
    closable: false,
    
    width: 30,
    margin: '0 5 0 0',
    
    initComponent: function() {
    	var me = this;
    	
    	me.addCls("x-tab x-button-tab");
    	
    	me.callParent();

    },
    
    beforeClick: function() {
    	return null;
    	
    },
	privates: {
		            
		/**
		 * Overrride del método original para en el momento de hacer el bind llamar al evaluar botones
			* si el activeTab tiene ocultarbotoneseditar
		 * @param {} value
		 * @param {} oldValue
		 * @param {} binding
		 */
		onBindNotify: function(value, oldValue, binding) {
			binding.syncing = (binding.syncing + 1) || 1;
			this[binding._config.names.set](value);
			--binding.syncing;
			if(binding._config.names.set == 'setHidden'){
				if(this.itemId == 'botoneditar'){
					var tabpanel = this.up("tabpanel");
					if(!Ext.isEmpty(tabpanel)){
						if(Ext.isDefined(tabpanel.getActiveTab())){
							if(!tabpanel.getActiveTab().ocultarBotonesEdicion && !value){
								tabpanel.evaluarBotonesEdicion(tabpanel.getActiveTab());
							}else{
								this.hide();
							}
						}else{
							this.hide();
						}
					}
				}else if(this.itemId == 'botonguardar' || this.itemId == 'botoncancelar'){
					var tabpanel = this.up("tabpanel");
					if(!Ext.isEmpty(tabpanel)){
						if(!value)
							tabpanel.down("[itemId=botoneditar]").hide();
					}
				}
			}
			this.fireEvent("afterbind", this);
		
		}

     }
    
});