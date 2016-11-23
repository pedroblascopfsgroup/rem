Ext.define('HreRem.view.configuracion.administracion.ConfiguracionAdministracionMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionadministracionmain',
    requires	: ['HreRem.view.configuracion.administracion.ConfiguracionAdministracionTabPanel'],
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.configuracion.administracion'));

        me.items = [];
        $AU.confirmFunToFunctionExecution(function(){me.items.push({xtype: 'configuracionadministraciontabpanel', flex: 1})}, ['TAB_ADMINISTRACION_CONFIGURACION']);

        me.callParent();
    }
});