Ext.define('HreRem.view.common.WindowBase', {
    extend		: 'Ext.window.Window',
    xtype		: 'windowBase',
    cls	: 'window-base',
    border: false,
    modal	: true,
    bodyPadding: 10,
    closable: false,
    
    initComponent: function() {  
    	var me = this;
   		me.callParent();
    },
    
    hideWindow: function() {
    	var me = this;    	
    	me.hide();   	
    },
    
    closeWindow: function() {
    	var me = this;
    	me.close();   	
    }

});