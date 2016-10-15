Ext.define('HreRem.view.publicacion.configuracion.ConfiguracionPublicacionMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'configuracionpublicacionmain',
    requires	: ['HreRem.view.publicacion.configuracion.ConfiguracionPublicacionList'],
    layout: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {

        var me = this;

        me.setTitle(HreRem.i18n('title.publicaciones.configuracion'));

        me.items = [
        	{xtype: 'configuracionpublicacionlist'}
        ];
        
        me.callParent();
    }
});

