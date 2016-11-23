Ext.define('HreRem.view.comercial.ComercialMainMenu', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'comercialmainmenu',
    reference	: 'comercialMainmenu',
    layout		: 'fit',
    requires	: ['HreRem.view.comercial.ComercialVisitasController','HreRem.view.comercial.ComercialModel',
    				'HreRem.view.comercial.visitas.VisitasComercialMain', 'HreRem.view.comercial.ofertas.OfertasComercialMain',
    				'HreRem.view.comercial.configuracion.ConfiguracionComercialMain'],
    listeners: {
    	boxready: function (tabPanel) {
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
    	}
	},

    initComponent: function () {
        var me = this;

        var items = [];
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'visitascomercialmain', reference: 'visitasComercialMain'})}, ['TAB_VISITAS_COMERCIAL']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'ofertascomercialmain', reference: 'ofertasComercialMain'})}, ['TAB_OFERTAS_COMERCIAL']);

        me.addPlugin({ptype: 'lazyitems', items: items });
        me.callParent();
    }
});