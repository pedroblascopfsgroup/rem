Ext.define('HreRem.view.activos.comercial.ofertas.ofertantes.OfertantesTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'ofertantestabmain',
	title		: 'Ofertantes',
	layout : {
		type : 'vbox',
		align : 'stretch'
	},
	scrollable	: 'y',
    closable	: false, 
            
    requires: [
        'HreRem.view.activos.comercial.ofertas.ofertantes.OfertantesSearch',
        'HreRem.view.activos.comercial.ofertas.ofertantes.OfertantesList'
    ],
    
    viewModel: {
        type: 'ofertantes'
    },   
    
    initComponent: function () {
    	
        var me = this; 
        
        me.items = [
        	
			{xtype: "ofertantessearch"},
			{xtype: "ofertanteslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});