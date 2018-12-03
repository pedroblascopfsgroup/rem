Ext.define('HreRem.view.activos.detalle.ComercialActivoTabPanel', {
    extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'comercialactivotabpanel',
    reference	: 'comercialactivotabpanelref',
    layout		: 'fit',
    requires	: [
    				'HreRem.view.activos.detalle.VisitasComercialActivo', 
    				'HreRem.view.activos.detalle.OfertasComercialActivo',
    				'HreRem.view.activos.detalle.GencatComercialActivo'
    			  ],    

	listeners	: {
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

		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'ofertascomercialactivo'})}, ['TAB_COMERCIAL_OFERTAS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'visitascomercialactivo'})}, ['TAB_COMERCIAL_VISITAS']);
		
		if (me.lookupViewModel().get('activo.afectoAGencat')) {
			items.push({xtype: 'gencatcomercialactivo'});
		}

    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },

    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    }
});