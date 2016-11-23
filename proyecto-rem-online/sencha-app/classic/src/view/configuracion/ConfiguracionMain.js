Ext.define('HreRem.view.configuracion.ConfiguracionMain', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'configuracionmain',
    reference	: 'configuracionMain',
    layout		: 'fit',
    requires	: ['HreRem.view.configuracion.ConfiguracionController','HreRem.view.configuracion.ConfiguracionModel',
    				'HreRem.view.configuracion.administracion.ConfiguracionAdministracionMain',
    				'HreRem.view.configuracion.mediadores.EvaluacionMediadores'],
    controller	: 'configuracion',
    viewModel	: {
        type: 'configuracion'
    },

    initComponent: function () {
        var me = this;

        var items = [];
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionadministracionmain', reference: 'configuracionAdministracionMain'})}, ['TAB_ADMINISTRACION_CONFIGURACION']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'evaluacionmediadores', reference: 'evaluacionMediadores'})}, ['TAB_MEDIADORES']);

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent();
    }
});