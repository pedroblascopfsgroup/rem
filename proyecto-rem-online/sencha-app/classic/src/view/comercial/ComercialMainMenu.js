Ext.define('HreRem.view.comercial.ComercialMainMenu', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'comercialmainmenu',
    reference	: 'comercialMainmenu',
    layout: 'fit',
    
    requires	: ['HreRem.view.comercial.ComercialController','HreRem.view.comercial.ComercialModel',
    'HreRem.view.comercial.visitas.VisitasComercialMain', 'HreRem.view.comercial.ofertas.OfertasMain', 'HreRem.view.comercial.configuracion.ConfiguracionMain'],
    
    controller: 'comercial',
    viewModel: {
        type: 'comercial'
    },
    initComponent: function () {
        
        var me = this;
        
        me.items = [
		    {	
				xtype: 'visitascomercialmain', reference: 'visitasComercialMain'
			},
			{	
				xtype: 'ofertasmain', reference: 'ofertasMain'
			},
			{	
				xtype: 'configuracionmain', reference: 'configuracionMain'
			}
        ];
        
        me.callParent(); 

        
    }

});

