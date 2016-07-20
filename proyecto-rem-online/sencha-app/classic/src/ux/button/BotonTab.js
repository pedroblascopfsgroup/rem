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
    	
    }
    
});