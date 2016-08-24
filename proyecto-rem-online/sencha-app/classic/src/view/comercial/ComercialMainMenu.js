Ext.define('HreRem.view.comercial.ComercialMainMenu', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'comercialmainmenu',
    reference	: 'comercialMainmenu',
    layout: 'fit',
    
    requires	: ['HreRem.view.comercial.ComercialVisitasController','HreRem.view.comercial.ComercialModel',
    'HreRem.view.comercial.visitas.VisitasComercialMain', 'HreRem.view.comercial.ofertas.OfertasComercialMain', 'HreRem.view.comercial.configuracion.ConfiguracionMain'],
    

    initComponent: function () {
        
        var me = this;
        
        me.items = [
		    {	
				xtype: 'visitascomercialmain', reference: 'visitasComercialMain'
			},
			{	
				xtype: 'ofertascomercialmain', reference: 'ofertasComercialMain'
			},
			{	
				xtype: 'configuracionmain', reference: 'configuracionMain', disabled: true
			}
        ];
        
        me.callParent(); 

        
    }

});

