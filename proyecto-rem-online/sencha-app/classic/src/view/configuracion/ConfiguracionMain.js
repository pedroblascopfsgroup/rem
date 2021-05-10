Ext.define('HreRem.view.configuracion.ConfiguracionMain', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'configuracionmain',
    reference	: 'configuracionMain',
    layout		: 'fit',
    requires	: ['HreRem.view.configuracion.ConfiguracionController','HreRem.view.configuracion.ConfiguracionModel',
    				'HreRem.view.configuracion.administracion.ConfiguracionAdministracionMain',
    				'HreRem.view.configuracion.mediadores.EvaluacionMediadores','HreRem.view.configuracion.mantenimiento.MantenimientosMain'],
    controller	: 'configuracion',
    viewModel	: {
        type: 'configuracion'
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
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionadministracionmain', reference: 'configuracionAdministracionMain'})}, ['TAB_ADMINISTRACION_CONFIGURACION']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'evaluacionmediadores', reference: 'evaluacionMediadores'})}, ['TAB_MEDIADORES']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'mantenimientosmain', reference: 'mantenimientosmainref'})}, ['TAB_MEDIADORES']); //SE PONE LA MISMA TAB PORQUE NO TIENE NINFUNA FUNCIONALIDAD ESPECIAL

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent();
    }
});