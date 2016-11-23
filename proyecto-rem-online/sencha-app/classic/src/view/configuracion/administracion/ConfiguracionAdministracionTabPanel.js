Ext.define('HreRem.view.configuracion.administracion.ConfiguracionAdministracionTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'configuracionadministraciontabpanel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    requires	: ['HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedores',
    				'HreRem.view.configuracion.administracion.mediadores.ConfiguracionMediadores'],
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
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionproveedores'})}, ['TAB_PROVEEDORES']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionmediadores'})}, ['TAB_MEDIADORES']);

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent();
    }
});

