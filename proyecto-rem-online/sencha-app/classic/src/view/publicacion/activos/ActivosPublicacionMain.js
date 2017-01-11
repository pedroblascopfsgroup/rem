Ext.define('HreRem.view.publicacion.activos.ActivosPublicacionMain', {
	extend		: 'Ext.panel.Panel',
    xtype		: 'activospublicacionmain',
    requires	: ['HreRem.view.publicacion.activos.ActivosPublicacionSearch', 'HreRem.view.publicacion.activos.ActivosPublicacionList'],
    layout		: {
        type: 'vbox',
        align: 'stretch'
    },

    initComponent: function () {
        var me = this;
        me.setTitle(HreRem.i18n('title.publicacion.tab'));

        me.items = [
            {	
            	xtype: 'activospublicacionsearch', reference: 'ActivosPublicacionSearch'
            },
            {	
            	xtype: 'activospublicacionlist', reference: 'ActivosPublicacionList'
            }
        ];

        me.callParent(); 
    }
});