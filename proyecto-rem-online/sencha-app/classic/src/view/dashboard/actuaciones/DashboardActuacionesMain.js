Ext.define('HreRem.view.dashboard.actuaciones.DashboardActuacionesMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'dashboardactuacionesmain',
	layout : {
		type : 'vbox',
		align : 'stretch'
	},   
    closable	: false, 
            
    requires: [
        'HreRem.view.dashboard.actuaciones.DashboardActuacionesList'    
    ],
    
   
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "dashboardactuacioneslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});