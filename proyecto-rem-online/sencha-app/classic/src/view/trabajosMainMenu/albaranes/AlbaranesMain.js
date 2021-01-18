Ext.define('HreRem.view.trabajosMainMenu.albaranes.AlbaranesMain', {
	extend : 'Ext.panel.Panel',
    xtype: 'albaranesMain',
    cls	: 'tabpanel-base',
    layout : {
		type : 'vbox',
		align : 'stretch'
    },
    
    requires: [
        'HreRem.view.trabajosMainMenu.albaranes.AlbaranesController',
        'HreRem.view.trabajosMainMenu.albaranes.AlbaranesModel',
        'HreRem.view.trabajosMainMenu.albaranes.AlbaranesSearch',
        'HreRem.view.trabajosMainMenu.albaranes.AlbaranesList'
    ],

    controller: 'albaranes',
    viewModel: {
        type: 'albaranes'
    },  

	items : [
			{
				xtype : 'albaranessearch',
				reference : 'albaranessearch'
			},
			{
				xtype : 'albaraneslist',
				reference : 'albaraneslist',
				flex: 1
			}
	],
	
	initComponent: function() {
		var me = this;
		me.setTitle(HreRem.i18n("title.albaran.albaran"));
		me.on('activate', me.refresh, me);
		me.callParent();
	},
	
	refresh: function() {
		var me = this;
		if(me.refreshOnActivate)  {
			me.down('albaraneslist').down('albaranGrid').getStore().load();
			me.refreshOnActivate = false;
		}
	
	}

});

