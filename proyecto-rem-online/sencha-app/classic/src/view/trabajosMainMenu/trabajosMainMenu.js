Ext.define('HreRem.view.trabajosMainMenu.trabajosMainMenu', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'trabajosMainMenu',
    reference	: 'trabajosMainMenu',
    layout		: 'fit',
    requires	: ['HreRem.view.trabajosMainMenu.albaranes.AlbaranesMain', 
    			   'HreRem.view.trabajos.TrabajosMain'],

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

        var items = [
        	{xtype: 'trabajosmain', reference:	 'trabajosmain'},
        	{xtype: 'albaranesMain', reference: 'albaranesMain'}
        ];

	    me.addPlugin({ptype: 'lazyitems', items: items });
        me.callParent();
    }
});