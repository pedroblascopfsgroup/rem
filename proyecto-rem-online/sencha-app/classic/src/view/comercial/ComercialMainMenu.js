Ext.define('HreRem.view.comercial.ComercialMainMenu', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'comercialmainmenu',
    reference	: 'comercialMainmenu',
    layout: 'fit',

    requires	: ['HreRem.view.comercial.ComercialVisitasController','HreRem.view.comercial.ComercialModel',
    'HreRem.view.comercial.visitas.VisitasComercialMain', 'HreRem.view.comercial.ofertas.OfertasComercialMain', 'HreRem.view.comercial.configuracion.ConfiguracionComercialMain'],
    
    
	listeners: {
			    	
    	boxready: function (tabPanel) {   		
    		
			tabPanel.getLayout().setActiveItem(tabPanel.items.indexOf(tabPanel.down('[xtype=ofertascomercialmain]')));
		
		}

    },

    initComponent: function () {
        
        var me = this;
        
        me.items = [
		    {	
				xtype: 'visitascomercialmain', reference: 'visitasComercialMain'
			},
			{	
				xtype: 'ofertascomercialmain', reference: 'ofertasComercialMain'
			}/*,
			{	
				xtype: 'configuracioncomercialmain', reference: 'configuracioncomercialMain', hidden: true
			}*/
        ];
       
        
        me.callParent(); 

        
    }

});

