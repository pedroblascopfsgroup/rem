Ext.define('HreRem.view.activos.detalle.ComercialActivo', {
    extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'comercialactivo',
    reference	: 'comercialactivoref',
    layout		: 'fit',
    requires	: ['HreRem.view.activos.detalle.VisitasComercialActivo','HreRem.view.activos.detalle.OfertasComercialActivo'],    

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
    	me.setTitle(HreRem.i18n('title.comercial'));

		var items = [];
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'ofertascomercialactivo', funPermEdition: ['EDITAR_TAB_COMERCIAL_OFERTAS']})}, ['TAB_COMERCIAL_OFERTAS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'visitascomercialactivo', funPermEdition: ['EDITAR_TAB_COMERCIAL_VISITAS']})}, ['TAB_COMERCIAL_VISITAS']);

    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    }
});