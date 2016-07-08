Ext.define('HreRem.view.activos.comercial.ofertas.OfertasTabMain', {
    extend		: 'Ext.panel.Panel',
    xtype		: 'ofertasTabMain',
	title		: 'Ofertas',
	layout : {
		type : 'vbox',
		align : 'stretch'
	},
	scrollable	: 'y',
    closable	: false, 
    
            
    requires: [
        'HreRem.view.activos.comercial.ofertas.OfertasSearch',
        'HreRem.view.activos.comercial.ofertas.OfertasList',
        'HreRem.view.activos.comercial.ofertas.OfertasController',
        'HreRem.view.activos.comercial.ofertas.OfertasModel',
        'HreRem.view.activos.comercial.ofertas.OfertaDetalle',
        'HreRem.view.activos.comercial.ofertas.OfertaAlta'
    ],
    
    controller: 'ofertas',
    /*viewModel: {
        type: 'ofertas'
    },*/  
    
    initComponent: function () {
    	
        var me = this;
        
        me.items = [
        	
			{xtype: "ofertasSearch"},
			{xtype: "ofertaslist"}
        	      
        ] 
        
        me.callParent();
        
    }
});