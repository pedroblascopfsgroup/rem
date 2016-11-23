Ext.define('HreRem.view.publicacion.PublicacionMain', {
    extend		: 'Ext.tab.Panel',
    cls			: 'tabpanel-base',
    xtype		: 'publicacionmain',
    reference	: 'publicacionMain',
    layout		: 'fit',
    requires	: ['HreRem.view.publicacion.PublicacionController', 'HreRem.view.publicacion.activos.ActivosPublicacionMain',
            	   'HreRem.view.publicacion.configuracion.ConfiguracionPublicacionMain', 'HreRem.view.publicacion.PublicacionModel',
            	   'HreRem.model.BusquedaActivosPublicacion', 'HreRem.view.publicacion.activos.ActivosPublicacionList'],
    controller	: 'publicaciones',
    viewModel	: {
        type: 'publicaciones'
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
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'activospublicacionmain', reference: 'activosPublicacionMain'})}, ['TAB_PUBLICACION_ACTIVOS']);
        $AU.confirmFunToFunctionExecution(function(){items.push({xtype: 'configuracionpublicacionmain', reference: 'configuracionPublicacionMain', funPermEdition: ['EDITAR_TAB_CONFIGURACION_PUBLICACION']})}, ['TAB_CONFIGURACION_PUBLICACION']);

        me.addPlugin({ptype: 'lazyitems', items: items});
        me.callParent(); 
    }
});