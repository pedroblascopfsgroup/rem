Ext.define('HreRem.view.configuracion.administracion.ConfiguracionAdministracionTabPanel', {
	extend		: 'Ext.tab.Panel',
    xtype		: 'configuracionadministraciontabpanel',
	cls			: 'panel-base shadow-panel, tabPanel-segundo-nivel',
    requires	: ['HreRem.view.configuracion.administracion.proveedores.ConfiguracionProveedores',
    	'HreRem.view.configuracion.administracion.gestoressustitutos.ConfiguracionGestoresSustitutos',
    	'HreRem.view.configuracion.administracion.testigosobligatorios.ConfiguracionTestigosObligatorios'],
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
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionproveedores', reference: 'configuracionProveedores'})}, ['TAB_PROVEEDORES']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuraciongestoressustitutos', reference: 'configuracionGestoresSustitutos'})}, ['TAB_GESTORES_SUSTITUTOS']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuraciontestigosobligatorios', reference: 'configuracionTestigosObligatorios'})}, ['TAB_TESTIGOS_OBLIGATORIOS']);
		$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionrecomendacion', reference: 'configuracionrecomendacion'})}, ['TAB_CONFIG_RECOMENDACION']);
        //$AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionperfiles', reference: 'configuracionPerfiles'})}, ['TAB_ADMINISTRACION_CONFIGURACION']);

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent();
    }
});