Ext.define('HreRem.view.precios.PreciosMain', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'preciosmain',
    reference	: 'preciosMain',
    layout		: 'fit',
    requires	: ['HreRem.view.precios.PreciosController','HreRem.view.precios.PreciosModel',
    				'HreRem.view.precios.generacion.GeneracionPropuestasMain','HreRem.view.precios.historico.HistoricoPropuestasMain'],
    controller	: 'precios',
    viewModel	: {
        type: 'precios'
    },
    listeners	: {
    	boxready : function (tabPanel) {   		
			if(tabPanel.items.length > 0 && tabPanel.items.items.length > 0) {
				var tab = tabPanel.items.items[0];
				tabPanel.setActiveTab(tab);
			}
    	}
    },

    initComponent: function () {
    	var me = this;

        var items = [];
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'generacionpropuestasmain', reference: 'generacionPropuestasMain'})}, ['TAB_GENERACION_PROPUESTAS_PRECIO']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'historicopropuestasmain', reference: 'historicoPropuestasMain'})}, ['TAB_HISTORICO_PROPUESTA_PRECIOS']);

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent();
    }
});