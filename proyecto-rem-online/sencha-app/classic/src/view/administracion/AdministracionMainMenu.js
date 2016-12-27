Ext.define('HreRem.view.administracion.AdministracionMainMenu', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'administracionmainmenu',
    reference	: 'administracionMainMenu',
    layout		: 'fit',
    requires	: ['HreRem.view.administracion.gastos.AdministracionGastosMain'],
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
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'administraciongastosmain', reference: 'administracionGastosMain'})}, ['TAB_GASTOS_ADMINISTRACION']);

	    me.addPlugin({ptype: 'lazyitems', items: items });
        me.callParent();
    }
});