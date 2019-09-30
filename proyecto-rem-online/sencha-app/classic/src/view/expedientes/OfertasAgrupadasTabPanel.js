Ext.define('HreRem.view.expedientes.OfertasAgrupadasTabPanel', {
    extend		: 'Ext.tab.Panel',
	cls			: 'panel-base shadow-panel tabPanel-tercer-nivel',
    xtype		: 'ofertasagrupadastabpanel',
    reference	: 'ofertasagrupadastabpanelref',
    layout		: 'fit',
    requires	: [ 'HreRem.model.OfertasAgrupadasModel',
    				'HreRem.view.expedientes.ExpedienteDetalleModel',
    				'HreRem.view.expedientes.OfertasDependientesExpediente',
    				'HreRem.view.expedientes.ListaActivosOfertaAgrupadaExpediente'
    				],    
    bind: {
    	hidden: '{!esCarteraLiberbank}'
    },
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
    	items.push({xtype: 'ofertasdependientesexpediente'});
    	items.push({xtype: 'listaactivosofertaagrupadaexpediente'});
    	me.addPlugin({ptype: 'lazyitems', items: items });
    	me.callParent();
    },
    
    funcionRecargar: function() {
		var me = this;
		me.recargar = false;
		me.getActiveTab().funcionRecargar();
    }
});
