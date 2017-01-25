Ext.define('HreRem.view.precios.generacion.GeneracionPropuestasConfiguracion', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'generacionpropuestasconfiguracion',
    requires	: ['HreRem.view.precios.generacion.GeneracionPropuestasConfiguracionList'],
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.precios.generacion.propuestas.configuracion'));

        me.items = [
        	{xtype: 'generacionpropuestasconfiguracionlist'}
        ];

        me.callParent();
    }
});