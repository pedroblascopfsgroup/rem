Ext.define('HreRem.view.activos.comercial.solicitudes.SolicitudesGestion', {
    extend		: 'Ext.container.Container',
    xtype		: 'solicitudesgestion',
    reference	: 'solicitudesGestion',
	layout : {
		type : 'vbox',
		align : 'stretch'
	},   
	scrollable	: 'y',
            
    requires: [
        'HreRem.view.activos.comercial.solicitudes.SolicitudesSearch',
        'HreRem.view.activos.comercial.solicitudes.SolicitudesList'    
    ],        
    
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "solicitudessearch"},
			{xtype: "solicitudeslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});