Ext.define('HreRem.view.activos.actuaciones.ActuacionesTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'actuacionestabmain',
	title		: 'Actuaciones',
	layout : {
		type : 'vbox',
		align : 'stretch'
	},   
	scrollable	: 'y',
    closable	: false, 
            
    requires: [
        'HreRem.view.activos.actuaciones.ActuacionesSearch',
        'HreRem.view.activos.actuaciones.ActuacionesList'    
    ],
    
   	controller: 'actuaciones',
    /*viewModel: {
        type: 'actuaciones'
    },*/
    
    
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "actuacionessearch"},
			{xtype: "actuacioneslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});